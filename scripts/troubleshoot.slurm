#!/bin/bash

#SBATCH --partition=psfehq
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --output=%j.log
#SBATCH --error=%j.err

project_dir="/cds/home/f/fpoitevi/lcls-run-digest/scripts"
run_number="xxx"
mkdir -p ${project_dir}/r0${run_number}


cat << EOP > ${project_dir}/r0${run_number}/test-mpi.py
from mpi4py import MPI

# set up MPI environment
comm = MPI.COMM_WORLD # communication module
size = comm.Get_size() # number of processors available
rank = comm.Get_rank() # the rank of the process (the rank of a process always ranges from 0 to size-1)

print(f'[rank/size] {rank} / {size}')

EOP

cat <<EOB > ${project_dir}/r0${run_number}/run.sh
#!/bin/bash

python ${project_dir}/r0${run_number}/test-mpi.py

exit 0
EOB

chmod +x ${project_dir}/r0${run_number}/run.sh

orterun -n 24 \
       singularity run -B /cds,/reg  /cds/home/f/fpoitevi/singularity/ana_4.0.20-py3.sif \
       /bin/bash ${project_dir}/r0${run_number}/run.sh

exit 0
