#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh

conda activate pyembree2

# set embree2 path
export LD_LIBRARY_PATH=/home/vagrant/dev/pyembree-2/embree-2.17.6.x86_64.linux/lib

python tests/test_intersection.py
