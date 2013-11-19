namespace eval ::agate::request {
    namespace export RivetRequestHandler
}

itcl::class ::agate::request::RivetRequestHandler {
    private variable load_env {}

    constructor {} {
        if {[namespace exists ::rivet]} {
            set load_env ::rivet::load_env
        } else {
            set load_env load_env
        }
    }

    method generateRequestData {} {
        $load_env
        return [dict create {*}[array get ::request::env]]
    }
}
