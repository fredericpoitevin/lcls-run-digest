#!/bin/bash

#SBATCH --partition=psfehq
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --output=%j.log
#SBATCH --error=%j.err

project_dir="/cds/home/f/fpoitevi/lcls-run-digest/scripts"
run_number=344
mkdir -p ${project_dir}/r0${run_number}

source /reg/g/psdm/etc/psconda.sh
conda activate ana-4.0.20-py3

mpirun generatePowder exp=mfxc00118:run=${run_number} -d Rayonix -o r0${run_number}
