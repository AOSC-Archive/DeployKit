dk_srcs += files(
  'lang.vala',
)

# version.vala.in is a configuration file to be generated
dk_srcs += configure_file(
  input: 'version.vala.in',
  output: 'version.vala',
  configuration: {
    'VERSION': meson.project_version(),
  },
)
