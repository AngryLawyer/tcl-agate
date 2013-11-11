package provide agate 0.1

namespace eval ::agate {
    namespace export application run get post put delete
}

proc ::agate::relativeSource {name} {
    source [file join [file dirname [info script]] $name]
}

agate::relativeSource router.tcl

proc ::agate::application {} {
    return [dict create routes [::agate::router::init]]
}

proc ::agate::run {app} {
}

proc ::agate::get {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app get $path $method
}

proc ::agate::post {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app post $path $method
}

proc ::agate::put {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app put $path $method
}

proc ::agate::delete {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app delete $path $method
}
