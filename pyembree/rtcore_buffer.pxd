# distutils: language=c++

cdef extern from "embree3/rtcore_buffer.h":

    cdef enum RTCBufferType:
      RTC_BUFFER_TYPE_INDEX            = 0
      RTC_BUFFER_TYPE_VERTEX           = 1
      RTC_BUFFER_TYPE_VERTEX_ATTRIBUTE = 2
      RTC_BUFFER_TYPE_NORMAL           = 3
      RTC_BUFFER_TYPE_TANGENT          = 4
      RTC_BUFFER_TYPE_NORMAL_DERIVATIVE = 5

      RTC_BUFFER_TYPE_GRID                 = 8

      RTC_BUFFER_TYPE_FACE                 = 16
      RTC_BUFFER_TYPE_LEVEL                = 17
      RTC_BUFFER_TYPE_EDGE_CREASE_INDEX    = 18
      RTC_BUFFER_TYPE_EDGE_CREASE_WEIGHT   = 19
      RTC_BUFFER_TYPE_VERTEX_CREASE_INDEX  = 20
      RTC_BUFFER_TYPE_VERTEX_CREASE_WEIGHT = 21
      RTC_BUFFER_TYPE_HOLE                 = 22

      RTC_BUFFER_TYPE_FLAGS = 32

