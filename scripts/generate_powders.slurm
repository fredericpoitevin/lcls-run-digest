#!/bin/bash

#!/bin/bash
#SBATCH --partition=psanaq
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --output=%j.log
#SBATCH --error=%j.err

export PATH=/cds/home/f/fpoitevi/Toolkit/psocake/app:$PATH
export PYTHONPATH=/cds/home/f/fpoitevi/Toolkit/psocake:$PYTHONPATH
export PSOCAKE_FACILITY=LCLS

singularity run --nv -B /cds,/reg  /cds/home/f/fpoitevi/singularity/ana_4.0.20-py3.sif mpiexec -n 24 generatePowder exp=cxilv4418:run=221 -d jungfrau4M -o r0221

#CONDA_BASE=/cds/home/f/fpoitevi/miniconda3/
#source $CONDA_BASE/etc/profile.d/conda.sh
#conda activate ana-py3

#mpirun generatePowder exp=cxilv4418:run221 -d jungfrau4M -o r0221

exit 0
