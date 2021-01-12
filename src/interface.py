import numpy as np
import requests
import psana
from psana import *

class Detector:
    
    """
    Detector object useful for reshaping data from XTC into detector shape. Stripped
    down version of Detector class from pysingfel when that library isn't available.
    """
    
    def __init__(self, geom_file):
        """
        Initialize instance of Detector class.
        
        :param geom_file: path to *-end.data geometry file
        """
        
        from PSCalib.GeometryAccess import GeometryAccess
        self._geometry = GeometryAccess(geom_file, 0)
        self._compute_pixel_index_map()
        
    def _compute_pixel_index_map(self):
        """
        Compute various parameters related to detector dimensions and pixel indices
        and store as class variables.
        """
        
        # Set coordinate in real space (convert to m)
        temp = [np.asarray(t) * 1e-6 for t in self._geometry.get_pixel_coords()]
        temp_index = [np.asarray(t) for t in self._geometry.get_pixel_coord_indexes()]
        self._panel_num = np.prod(temp[0].shape[:-2])
        self._shape = (self._panel_num, temp[0].shape[-2], temp[0].shape[-1])
        
        pixel_index_map = np.zeros(self._shape + (2,))
        for n in range(2):
            pixel_index_map[..., n] = temp_index[n].reshape(self._shape)
        self._pixel_index_map = pixel_index_map.astype(np.int64)

        self._detector_pixel_num_x = int(np.max(self._pixel_index_map[..., 0]) + 1)
        self._detector_pixel_num_y = int(np.max(self._pixel_index_map[..., 1]) + 1)
        
        self._panel_index = np.zeros((self._detector_pixel_num_x, self._detector_pixel_num_y))
        for l in range(self._panel_num):
            self._panel_index[self._pixel_index_map[l, :, :, 0],
                              self._pixel_index_map[l, :, :, 1]] = l+1
        
        return        
        
    def assemble_image_stack(self, data, dtype=np.int64):
        """
        Reassemble data retrieved from XTC file into shape of detector.
        
        :param data: list of stacked data from each quad of panels
        :param dtype: type of the returned image
        :return image: data in shape of detector
        """
        data = np.array(data).reshape(self._shape)
        image = np.zeros((self._detector_pixel_num_x, self._detector_pixel_num_y)).astype(dtype)
        
        for l in range(self._panel_num):
            image[self._pixel_index_map[l, :, :, 0],
                  self._pixel_index_map[l, :, :, 1]] = data[l, :, :]
            
        return image


class Run:

    """
    Detector object useful for reshaping data from XTC into detector shape. Stripped
    down version of Detector class from pysingfel when that library isn't available.
    """

    def __init__(self, expt, run_idx, det=None, image_type=None):
        """
        Initialize instance of Run class.

        """
        if det is None:
            raise ValueError('det object needs to be instantiated first')
        if image_type is None:
            self._image_type = np.int64
        else:
            self._image_type = image_type
        self._expt= expt
        self._idx = run_idx
        self._dark_idx = self._retrieve_closest_dark()
        self._det = det
        self._ds  = psana.DataSource(f'exp={expt}:run={run_idx}:smd')
        self._n_images, self._images_nx, self._images_ny, self._image_type = self._retrieve_dimensions()
         
        print(f'{self._n_images} images of shape {self._images_nx}x{self._images_ny} and type {self._image_type}')
        memsize=self._n_images*self._images_nx*self._images_ny*self._image_type.itemsize/1e9
        print(f'Estimated size: {memsize:.2f} GB')

    def _reset_ds(self):
        self._ds = psana.DataSource(f'exp={self._expt}:run={self._idx}:smd')

    def _retrieve_dimensions(self):
        """
        """
        for num,evt in enumerate(self._ds.events()):
            if num == 0:
                data  = self._retrieve_cspad_evt_data(evt)
                image = self._det.assemble_image_stack(data, dtype=self._image_type)
        return num, image.shape[0], image.shape[1], image.dtype

    def _retrieve_cspad_evt_data(self,evt):
        """
        Retrieve intensities collected on CsPad from input event.
    
        :param evt: psana event object
        :return data: list of quads that make up measured data
        """
        data = list()
        cspad = evt.get(psana.CsPad.DataV2, psana.Source('DscCsPad'))
        for num in range(cspad.quads_shape()[0]):
            data.append(cspad.quads(num).data())
        return data

    def _retrieve_closest_dark(self):
        """
        """
        darks = self._retrieve_dark_list()
        return darks[np.where(darks<self._idx)[0][-1]]
        
    def _retrieve_dark_list(self):
        """
        """
        darks = requests.get(f'https://pswww.slac.stanford.edu/ws/lgbk/lgbk/{self._expt}/ws/get_runs_with_tag?tag=DARK').json()
        if darks['success']:
            #print(f"Dark runs: {darks['value']}")
            return np.array(darks['value'])
        else:
            raise ValueError(f'darks could not be found for {self._expt}')

    def set_dark_idx(self, idx):
        self._dark_idx = idx

    def _retrieve_pedestal(self):
        """
        """
        pedestal_file = f'/cds/data/psdm/cxi/{self._expt}/calib/CsPad::CalibV1/CxiDs1.0:Cspad.0/pedestals/{self._dark_idx}-end.data'
        return self._det.assemble_image_stack(np.loadtxt(pedestal_file))

    def _retrieve_image_batch(self, batch_id=0, batch_size=100, apply_pedestal_correction=True):
        """
        """
        if batch_id*batch_size > self._n_images:
            raise ValueError('batch is outside dataset')
        if apply_pedestal_correction:
            self._pedestal = self._retrieve_pedestal()
        image_batch = np.zeros((batch_size, self._images_nx, self._images_ny), dtype=self._image_type)

        self._reset_ds()
        i_batch=0
        for num, evt in enumerate(self._ds.events()):
            if num>=batch_id*batch_size and num<(batch_id+1)*batch_size:
                data  = self._retrieve_cspad_evt_data(evt)
                image_batch[i_batch,...] = self._det.assemble_image_stack(data, dtype=self._image_type)
                image_batch[i_batch,...] -= self._pedestal 
                i_batch += 1
        return image_batch
