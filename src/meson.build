dk_deps = [
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
  dependency('glib-2.0'),
]

dk_srcs = files(
  'app.vala',
  'main.vala',
)

subdir('recipe')
subdir('utils')

subdir('gui')

executable('aosc-dk', dk_srcs + dk_res, dependencies: dk_deps, gui_app: true)
