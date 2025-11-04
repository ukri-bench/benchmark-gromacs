#!/bin/bash
#SBATCH --nodes=$nodes
#SBATCH --time=02:00:00
#SBATCH --job-name=$jobname
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=$ntasks
#SBATCH --partition=standard
#SBATCH --qos=standard
#SBATCH --account=$account
#SBATCH --exclusive

export OMP_NUM_THREADS=1
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# install gromacs
# note: the gromacs spack package should be fine for this

# run gromacs
srun --unbuffered --cpu-bind=cores --distribution=block:block --hint=nomultithread gmx_mpi mdrun -s ${atoms}-atoms.tpr
#rm benchmark.tpr traj.trr ener.edr

python gmxlog.py md.log results.json
