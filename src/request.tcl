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

    private variable load_env load_env
    private variable var_qs var_qs
    private variable var_post var_post

    constructor {} {
        if {[namespace exists ::rivet]} {
            set load_env ::rivet::load_env
            set var_qs ::rivet::var_qs
            set var_post ::rivet::var_post
        }
    }

    method generateHeaderData {} {
        $load_env
        return [dict create {*}[array get ::request::env]]
    }

    method makeRequest {} {
        set request [::agate::request::Request #auto]
        $request setHeaderData [generateHeaderData]
        $request setUri [::agate::util::stripGetParameters [$request getHeader REQUEST_URI]]
        $request setGetData [$var_qs all]
        $request setPostData [$var_post all]
        return [namespace which $request]
    }
}

itcl::class ::agate::request::Request {
    private variable headerData {}
    private variable getData {}
    private variable postData {}
    private variable uri {}

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

    method getUri {} {
        return $uri
    }

    method setUri {newUri} {
        set uri $newUri
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
