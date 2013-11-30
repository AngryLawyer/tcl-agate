package provide agate 0.1

#TODO: Require a specific version
package require Itcl

namespace eval ::agate {
    namespace export application run get post put delete
}

proc ::agate::relativeSource {name} {
    source [file join [file dirname [info script]] $name]
}

agate::relativeSource util.tcl
agate::relativeSource router.tcl
agate::relativeSource request.tcl
agate::relativeSource response.tcl

itcl::class ::agate::Application {

    private variable components [dict create \
        requestHandler ::agate::request::RivetRequestHandler \
        router ::agate::router::Router \
        responseHandler ::agate::response::RivetResponseHandler
    ]

    private variable router {}
    private variable requestHandler {}
    private variable responseHandler {}

    constructor {args} {
        $this apply_components {*}args
    }

    destructor {
        itcl::delete object $router
        itcl::delete object $requestHandler
        itcl::delete object $responseHandler
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

    method run {{request {}}} {
        if {$request == {}} {
            set request [$requestHandler makeRequest]
            set owned 1
        } else {
            set owned 0
        }

        set response [handle $request]

        if {$owned} {
            itcl::delete object $request
        }

        return [$responseHandler consumeResponse $response]
    } 

    method handle {request} {
        set path [$request getHeader REQUEST_URI /]
        set method [$request getHeader REQUEST_METHOD GET]

        set callbackAndParams [$router matchRoute $method $path]
        if {$callbackAndParams != {}} {
            lassign $callbackAndParams callback params
            # Prepend our additional values for access to $request and $this
            set callingArgs [list $this $request [$this getResponseHandler] {*}$params]
            set callbackArgs [list this request responseHandler {*}[lindex $callback 0]]

            set callingArgsLength [llength $callingArgs]
            set callbackArgsLength [llength $callbackArgs]

            set lengthComparison [expr $callbackArgsLength - $callingArgsLength]
            if {$lengthComparison > 0} {
                # We got more callbackArgs than callingArgs? Inflate, and pass empty strings
                set callingArgs [list {*}$callingArgs {*}[lrepeat $lengthComparison {}]]
            } elseif {$lengthComparison < 0} {
                # If we've got more callingArgs than callbackArgs, truncate 
                set callingArgs [lrange $callingArgs 0 [expr $callbackArgsLength - 1]]
            }

            set callback [list $callbackArgs [lindex $callback 1]]
            set response [apply $callback {*}$callingArgs]

            if {[itcl::is object $response] == 0} {
                set response [$responseHandler makeResponse $response]
            }

            return $response
        } else {
            return [$responseHandler notFound]
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

    method getResponseHandler {} {
        return [namespace which $responseHandler]
    }
}
