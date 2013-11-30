namespace eval ::agate::util {
    namespace export getOrDefault
}

proc ::agate::util::getOrDefault {group key default} {
    if {[dict exists $group $key]} {
        return [dict get $group $key]
    } else {
        return $default
    }
}
