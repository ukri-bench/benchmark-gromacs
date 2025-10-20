# GROMACS benchmarks

The repository provides benchmarks for [GROMACS](https://www.gromacs.org/).

## Status

Under development.

## Maintainers

- Maintainer 1 (Link to github profile)
- Maintainer 2 (Link to github profile)
- ...

## Overview

### Code/library

[GROMACS](https://www.gromacs.org/)

### Architectures

- CPU: *e.g. x86, Arm*
- GPU: *e.g. NVIDIA, AMD, Intel*
- Other: *e.g. Cerebras, ...*

### Languages and programming models

- Programming languages: *e.g. Fortran, C++, Python*
- Parallel models: *e.g. MPI, OpenMP*
- Accelerator offload models: *e.g. CUDA, HIP, OpenACC, Kokkos*

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

A Spack package is provided in `spack/`:

```bash
spack repo add ./spack
spack info <package name>
```
- ADD: Describe Spack spec and variants available

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
