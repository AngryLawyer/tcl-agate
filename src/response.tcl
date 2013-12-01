namespace eval ::agate::response {
    namespace export RivetResponseHandler
}

itcl::class ::agate::response::Response {

    protected variable statusCode 200
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
        set statusCode $number
    }

    method getStatusCode {} {
        return $statusCode
    }
}

itcl::class ::agate::response::RivetResponseHandler {

    private variable headers {}

    constructor {{headersOverride {}}} {
        if {$headersOverride == {}} {
            if {[namespace exists ::rivet]} {
                set headers ::rivet::headers
            } else {
                set headers headers
            }
        } else {
            set headers $headersOverride
        }
    }

    method consumeResponse {responseData} {
        set body [$responseData getBody]
        set headerData [$responseData getHeaders]
        set statusCode [$responseData getStatusCode]

        itcl::delete object $responseData

        $headers numeric $statusCode

        dict for {headerName headerData} $headerData {
            if {$headerName == {Content-Type}} {
                #Rivet handles Content-Type differently from normal headers
                $headers type $headerData
            } else {
                $headers set $headerName $headerData
            }
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
