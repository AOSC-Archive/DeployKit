# AOSC OS DeployKit

The new installation and recovery utility for AOSC OS.

This repository contains the reference implementation of DeployKit frontend. The backend of DeployKit is at [AOSC-Dev/libaoscdeploykit](https://github.com/AOSC-Dev/libaoscdeploykit).

## Build

Use [Meson](https://mesonbuild.com):

```shell
mkdir build && cd build

# Use meson to configure the project
meson ..

# Use ninja to build the project (parallel build by default)
ninja
```

[Options](meson_options.txt) can be set with `meson` to customize the build:

- `-Dbuild_documentation=false` to disable HTML documentation build using `valadoc`.
- More to come...

## Features

(Some of the following features are still under development, so stay tuned!)

- Choose, customize, and install AOSC OS with a straightforward graphical user interface
- Offering "general" mode for newcomers and "expert" mode for power users
- Providing command line inerface (CLI) for batch operation and terminal lovers
- Search and restore your AOSC OS backups
- Repair your AOSC OS installation

DeployKit is designed to be used with **LiveKit**, which is the new, planned pre-installation environment of AOSC OS. When DeployKit is used with LiveKit, it can perform various offline operations to the AOSC OS installation on a local disk / partition.

DeployKit is still in its early stage of development, and you're welcomed to contribute to this project!

## Supported Platform

So far: LiveKit only. (See above)

## License

This project is licensed under the MIT license. See [COPYING](COPYING) for details.
