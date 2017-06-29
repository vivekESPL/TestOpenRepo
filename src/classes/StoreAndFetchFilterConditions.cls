/*      Class description:    Class is developed to save and retrieve filter logic. 
*                            There will be only one record of "Custom Lookup Field" for every object and 
*                            All the selected filter conditions will be saved in object "Filterable Fields" which all 
*                            will be children of "Custom Lookup Field".                 
*       Revision History: 
*       Version                 Author                      Date                        Description 
*       1.0                     Siddharth Birari            13/02/2013                  Initial draft
*
*/

public class StoreAndFetchFilterConditions{
    
        public String strCustomLookUpId {get; set;}
        public string strFilterLogic {get;set;}
        public string strObjectApi {get;set;}
        public string strObjectFieldApi {get;set;}
        public List<Env.FilterableFields> lstFieldFilters{get;set;}
        
        public List<Custom_Lookup_Field__c> lstCustomLookupWithFilters{get;set;}
       
        //constructor will initialize all the global variables and will check if fields filters are already there. 
        //if exists, all the variables will be automatically set to values in records (custom lookup and filter fields) 
		public StoreAndFetchFilterConditions (){
            
            strCustomLookUpId = '';
            
            lstFieldFilters = new List<Env.FilterableFields>();
            lstCustomLookupWithFilters = new List<Custom_Lookup_Field__c>(); 
            
            if(Apexpages.currentPage().getParameters().containsKey('id'))
            	strCustomLookUpId = ApexPages.CurrentPage().getParameters().get('id');
            	
            lstCustomLookupWithFilters=[select Name,
                                               Formula_Filter_Logic__c,
                                               Source_Object_API__c,
                                               Field_Api__c,
                                               (Select Id, 
                                                       Custom_Lookup_Field__c, 
                                                       Filter_Order__c, 
                                                       Source_Field_API__c, 
                                                       Operator__c,
                                                       Target_Is_Field__c, 
                                                       Target_Field_API__c, 
                                                       Target_Values__c, 
                									   SOURCE_FIELD_SF_TYPE__c,
											           SOURCE_FIELD_SOAP_TYPE__c,
											           SOURCE_Is_1st_Relational__c,
											           SOURCE_Relational_OBJ_1st__c,
											           SOURCE_Relational_FIELD_1st__c,
											           SOURCE_Is_2nd_Relational__c,
											           SOURCE_Relational_OBJ_2nd__c,
											           SOURCE_Relational_FIELD_2nd__c,
											           SOURCE_Relational_Ref_Object_1st__c,
											           SOURCE_Relational_Ref_Object_2nd__c,
											           TARGET_FIELD_SF_TYPE__c,
											           TARGET_FIELD_SOAP_TYPE__c,
											           TARGET_Is_1st_Relational__c,
											           TARGET_Relational_OBJ_1st__c,
											           TARGET_Relational_FIELD_1st__c,
											           TARGET_Is_2nd_Relational__c,
											           TARGET_Relational_OBJ_2nd__c,
											           TARGET_Relational_FIELD_2nd__c,
											           TARGET_Relational_Ref_Object_1st__c,
											           TARGET_Relational_Ref_Object_2nd__c
                                               From Filterable_Fields__r
                                               order by Filter_Order__c) 
                                        from Custom_Lookup_Field__c 
                                        where Id =: strCustomLookUpId];
                                        	  
			if(!lstCustomLookupWithFilters.isEmpty()){
              	
				strObjectFieldApi = lstCustomLookupWithFilters[0].Field_Api__c;
                strFilterLogic = lstCustomLookupWithFilters[0].Formula_Filter_Logic__c;
                strObjectApi = lstCustomLookupWithFilters[0].Source_Object_API__c;
                 
                if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty()){
                 	
                	for(Filterable_Fields__c filter :lstCustomLookupWithFilters[0].Filterable_Fields__r){
                     	
                    	Env.FilterableFields envFilter = new Env.FilterableFields();
                         
                        envFilter.intFilterOrder = Integer.valueOf(filter.Filter_Order__c);
                        //envFilter.strSourceFieldLabel = filter.Field_Label__c;
                        envFilter.strSourceFieldApi = filter.Source_Field_API__c;
                         
                        envFilter.intOperator = Integer.valueOf(filter.Operator__c);
                        envFilter.strOperator = ENV.getOpratorsMapping().get(envFilter.intOperator);
                         
                        envFilter.blnTargetIsField = filter.Target_Is_Field__c;
                        if(envFilter.blnTargetIsField)
                        	envFilter.strTargetIsField = 'true';
                        if(!envFilter.blnTargetIsField)
                        	envFilter.strTargetIsField = 'false';
                         
                        //if(filter.Target_Field_Label__c != null)
                        	//envFilter.strTargetFieldLabel = filter.Target_Field_Label__c;
                         	
                        envFilter.strTargetFieldApi = filter.Target_Field_API__c;
                         
                        if(filter.Target_Values__c != null)
                        	envFilter.strTargetValues = filter.Target_Values__c;
                        
		                envFilter.strSrcSFType = filter.SOURCE_FIELD_SF_TYPE__c;
		                envFilter.strSrcSoapType = filter.SOURCE_FIELD_SOAP_TYPE__c;
		                envFilter.blnSrcFirstRelational = filter.SOURCE_Is_1st_Relational__c;
						envFilter.blnSrcSecondRelational = filter.SOURCE_Is_2nd_Relational__c;
						
		                envFilter.strSrcObjFirst = (filter.SOURCE_Relational_OBJ_1st__c == null) ? '' : filter.SOURCE_Relational_OBJ_1st__c;
		                envFilter.strSrcFieldFirst = (filter.SOURCE_Relational_FIELD_1st__c == null) ? '' : filter.SOURCE_Relational_FIELD_1st__c;
		                envFilter.strSrcObjSecond = (filter.SOURCE_Relational_OBJ_2nd__c == null) ? '' : filter.SOURCE_Relational_OBJ_2nd__c;
		                envFilter.strSrcFieldSecond = (filter.SOURCE_Relational_FIELD_2nd__c == null) ? '' : filter.SOURCE_Relational_FIELD_2nd__c;
		                envFilter.strSrcRelRefObj1 = (filter.SOURCE_Relational_Ref_Object_1st__c == null) ? '' : filter.SOURCE_Relational_Ref_Object_1st__c;
		                envFilter.strSrcRelRefObj2 = (filter.SOURCE_Relational_Ref_Object_2nd__c == null) ? '' : filter.SOURCE_Relational_Ref_Object_2nd__c;
		                
		                envFilter.strTrgtSFType = filter.TARGET_FIELD_SF_TYPE__c;
		                envFilter.strTrgtSoapType = filter.TARGET_FIELD_SOAP_TYPE__c;
		                envFilter.blnTrgtFirstRelational = filter.TARGET_Is_1st_Relational__c;
		                envFilter.blnTrgtSecondRelational = filter.TARGET_Is_2nd_Relational__c;
		                
		                envFilter.strTrgtObjFirst = (filter.TARGET_Relational_OBJ_1st__c == null) ? '' : filter.TARGET_Relational_OBJ_1st__c;
		                envFilter.strTrgtFieldFirst = (filter.TARGET_Relational_FIELD_1st__c == null) ? '' : filter.TARGET_Relational_FIELD_1st__c;
		                envFilter.strTrgtObjSecond = (filter.TARGET_Relational_OBJ_2nd__c == null) ? '' : filter.TARGET_Relational_OBJ_2nd__c;
		                envFilter.strTrgtFieldSecond = (filter.TARGET_Relational_FIELD_2nd__c == null) ? '' : filter.TARGET_Relational_FIELD_2nd__c;
                        envFilter.strTrgtRelRefObj1 = (filter.TARGET_Relational_Ref_Object_1st__c == null) ? '' : filter.TARGET_Relational_Ref_Object_1st__c;
		                envFilter.strTrgtRelRefObj2 = (filter.TARGET_Relational_Ref_Object_2nd__c == null) ? '' : filter.TARGET_Relational_Ref_Object_2nd__c;
                        
                        lstFieldFilters.add(envFilter);
					}
				}
			}
		}//Constructor
            
        //method to create custom lookup field object record
        public Custom_Lookup_Field__c createCustomLookup(string fieldApi, 
                                                         string filterLogic, 
                                                         string sourceObjectAPI){
            Custom_Lookup_Field__c customLookup = new Custom_Lookup_Field__c();
            customLookup.Formula_Filter_Logic__c = filterLogic;
            customLookup.Source_Object_API__c = sourceObjectAPI;
            customLookup.Field_Api__c = fieldApi;
            try{
                insert customLookup;
                return customLookup;
            }// end of try
            catch(Exception e){
                system.debug(e.getMessage());
            }// end of catch    
              
            return null;
        } // end of method createCustomLookup 
        
        //method to insert filter record related to custom lookup
        public List<Filterable_Fields__c> createFillter(Custom_Lookup_Field__c  customLookup, List<Env.FilterableFields> lstfilters){               
            List<Filterable_Fields__c> filtersList= new List<Filterable_Fields__c>();
            for(Env.FilterableFields envFilter:lstFilters){
            	                    
                Filterable_Fields__c filter = new Filterable_Fields__c();
                
                filter.Source_Field_API__c = envFilter.strSourceFieldApi;
                filter.Target_Field_API__c = envFilter.strTargetFieldApi;
                filter.Filter_Order__c = envFilter.intFilterOrder;
                filter.Custom_Lookup_Field__c = customLookup.id;
                filter.Operator__c = envFilter.intOperator;
                filter.Target_Is_Field__c = envFilter.blnTargetIsField;
                filter.Target_Values__c = envFilter.strTargetValues;
                
                filter.SOURCE_FIELD_SF_TYPE__c = envFilter.strSrcSFType.toUpperCase();
                filter.SOURCE_FIELD_SOAP_TYPE__c = envFilter.strSrcSoapType.toUpperCase();
                filter.SOURCE_Is_1st_Relational__c = envFilter.blnSrcFirstRelational;
                filter.SOURCE_Relational_OBJ_1st__c = envFilter.strSrcObjFirst;
                filter.SOURCE_Relational_FIELD_1st__c = envFilter.strSrcFieldFirst;
                filter.SOURCE_Is_2nd_Relational__c = envFilter.blnSrcSecondRelational;
                filter.SOURCE_Relational_OBJ_2nd__c = envFilter.strSrcObjSecond;
                filter.SOURCE_Relational_FIELD_2nd__c = envFilter.strSrcFieldSecond;
                filter.SOURCE_Relational_Ref_Object_1st__c = envFilter.strSrcRelRefObj1;
                filter.SOURCE_Relational_Ref_Object_2nd__c = envFilter.strSrcRelRefObj2;
                
                if(envFilter.blnTargetIsField){
		            filter.TARGET_FIELD_SF_TYPE__c = envFilter.strTrgtSFType.toUpperCase();
		            filter.TARGET_FIELD_SOAP_TYPE__c = envFilter.strTrgtSoapType.toUpperCase();
		            filter.TARGET_Is_1st_Relational__c = envFilter.blnTrgtFirstRelational;
		            filter.TARGET_Relational_OBJ_1st__c = envFilter.strTrgtObjFirst;
		            filter.TARGET_Relational_FIELD_1st__c = envFilter.strTrgtFieldFirst;
		            filter.TARGET_Is_2nd_Relational__c = envFilter.blnTrgtSecondRelational;
		            filter.TARGET_Relational_OBJ_2nd__c = envFilter.strTrgtObjSecond;
		            filter.TARGET_Relational_FIELD_2nd__c = envFilter.strTrgtFieldSecond;
		            filter.TARGET_Relational_Ref_Object_1st__c = envFilter.strTrgtRelRefObj1;
		            filter.TARGET_Relational_Ref_Object_2nd__c = envFilter.strTrgtRelRefObj2;                	
                }
                
                filtersList.add(filter);        
                            
            } // end of for 
            
            try{
                insert filtersList;
                return filtersList;
            }// end of try
            catch(Exception e){
                system.debug('exception' + e.getMessage());
            }// end of catch
                          
            return null;
        } // end of method createFillter
        
	//save method to save filters and its logic 
	public PageReference saveFilters(){
        	    
            // if object dont have any filters stored already
            if(lstCustomLookupWithFilters.isEmpty()){
            	
                Custom_Lookup_Field__c customLookup = createCustomLookup(strObjectFieldApi, 
                                                                         strFilterLogic, strObjectApi);
                List<Filterable_Fields__c> filtersList = createFillter(customLookup, lstFieldFilters);
                          
            } // end of if(lstCustomLookupWithFilters.isEmpty())
            else{ // if object do have a record of Custom_Lookup_Field__c object
            
                 //if object has filters saved   
                 if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty()){
                 	lstCustomLookupWithFilters[0].Formula_Filter_Logic__c=strFilterLogic;
                     update lstCustomLookupWithFilters[0]; // update new filter logic in custom lookup	
                 		
                     delete lstCustomLookupWithFilters[0].Filterable_Fields__r; // delete old filters
                     //create new filters on save button
                     List<Filterable_Fields__c> filtersList= createFillter(lstCustomLookupWithFilters[0],lstFieldFilters); 
                 } // end of if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty())
                 else{ //if object have a record in Custom_Lookup_Field__c but dont have filter records

                 	lstCustomLookupWithFilters[0].Formula_Filter_Logic__c=strFilterLogic;
                     update lstCustomLookupWithFilters[0]; // update new filter logic in custom lookup	
                     List<Filterable_Fields__c> filtersList= createFillter(lstCustomLookupWithFilters[0],lstFieldFilters); 
                 }
            } // end of else for if(lstCustomLookupWithFilters.isEmpty())
            
            return null;
	} // end of save method
        
} //end of class StoreAndFetchFilterConditions