#!/usr/bin/env bash

set -ex

# Download and try to pip install some packages


PLAT=$(python -c "import sys;print(sys.platform)")
EXT="${PYPY##*.}"

for BRANCH in trunk py3.6; do
    URL=http://buildbot.pypy.org/nightly/$BRANCH

    echo
    echo xxxxxxxxxxxxxxxx download xxxxxxxxxxxxxxxx 
    echo
    wget -q ${URL}/$PYPY
    if [ "$EXT" == "zip" ]; then
        unzip -q $PYPY
    else
        tar -xf $PYPY
    fi
    rm $PYPY
    pushd pypy-c-*
    if [ "$BRANCH" == "trunk" ]; then
        BASE=pypy
    else
        BASE=pypy3
    fi
    if [ "$PLAT" == "win32" ]; then
        BIN=./$BASE.exe
    else
        BIN=./bin/$BASE
    fi
    if [ "$PLAT" == "darwin" ]; then
        echo
        echo xxxxxxxxxxxxxxxx check sdk xxxxxxxxxxxxxxxx 
        echo
        otool -l lib_pypy/_pypy_openssl*.so 
    fi
    echo
    echo xxxxxxxxxxxxxxxx ensurepip xxxxxxxxxxxxxxxx 
    echo
    $BIN -mensurepip
    $BIN -mpip install flask
    popd
    echo
    echo xxxxxxxxxxxxxxxx cleanup xxxxxxxxxxxxxxxx 
    echo
    rm -rf pypy-c-*
done
