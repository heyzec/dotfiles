find . \
    -name 'install.sh' \
    ! -path "$0" \
    -exec sh {} \;

