FLLinRegr <- function( 	Tbl,
						DepCol,
						Note     = "From RWrapper For DBLytix",
						PrimaryKey,
						Exclude      = c(),
						ClassSpec    = list(),
						WhereClause  = ""){

	ObsIDColName  <- "ObsID";
	VarIDColName  <- "VarID";
	ValueColName  <- "Num_Val";
	
	DataPrepRes <- FLRegrDataPrep( 	Tbl,
									DepCol,
									ObsIDColName = ObsIDColName,
									VarIDColName = VarIDColName,
									ValueColName = ValueColName,
									PrimaryKey   = PrimaryKey,
									Exclude      = Exclude,
									ClassSpec    = ClassSpec,
									WhereClause  = WhereClause);
	DeepTableName        <- DataPrepRes$DeepTableName
	WidetoDeepAnalysisID <- DataPrepRes$WidetoDeepAnalysisID
	DBConnection         <- Tbl@ODBCConnection;
	SQLStr               <- "CALL FLLinRegr('";
	SQLParameters <- paste(	DeepTableName,
							ObsIDColName,  
							VarIDColName, 
							ValueColName, 							
							Note, sep="','")
	SQLStr           <- paste(SQLStr, SQLParameters,"', AnalysisID)", sep="")
	
	#print(SQLStr)
	#run LinRegr
	LinRegRes        <- sqlQuery(DBConnection, SQLStr);
	#print(LinRegRes)
	AnalysisID       <- toString(LinRegRes[1,"AnalysisID"]);

	RetData = new("FLLinRegr",AnalysisID = AnalysisID, ODBCConnection = DBConnection, DeepTableName = DeepTableName, WidetoDeepAnalysisID = WidetoDeepAnalysisID);
	
	return(RetData);
}

# runFLLinRegrDBLytix returns the coefficient table for Linear Regression as in DBLytix
runFLLinRegrDBLytix <- function(Tbl,
						DepCol,
						Note     = "From RWrapper For DBLytix",
						PrimaryKey,
						Exclude      = c(),
						ClassSpec    = list(),
						WhereClause  = "") {
	Analysis 	<- FLLinRegr(Tbl, DepCol, Note, PrimaryKey, Exclude, ClassSpec)
	Analysis 	<- fetch.results(Analysis)
	CoeffTable 	<- Analysis@coeffs
	return(CoeffTable[,c(3:5)])
}