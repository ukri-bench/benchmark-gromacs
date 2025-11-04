#!/bin/bash
#SBATCH --account=$account  # Run job under project <project>
#SBATCH --time=3:0:0         # Run for a max of 1 hour
#SBATCH --partition=$partition    # Choose either "gh" or "ghtest" node type for grace-hopper
#SBATCH --gres=gpu:1      # Request 1 GPU, and implicitly the full 72 CPUs and 100% of the nodes memory
#SBATCH --job-name=$jobname
#SBATCH --ntasks-per-node=$ntasks

module load cuda

# install gromacs
# note: the gromacs spack package should be fine for this

# set environment vars for nvidia
export GMX_FORCE_UPDATE_DEFAULT_GPU=true
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_ENABLE_DIRECT_GPU_COMM=1

# run gromacs
gmx mdrun -s ${atoms}-atoms.tpr -ntomp $ntasks -nb gpu -pme gpu -bonded gpu -dlb no -nstlist 300 -pin on -v -gpu_id 0
#rm benchmark.tpr traj.trr ener.edr

python gmxlog.py md.log results.json

