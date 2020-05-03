i18n = import('i18n')

# Define GETTEXT_PACKAGE in C sources
# Note that Vala sources have this defined in Dk.Utils.
add_project_arguments(['-D', 'GETTEXT_PACKAGE="aosc-dk"'], language:'c')

i18n.gettext('aosc-dk', args:[
    '--from-code=UTF-8',
    '--package-name=' + meson.project_name(),
    '--package-version=' + meson.project_version(),
    '--copyright-holder=Anthon Open Source Community',
    '--msgid-bugs-address=https://github.com/AOSC-Dev/DeployKit/issues',
  ]
)
