import logging


logger = logging.getLogger(__name__)

cdef void print_error(RTCError code):
    if code == RTC_ERROR_NONE:
        logger.error("ERROR: No error")
    elif code == RTC_ERROR_UNKNOWN:
        logger.error("ERROR: Unknown error")
    elif code == RTC_ERROR_INVALID_ARGUMENT:
        logger.error("ERROR: Invalid argument")
    elif code == RTC_ERROR_INVALID_OPERATION:
        logger.error("ERROR: Invalid operation")
    elif code == RTC_ERROR_OUT_OF_MEMORY:
        logger.error("ERROR: Out of memory")
    elif code == RTC_ERROR_UNSUPPORTED_CPU:
        logger.error("ERROR: Unsupported CPU")
    elif code == RTC_ERROR_CANCELLED:
        logger.error("ERROR: Cancelled")
    else:
        raise RuntimeError


cdef class EmbreeDevice:
    def __cinit__(self):
        self.device = rtcNewDevice(NULL)
        logger.debug('rtcNewDevice created and stored')

    def __dealloc__(self):
        rtcReleaseDevice(self.device)
        logger.debug('Device released')

    def __repr__(self):
        return 'Embree version:  {0}.{1}.{2}'.format(RTC_VERSION_MAJOR,
                                                     RTC_VERSION_MINOR,
                                                     RTC_VERSION_PATCH)
