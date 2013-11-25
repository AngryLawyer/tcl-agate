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
        if {[dict exists $headerData $header]} {
            return [dict get $headerData $header]
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

    method setStatusCode {number} {
        $this setHeader Status $number
    }

    method getStatusCode {} {
        $this getHeader Status
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

    method makeResponse {{body {}} {statusCode 200}} {
        set response [::agate::response::Response #auto $body]
        $response setStatusCode $statusCode 
        return [namespace which $response]
    }

    method notFound {{body {}}} {
        return [$this makeResponse $body 404]
    }

    method error {} {
        return [$this makeResponse $body 500]
    }

    method redirect {targetUrl {statusCode 302}} {
        set response [$this makeResponse {} $statusCode]
        $response setHeader Location $targetUrl
        return $response
    }
}
