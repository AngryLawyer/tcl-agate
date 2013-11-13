namespace eval ::agate::request {
    namespace export init setRoutes getRoutes
}

proc ::agate::request::generateRequestData {} {

    # TODO: Check for Rivet before actually doing any of this
    ::rivet::load_env
    parray ::request::env
    return [dict create path $::request::env(REQUEST_URI) method $::request::env(REQUEST_METHOD)]
}
