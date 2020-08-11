#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh

conda activate pyembree3

# set embree2 path
export CPATH=/home/vagrant/dev/pyembree-3/embree-3.11.0.x86_64.linux/include
export LIBRARY_PATH=/home/vagrant/dev/pyembree-3/embree-3.11.0.x86_64.linux/lib

python setup.py build && python setup.py install
