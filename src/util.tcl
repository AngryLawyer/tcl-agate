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
    return $uri
}
