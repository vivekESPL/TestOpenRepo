/*      Class descrption:  
*       Revision History: 
*       Version         Author                  Date            Description
*
*       1.0             Amol Chaudhari          31/01/2013      Intial Draft
*
*		1.1				Siddharth Birari		19/02/2013		Omitted redundant variables used for CustomLookUpField
*																object	
*/
public with sharing class FieldsFilterCloneController {

	private static final String VALUE = Label.Value;
	private static final String FIELD = Label.Field;
	
	public Integer intFilterIndex {get; set;}
	
	public Boolean blnIsEditMode {get; set;}
	
	//Variables for Custom Lookup Field Object
	public String strSourceObjLabel {get; set;}
	public String strSourceObjApi {get; set;}
	public String strFieldApi {get; set;}
	public String strReferencedObject {get;set;}
	 
	public String strSaveErrorMsg{get;set;}					//Error Message	
	public String strJSONToSave {get; set;}
	public String strFilterLogic {get; set;}
	public String strRetrievedJSON {get; set;}
	
	public String strTestString {get; set;}
	private List<FieldsMetadata> FieldsList{get;set;}                          // List of all fields (list of class 'Fields')
	public String strFields{get;set;}                                 //serialized string for related fields
	public String strSelectedValue{get;set;}
	
	public List<ENV.FilterableFields> lstFilterableFields {get; set;}
	
	//Constructor 
	public FieldsFilterCloneController(){
		
        if((Apexpages.currentPage().getParameters().containsKey('strObjectApi')) &&
           (Apexpages.currentPage().getParameters().containsKey('strObjectFieldApi')))
        blnIsEditMode = true;
        else
        blnIsEditMode = false;
		
		strRetrievedJSON = Json.serialize(this.lstFilterableFields);
		
		//Retrieving the existing filters when in edit mode
		if(blnIsEditMode){
			StoreAndFetchFilterConditions objFetchFilters = new StoreAndFetchFilterConditions();
			this.lstFilterableFields = objFetchFilters.lstFieldFilters;
			this.strFilterLogic = objFetchFilters.strFilterLogic;
			
			if(!this.lstFilterableFields.isEmpty()){
				
				strRetrievedJSON = Json.serialize(this.lstFilterableFields);
			}
		}
		
		strFields = '';
		intFilterIndex = 0;
		//getting the list of all related fields depending upon the current parameters
		FieldsList = new List<FieldsMetadata>();
		Boolean isValidLookup = FieldsExtractor.isLookupFilterValid('Contact','AccountId');
		if(isValidLookup){
			FieldsList = new FieldsExtractor().getFields('Contact','AccountId');	
		}
		if((!FieldsList.isEmpty()) || (FieldsList != null))
			strFields = Json.serialize(FieldsList);	
		
		lstFilterableFields = new List<ENV.FilterableFields>();
					
		//Populating the value for custom lookup field
		strFieldApi = 'AccountId';
		strSourceObjLabel = 'Contact';
		strSourceObjApi = 'Contact';	
	}
	
	public pageReference save(){
		
		Boolean isFilterExpressionValid = true;
		ValidateFilterLogic objValidateFilterLogic = new ValidateFilterLogic();
		
		if(String.isNotBlank(strJSONToSave)){
			lstFilterableFields = (List<ENV.FilterableFields>)Json.deserializeStrict(strJSONToSave, List<ENV.FilterableFields>.class);
			
			for(ENV.FilterableFields objFilterlableFileds : lstFilterableFields){
				
				if(objFilterlableFileds.strTargetIsField.equalsIgnoreCase('true'))
					objFilterlableFileds.blnTargetIsField = true;
				if(objFilterlableFileds.strTargetIsField.equalsIgnoreCase('false'))
					objFilterlableFileds.blnTargetIsField = false;
				objFilterlableFileds.intOperator = getOperatorNumber(objFilterlableFileds.strOperator);
			}
			
			//calling the method to validate the filter expression which returns true or false
			isFilterExpressionValid = objValidateFilterLogic.isFilterLogicCorrect(strFilterLogic,20);			
			
			if(isFilterExpressionValid){
				//Saving the logic into the database
				StoreAndFetchFilterConditions objSaveFilter = new StoreAndFetchFilterConditions();
		        
		        objSaveFilter.strFilterLogic = this.strFilterLogic;
		        objSaveFilter.strObjectApi = this.strSourceObjApi;
		        objSaveFilter.strObjectFieldApi = this.strFieldApi;
		        //objSaveFilter.strObjectLabel = this.strSourceObjLabel;
		        
		        objSaveFilter.lstFieldFilters = this.lstFilterableFields;
		        
		        objSaveFilter.saveFilters();
		        strSaveErrorMsg = 'Data saved successfully.';
			}
			else{
				strSaveErrorMsg = objValidateFilterLogic.strErrorMessage;
				system.debug('_____________ Invalid Expression'+(objValidateFilterLogic.strErrorMessage));
			}
		}
		return null;
	}
	
	//This method returns the operator number corresponding to the provided operator based on the
	//operator mapping provided in the ENV class
	public Integer getOperatorNumber(String pStrOperator){
		
		for(Integer index = 1; index <= ENV.getOpratorsMapping().size(); index++){
			
			if(pStrOperator.equalsIgnoreCase(ENV.getOpratorsMapping().get(index))){
				return index;
			}
		}
		return 0;
	}
}