project('com.github.tuurdutoit.elementary-isw-controller', ['vala', 'c'],
    version: '0.2.0'
)

gnome = import('gnome')
i18n = import('i18n')

asresources = gnome.compile_resources(
    'as-resources', 'data/css.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h',
  '-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE',
]

executable(
    'com.github.tuurdutoit.elementary-isw-controller',
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/view/MediaView.vala',
    'src/view/SoundboardView.vala',
    'src/service/MediaService.vala',
    'src/service/SoundboardService.vala',
    'src/service/ISWService.vala',
    asresources,
    c_args: c_args,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gee-0.8'),
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0')
    ],
    install : true
)

meson.add_install_script('meson/post_install.py')

subdir('data')
subdir('po')
