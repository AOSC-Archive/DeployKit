dk_deps += [
  dependency('gtk+-3.0', version: '>=3.20'),
  dependency('libsoup-2.4'),
]

dk_srcs += files(
  'rows/common.vala',
  'rows/variant.vala',
  'rows/destination.vala',
  'rows/mirror.vala',
  'rows/extracomponent.vala',

  'networkconfig.vala',
  'main.vala',
)

dk_args += ['-D', 'BUILD_GUI']

add_project_arguments(dk_args, language: 'vala')
