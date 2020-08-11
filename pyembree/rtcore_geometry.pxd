# rtcore_geometry wrapper

cimport rtcore as rtc

from .rtcore_ray cimport RTCRay, RTCRay4, RTCRay8, RTCRay16
from .rtcore_scene cimport RTCScene
from .rtcore_geometry cimport RTCBufferType

cimport cython
cimport numpy as np

cdef extern from "embree3/rtcore_geometry.h":

    cdef enum RTCGeometryType:
          RTC_GEOMETRY_TYPE_TRIANGLE = 0, # triangle mesh
          RTC_GEOMETRY_TYPE_QUAD     = 1, # quad (triangle pair) mesh
          RTC_GEOMETRY_TYPE_GRID     = 2, # grid mesh

          RTC_GEOMETRY_TYPE_SUBDIVISION = 8, # Catmull-Clark subdivision surface
        
          RTC_GEOMETRY_TYPE_ROUND_LINEAR_CURVE  = 16, # Round (rounded cone like) linear curves 
          RTC_GEOMETRY_TYPE_FLAT_LINEAR_CURVE   = 17, # flat (ribbon-like) linear curves
        
          RTC_GEOMETRY_TYPE_ROUND_BEZIER_CURVE  = 24, # round (tube-like) Bezier curves
          RTC_GEOMETRY_TYPE_FLAT_BEZIER_CURVE   = 25, # flat (ribbon-like) Bezier curves
          RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_BEZIER_CURVE  = 26, # flat normal-oriented Bezier curves
          
          RTC_GEOMETRY_TYPE_ROUND_BSPLINE_CURVE = 32, # round (tube-like) B-spline curves
          RTC_GEOMETRY_TYPE_FLAT_BSPLINE_CURVE  = 33, # flat (ribbon-like) B-spline curves
          RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_BSPLINE_CURVE  = 34, # flat normal-oriented B-spline curves
        
          RTC_GEOMETRY_TYPE_ROUND_HERMITE_CURVE = 40, # round (tube-like) Hermite curves
          RTC_GEOMETRY_TYPE_FLAT_HERMITE_CURVE  = 41, # flat (ribbon-like) Hermite curves
          RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_HERMITE_CURVE  = 42, # flat normal-oriented Hermite curves
        
          RTC_GEOMETRY_TYPE_SPHERE_POINT = 50,
          RTC_GEOMETRY_TYPE_DISC_POINT = 51,
          RTC_GEOMETRY_TYPE_ORIENTED_DISC_POINT = 52,
        
          RTC_GEOMETRY_TYPE_ROUND_CATMULL_ROM_CURVE = 58, # round (tube-like) Catmull-Rom curves
          RTC_GEOMETRY_TYPE_FLAT_CATMULL_ROM_CURVE  = 59, # flat (ribbon-like) Catmull-Rom curves
          RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_CATMULL_ROM_CURVE  = 60, # flat normal-oriented Catmull-Rom curves
        
          RTC_GEOMETRY_TYPE_USER     = 120, # user-defined geometry
          RTC_GEOMETRY_TYPE_INSTANCE = 121  # scene instance


    ctypedef void* RTCGeometry
    RTCGeometry rtcNewGeometry(rtc.RTCDevice hdevice, RTCGeometryType type)

    void rtcReleaseGeometry(RTCGeometry hgeometry)


    void* rtcSetNewGeometryBuffer(RTCGeometry hgeometry, RTCBufferType type, unsigned int slot, rtc.RTCFormat format, size_t byteStride, size_t itemCount)

    void rtcSetSharedGeometryBuffer(RTCGeometry hgeometry, RTCBufferType type, unsigned int slot, rtc.RTCFormat format, const void* ptr, size_t byteOffset, size_t byteStride, size_t itemCount)


    void rtcCommitGeometry (RTCGeometry hgeometry)

    unsigned int rtcAttachGeometry (RTCScene hscene, RTCGeometry hgeometry)
