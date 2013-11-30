namespace eval ::agate::util {
    namespace export getOrDefault stripGetParameters
}

proc ::agate::util::getOrDefault {group key default} {
    if {[dict exists $group $key]} {
        return [dict get $group $key]
    } else {
        return $default
    }
}

proc ::agate::util::stripGetParameters {uri} {
    set pos [string first ? $uri]
    if {$pos > -1} {
        return  [string range $uri 0 [expr $pos - 1]]
    }
    return $uri
}
