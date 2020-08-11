# distutils: language=c++


cimport cython
cimport numpy as np

cdef extern from "embree3/rtcore_ray.h":
    # RTCORE_ALIGN(16)
    # This is for a *single* ray
    cdef struct RTCRay:
        # Ray data
        float org_x
        float org_y
        float org_z
        float tnear

        float dir_x
        float dir_y
        float dir_z

        float time
        float tfar

        unsigned int mask

    cdef struct RTCHit:
        float Ng_x
        float Ng_y
        float Ng_z

        float u
        float v

        unsigned int geomID
        unsigned int primID
        unsigned int instID[1]

    cdef struct RTCRayHit:
        RTCRay ray
        RTCHit hit

    # This is for a packet of 4 rays
    cdef struct RTCRay4:
        # Ray data
        # Ray data
        float org_x[4]
        float org_y[4]
        float org_z[4]
        float tnear[4]

        float dir_x[4]
        float dir_y[4]
        float dir_z[4]

        float time[4]
        float tfar[4]

        unsigned int mask[4]

    cdef struct RTCHit4:
        float Ng_x[4]
        float Ng_y[4]
        float Ng_z[4]

        float u[4]
        float v[4]

        unsigned int geomID[4]
        unsigned int primID[4]
        unsigned int instID[1][4]

    cdef struct RTCRayHit4:
        RTCRay4 ray
        RTCHit4 hit

    # This is for a packet of 8 rays
    cdef struct RTCRay8:
        # Ray data
        # Ray data
        float org_x[8]
        float org_y[8]
        float org_z[8]
        float tnear[8]

        float dir_x[8]
        float dir_y[8]
        float dir_z[8]

        float time[8]
        float tfar[8]

        unsigned int mask[8]

    cdef struct RTCHit8:
        float Ng_x[8]
        float Ng_y[8]
        float Ng_z[8]

        float u[8]
        float v[8]

        unsigned int geomID[8]
        unsigned int primID[8]
        unsigned int instID[1][8]

    cdef struct RTCRayHit8:
        RTCRay8 ray
        RTCHit8 hit

    # This is for a packet of 16 rays
    cdef struct RTCRay16:
        # Ray data
        float org_x[16]
        float org_y[16]
        float org_z[16]
        float tnear[16]

        float dir_x[16]
        float dir_y[16]
        float dir_z[16]

        float time[16]
        float tfar[16]

        unsigned int mask[16]

    cdef struct RTCHit16:
        float Ng_x[16]
        float Ng_y[16]
        float Ng_z[16]

        float u[16]
        float v[16]

        unsigned int geomID[16]
        unsigned int primID[16]
        unsigned int instID[1][16]

    cdef struct RTCRayHit16:
        RTCRay16 ray
        RTCHit16 hit