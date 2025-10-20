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
# TODO

# get benchmark files
wget https://www.hecbiosim.ac.uk/file-store/benchmark-suite/gromacs.tar.xz
tar -xf gromacs.tar.xz
for atoms in 20k 61k 465k 1400k 3000k
do
    mv gromacs/${atoms}-atoms/benchmark.tpr ${atoms}-atoms.tpr
done
rm -r gromacs
rm gromacs.tar.xz

# install hpcbench
git clone https://github.com/HECBioSim/hpcbench.git
cd hpcbench
pip install .
cd ..

for atoms in 20k 61k 465k 1400k 3000k
do
    hpcbench infolog sysinfo.json
    hpcbench cpulog -p cpu.pid "'gmx_mpi mdrun'" cpulog.json &
    srun --unbuffered --cpu-bind=cores --distribution=block:block --hint=nomultithread gmx_mpi mdrun -s ${atoms}-atoms.tpr
    kill $(< cpu.pid)
    hpcbench sacct $SLURM_JOB_ID accounting.json
    hpcbench gmxlog md.log run.json
    hpcbench slurmlog $0 slurm.json
    hpcbench extra -e "'Comment:GROMACS living benchmark'" -e "'Machine:CPU'" meta.json
    hpcbench gmxedr ener.edr thermo.json
    hpcbench collate -l sysinfo.json thermo.json run.json accounting.json slurm.json meta.json -o ${atoms}_atoms_results.json
    rm benchmark.tpr traj.trr
done

hpcbench table -c "'run:Totals:Number of atoms'" -r "'run:Totals:ns/day'" -r "'run:Totals:J/ns'" . -o results_summary.json
