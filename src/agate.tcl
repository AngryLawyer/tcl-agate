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

proc ::agate::application {} {
    return [dict create routes [::agate::router::init]]
}

proc ::agate::run {appVar {requestData 0}} {
    upvar $appVar app
    if {$requestData == 0} {
        set requestData [::agate::request::generateRequestData]
    }
    set response [::agate::handle app $requestData]
    puts $response
}

proc ::agate::handle {appVar requestData} {
    upvar $appVar app
    set path [dict get $requestData path]
    set method [dict get $requestData method] 
    set callbackAndParams [::agate::router::matchRoute $app $method $path]
    if {$callbackAndParams != {}} {
        lassign $callbackAndParams callback params
        puts [apply $callback {*}[list $requestData {*}$params]]
    } else {
        puts 404
    }
}

proc ::agate::get {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app GET $path $method
}

proc ::agate::post {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app POST $path $method
}

proc ::agate::put {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app PUT $path $method
}

proc ::agate::delete {appVar path method} {
    upvar $appVar app
    ::agate::router::setRoute app DELETE $path $method
}
