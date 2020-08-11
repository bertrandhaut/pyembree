

cdef extern from "embree3/rtcore.h":

    #rtcore_config.h

    cdef int RTC_VERSION_MAJOR
    cdef int RTC_VERSION_MINOR
    cdef int RTC_VERSION_PATCH

    #rtcore_device.h

    # typedef struct __RTCDevice {}* RTCDevice;
    ctypedef void* RTCDevice

    RTCDevice rtcNewDevice(const char* cfg)
    void rtcReleaseDevice(RTCDevice device)

    cdef enum RTCError:
        RTC_ERROR_NONE
        RTC_ERROR_UNKNOWN
        RTC_ERROR_INVALID_ARGUMENT
        RTC_ERROR_INVALID_OPERATION
        RTC_ERROR_OUT_OF_MEMORY
        RTC_ERROR_UNSUPPORTED_CPU
        RTC_ERROR_CANCELLED
    RTCError rtcGetDeviceError(RTCDevice device)

    ctypedef void (*RTCErrorFunc)(void* userPtr, const RTCError code, const char* str)
    void rtcDeviceSetErrorFunction(RTCDevice device, RTCErrorFunc func, void* userPtr)

    cdef enum RTCIntersectContextFlags:
        RTC_INTERSECT_CONTEXT_FLAG_NONE
        RTC_INTERSECT_CONTEXT_FLAG_INCOHERENT
        RTC_INTERSECT_CONTEXT_FLAG_COHERENT

    # cython comment: If the header file declares a big struct and you only want to use a few members,
    # you only need to declare the members you’re interested in.
    # Leaving the rest out doesn’t do any harm, because the C compiler will use the full definition
    # from the header file.
    cdef struct RTCIntersectContext:
        RTCIntersectContextFlags flags

cdef extern from "embree3/rtcore_ray.h":
    pass

cdef struct Vertex:
    float x, y, z, r

cdef struct Triangle:
    int v0, v1, v2

cdef struct Vec3f:
    float x, y, z

cdef void print_error(RTCError code)

cdef class EmbreeDevice:
    cdef RTCDevice device
