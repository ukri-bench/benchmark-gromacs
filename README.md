# GROMACS benchmarks

The repository provides benchmarks for [GROMACS](https://www.gromacs.org/).

## Status

Under development.

## Maintainers

- [James Gebbie-Rayet](https://github.com/jimboid)
- [Robert Welch](https://github.com/Rob-Welch) 

## Overview

### Code/library

[GROMACS](https://www.gromacs.org/)

### Architectures

- CPU: x86, Arm64, PPC64
- GPU: NVIDIA, AMD, Intel*

### Languages and programming models

- Programming languages:  C, C++, Python*
- Parallel models: MPI, OpenMP*
- Accelerator offload models: CUDA, OpenCL, SYCL

### Seven 'dwarfs'

- [ ] Dense linear algebra
- [ ] Sparse linear algebra
- [ ] Spectral methods
- [ ] N-body methods
- [ ] Structured grids
- [ ] Unstructured grids
- [ ] Monte Carlo

## Building the benchmark

The benchmark can be built using Spack or manually. If you are using the
ReFrame method to run the benchmark described below, it will automatically
perform the build step for you.

Once it has been built the benchmark executable is called `name-of-exe.x`

### Spack build

Gromacs can be installed from a spack repository maintained by the core
developers:

For GROMACS with MPI for CPU based architecture

```bash
spack install gromacs@2025.2 +mpi
```
For an MPI + CUDA build for NVIDA GPU architecture

```bash
spack install gromacs@2025.2 +mpi +cuda
```

For a multinode, multiGPU compilation targetting specific GPU arch

```bash
spack install gromacs@2025.2 +mpi +cuda cuda_arch=70,80,90 +cufftmp
```

Often better for single NVIDA GPU tests is to use threadMPI and CUDA

```bash
spack install gromacs@2025.2 ~mpi +cuda
```

Enable SYCL for use with Intel and AMD GPUs, may need to add
hardware specific backends to the commands

```bash
spack install gromacs@2025.2 +sycl
```

Note: to use Spack, you must have Spack installed on the system you are using and
a valid Spack system configuration. Example Spack configurations are available
in a separate repository: [https://github.com/ukri-bench/system-configs]

### Manual build

- ADD: Describe (or link to) the manual build process for a systems where
  baseline performance has been measured.
  - Links to multiple sub-pages of instructions can be added if they are
    too long to fit on this page

## Running the benchmark

## Example performance data

This section contains example performance data from selected HPC systems.

ADD: Example performance data

## License

This benchmark description and associated files are released under the MIT license.
