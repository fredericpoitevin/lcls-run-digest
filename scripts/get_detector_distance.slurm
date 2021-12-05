#!/bin/bash

#SBATCH --partition=psfehq
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --output=%j.log
#SBATCH --error=%j.err

project_dir="/cds/home/f/fpoitevi/lcls-run-digest/scripts"
run_number=343
mkdir -p ${project_dir}/r0${run_number}

#source /reg/g/psdm/etc/psconda.sh
#conda activate ana-4.0.20-py3
#mpirun generatePowder exp=mfxc00118:run=${run_number} -d Rayonix -o r0${run_number}

cat <<EOT > ${project_dir}/r0${run_number}/run.sh
#!/bin/bash

export PATH=/cds/home/f/fpoitevi/Toolkit/psocake/app:\$PATH
export PYTHONPATH=/cds/home/f/fpoitevi/Toolkit/psocake:\$PYTHONPATH
export PSOCAKE_FACILITY=LCLS

generatePowder exp=mfxc00118:run=${run_number} -d Rayonix -o r0${run_number}

exit 0
EOT

chmod +x ${project_dir}/r0${run_number}/run.sh

orterun -n 24 \
       singularity run -B /cds,/reg  /cds/home/f/fpoitevi/singularity/ana_4.0.20-py3.sif \
       /bin/bash ${project_dir}/r0${run_number}/run.sh

exit 0
