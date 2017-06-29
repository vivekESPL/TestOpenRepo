/*      Class descrption:  Class describes all the metatadata information related to the field.
*                          List of the same will get passed to main UI (e.g fields which are 
*                          available for filteration) 
*       Revision History: 
*       Version                         Author                          Date                            Description 
*       1.0                             Amol Chaudhari                  31/01/2013                      Intial Draft 
*/
public with sharing class Fields {
	public string strAPIName{get;set;}
	public string label{get;set;}
	public string strFieldType{get;set;}
	public string category{get;set;}
	//public string strPickListValues{get;set;}
}