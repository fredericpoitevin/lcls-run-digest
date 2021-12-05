#!/bin/bash

run_start=10
run_end=18
run_current=$run_start

while [ $run_current -le $run_end ]
do
  if [ $run_current -lt 10 ]; then
    run_id="00$run_current"
  elif [ $run_current -lt 100 ]; then
    run_id="0$run_current"
  else
    run_id=$run_current
  fi
  #echo "
  if [ ! -f /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0${run_id}/cxilv4418_0${run_id}_jungfrau4M_sum.npy ]; then
    echo "submitting powder $run_id"
    sbatch --partition=psanaq --output=/reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0${run_id}/%J.log --ntasks=24 --job-name=powder${run_id} --wrap="mpirun generatePowder exp=cxilv4418:run=${run_current} -d jungfrau4M -o /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0${run_id}"

#--mca btl ^openib findPeaksTurbo -e cxilv4418 -d jungfrau4M --outDir /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0010 --algorithm 2 --alg_npix_min 2.0 --alg_npix_max 30.0 --alg_amax_thr 300.0 --alg_atot_thr 600.0 --alg_son_min 7.0 --alg1_thr_low 0.0 --alg1_thr_high 0.0 --alg1_rank 3 --alg1_radius 3 --alg1_dr 2 --psanaMask_on True --psanaMask_calib True --psanaMask_status True --psanaMask_edges True --psanaMask_central True --psanaMask_unbond True --psanaMask_unbondnrs True --mask /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0010/staticMask.h5 --localCalib --clen CXI:DS1:MMS:06.RBV --coffset 0.5729980000000001 --minPeaks 10 --maxPeaks 2048 --minRes -1 --sample sample --instrument cxi --pixelSize 7.5e-05 --auto False --detectorDistance 0.133 --access ana --tag postlocalcalib -r 10"sbatch --partition=psanaq --output=/reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0010/%J.log --ntasks=24 --job-name=peaks10 --wrap="mpirun --mca btl ^openib findPeaksTurbo -e cxilv4418 -d jungfrau4M --outDir /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0010 --algorithm 2 --alg_npix_min 2.0 --alg_npix_max 30.0 --alg_amax_thr 300.0 --alg_atot_thr 600.0 --alg_son_min 7.0 --alg1_thr_low 0.0 --alg1_thr_high 0.0 --alg1_rank 3 --alg1_radius 3 --alg1_dr 2 --psanaMask_on True --psanaMask_calib True --psanaMask_status True --psanaMask_edges True --psanaMask_central True --psanaMask_unbond True --psanaMask_unbondnrs True --mask /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0010/staticMask.h5 --localCalib --clen CXI:DS1:MMS:06.RBV --coffset 0.5729980000000001 --minPeaks 10 --maxPeaks 2048 --minRes -1 --sample sample --instrument cxi --pixelSize 7.5e-05 --auto False --detectorDistance 0.133 --access ana --tag postlocalcalib -r 10"    
# -q psanaq -n 24 -o /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0${run_id}/.%J.log mpirun generatePowder exp=cxilv4418:run=${run_current} -d jungfrau4M -o /reg/d/psdm/cxi/cxilv4418/scratch/fpoitevi/psocake/r0${run_id}
  else
    echo "cxilv4418_0${run_id}_jungfrau4M_sum.npy already exists"
  fi
  #"
  run_current=$[$run_current+1]
done
