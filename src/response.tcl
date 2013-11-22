namespace eval ::agate::response {
    namespace export RivetResponseHandler
}

itcl::class ::agate::response::Response {

    protected variable headerData {}
    protected variable body {}

    constructor {{newBody {}}} {
        set body $newBody
    }

    method setHeader {header value} {
        dict set headerData $header $value
    }

    method getHeader {header} {
        if {dict exists $headerData $header} {
            dict get $headers $header
        } else {
            return {}
        }
    }

    method getHeaders {} {
        return $headerData
    }

    method getBody {} {
        return $body
    }

    method setBody {newBody} {
        set body $newBody
    }
}

itcl::class ::agate::response::RivetResponseHandler {

    private variable headers {}

    constructor {} {
        if {[namespace exists ::rivet]} {
            set headers ::rivet::headers
        } else {
            set headers headers
        }
    }

    method consumeResponse {responseData} {
        set body [$responseData getBody]
        set headerData [$responseData getHeaders]

        itcl::object delete $responseData

        dict for {headerName headerData} $headers {
            $headers set $headerName $headerData
        }
        puts $body
    }
}
