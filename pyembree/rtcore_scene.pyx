import numpy as np
import logging
import numbers
import time

cimport rtcore as rtc
cimport rtcore_ray as rtcr


log = logging.getLogger(__name__)

cdef void error_printer(void * user_ptr, const rtc.RTCError code, const char *_str):
    """
    error_printer function depends on embree version
    Embree 2.14.1
    -> cdef void error_printer(const rtc.RTCError code, const char *_str):
    Embree 2.17.1
    -> cdef void error_printer(void* userPtr, const rtc.RTCError code, const char *_str):
    """
    log.error("ERROR CAUGHT IN EMBREE")
    rtc.print_error(code)
    log.error("ERROR MESSAGE: %s" % _str)

# cdef bint memory_monitor_printer(void* ptr, ssize_t bytes, bint post):
#     log.debug('memory monitor:')
#     log.debug('bytes', bytes, 'post', post)
#     return True
#

cdef class EmbreeScene:
    def __cinit__(self, rtc.EmbreeDevice embree_device=None):
        if embree_device is None:
            # We store the embree device inside EmbreeScene to avoid premature deletion
            embree_device = rtc.EmbreeDevice()
            log.debug('New device created')

        self.embree_device = embree_device
        rtc.rtcRetainDevice(self.embree_device.device)  # will be released in desctructor

        rtc.rtcSetDeviceErrorFunction(self.embree_device.device, error_printer, NULL)
        # rtc.rtcSetDeviceMemoryMonitorFunction(self.embree_device.device, memory_monitor_printer, NULL)

        self.scene_i = rtcNewScene(self.embree_device.device)
        self.is_committed = 0

    def run(self, np.ndarray[np.float32_t, ndim=2] vec_origins,
                  np.ndarray[np.float32_t, ndim=2] vec_directions,
                  dists=None,query='INTERSECT',output=None):

        if self.is_committed == 0:
            rtcCommitScene(self.scene_i)
            self.is_committed = 1
        start_time = time.time()

        cdef int nv = vec_origins.shape[0]
        cdef int vo_i, vd_i, vd_step
        cdef np.ndarray[np.int32_t, ndim=1] intersect_ids
        cdef np.ndarray[np.float32_t, ndim=1] tfars
        cdef rayQueryType query_type

        if query == 'INTERSECT':
            query_type = intersect
        elif query == 'OCCLUDED':
            query_type = occluded
            raise NotImplemented
        elif query == 'DISTANCE':
            query_type = distance
            raise NotImplemented

        else:
            raise ValueError("Embree ray query type %s not recognized." 
                "\nAccepted types are (INTERSECT,OCCLUDED,DISTANCE)" % (query))

        if dists is None:
            tfars = np.empty(nv, 'float32')
            tfars.fill(1e37)
        elif isinstance(dists, numbers.Number):
            tfars = np.empty(nv, 'float32')
            tfars.fill(dists)
        else:
            tfars = dists

        if output:
            u = np.empty(nv, dtype="float32")
            v = np.empty(nv, dtype="float32")
            Ng = np.empty((nv, 3), dtype="float32")
            primID = np.empty(nv, dtype="int32")
            geomID = np.empty(nv, dtype="int32")
        else:
            intersect_ids = np.empty(nv, dtype="int32")


        cdef rtc.RTCIntersectContext context
        rtc.rtcInitIntersectContext(&context)

        cdef rtcr.RTCRayHit ray_hit
        vd_i = 0
        vd_step = 1
        # If vec_directions is 1 long, we won't be updating it.
        if vec_directions.shape[0] == 1: vd_step = 0

        for i in range(nv):
            ray_hit.ray.org_x = vec_origins[i, 0]
            ray_hit.ray.org_y = vec_origins[i, 1]
            ray_hit.ray.org_z = vec_origins[i, 2]

            ray_hit.ray.dir_x = vec_directions[vd_i, 0]
            ray_hit.ray.dir_y = vec_directions[vd_i, 1]
            ray_hit.ray.dir_z = vec_directions[vd_i, 2]

            ray_hit.ray.tnear = 0.0
            ray_hit.ray.tfar = tfars[i]
            ray_hit.ray.mask = -1
            ray_hit.ray.time = 0

            ray_hit.hit.geomID = rtc.RTC_INVALID_GEOMETRY_ID
            ray_hit.hit.primID = rtc.RTC_INVALID_GEOMETRY_ID
            ray_hit.hit.instID[0] = rtc.RTC_INVALID_GEOMETRY_ID
            vd_i += vd_step

            if query_type == intersect or query_type == distance:
                rtcIntersect1(self.scene_i, &context, &ray_hit)

                if not output:
                    if query_type == intersect:
                        intersect_ids[i] = ray_hit.hit.primID
                    else:
                        tfars[i] = ray_hit.ray.tfar
                else:
                    primID[i] = ray_hit.hit.primID
                    geomID[i] = ray_hit.hit.geomID
                    u[i] = ray_hit.hit.u
                    v[i] = ray_hit.hit.v
                    tfars[i] = ray_hit.ray.tfar

                    Ng[i, 0] = ray_hit.hit.Ng_x
                    Ng[i, 1] = ray_hit.hit.Ng_y
                    Ng[i, 2] = ray_hit.hit.Ng_z
            else:
                raise NotImplemented()
                # rtcOccluded(self.scene_i, ray)
                # intersect_ids[i] = ray.geomID

        end_time = time.time()
        log.debug(f'Total elapsed time {end_time-start_time:.1f}')

        if output:
            return {'u':u, 'v':v, 'Ng': Ng, 'tfar': tfars, 'primID': primID, 'geomID': geomID}
        else:
            if query_type == distance:
                return tfars
            else:
                return intersect_ids

    def __dealloc__(self):
        rtcReleaseScene(self.scene_i)
        log.debug(f'Scene released')
