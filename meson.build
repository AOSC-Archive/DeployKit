project('DeployKit', 'vala', 'c', license: 'MIT', version: '0.1')

# GTK depends on GObject, GLib, and GIO
dependencies = [
  dependency('gtk+-3.0')
]

# Source files
sources = [
  'src/dk-variantrow.vala',
  'src/dk-destinationrow.vala',
  'src/dk-mirrorrow.vala',
  'src/dk-extracomponentrow.vala',
  'src/dk-guimain.vala',
  'src/dk-app.vala',
  'src/main.vala',
]

# Resources files
sources += import('gnome').compile_resources(
  'dk-resources',
  'res/dk-resources.gresource.xml',
  source_dir: 'res',
)

# Final executable
executable('aosc-dk', sources, dependencies: dependencies)
