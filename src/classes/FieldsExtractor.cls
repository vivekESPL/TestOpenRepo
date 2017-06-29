/*      Class descrption:  Class contains all the methods to exctract all the related fields
                           required for the loookup filter.
*       Revision History: 
*       Version                         Author                          Date                            Description 
*       1.0                             Amol Chaudhari                02/02/2013                      Intial Draft 
*/
public with sharing class FieldsExtractor {
	//final variables
	private final String SPLIT_CHAR = ',';
	private final String APPEND_CHAR = ': ';
	private final String CATEGORY_CURRENT_USER = 'Current User';
	private final String CATEGORY_CURRENT_RECORD = 'Current Record';
	private final String CATEGORY_CURRENT_LOOKUP = 'Current Lookup';
	private final String CATEGORY_USER = 'Current User';
	private final String ID = ' ID';
	//variables	
	private map<String, String> currentUserObjectsMap;
	private map<string,set<String>> userStandardFieldsMap;
	public list<FieldsMetadata> FieldsList;
	private map<String,String> compatibleTargetFieldTypesMap;
	
	//default constructor
	public FieldsExtractor(){
		currentUserObjectsMap = new map<String,String>();
		userStandardFieldsMap = new map<String,set<String>>();	
		compatibleTargetFieldTypesMap = new map<String,String>();
		compatibleTargetFieldTypesMap = ENV.compatibleTargetFieldTypes();	
		system.debug('_____________'+compatibleTargetFieldTypesMap);
		currentUserObjectsMap.put(label.FieldFilter_User,label.FieldFilter_Current_User);
		currentUserObjectsMap.put(label.FieldFilter_Profile,label.FieldFilter_Current_User_Profile);
		currentUserObjectsMap.put(label.FieldFilter_UserRole,label.FieldFilter_Current_User_Role);
		userStandardFieldsMap = ENV.getUserStandardFields();
	} 
	
	/* mehtod accepting the parameters as Object API and Object Field API Name to get the
	  related list of fields. */  
	public list<FieldsMetadata> getFields(String pObjectAPI, String pObjectFieldAPI){
		FieldsList = new list<FieldsMetadata>();
		getSourceObjectFields(pObjectAPI);
		getParentObjectFields(pObjectAPI, pObjectFieldAPI);
		getGlobalData();
		system.debug('FieldsList...........'+FieldsList.size());
		return FieldsList;
	} //end of method(getFields())

    public list<FieldsMetadata> getSourceObjectFields(String pObjectAPI){
    	FieldsMetadata objFields;
    	List<FieldsMetadata> sourceObjectFieldsList = new List<FieldsMetadata>();
    	set<String> InValidDataTypesForSourceSet = ENV.getInValidFieldsForSourceObject();
    	Map<String, Schema.SObjectField> objectFieldsMap = 
			                                       new Map<String, Schema.SObjectField>();
		objectFieldsMap = Schema.getGlobalDescribe().get(pObjectAPI).
															getDescribe().fields.getMap();
	    Schema.SobjectType sourceObjSFDCObject = getObjectToken(pObjectAPI);
        Schema.DescribeSobjectResult sourceObjectResult = sourceObjSFDCObject.getDescribe();													
		if(objectFieldsMap != null){
			objFields = new FieldsMetadata();
	        objFields.label =  sourceObjectResult.getLabel() + APPEND_CHAR;
	        objFields.category = CATEGORY_CURRENT_RECORD;
	        FieldsList.add(objFields);
	        list<String> sourceFieldsList = new list<String>();
	        sourceFieldsList =  getSortedFields(objectFieldsMap);
			for(String strFieldAPI : sourceFieldsList){
        		Schema.Describefieldresult fieldResult = objectFieldsMap.get(strFieldAPI).getDescribe();
        		String StrFieldDataType = fieldResult.getType().name().toLowerCase();
        	    	if(!(InValidDataTypesForSourceSet.contains(StrFieldDataType))) {
	        	    	objFields = new FieldsMetadata();
	        	    	objFields.label =  sourceObjectResult.getLabel() + APPEND_CHAR + (fieldResult.getLabel());
	        	    	objFields.strAPIName =  strFieldAPI;
	        	    	objFields.strFieldType = fieldResult.getType().name().toLowerCase().capitalize();
	        	    	objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
	        	    	//objFields.strPickListValues = PicklistHelper.getFieldPicklistValues(fieldResult);
	        	    	objFields.strOperators = OperatorHelper.getAvailableOperators(fieldResult);
	        	    	objFields.category = CATEGORY_CURRENT_RECORD;
	        	    	objFields.strObject1 = pObjectAPI;
	        	    	objFields.strObject2 = '';
	        	    	objFields.strField1 = strFieldAPI;
	        	    	objFields.strField2 = '';
	        	    	objFields.strRelationalRefObject1 = '';
						objFields.strRelationalRefObject2 = '';
	        	    	objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(fieldResult);
	        	    	FieldsList.add(objFields);
        	    	} //end if
        	} //end for
		}//end if
													
		return sourceObjectFieldsList;													
    } //end of method(getSourceObjectFields())
    
    //getting the fields related to the parent object to which ObjectFieldAPI is referenced.
    public list<FieldsMetadata> getParentObjectFields(String pObjectAPI, String pObjectFieldAPI){
    	system.debug('*****************in parent method');
    	String strObjectFieldAPILabel = '';
    	FieldsMetadata objFields;
    	String strRelationshipName;
    	List<String> refrenceObjectFieldsList;
    	set<string> standardFieldsSet = new set<string>();
        //getting the set of standard fields for User Object
        if(userStandardFieldsMap != null)
        	standardFieldsSet = userStandardFieldsMap.get('User'); 
        //getting the Invalid list of fields for Parent Object	
        set<String> InValidDataTypesForParentSet = ENV.getInValidFieldsForParentObject();
    	Map<String, Schema.SObjectField> objectFieldsMap = 
			                                       new Map<String, Schema.SObjectField>();
		//getting the metadata information for Source Object (i.e for Object API - 1st parameter)
		objectFieldsMap = Schema.getGlobalDescribe().get(pObjectAPI).
															getDescribe().fields.getMap();
		//getting the Describefieldresult for the Parent Object (using Object Field API - 2nd param)
		Schema.Describefieldresult sourceObjectFieldResult = 
		                                objectFieldsMap.get(pObjectFieldAPI).getDescribe();
		//strRelationshipName = sourceObjectFieldResult.getRelationshipName();     //api of parent object
		List<Schema.Sobjecttype> fieldAPIRelationList =
				                                      new List<Schema.Sobjecttype>(); 
		fieldAPIRelationList = sourceObjectFieldResult.getReferenceTo();
		if(!fieldAPIRelationList.isEmpty())
			strRelationshipName  = String.valueOf(fieldAPIRelationList[0]);
		
		//map of parent object's fields
		objectFieldsMap = Schema.getGlobalDescribe().get(strRelationshipName).
															getDescribe().fields.getMap();
		Schema.SobjectType parentObjSFDCObject = getObjectToken(strRelationshipName);
        Schema.DescribeSobjectResult parentObjectResult = parentObjSFDCObject.getDescribe();	
        strObjectFieldAPILabel = parentObjectResult.getLabel();													
		/* iterating over the fields of parent object, adding the valid fields and checking for field
		  is referenced or not (if referenced getting the corresponding objects fields too)	*/	
		if(objectFieldsMap !=null)  {
			refrenceObjectFieldsList = getSortedFields(objectFieldsMap);
			//refrenceObjectFieldsList.sort();	
		}
		if(!refrenceObjectFieldsList.isEmpty()){
			objFields = new FieldsMetadata();
	        objFields.label =  strObjectFieldAPILabel + APPEND_CHAR;
	        objFields.category = CATEGORY_CURRENT_LOOKUP;
	        FieldsList.add(objFields);
	        // for test
	        Integer i = 0;
			for(String strFieldAPI : refrenceObjectFieldsList) {
				system.debug('*****************in parent method for loop');
				List<Schema.Sobjecttype> strFieldRelationshipList =
				                                      new List<Schema.Sobjecttype>();
				Schema.Describefieldresult fieldResult = objectFieldsMap.get(strFieldAPI).getDescribe();
				i++;
				String StrFieldDataType = fieldResult.getType().name().toLowerCase().capitalize();
				strFieldRelationshipList = fieldResult.getReferenceTo();
				String strFieldRelationship = '';
				Schema.DescribeSObjectResult parentObjectDescribeResult;
				Boolean isObjectCustom = false;
				if(!strFieldRelationshipList.isEmpty()){
					strFieldRelationship = String.valueOf(strFieldRelationshipList[0]);
					Schema.SobjectType objSFDCObject = getObjectToken(strFieldRelationship);
                    parentObjectDescribeResult = objSFDCObject.getDescribe();
                    if(parentObjectDescribeResult.isCustom())
                    	isObjectCustom = true;
				}
				if((!strFieldRelationship.equals('')) 
				              || (strFieldRelationship.equalsIgnoreCase(''))|| (isObjectCustom)) {				
					if(!(InValidDataTypesForParentSet.contains(StrFieldDataType))) {
						if(strFieldRelationship.equals('')){
							if(!(InValidDataTypesForParentSet.contains(fieldResult.getType().name().toLowerCase()))) {
								objFields = new FieldsMetadata();
						    	objFields.label =  strObjectFieldAPILabel + APPEND_CHAR + (fieldResult.getLabel());
						    	objFields.strAPIName =  strFieldAPI;
						    	objFields.strFieldType = fieldResult.getType().name().toLowerCase().capitalize();
		        	    	    objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
						    	objFields.strOperators = OperatorHelper.getAvailableOperators(fieldResult);
						    	//objFields.strPickListValues = PicklistHelper.getFieldPicklistValues(fieldResult);
						    	objFields.category = CATEGORY_CURRENT_LOOKUP;
						    	objFields.strObject1 = strRelationshipName;
			        	    	objFields.strObject2 = '';
			        	    	objFields.strField1 = strFieldAPI;
			        	    	objFields.strField2 = '';
						    	objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(fieldResult);
						    	objFields.strRelationalRefObject1 = strRelationshipName;
						    	objFields.strRelationalRefObject2 = '';
						    	FieldsList.add(objFields);
							  } 	
						  }else{
							Map<String, Schema.SObjectField> parentObjectFieldsMap = 
							                          Schema.getGlobalDescribe().get(strFieldRelationship).
																	            getDescribe().fields.getMap();
							list<String> relationshipList =  getSortedFields(parentObjectFieldsMap);
							objFields = new FieldsMetadata();
							objFields.label =  strObjectFieldAPILabel + APPEND_CHAR + 
					        	    	              fieldResult.getLabel().removeEndIgnoreCase(ID) + ':';
					        objFields.category = CATEGORY_CURRENT_LOOKUP;
					        FieldsList.add(objFields);	    	                       
							if(parentObjectFieldsMap != null){
								for(String strParentField : relationshipList){
								Schema.Describefieldresult parentFieldResult = 
								                              parentObjectFieldsMap.get(strParentField).getDescribe();
								String StrParentFieldDataType = parentFieldResult.getType().name().toLowerCase();
		                        
								if(strFieldRelationship.equalsIgnoreCase('User')) {
									if(standardFieldsSet.contains((parentFieldResult.getLabel().trim()))) {
					        	    	objFields = new FieldsMetadata();
					        	    	objFields.label =  strObjectFieldAPILabel + APPEND_CHAR + 
					        	    	                       fieldResult.getLabel().removeEndIgnoreCase(ID)
					        	    	                        + APPEND_CHAR +  (parentFieldResult.getLabel());
					        	    	objFields.strAPIName =  strParentField;
					        	    	objFields.strFieldType = parentFieldResult.getType().name().toLowerCase().capitalize();
	        	    	                objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
					        	    	objFields.strOperators = OperatorHelper.getAvailableOperators(parentFieldResult);
					        	    	//objFields.strPickListValues = 
					        	    	               //PicklistHelper.getFieldPicklistValues(parentFieldResult);
					        	    	objFields.category = CATEGORY_CURRENT_LOOKUP;
					        	    	objFields.strObject1 = strRelationshipName;
					        	    	objFields.strObject2 = strFieldRelationship;
					        	    	objFields.strField1 = fieldResult.getName();
					        	    	objFields.strField2 = strParentField;
					        	    	objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(parentFieldResult);
					        	    	objFields.strRelationalRefObject1 = strRelationshipName;
						    	        objFields.strRelationalRefObject2 = fieldResult.getRelationshipName();
					        	    	FieldsList.add(objFields);
		        	        	    }  //end if
								}
								else{
									//if(!(InValidDataTypesForParentSet.contains(StrParentFieldDataType))) {
										objFields = new FieldsMetadata();
								    	objFields.label =  strObjectFieldAPILabel + APPEND_CHAR + 
								    	                         fieldResult.getLabel().removeEndIgnoreCase(ID) 
								    	                         + APPEND_CHAR + (parentFieldResult.getLabel());
								    	objFields.strAPIName =  strParentField;
								    	objFields.strFieldType = parentFieldResult.getType().name().toLowerCase().capitalize();
	        	    	                objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
								    	//objFields.strPickListValues = 
					        	    	               //PicklistHelper.getFieldPicklistValues(parentFieldResult);
					        	    	objFields.strOperators = OperatorHelper.getAvailableOperators(parentFieldResult);               
								    	objFields.category = CATEGORY_CURRENT_LOOKUP;
								    	objFields.strObject1 = strRelationshipName;
					        	    	objFields.strObject2 = strFieldRelationship;
					        	    	objFields.strField1 = fieldResult.getName();
					        	    	objFields.strField2 = strParentField;
					        	    	objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(parentFieldResult);
					        	    	objFields.strRelationalRefObject1 = strRelationshipName;
						    	        objFields.strRelationalRefObject2 = fieldResult.getRelationshipName();
								    	FieldsList.add(objFields);
								    //} //end if
							      }//end if-else
								} //enf for
							} //end if
							objFields = new FieldsMetadata();
					    	objFields.label =  strObjectFieldAPILabel + APPEND_CHAR + (fieldResult.getLabel());
					    	objFields.strAPIName =  strFieldAPI;
					    	objFields.strFieldType = fieldResult.getType().name().toLowerCase().capitalize();
	        	    	    objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
					    	objFields.strOperators = OperatorHelper.getAvailableOperators(fieldResult);
					    	//objFields.strPickListValues = 
					        	    	               //PicklistHelper.getFieldPicklistValues(fieldResult);
					    	objFields.category = CATEGORY_CURRENT_LOOKUP;
					    	objFields.strObject1 = pObjectFieldAPI;
					        objFields.strObject2 = '';
					        objFields.strField1 = strFieldAPI;
					        objFields.strField2 = '';
					        objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(fieldResult);
					        objFields.strRelationalRefObject1 = strRelationshipName;
						    objFields.strRelationalRefObject2 = '';
					    	FieldsList.add(objFields);							         
						}  //end if-else
		         	} //end if
		        }//end if    	
			
			} //end for	
			system.debug('------------------------------counter end'+(i++));
		}//end if						
										
    	return null;
    } //end of method(getParentObjectFields())
    
	
	//getting the fields realted to the current user(global data)
	public list<FieldsMetadata> getGlobalData() {
		List<String> currentUserObjectsList = new List<String>();
		List<FieldsMetadata> userFieldsList = new List<FieldsMetadata>();
        FieldsMetadata objFields;
		map<String,list<String>> fieldsMap = new map<String,list<String>>();
		set<String> InValidDataTypesForParentSet = ENV.getInValidFieldsForParentObject();
		list<String> GlobalDataList = new list<String>();
		for(String strUserObject : currentUserObjectsMap.keySet()){
			GlobalDataList.add(currentUserObjectsMap.get(strUserObject));
		}
		GlobalDataList.sort();
		 list<String> userGlobalList;
		/* iterating on all the Current User objects to get the fields and its metadata
		   description for filteration */ 
		for(String strUserObject : GlobalDataList){
			if(strUserObject.equalsIgnoreCase('Current User'))
				strUserObject = 'User';
			else if(strUserObject.equalsIgnoreCase('Current User Profile'))
			    strUserObject = 'Profile';
			else
			    strUserObject = 'UserRole';    	
			List<String> tempList;
			set<string> standardFieldsSet = new set<string>();
        	if(userStandardFieldsMap != null)
        		standardFieldsSet = userStandardFieldsMap.get(strUserObject); 
			Map<String, Schema.SObjectField> objectFieldsMap = 
			                                       new Map<String, Schema.SObjectField>();
			objectFieldsMap = Schema.getGlobalDescribe().get(strUserObject).
															getDescribe().fields.getMap();							
        	tempList = new List<String>();
        	String strUserLabel = currentUserObjectsMap.get(strUserObject);
        	
        	objFields = new FieldsMetadata();
	        objFields.label =  strUserLabel + APPEND_CHAR;
	        objFields.category = CATEGORY_CURRENT_USER;
	        FieldsList.add(objFields);
	        userGlobalList = new list<String>();
        	/* iterating on all the fields for the corresponding object to 
        	    get the related fields for filteration */ 
        	if(objectFieldsMap != null){
        		userGlobalList =  getSortedFields(objectFieldsMap);
        		for(String strFieldAPI : userGlobalList){
        			Schema.Describefieldresult fieldResult = objectFieldsMap.get(strFieldAPI).getDescribe();
        			/* If User field is standtard then getting the fields from standard set only, validating
        			   the custom fields and getting the metadata of corresponsings */
        	    	if(!(fieldResult.isCustom())){
        	    		if(standardFieldsSet.contains((fieldResult.getLabel().trim()))){
		        	    	objFields = new FieldsMetadata();
		        	    	objFields.label =  strUserLabel + APPEND_CHAR + (fieldResult.getLabel());
		        	    	objFields.strAPIName =  strFieldAPI;
		        	    	objFields.strFieldType = fieldResult.getType().name().toLowerCase().capitalize();
	        	    	    objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
		        	    	//objFields.strPickListValues = 
				        	    	               //PicklistHelper.getFieldPicklistValues(fieldResult);
				        	objFields.strOperators = OperatorHelper.getAvailableOperators(fieldResult);    	               
		        	    	objFields.category = CATEGORY_CURRENT_USER;
		        	    	objFields.strObject1 = strUserObject;
	        	    	    objFields.strObject2 = '';
	        	    	    objFields.strField1 = strFieldAPI;
	        	    	    objFields.strField2 = '';
	        	    	    objFields.strRelationalRefObject1 = '';
						    objFields.strRelationalRefObject2 = '';
	        	    	    objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(fieldResult);
		        	    	FieldsList.add(objFields);
        	        	}  
        	    	}else{
        	    			if(!(InValidDataTypesForParentSet.contains((fieldResult.getType().name().toLowerCase())))) {
			        	    	objFields = new FieldsMetadata();
			        	    	objFields.label =  strUserLabel + APPEND_CHAR + (fieldResult.getLabel());
			        	    	objFields.strAPIName =  strFieldAPI;
			        	    	objFields.strFieldType = fieldResult.getType().name().toLowerCase().capitalize();
	        	    	        objFields.strCompatibleTargetFieldTypes = compatibleTargetFieldTypesMap.get(objFields.strFieldType);
			        	    	objFields.strOperators = OperatorHelper.getAvailableOperators(fieldResult);
			        	    	//objFields.strPickListValues = PicklistHelper.getFieldPicklistValues(fieldResult);
			        	    	objFields.category = CATEGORY_CURRENT_USER;
			        	    	objFields.strObject1 = strUserObject;
		        	    	    objFields.strObject2 = '';
		        	    	    objFields.strField1 = strFieldAPI;
		        	    	    objFields.strField2 = '';
		        	    	    objFields.strRelationalRefObject1 = '';
						        objFields.strRelationalRefObject2 = '';
		        	    	    objFields.strSoapType = SoapTypeHelper.getSOAPTypeEnumValues(fieldResult);
			        	    	FieldsList.add(objFields);
        	    			} //end if
        	   		} //end if-else
        		} //end for
        	} //end if 
        	fieldsMap.put(strUserObject,tempList);
		} //end for
		return null;
	} //end of method(getGlobalData())
	
	
	//Method which returns object token of an object
    private static Schema.Sobjecttype getObjectToken(String pOjbectName){
        Map<String, Schema.Sobjecttype> globalDescribeMap = Schema.getGlobalDescribe(); 
        if(globalDescribeMap.size() > 0 && globalDescribeMap.containsKey(pOjbectName))
            return globalDescribeMap.get(pOjbectName);                        
        return null;
    }
    
    /* method which checks for whether Lookup filter is valid or not depends upon the 
       parameters provided ObjectAPI and ObjectFieldAPI */
    public static Boolean isLookupFilterValid(String pObjectAPI, String pObjectFieldAPI) {
    	Map<String, Schema.SObjectField> objectFieldsMap = 
			                                       new Map<String, Schema.SObjectField>();
		set<String> validReferencedObjects = new set<String>();
		String strFieldObjectAPIParentObjectAPI = '';
		Boolean isLookupValid = false;
		Boolean isReferencedObject = false;	    
	    try{ 	
        	objectFieldsMap = Schema.getGlobalDescribe().get(pObjectAPI)
                                                       .getDescribe().fields.getMap();
            Schema.Describefieldresult fieldResult;                                           
            if(objectFieldsMap != null){
            	fieldResult = objectFieldsMap.get(pObjectFieldAPI).getDescribe();
            	if(fieldResult != null){
            		List<Schema.Sobjecttype> strFieldRelationshipList =
				                                      new List<Schema.Sobjecttype>();
				    strFieldRelationshipList = fieldResult.getReferenceTo();
            		strFieldObjectAPIParentObjectAPI = String.valueOf(strFieldRelationshipList[0]);
            		isReferencedObject = ENV.IsValidSobjectsForParent(strFieldObjectAPIParentObjectAPI);
            	}
            }
            if((strFieldObjectAPIParentObjectAPI != '' && isReferencedObject) ||(fieldResult.isCustom())){
            	isLookupValid = true;
            }                                           				                                       
    	    return isLookupValid;
        }catch(Exception e){
        	isLookupValid =false;
        	system.debug('Exception______________________'+isLookupValid);
        	return isLookupValid;
        }
    }
    //sorted list of api names of fields based upon the sorting order of the field labels
    public static list<String> getSortedFields(Map<String, Schema.SObjectField> pObjectFieldsMap) {
    	list<String> sortedFieldsList = new list<String>();
    	list<String> temp = new list<String>();
    	list<String> fieldsLableList = new list<String>();
    	Map<String, Schema.SObjectField> objectFieldsMap = 
			                                       new Map<String, Schema.SObjectField>();	
        objectFieldsMap = pObjectFieldsMap;  
	    for(String strFieldAPI : objectFieldsMap.keySet()){
	    	Schema.Describefieldresult fieldResult = objectFieldsMap.get(strFieldAPI).getDescribe();
	    	String strLabel = fieldResult.getLabel();
	    	Boolean isFound = false;
	    	for(Integer i = 0; i < temp.size(); ++i) {
            	String str = temp.get(i);
            	if(strLabel.compareTo(str) <= 0) {
            		sortedFieldsList.add(i, strFieldAPI);
            		temp.add(i,strLabel);
            		isFound = true;
            		break;
            	}
      		}
	    // not found a greater one in the arrayList
	    if(!isFound){
	    	sortedFieldsList.add(strFieldAPI);  // so append to the end
	        temp.add(strLabel);
	    }
	    system.debug('_________________________'+strLabel+': '+sortedFieldsList);
     }
     system.debug('_________________________'+temp);
     system.debug('_________________________'+sortedFieldsList);
     return sortedFieldsList;
    }
}