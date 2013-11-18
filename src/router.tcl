namespace eval ::agate::router {
    namespace export Router
}

itcl::class ::agate::router::Router {

    private variable routes [dict create GET [list] POST [list] PUT [list] DELETE [list]]

    constructor {} {
    }

    method setRoute {type path method} {
        set paths [dict get $routes $type]
        lappend paths [list $path $method]
        dict set routes $type $paths
    }

    method getRoutes {type} {
        return [dict get $routes $type]
    }

    # Check against a given method type whether any URLs match it
    # @param type The method type to match
    # @param url The input url
    #
    # @return {callback, captured variables} 
    # TODO: This should also handle python-style named params
    method matchRoute {type url} {
        set paths [dict get $routes $type]
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
}
