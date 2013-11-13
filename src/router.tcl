namespace eval ::agate::router {
    namespace export init setRoutes getRoutes
}

proc ::agate::router::init {} {
    return [dict create get [list] post [list] put [list] delete [list]]
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

# TODO: This should also handle python-style named params
proc ::agate::router::matchRoute {appVar type url} {
    upvar $appVar app
    set paths [dict get $app routes $type]
    foreach {path} $paths {
        set result [regexp -inline -- [lindex $path 0] $url]
        if {[llength $result] > 0} {
            return [lindex $path 1]
        }
    }
}
