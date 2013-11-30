namespace eval ::agate::request {
    namespace export RivetRequestHandler
}

itcl::class ::agate::request::BaseRequestHandler {

    method generateHeaderData {} {
        return {}
    }

    method makeRequest {} {
        set request [::agate::request::Request #auto]
        $request setHeaderData [generateHeaderData]
        return [namespace which $request]
    }
}

itcl::class ::agate::request::RivetRequestHandler {
    inherit ::agate::request::BaseRequestHandler

    private variable load_env {}

    constructor {} {
        if {[namespace exists ::rivet]} {
            set load_env ::rivet::load_env
        } else {
            set load_env load_env
        }
    }

    method generateHeaderData {} {
        $load_env
        return [dict create {*}[array get ::request::env]]
    }

    method makeRequest {} {
        set request [::agate::request::Request #auto]
        $request setHeaderData [generateHeaderData]
        return [namespace which $request]
    }
}

itcl::class ::agate::request::Request {
    private variable headerData {}

    method setHeaderData {newHeaderData} {
        set headerData $newHeaderData
    }

    method getHeader {header {default {}}} {
        if {[dict exists $headerData $header]} {
            return [dict get $headerData $header]
        } else {
            return $default
        }
    }
}
