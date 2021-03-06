#' @include FLMatrix.R
NULL

#' Inverse of a Matrix.
#'
#' \code{solve} computes the inverse for FLMatrix objects.
#'
#' The wrapper overloads solve and implicitly calls FLMatrixInvUdt.
#' @param x is of class FLMatrix
#' @param ... any additional arguments
#' @section Constraints:
#' Input can only be a square matrix (n x n) with maximum dimension limitations
#' of (1000 x 1000).
#' @return \code{solve} returns a FLMatrix object which is the inverse of input FLMatrix object
#' and replicates the equivalent R output.
#' @examples
#' connection <- flConnect(odbcSource="Gandalf")
#' flmatrix <- FLMatrix("FL_DEMO", 
#' "tblMatrixMulti", 2,"MATRIX_ID","ROW_ID","COL_ID","CELL_VAL")
#' resultFLMatrix <- solve(flmatrix)
#' @export
solve <- function (a,b=NULL, ...){
	UseMethod("solve", a)
}
#solve.default <- base::solve
# do not define solve.default in this package as it is already defined in base::solve.default.
# It might lead to stack overflow.


#' @export
solve.FLMatrix <- function(a,b=NULL,...)
{
    ## checkSquare(object,"solve")
    ## checkSingularity(object)
  if(is.null(b))
  return(FLInv(a))
  else
  return(FLInv(a)%*%b)
}


FLInv <- function(x,...)
{

  sqlstr<-paste0(viewSelectMatrix(x, "mtrx", withName="z"),
                 outputSelectMatrix("FLMatrixInvUdt",
                                    viewName="z",
                                    localName="mtrx",
                                    includeMID=TRUE)
                )

  tblfunqueryobj <- new("FLTableFunctionQuery",
                        connection = getOption("connectionFL"),
                        variables=list(
                            rowIdColumn="OutputRowNum",
                            colIdColumn="OutputColNum",
                            valueColumn="OutputVal"),
                        whereconditions="",
                        order = "",
                        SQLquery=sqlstr)

  flm <- new("FLMatrix",
             select= tblfunqueryobj,
             dim=rev(dim(x)),
             dimnames=rev(dimnames(x)))

   return(ensureQuerySize(pResult=flm,
            pInput=list(x),
            pOperator="FLInv",
            pStoreResult=TRUE))

}
