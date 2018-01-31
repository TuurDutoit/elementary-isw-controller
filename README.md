# ISW Controller
[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.tuurdutoit.elementary-isw-controller)

Control ISW systems, like media, airconditioner and the shop

![ISW Controller Screenshot](https://raw.github.com/tuurdutoit/elementary-isw-controller/master/data/screenshot.png)

## Building, Testing, and Installation


You'll need the following dependencies to build:
* libgtk-3-dev
* meson
* valac

Run `meson build` to configure the build environment and run `ninja test` to build and run automated tests

    meson build --prefix=/usr
    cd build
    ninja test

To install, use `ninja install`, then execute with `com.github.tuurdutoit.elementary-isw-controller`

    sudo ninja install
    com.github.tuurdutoit.elementary-isw-controller
