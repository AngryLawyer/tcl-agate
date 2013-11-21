namespace eval ::agate::response {
    namespace export RivetResponseHandler
}

itcl::class ::agate::response::Response {
}

itcl::class ::agate::response::RivetResponseHandler {

    method generateResponseData {} {
    }

    method consumeResponse {responseData} {
        itcl::object delete responseData
    }
}
