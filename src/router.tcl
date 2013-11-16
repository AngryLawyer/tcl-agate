namespace eval ::agate::router {
    namespace export init setRoutes getRoutes matchRoute
}

itcl::class ::agate::router::Router {

    private variable routes [dict create GET [list] POST [list] PUT [list] DELETE [list]]

    constructor {} {
    }

    method setRoute {type path method} {
    }

    method getRoutes {type} {
    }

    method matchRoute {type url} {
    }
}

proc ::agate::router::setRoute {appVar type path method} {
    upvar $appVar app
    set paths [dict get $app routes $type]
    lappend paths [list $path $method]
    dict set app routes $type $paths 
}

proc ::agate::router::getRoutes {appVar type} {
    upvar $appVar app
    return [dict get $app routes $type]
}

# Check against a given method type whether any URLs match it
# @param appVar The Agate dictionary
# @param type The method type to match
# @param url The input url
#
# @return {callback, captured variables} 
# TODO: This should also handle python-style named params
proc ::agate::router::matchRoute {app type url} {
    set paths [dict get $app routes $type]
    foreach {path} $paths {
        set result [regexp -inline -- [lindex $path 0] $url]
        if {[llength $result] > 0} {
            # If we have captured variables, we need to return them
            if {[llength $result] > 1} {
                set params [lrange $result 1 end]
            } else {
                set params {}
            }
            return [list [lindex $path 1] $params]
        }
    }
}
