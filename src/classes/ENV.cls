/*      Class descrption:    This apex class is aimed at storing all the generic settings that are
*                            required for custom Field Filter Functionality
*       Revision History: 
*       Version                 Author                      Date                        Description 
*       1.0                     Siddharth Birari            01/02/2013                  Initial draft
*
*       1.1                     Amol Chaudhari              05/02/2013                  added all the required mappings
*
*		1.2						Siddharth Birari			12/02/2013					Made necessary changes in
*																						getOpratorsMapping and 					 
*																						getFieldTypeVsOprators1 and 
*																						commented getFieldTypeVsOprators
*
*		1.3						Siddharth Birari			14/02/2013					Introduced an inner class named
*																						FilterableFields which would
*																						essentially store the filter logic details
*/

public with sharing class ENV {
	// map of user realted fields
	private static map<String,set<String>> userFieldsMap; 
    
    //User standard fields as per standard SFDC lookup filter
 	private static void setUserFields() {
 		userFieldsMap = new map<string,set<String>>();
 	    set<String> userProfileFieldsSet = new set<String>();
 	    set<String> userRoleFieldsSet = new set<String>();
 	    set<String> userFieldsSet = new set<String>();
 	    
	    userProfileFieldsSet.add('Created By ID');
	    userProfileFieldsSet.add('Description');
	    userProfileFieldsSet.add('Created Date');
 	    userProfileFieldsSet.add('Last Modified By ID');
 	    userProfileFieldsSet.add('Last Modified Date');
	    userProfileFieldsSet.add('Manage Users');
 	    userProfileFieldsSet.add('Profile ID');
	    userProfileFieldsSet.add('Name');
 	    userProfileFieldsSet.add('User Type');
 	    
 	    userRoleFieldsSet.add('Case Access Level for Account Owner');
 		userRoleFieldsSet.add('Contact Access Level for Account Owner');
 		userRoleFieldsSet.add('Description');
 		userRoleFieldsSet.add('Developer Name');
 		userRoleFieldsSet.add('Last Modified By ID');
 		userRoleFieldsSet.add('Last Modified Date');
 		userRoleFieldsSet.add('May Forecast Manager Share');
 		userRoleFieldsSet.add('Name');
 		userRoleFieldsSet.add('Opportunity Access Level for Account Owner');
 		userRoleFieldsSet.add('Portal Role');
 		userRoleFieldsSet.add('Portal Type');
 		userRoleFieldsSet.add('Role ID');
 	    
 	    userFieldsSet.add('Active');
		userFieldsSet.add('Alias');
		userFieldsSet.add('Cell');
		userFieldsSet.add('City');
		userFieldsSet.add('Community Nickname');
		userFieldsSet.add('Company Name');
		userFieldsSet.add('Contact ID');
		userFieldsSet.add('Country');
		userFieldsSet.add('Department');
		userFieldsSet.add('Division');
		userFieldsSet.add('E-mail');
		userFieldsSet.add('Employee Number');
		userFieldsSet.add('End of Day');
		userFieldsSet.add('Extension');
		userFieldsSet.add('Fax');
		userFieldsSet.add('First Name');
		userFieldsSet.add('Last Name');
		userFieldsSet.add('Manager ID');
		userFieldsSet.add('Phone');
		userFieldsSet.add('Profile ID');
		userFieldsSet.add('Role ID');
		userFieldsSet.add('Self-Registered via Customer Portal');
		userFieldsSet.add('Start of Day');
		userFieldsSet.add('State/Province');
		userFieldsSet.add('Street');
		userFieldsSet.add('Title');
		userFieldsSet.add('User ID');
		userFieldsSet.add('Username');
		userFieldsSet.add('User Type');
		userFieldsSet.add('Zip/Postal Code');
 	    
 	    userFieldsMap.put('Profile',userProfileFieldsSet);
 	    userFieldsMap.put('UserRole',userRoleFieldsSet);
 	    userFieldsMap.put('User',userFieldsSet);
 	}
 	
 	//getting the map of user fields for the lookup filter
 	public static map<String,set<String>> getUserStandardFields(){
 		setUserFields();
 		system.debug('------------userFieldsMap'+userFieldsMap.size());
 		return userFieldsMap;
 	}
 	
 	//getting the invalid field data type list for the Source Object
 	public static set<String> getInValidFieldsForSourceObject(){
 		set<String> strInValidSourceObjectFieldsDataTypes = new set<String>();
 		strInValidSourceObjectFieldsDataTypes.add('autonumber');
	    strInValidSourceObjectFieldsDataTypes.add('encrypted');
	    strInValidSourceObjectFieldsDataTypes.add('formula');
	    strInValidSourceObjectFieldsDataTypes.add('long text area');
	    strInValidSourceObjectFieldsDataTypes.add('multipicklist');
	    strInValidSourceObjectFieldsDataTypes.add('roll-up summary');
	    strInValidSourceObjectFieldsDataTypes.add('string');
	    strInValidSourceObjectFieldsDataTypes.add('textarea');
	    strInValidSourceObjectFieldsDataTypes.add('url');
	    strInValidSourceObjectFieldsDataTypes.add('phone');
 		strInValidSourceObjectFieldsDataTypes.add('encryptedstring');
 		return strInValidSourceObjectFieldsDataTypes;
 	}
	
 	//getting the invalid field data type list for the Parent(referenced) Object
 	public static set<String> getInValidFieldsForParentObject(){
 		set<String> strInValidParentObjectFieldsDataTypes = new set<String>();
 		strInValidParentObjectFieldsDataTypes.add('autonumber');
	    strInValidParentObjectFieldsDataTypes.add('encrypted');
	    strInValidParentObjectFieldsDataTypes.add('formula');
	    strInValidParentObjectFieldsDataTypes.add('multipicklist');
	    strInValidParentObjectFieldsDataTypes.add('roll-up summary');
	    strInValidParentObjectFieldsDataTypes.add('textarea');
	    strInValidParentObjectFieldsDataTypes.add('encryptedstring'); 		
 		return strInValidParentObjectFieldsDataTypes;
 	}
 	
 	//checking for if refrenced object is valid or not as per standard SFDC
	public static Boolean IsValidSobjectsForParent(String pstrSObject){
 		set<String> validSobjectsForParentSet = new set<String>();	
	    validSobjectsForParentSet.add('Account');
	    validSobjectsForParentSet.add('Asset');
	    validSobjectsForParentSet.add('Contact');
	    validSobjectsForParentSet.add('User');
        if(validSobjectsForParentSet.contains(pstrSObject))
        	return true;
        else
            return false; 	
 	}
 	
 	//getting the map of compatible source vs target data types for validataion for filter save
 	public static map<String,String> compatibleTargetFieldTypes()  {
 		map<String,String> compatibleTargetFieldTypesMap = new map<String,String>();
 		compatibleTargetFieldTypesMap.put('Currency','Currency,Double');
 		compatibleTargetFieldTypesMap.put('Picklist','String,Picklist,Text,Textarea,Email,Url');
 		compatibleTargetFieldTypesMap.put('Date','Date,Datetime,Double');
 		compatibleTargetFieldTypesMap.put('Datetime','Datetime,Date,Double');
 		compatibleTargetFieldTypesMap.put('Lookup','Reference,Lookup,Hierarchy');
 		compatibleTargetFieldTypesMap.put('Reference','Id,Reference,Lookup,Hierarchy');
 		compatibleTargetFieldTypesMap.put('Hierarchy','Reference,Lookup,Hierarchy');
 		compatibleTargetFieldTypesMap.put('Number','Number,Percent,Double');
 		compatibleTargetFieldTypesMap.put('Percent','Number,Percent,Double');
 		compatibleTargetFieldTypesMap.put('Double','Currency,Number,Date,Datetime,Double');
 		compatibleTargetFieldTypesMap.put('Phone','Phone,Currency,Double,Number');
 		compatibleTargetFieldTypesMap.put('Boolean','Boolean');
 		compatibleTargetFieldTypesMap.put('String','String,Picklist,Text,Textarea,Url,Email,Phone');
 		compatibleTargetFieldTypesMap.put('Id','Id,Reference,Lookup,Hierarchy');
 		compatibleTargetFieldTypesMap.put('Textarea','Textarea');
 		return compatibleTargetFieldTypesMap;
 	}
 	
 	//getting the map of operators vs unique number (later string these nos in custom object)
 	public static map<Integer,String> getOpratorsMapping() {
 		map<Integer,String> operatorsMap = new map<Integer,String>();	
		
		//changes 1.2 Siddharth Birari
		
		operatorsMap.put(1,'equals');
		operatorsMap.put(2,'not equal to');
		operatorsMap.put(3,'starts with');
		operatorsMap.put(4,'contains');
		operatorsMap.put(5,'does not contain');
		operatorsMap.put(6,'less than');
		operatorsMap.put(7,'greater than');
		operatorsMap.put(8,'less or equal');
		operatorsMap.put(9,'greater or equal');
		operatorsMap.put(10,'includes');
		operatorsMap.put(11,'excludes');
		operatorsMap.put(12,'within');
		 
        return operatorsMap;	
 	}
 	
 	//changes 1.2 Siddharth Birari
 	public static map<String,String> getFieldTypeVsOprators1() {
 		map<String,String> fieldTypesVsOperatorsMap = new map<String,String>();

		fieldTypesVsOperatorsMap.put('reference','1,2,3');
		fieldTypesVsOperatorsMap.put('date','1,2,6,7,8,9');
		fieldTypesVsOperatorsMap.put('datetime','1,2,6,7,8,9');
		fieldTypesVsOperatorsMap.put('string','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('textarea','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('phone','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('number','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('boolean','1,2');
		fieldTypesVsOperatorsMap.put('picklist','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('integer','1,2,4,5,3');
		fieldTypesVsOperatorsMap.put('id','1,2,3');
		fieldTypesVsOperatorsMap.put('percent','1,2,6,7,8,9');
        fieldTypesVsOperatorsMap.put('currency','1,2,6,7,8,9');
        fieldTypesVsOperatorsMap.put('email','1,2,4,5,3');
        fieldTypesVsOperatorsMap.put('double','1,2,6,7,8,9');
        return fieldTypesVsOperatorsMap;	
 	}
 	
 	//changes 1.3 Siddharth Birari
 	//Inner class representing field filters
 	public class FilterableFields{
 		
 		public Integer intFilterOrder;				//Filter Number 
 		public String strSourceFieldLabel;			//Field Label for the selected Source Field (Needs to deprecated from Schema)
 		public String strSourceFieldApi;			//Field Api for the selected Source Field
 		
 		public Integer intOperator;					//Number representation of the operator selected for the filter criteria Populated Externally
 		public String strOperator;					//String representing the operator selected for the filter criteria
 		
 		public Boolean blnTargetIsField;			//Populated Externally
 		public String strTargetIsField;				//String with either 'true' or 'false' representing if field/value has been selected 
 		
 		public String strTargetFieldLabel;			//Field Label for the selected Target Field (Needs to deprecated from Schema)
 		public String strTargetFieldApi;			//Field Api for the selected Target Field
 		public String strTargetValues;				//String representing the value entered in the target textbox
 		public String strSourceFieldType;			//String representing the field type of the source field selected
 		
 		//Fields Necessary for CR#1
 		
 		public Boolean blnSrcFirstRelational;
 		public Boolean blnSrcSecondRelational;
 		public String strSrcSFType;
 		public String strSrcSoapType;
 		public String strSrcObjFirst;
 		public String strSrcFieldFirst;
 		public String strSrcObjSecond;
 		public String strSrcFieldSecond;
 		public String strSrcRelRefObj1;
 		public String strSrcRelRefObj2;
 		
 		public Boolean blnTrgtFirstRelational;
 		public Boolean blnTrgtSecondRelational; 		
 		public String strTrgtSFType;
 		public String strTrgtSoapType;
 		public String strTrgtObjFirst;
 		public String strTrgtFieldFirst;
 		public String strTrgtObjSecond;
 		public String strTrgtFieldSecond;
 		public String strTrgtRelRefObj1;
 		public String strTrgtRelRefObj2; 		
 	}
}