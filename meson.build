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

# Set up documentation target to generate one from valadoc
if get_option('build_documentation')
  valadoc = find_program('valadoc')

  # Generate the package import options for valadoc
  pkgs_valac = []
  foreach d : dependencies
    pkgs_valac += '--pkg'
    pkgs_valac += d.name()
  endforeach

  custom_target(
    'docs',
    build_by_default: true,
    input: sources,
    output: 'docs',
    command: [
      valadoc,
      pkgs_valac,
      '--package-name', meson.project_name(),
      '--package-version', meson.project_version(),
      '--internal',
      '--private',
      '--use-svg-images',
      '--force',
      '--basedir', meson.current_source_dir(),
      '--directory', '@OUTPUT@',
      '@INPUT@'
    ]
  )
endif
