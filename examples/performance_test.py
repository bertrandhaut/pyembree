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

from pyembree.rtcore_scene import EmbreeScene
from pyembree.mesh_construction import TriangleMesh

__author__ = 'Laborelec, Math & IT service'

logger = logging.getLogger(__name__)


@profile()
def check_sphere_visibility(subdivisions=3):
    """
    This function

    :param subdivisions:
    :return:
    """

    # create a mesh corresponding to a sphere at (0,0,0)
    mesh = trimesh.creation.icosphere(subdivisions=subdivisions,
                                      radius=1.0)
    triangle_centers = mesh.triangles_center.astype('float32')

    observer_position = np.array([100, 0, 0], dtype='float32')

    ray_origins = np.repeat(observer_position[None, :], len(mesh.faces), axis=0)
    ray_directions = triangle_centers - observer_position

    scene = EmbreeScene()
    TriangleMesh(scene,
                 vertices=mesh.vertices,
                 indices=mesh.faces)

    intersect_ids = np.array(list(range(len(ray_origins))), dtype='int32')
    # intersect_ids = np.ones(len(ray_origins), 'int32')  # easier monitoring of the scene.run memory increase

    logger.info('Starting trimesh intersection')
    start_time = time.time()
    intersect_ids = scene.run(vec_origins=ray_origins,
                              vec_directions=ray_directions)
    end_time = time.time()
    logger.info(f'Total elapsed time: {end_time-start_time:.1f}')

    # force gc
    logger.info('Forcing scene deletion and gc')
    del intersect_ids
    del scene
    gc.collect()
    #
    # # Converting intersects_id to a "hit/not hit" array
    # visible = np.zeros(len(triangle_centers), dtype=bool)
    # visible[intersect_ids] = True
    #
    # # front of sphere (x>0) should be visible, back (x<0) not
    # x_vis_pos = triangle_centers[visible, 0]
    # assert (sum(x_vis_pos >= 0) / len(x_vis_pos)) > 0.9  # the point around x=0 can be visible or invisible
    #
    # x_hidden_pos = triangle_centers[~visible, 0]
    # assert (sum(x_hidden_pos <= 0) / len(x_hidden_pos)) > 0.9

    logger.info('Ending performance test')

if __name__ == '__main__':
    check_sphere_visibility(7)
