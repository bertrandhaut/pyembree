# distutils: language=c++

# rtcore_scene.pxd wrapper

cimport cython
cimport numpy as np
cimport rtcore as rtc
cimport rtcore_ray as rtcr

cdef extern from "embree3/rtcore_scene.h":

    ctypedef struct RTCRayHit
    ctypedef struct RTCRayHit4
    ctypedef struct RTCRayHit8
    ctypedef struct RTCRayHit16
    ctypedef struct RTCRayHitNp

    ctypedef void* RTCScene
    RTCScene rtcNewScene(rtc.RTCDevice device)

    cdef enum RTCSceneFlags:
        RTC_SCENE_FLAG_NONE
        RTC_SCENE_FLAG_DYNAMIC
        RTC_SCENE_FLAG_COMPACT
        RTC_SCENE_FLAG_ROBUST
        RTC_SCENE_FLAG_CONTEXT_FILTER_FUNCTION

#    cdef enum RTCAlgorithmFlags:
#        RTC_INTERSECT1
#        RTC_INTERSECT4
#        RTC_INTERSECT8
#        RTC_INTERSECT16

    void rtcSetSceneFlags(RTCScene scene, RTCSceneFlags flags)

    #RTCScene rtcDeviceNewScene(rtc.RTCDevice device, RTCSceneFlags flags, RTCAlgorithmFlags aflags)

    ctypedef bint (*RTCProgressMonitorFunc)(void* ptr, const double n)
    void rtcSetProgressMonitorFunction(RTCScene scene, RTCProgressMonitorFunc func, void* ptr)

    void rtcCommitScene(RTCScene scene)

    void rtcJoinCommitScene(RTCScene scene)


    void rtcIntersect1(RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit* ray)

    void rtcIntersect4(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit4* ray)

    void rtcIntersect8(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit8* ray)

    void rtcIntersect16(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit16* ray)

    void rtcIntersect1M(RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit* rayhit, unsigned int M, size_t byteStride);


    void rtcOccluded(RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit* ray)

    void rtcOccluded4(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit4* ray)

    void rtcOccluded8(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit8* ray)

    void rtcOccluded16(const void* valid, RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit16* ray)

    void rtcOccluded1M(RTCScene scene, rtc.RTCIntersectContext* context, RTCRayHit* ray, unsigned int M, size_t byteStride);

    void rtcReleaseScene(RTCScene scene)

cdef class EmbreeScene:
    cdef RTCScene scene_i
    # Optional device used if not given, it should be as input of EmbreeScene
    cdef bint compact
    cdef public int is_committed
    cdef rtc.EmbreeDevice embree_device

cdef enum rayQueryType:
    intersect,
    occluded,
    distance
