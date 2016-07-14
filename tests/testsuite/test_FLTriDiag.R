
#Outputs the class of result and result.
test_that("Check for FLTriDiag function which calculates Hessenberg upper diagnol matrix",{
    ## Initialized a matrix using tblMatrixMulti table of database.
    testmatrix <- FLMatrix(getOption("ResultDatabaseFL"), 
                           "tblMatrixMulti", 5,"MATRIX_ID","ROW_ID","COL_ID","CELL_VAL")
    result <- FLTriDiag(testmatrix)
    ##    print(result)
    print(paste0("Class of result is :",class(result)))
})

## Testing FLTriDiag
test_that("check FLTriDiag",
{
    FLTriDiag(initF.FLMatrix(n=5,isSquare=TRUE)$FL)
})