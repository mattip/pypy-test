#!/usr/bin/env bash

set -ex

# Download and try to pip install some packages


URL=http://buildbot.pypy.org/nightly/trunk
EXT="${PYPY##*.}"

echo $EXT
wget ${URL}/$PYPY
if [ "$EXT" == "zip" ]; then
    unzip $PYPY
else
    tar -xf $PYPY
fi
rm $PYPY
cd pypy-c-*
bin/pypy -mensurepip
bin/pypy -mpip install flask
