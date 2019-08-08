# AOSC OS DeployKit

The new installation and recovery utility for AOSC OS.

This repository contains the reference implementation of DeployKit frontend. The backend of DeployKit is at [AOSC-Dev/libaoscdeploykit](https://github.com/AOSC-Dev/libaoscdeploykit).

## Dependencies

To build DeployKit, the following build dependencies are required:

- The Vala compiler (`valac`)
  - To build the HTML API reference, `valadoc` is also required, which is shipped with the Vala compiler, but may not on some Linux distributions
  - Since Vala transpiles to C, a C compiler (e.g. GCC) is also required to produce binary object files and the final executable
- The Meson build system (`meson`)

The following libraries are required both during compile-time and run-time:

- **GLib** 2.x (`glib-2.0`): The very fundamental library used in software written in Vala
  - Along with GObject 2.x (`gobject-2.0`, the GLib object system) and GIO 2.x (`gio-2.0`, the GLib input / output system), which are usually shipped with GLib
- **LibGee** 0.8+ (`libgee-0.8`): The GObject-based data structure library for Vala
- **JSON-GLib** 1.x (`json-glib-1.0`): The GObject-based JSON parsing and generating library
- **LibSoup** 2.4+ (`libsoup-2.4`): The GObject-based HTTP(S) client / server
- **GTK** 3.x (`gtk+-3.0`): The famous toolkit for building nice graphical user interfaces

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

- `-Dbuild_docs=false` to disable HTML documentation build using `valadoc`.
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
