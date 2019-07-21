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
  'src/dk-networkconfig.vala',
  'src/dk-guimain.vala',
  'src/dk-app.vala',
  'src/main.vala',
]

# Add configuration files for versioning, etc
conf_data = configuration_data()
conf_data.set('VERSION', meson.project_version())
sources += configure_file(
  input: 'src/dk-version.vala.in',
  output: 'dk-version.vala',
  configuration : conf_data,
)

# Add resource files
resources = import('gnome').compile_resources(
  'dk-resources',
  'res/dk-resources.gresource.xml',
  source_dir: 'res',
)

# Final executable
executable('aosc-dk', sources + resources, dependencies: dependencies)
