/*
	DataBase NameSpace Import
*/

#Include "Base.ah2"
#Include "ArchLogger.ah2"
#Include "MemoryBuffer.ah2"
#Include "Collection.ah2"
#Include "ADO.ah2"
#Include "SQLite_L.ah2"
#Include "mySQL.ah2"


class DBA ; namespace DBA
{
	/*
	* All thefollowing included classes will be contained in the DBA namespace
	* which is actually just an encapsulating class
	*
	*/
	
	;base classes
	#Include "DataBaseFactory.ah2"
	#Include "DataBaseAbstract.ah2"
	

	; Concrete SQL-Provider Implementations
	#Include "DataBaseSQLLite.ah2"
	#Include "DataBaseMySQL.ah2"
	#Include "DataBaseADO.ah2"
	
	#Include "RecordSetSqlLite.ah2"
	#Include "RecordSetADO.ah2"
	#Include "RecordSetMySQL.ah2"
}