import os,sys
import time
from matplotlib import pyplot as plt
import numpy as np
sys.path.insert(0, os.path.abspath('/cds/home/f/fpoitevi/Projects/lcls-run-digest/src'))
from interface import Detector, Run
from visualizer import show_image, show_components
from embedding import run_PCA as PCA

expt='cxic0415'
run_idx=36
geom_file = f'/cds/data/psdm/cxi/{expt}/calib/CsPad::CalibV1/CxiDs1.0:Cspad.0/geometry/0-end.data'
det = Detector(geom_file)

pca = PCA(expt, run_idx, det=det, image_type=np.int16)


