# Print the objects
#' @export
print.FLMatrix <- function(object)
{
    print(as.matrix(object,sparse=TRUE))
}

## Prints FLVector object
#' @export
print.FLVector <- function(object)
{
    print(as.vector(object))
}

