#!/usr/bin/env python
from pyembree import __version__

from setuptools import setup, find_packages
import numpy as np
from Cython.Build import cythonize

include_path = [np.get_include()]

ext_modules = cythonize('pyembree/*.pyx',
                        include_path=include_path,
                        gdb_debug=True)
for ext in ext_modules:
    ext.include_dirs = include_path
    ext.libraries = ["embree3"]



setup(
    name="pyembree",
    version=__version__,
    ext_modules=ext_modules,
    zip_safe=False,
    packages=find_packages(),
    package_data = {'pyembree': ['*.pxd']}
)
