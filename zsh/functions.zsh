function retry() {
    echo Retrying "$@"
    $@
    sleep 1
    retry $@
}
