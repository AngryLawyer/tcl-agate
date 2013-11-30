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
    private variable getData {}
    private variable postData {}

    method setHeaderData {newHeaderData} {
        set headerData $newHeaderData
    }

    method getHeader {header {default {}}} {
        return [::agate::util::getOrDefault $headerData $header $default]
    }

    method setGetData {newGetData} {
        set getData $newGetData
    }

    method setPostData {newPostData} {
        set postData $newPostData
    }

    method GET {{key {}} {default {}}} {
        if {$key != {}} {
            return [::agate::util::getOrDefault $getData $key $default]
        }
        return $getData
    }

    method POST {{key {}} {default {}}} {
        if {$key != {}} {
            return [::agate::util::getOrDefault $postData $key $default]
        }
        return $postData
    }
}
