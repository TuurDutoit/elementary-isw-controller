if ./scripts/build.sh ; then
    cd build
    sudo ninja install
else
    echo "Build error."
    exit 1
fi
