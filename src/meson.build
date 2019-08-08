dk_deps = [
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
  dependency('glib-2.0'),
]

dk_srcs = files(
  'app.vala',
  'main.vala',
)

dk_args = []

# Submodules of DeployKit will add their dependencies to dk_deps and their
# source files to dk_srcs if necessary.
subdir('recipe')
subdir('utils')

# The following optional submodules will additionally add extra arguments to be
# passed to the compiler (often preprocessor ones) to dk_args.
if get_option('build_gui')
  subdir('gui')
endif

executable('aosc-dk', dk_srcs + dk_res, dependencies: dk_deps, gui_app: true)
