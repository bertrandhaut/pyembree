"""
A small performance test.

Ideally should be standalone but relying here on trimesh package for testcase creation
"""
import logging
logging.basicConfig(level=logging.DEBUG)

import sys
import time
import trimesh.creation
from trimesh.ray.ray_pyembree import RayMeshIntersector
import numpy as np
from memory_profiler import profile
import gc

import pyembree.rtcore as rtc


from pyembree.rtcore_scene import EmbreeScene
from pyembree.mesh_construction import TriangleMesh

import psutil


__author__ = 'Laborelec, Math & IT service'

logger = logging.getLogger(__name__)

def print_meminfo(space=0):
    for proc in psutil.process_iter():
        if 'python' == proc.name():
            logger.info('')
            logger.info(f'{" "*space}, {proc.pid}, {proc.name()}, {proc.cmdline()[-1]}')
            logger.info(f'{" "*space}, {proc.memory_info()}')
            return


def f():
    print_meminfo(space=3)

    device = rtc.EmbreeDevice()
    scene = EmbreeScene(embree_device=device)

    n_t = 10000000
    print_meminfo(space=3)
    vertices = np.zeros((n_t, 3), dtype='float32')
    indices = np.ones((n_t, 3), dtype='int32')
    print_meminfo(space=3)
    TriangleMesh(scene, vertices=vertices, indices=indices)
    print_meminfo(space=3)


@profile()
def mem_test():
    """
    This function

    :param subdivisions:
    :return:
    """
    print_meminfo()

    print('1')
    f()
    gc.collect()
    print_meminfo()
    print('2')
    f()
    gc.collect()
    print_meminfo()
    print('3')
    f()
    gc.collect()
    print_meminfo()
    print('4')
    f()
    gc.collect()
    print_meminfo()


if __name__ == '__main__':
    mem_test()
