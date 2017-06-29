/*      Class descrption:  Custom controller for the page FormulaFilterLookup VF page.
                           Describes the functinality of lookup window if field is of data type Picklist or Boolean   
*       Revision History: 
*       Version                         Author                          Date                            Description 
*       1.0                             Amol Chaudhari                  11/01/2013                      Intial Draft 
*/
public with sharing class FormulaeFilterLookupController {
	//final varibales
	private final string FIELD_TYPE = 'fType';
	private final string PICKLIST_VALUES = 'pValues';
	private final string INPUT_VALUE = 'pInputValue';
	private final string OBJECTAPI = 'objApi';
	private final string FIELDAPI = 'fieldApi';
	private final string TARGET_FIELD_ID = 'filterTargetId';
	private final string FIELD_TYPE_PICKLIST = 'Picklist';
	private final string FIELD_TYPE_BOOLEAN = 'Boolean'; 
	private final string FIELD_FILTER_INDEX = 'pFilterIndex';
	//variables
	public string fieldDataType{get;set;}                  //data type of the field 
    public string fieldPickListValues{get;set;}            //picklist values for the field
    public string filterTargetId{get;set;}                 //target id of the parent field
    public List<String> picklistValuesList {get;set;}      //list os picklistvalues 
    public List<FieldsName> fieldsNameList {get;set;}
    public String strSelectedValues{get;set;}
    public Boolean blnPicklist {get;set;}
    public list<String> booleanValuesList{get;set;}
    public Integer filterIndex{get;set;}
    public string hiddenValueId{get;set;}
    public string strInputValue{get;set;}
    
    //inner class which populates based on the picklist values of the corresponding field.
    public class FieldsName {
    	public string strPicklistValue{get;set;}
    	public Integer srNo{get;set;} 
    	public Boolean isRemove{get;set;}
    }
    
    
    //constructor - getting the parameters from querystring and populates the list of inner class.
    public FormulaeFilterLookupController(){
    	picklistValuesList = new List<String>();
    	BooleanValuesList = new list<String>();
    	fieldDataType = ApexPages.currentPage().getParameters().get(FIELD_TYPE);
    	filterTargetId = ApexPages.currentPage().getParameters().get(TARGET_FIELD_ID);
    	filterIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get(FIELD_FILTER_INDEX));
    	strInputValue = ApexPages.currentPage().getParameters().get(INPUT_VALUE);
    	hiddenValueId = 'hiddenValue'+filterIndex;
    	BooleanValuesList.add('True');
    	BooleanValuesList.add('False');
    	if((fieldDataType != null) || (fieldDataType != '')){
    		if(fieldDataType.equalsIgnoreCase(FIELD_TYPE_PICKLIST)){
    			
    			String strObjectApi = ApexPages.currentPage().getParameters().get(OBJECTAPI);
    			String strFieldApi = ApexPages.currentPage().getParameters().get(FIELDAPI);
    			
    			//Object Describe
		    	Map<String, Schema.SObjectField> objectFieldsMap = 
					                                       new Map<String, Schema.SObjectField>();
				objectFieldsMap = Schema.getGlobalDescribe().get(strObjectApi).
																	getDescribe().fields.getMap();    			
    			//Field Describe
    			Schema.Describefieldresult fieldResult = objectFieldsMap.get(strFieldAPI).getDescribe();
    			fieldPickListValues = PicklistHelper.getFieldPicklistValues(fieldResult);
    			blnPicklist = true;
    			fieldsNameList = getPicklistValues(fieldPickListValues);
    		}
    		else{
    			blnPicklist = false;
    		}
    	}
    } 
    
    //returning the list of inner class used for bindings with VF UI
    public List<FieldsName> getFieldsNameList() {
    	return fieldsNameList;	
    }
    
    //returning the lest of all boolean values
    public List<String> getFieldsBooleanValues() {
    	return booleanValuesList;
    }
     
     //populating the string of seleceted picklist values
     public Pagereference selectedValues() {
     	system.debug('_______________________fieldsNameList'+fieldsNameList);
     	strSelectedValues = '';
     	List<String> inputValuesList = new List<String>();
     	String splitChr = '\\*\\*\\*\\*';
    	/*if((!strInputValue.equals('')) && strInputValue!=null && (!strInputValue.equals('\'\''))){
    		inputValuesList = strInputValue.split(splitChr);
    		for(String strInputVal : inputValuesList){
    			if(strSelectedValues.equalsIgnoreCase('')){
     				strSelectedValues = strInputVal;
     			}else{
     				strSelectedValues = strSelectedValues+PicklistHelper.pickListSplitKey+strInputVal;
     			} 
    		}
    	}*/
    	String strNewSelection = '';
        for(FieldsName objFieldsName:fieldsNameList){
     		if(objFieldsName.isRemove) {
     			if(strNewSelection.equalsIgnoreCase('')){
     				strNewSelection = objFieldsName.strPicklistValue;
     			}else{
     				strNewSelection = strNewSelection+PicklistHelper.pickListSplitKey+(objFieldsName.strPicklistValue);
     			} 
     		}
     	}
     
     	strNewSelection = getPicklistValuesSplittedByComma(strNewSelection);
     	if(!strSelectedValues.equals(''))
     		strSelectedValues = strSelectedValues + ','+ strNewSelection;
     	else
     	  	strSelectedValues = strSelectedValues + strNewSelection;
     	  	
     	system.debug('________strSelectedValues'+strSelectedValues);
    	return null;	
    }
    
    /* getting the picklist values splitted by **** and returning the comma separated picklist values result of the same, adds
    the delimeter " if any of the picklist value contains , itself in the value */
    private string getPicklistValuesSplittedByComma(string pPicklistValuesSplittedByStar) {
		String splitChar = '\\*\\*\\*\\*'; 
		List<String> valuesList = new List<String>();
		valuesList = pPicklistValuesSplittedByStar.split(splitChar);
		String strPickListValuesSplittedByComma = '';
		for(String str : valuesList){
			if(strPickListValuesSplittedByComma.equals('')){
				if(str.contains(',')) {
					str = '"'+str+'"';
					strPickListValuesSplittedByComma = str;
				}else {
					strPickListValuesSplittedByComma = str;
				}
		    }else { 
		   	   if(str.contains(',')) { 
		   	   	     str = '"'+str+'"'; 
		   	   	     strPickListValuesSplittedByComma = strPickListValuesSplittedByComma + ',' + str;
		   	   }else {
		   	   	    strPickListValuesSplittedByComma= strPickListValuesSplittedByComma+','+str;
		   	   }
		   }
		}
		system.debug('----------------------'+strPickListValuesSplittedByComma);
    	return strPickListValuesSplittedByComma;
    }
    
    //getting the picklist values of the corresponding field
    private List<FieldsName> getPicklistValues(string pStrPicklistValues) {
    	List<String> valuesList = new List<String>();
    	List<FieldsName> fieldsList = new List<FieldsName>();
    	String splitChar = '\\*\\*\\*\\*'; 
    	valuesList = pStrPicklistValues.split(splitChar);
    	Integer i = 0;
    	
    	for(String strPickValue : valuesList){
    		FieldsName objFieldsName = new FieldsName();
    		objFieldsName.strPicklistValue = strPickValue;
    		objFieldsName.srNo = i++;
    		objFieldsName.isRemove = false;
    		fieldsList.add(objFieldsName);
    	}
    	return fieldsList;
    }
// --------------- Test Class -------------------------------
    static testMethod void FormulaeFilterLookupControllerTest() 
    {   
        Test.setCurrentPageReference(new PageReference('Page.FormulaFilterLookupPage?pFilterIndex=2&fType=Picklist&pValues=Utilities&filterTargetId=targetField2'));
        FormulaeFilterLookupController ext = new FormulaeFilterLookupController();
        ext.selectedValues() ; 
    }
}