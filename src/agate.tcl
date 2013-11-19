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

    private variable components [dict create \
        requestHandler ::agate::request::RivetRequestHandler \
        router ::agate::router::Router
    ]

    private variable router {}
    private variable requestHandler {}

    constructor {args} {
        $this apply_components {*}args
    }

    destructor {
        itcl::delete object $router
        itcl::delete object $requestHandler
    }

    method apply_components {args} {
        dict for {key ctor} $components {
            if {[llength $args] >= 2 && [dict exists $args "-$key"]} {
                set $key [dict get "-$key"]
            } else {
                set $key [$ctor #auto]
            }
        }
    }

    method run {{requestData {}}} {
        if {$requestData == {}} {
            set requestData [$requestHandler generateRequestData]
        }
        set response [handle $requestData]
        puts $response
    } 

    method handle {requestData} {
        set path [dict get $requestData REQUEST_URI]
        set method [dict get $requestData REQUEST_METHOD] 
        set callbackAndParams [$router matchRoute $method $path]
        if {$callbackAndParams != {}} {
            lassign $callbackAndParams callback params
            set callingArgs [list $requestData {*}$params]
            #TODO: Check we're not calling with more params then available, if the last isn't args
            puts [apply $callback {*}$callingArgs]
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
