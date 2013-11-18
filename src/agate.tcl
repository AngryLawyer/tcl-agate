package provide agate 0.1

#TODO: Require a specific version
package require Itcl

namespace eval ::agate {
    namespace export application run get post put delete
}

proc ::agate::relativeSource {name} {
    source [file join [file dirname [info script]] $name]
}

agate::relativeSource router.tcl
agate::relativeSource request.tcl

itcl::class ::agate::Application {

    private variable router {}
    private variable requestHandler {}

    constructor {} {
        set router [::agate::router::Router #auto]
        set requestHandler [::agate::request::RequestHandler #auto]
    }

    destructor {
        itcl::delete object $router
        itcl::delete object $requestHandler
    }

    method run {{requestData {}}} {
        if {$requestData == {}} {
            set requestData [$requestHandler generateRequestData]
        }
        puts $requestData
        set response [handle $requestData]
        puts $response
    } 

    method handle {requestData} {
        set path [dict get $requestData path]
        set method [dict get $requestData method] 
        set callbackAndParams [router matchRoute $method $path]
        if {$callbackAndParams != {}} {
            lassign $callbackAndParams callback params
            puts [apply $callback {*}[list $requestData {*}$params]]
        } else {
            puts 404
        }
    }

    method get {path method} {
        $router setRoute GET $path $method
    }

    method post {path method} {
        $router setRoute POST $path $method
    }

    method put {path method} {
        $router setRoute PUT $path $method
    }

    method delete {path method} {
        $router setRoute DELETE $path $method
    }

    method getRoutes {} {
        return "GET [$router getRoutes GET] POST [$router getRoutes POST] PUT [$router getRoutes PUT] DELETE [$router getRoutes DELETE]"
    }

    method getRouter {} {
        return [namespace which $router]
    }
}
