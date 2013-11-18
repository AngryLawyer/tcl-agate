namespace eval ::agate::request {
    namespace export RequestHandler
}

itcl::class ::agate::request::RequestHandler {
    method generateRequestData {} {
        return [dict create [array get $::request::env]]
    }
}
