namespace eval ::agate::util {
    namespace export getOrDefault stripGetParameters stripBaseUri
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
        return [string range $uri 0 [expr $pos - 1]]
    }
    return $uri
}

proc ::agate::util::stripBaseUri {uri baseUri} {
    if {[string first $baseUri $uri] == 0} {
        return [string range $uri [string length $baseUri] [string length $uri]]
    } 
    return $uri
}
