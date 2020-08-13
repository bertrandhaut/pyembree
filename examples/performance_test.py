"""
A small performance test.

Ideally should be standalone but relying here on trimesh package for testcase creation
"""
import logging
logging.basicConfig(level=logging.DEBUG)

import os
import psutil
import time
import trimesh.creation
import numpy as np
import gc

from pyembree.rtcore_scene import EmbreeScene
from pyembree.mesh_construction import TriangleMesh

__author__ = 'Laborelec, Math & IT service'

logger = logging.getLogger(__name__)


def get_current_memory_str():
    pid = os.getpid()
    proc = psutil.Process(pid)
    return str(proc.memory_info())


def get_prob_data(subdivisions=3):
    # create a mesh corresponding to a sphere at (0,0,0)
    mesh = trimesh.creation.icosphere(subdivisions=subdivisions,
                                      radius=1.0)
    triangle_centers = mesh.triangles_center.astype('float32')

    observer_position = np.array([100, 0, 0], dtype='float32')

    ray_origins = np.repeat(observer_position[None, :], len(mesh.faces), axis=0)
    ray_directions = triangle_centers - observer_position

    vertices = mesh.vertices
    faces = mesh.faces

    return vertices, faces, ray_origins, ray_directions


def check_sphere_visibility(subdivisions=3, check_assert=True):
    """
    This function

    :param subdivisions:
    :return:
    """
    vertices, faces, ray_origins, ray_directions = get_prob_data(subdivisions=subdivisions)

    scene = EmbreeScene(compact=True)
    logger.info('Scene created')
    logger.info('Before geometry creation ' + get_current_memory_str())
    start_time = time.time()
    TriangleMesh(scene,
                 vertices=vertices,
                 indices=faces)
    scene.commit()
    end_time = time.time()
    logger.info(f'Geometry total elapsed time: {end_time - start_time:.1f}')
    logger.info('Geometry added')
    if not check_assert:
        # no more needed
        del vertices, faces
    logger.info('After geometry creation ' + get_current_memory_str())

    logger.info('Starting trimesh intersection')
    start_time = time.time()
    intersect_ids = scene.run(vec_origins=ray_origins,
                              vec_directions=ray_directions)
    end_time = time.time()
    logger.info(f'Run total elapsed time: {end_time-start_time:.1f}')

    # force gc
    logger.info('Forcing scene deletion and gc')
    del scene
    gc.collect()
    logger.info('After scene cleaning '+get_current_memory_str())

    if check_assert:
        triangle_positions = vertices[faces[:, 0]]  # position of first nodes

        # Converting intersects_id to a "hit/not hit" array
        visible = np.zeros(len(triangle_positions), dtype=bool)
        visible[intersect_ids] = True

        # front of sphere (x>0) should be visible, back (x<0) not
        x_vis_pos = triangle_positions[visible, 0]
        assert (sum(x_vis_pos >= 0) / len(x_vis_pos)) > 0.9  # the point around x=0 can be visible or invisible

        x_hidden_pos = triangle_positions[~visible, 0]
        assert (sum(x_hidden_pos <= 0) / len(x_hidden_pos)) > 0.9

    logger.info('Ending performance test')


if __name__ == '__main__':
    check_sphere_visibility(10, check_assert=False)
