package com.microsoft.c12.asoallowedlocations


violation[{"msg": msg }] {
    locationInSpec := input.review.object.spec.location
    not contains_items(input.parameters.allowedlocations, locationInSpec)
    msg:= sprintf("The resource has location '%s' which is denied by policy", [locationInSpec])
}

violation[{"msg": msg }] {
    input.review.kind.kind  == "CosmosDB"
    offendingLocation := input.review.object.spec.locations[_].locationName
  	not contains_items(input.parameters.allowedlocations, offendingLocation)
    msg:= sprintf("The CosmosDB resource uses location '%s' in locations  which is denied by policy", [offendingLocation])
}

contains_items(haystack, needle) {
  haystack[_] == needle
}