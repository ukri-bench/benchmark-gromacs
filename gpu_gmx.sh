#!/bin/bash
#SBATCH --account=$account  # Run job under project <project>
#SBATCH --time=3:0:0         # Run for a max of 1 hour
#SBATCH --partition=$partition    # Choose either "gh" or "ghtest" node type for grace-hopper
#SBATCH --gres=gpu:1      # Request 1 GPU, and implicitly the full 72 CPUs and 100% of the nodes memory
#SBATCH --job-name=$jobname
#SBATCH --ntasks-per-node=$ntasks

module load cuda

# install gromacs
# TODO

# install hpcbench
git clone https://github.com/HECBioSim/hpcbench.git
cd hpcbench
pip install .
cd ..

# get benchmark files
wget https://www.hecbiosim.ac.uk/file-store/benchmark-suite/gromacs.tar.xz
tar -xf gromacs.tar.xz
for atoms in 20k 61k 465k 1400k 3000k
do
    mv gromacs/${atoms}-atoms/benchmark.tpr ${atoms}-atoms.tpr
done
rm -r gromacs
rm gromacs.tar.xz

# set environment vars for nvidia
export GMX_FORCE_UPDATE_DEFAULT_GPU=true
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_ENABLE_DIRECT_GPU_COMM=1

for atoms in 20k 61k 465k 1400k 3000k
do
    hpcbench infolog sysinfo.json
    hpcbench gpulog -p gpu.pid gpulog.json &
    hpcbench cpulog -p cpu.pid "'gmx mdrun'" cpulog.json &
    hpcbench syslog -p sys.pid -i 1 -s /sys/class/hwmon/hwmon1/device/power1_average:totalpower:0.000001 -s /sys/class/hwmon/hwmon2/device/power1_average:gracepower:0.000001 -s /sys/class/hwmon/hwmon3/device/power1_average:cpupower:0.000001 -s /sys/class/hwmon/hwmon4/device/power1_average:iopower:0.000001 -t "'Total Energy (J)'" -t "'Total GPU Energy (J)'" -t "'Total CPU Energy (J)'" -t "'Total IO Energy (J)'" -o power.json &
    gmx mdrun -s ${atoms}-atoms.tpr -ntomp $ntasks -nb gpu -pme gpu -bonded gpu -dlb no -nstlist 300 -pin on -v -gpu_id 0
    kill $(< gpu.pid)
    kill $(< cpu.pid)
    kill $(< sys.pid)
    hpcbench sacct $SLURM_JOB_ID accounting.json
    hpcbench gmxlog md.log run.json
    hpcbench slurmlog $0 slurm.json
    hpcbench extra -e "'Comment:GROMACS living benchmark'" -e "'Machine:CPU'" meta.json
    hpcbench gmxedr ener.edr thermo.json
    hpcbench collate -l sysinfo.json gpulog.json cpulog.json thermo.json power.json run.json slurm.json meta.json meta.json -o ${atoms}_atoms_results.json
    rm benchmark.tpr traj.trr
done

hpcbench table -c "'run:Totals:Number of atoms'" -r "'run:Totals:ns/day'" -r "'run:Totals:J/ns'" . -o results_summary.json
