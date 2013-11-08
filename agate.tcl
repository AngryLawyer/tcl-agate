package provide agate 0.1

namespace eval ::agate {
    namespace export application run get post put delete

    variable app_list [dict create]
    variable last_id 0
}

proc ::agate::application {} {
    variable app_list
    variable last_id

    set id "agate[incr last_id]"
    dict set app_list $id {}
    return $id
}

proc ::agate::run {app {cleanup 1} } {
    puts "RUNNING $app"
    if { $cleanup } {
        ::agate::cleanup $app
    }
}

proc ::agate::get {app, path, method} {
}

proc ::agate::post {app, path, method} {
}

proc ::agate::put {app, path, method} {
}

proc ::agate::delete {app, path, method} {
}

proc ::agate::cleanup {app} {
    variable app_list
    variable last_id
    puts "CLEAN UP"
    puts $last_id
    dict unset app_list $app
}
