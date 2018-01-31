set -e
rm -rf build
meson build --prefix=/usr
cd build
ninja
ninja test
