/*      Class description:    Class is developed to save and retrieve filter logic. 
*                            There will be only one record of "Custom Lookup Field" for every object and 
*                            All the selected filter conditions will be saved in object "Filterable Fields" which all 
*                            will be children of "Custom Lookup Field".                 
*       Revision History: 
*       Version                 Author                      Date                        Description 
*       1.0                     Siddharth Birari            13/02/2013                  Initial draft
*
*/

public class StroreAndFetchFilterConditions{
    
        public string strFilterLogic{get;set;}
        public string strObjectApi{get;set;}
        public string strObjectFieldApi{get;set;}
        public string strObjectLabel{get;set;}
        public string strObjectFieldLabel{get;set;}    
        public List<Env.FilterableFields> lstFieldFilters{get;set;}    
        
        private List<Custom_Lookup_Field__c> lstCustomLookupWithFilters{get;set;}
       
        //constructor will initialize all the global variables and will check if fields filters are already there. 
        //if exists, all the variables will be automatically set to values in records (custom lookup and filter fields) 
        public StroreAndFetchFilterConditions (){
            
            strObjectLabel= ApexPages.CurrentPage().getParameters().get('objectLabel');
            lstCustomLookupWithFilters=[select Name,
            								   Field_Label__c,
            								   Formula_Filter_Logic__c,
                      						   Is_Standard_SF_Lookup__c,
                      						   Source_Object_API__c,
                      						   Source_Object_Prefix__c,
                      						   Field_Api__c,
                      						   (Select Id, 
                      						   		   Name, 
                      						   		   Custom_Lookup_Field__c, 
                      						   		   Filter_Order__c, 
                      						   		   Field_Label__c, 
                      						   		   Source_Field_API__c, 
                      								   Operator__c,
                      								   Target_Is_Field__c, 
                      								   Target_Field_API__c, 
                      								   Target_Values__c, 
                      								   Target_Field_Label__c 
                      						   From Filterable_Fields__r) 
                      					from Custom_Lookup_Field__c 
                      					where Name=:strObjectLabel];
              if(!lstCustomLookupWithFilters.isEmpty())
              {
                 strFilterLogic = lstCustomLookupWithFilters[0].Formula_Filter_Logic__c;
                 strObjectApi = lstCustomLookupWithFilters[0].Source_Object_API__c;
                 strFilterLogic = lstCustomLookupWithFilters[0].Formula_Filter_Logic__c;
                 strObjectFieldLabel = lstCustomLookupWithFilters[0].Field_Label__c;
                 strObjectFieldApi = lstCustomLookupWithFilters[0].Field_Api__c;
                 if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty())
                 {
                     for(Filterable_Fields__c filter :lstCustomLookupWithFilters[0].Filterable_Fields__r)
                     {
                         Env.FilterableFields envFilter=new Env.FilterableFields();
                         envFilter.intFilterOrder=Integer.valueOf(filter.Filter_Order__c);
                         envFilter.strSourceFieldLabel = filter.Field_Label__c;
                         envFilter.strSourceFieldApi = filter.Source_Field_API__c;
                         //envFilter.intOperator=Integer.valueOf(filter.Operator__c);
                         envFilter.strOperator = String.valueOf(filter.Operator__c);
                         //envFilter.blnTargetIsField=filter.Target_Is_Field__c;
                         //envFilter.strTargetIsField = filter.Target_Is_Field__c;
                         envFilter.strTargetFieldLabel = filter.Target_Field_Label__c;
                         envFilter.strTargetFieldApi = filter.Target_Field_API__c;
                         envFilter.strTargetValues = filter.Target_Values__c;
                         lstFieldFilters.add(envFilter);
                     }
                 } //end of  if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty())
              }// end of if(!lstCustomLookupWithFilters.isEmpty())
        
        }   // end of constructor StroreAndFetchFilterConditions 
            
        //method to create custom lookup field object record
        public Custom_Lookup_Field__c  createCustomLookup(string fieldApi, string fieldLabel, 
        												  string filterLogic, boolean isStandardLookup,
                                        				  string sourceObjectAPI, string sourceObjectPrefix, 
                                        				  string sourceObjectLabel){
            Custom_Lookup_Field__c customLookup = new Custom_Lookup_Field__c();
           // customLookup.Name = sourceObjectLabel;
            customLookup.Field_Label__c = fieldLabel;
            customLookup.Is_Standard_SF_Lookup__c = isStandardLookup;
            customLookup.Formula_Filter_Logic__c = filterLogic;
            customLookup.Source_Object_Prefix__c = sourceObjectPrefix;
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
            for(Env.FilterableFields envFilter:lstFilters)
                {                    
                    Filterable_Fields__c filter=new Filterable_Fields__c();
                    //filter.Name=envFilter.strSourceFieldLabel;
                    filter.Field_Label__c=envFilter.strSourceFieldLabel;
                    filter.Source_Field_API__c=envFilter.strSourceFieldApi;
                    filter.Target_Field_Label__c=envFilter.strTargetFieldLabel;
                    filter.Target_Field_API__c=envFilter.strTargetFieldApi;
                    filter.Filter_Order__c=envFilter.intFilterOrder;
                    filter.Custom_Lookup_Field__c=customLookup.id;
                    //filter.Operator__c = envFilter.intOperator;
                    filter.Operator__c = Decimal.valueOf(envFilter.strOperator);
                    //filter.Target_Is_Field__c=envFilter.blnTargetIsField;
                    filter.Target_Values__c=envFilter.strTargetValues;         
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
        public PageReference saveFilters()
        {    
            // if object dont have any filters stored already
            if(lstCustomLookupWithFilters.isEmpty())
            {
                Custom_Lookup_Field__c customLookup=createCustomLookup(strObjectFieldApi,strObjectFieldLabel,
                strFilterLogic,False,strObjectApi,'',strObjectLabel);
                List<Filterable_Fields__c> filtersList= createFillter(customLookup,lstFieldFilters);
                          
            } // end of if(lstCustomLookupWithFilters.isEmpty())
            else // if object do have a record of Custom_Lookup_Field__c object
            {    
                 //if object has filters saved   
                 if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty())
                 {
                     delete lstCustomLookupWithFilters[0].Filterable_Fields__r; // delete old filters
                     //create new filters on save button
                     List<Filterable_Fields__c> filtersList= createFillter(lstCustomLookupWithFilters[0],lstFieldFilters); 
                 } // end of if(!lstCustomLookupWithFilters[0].Filterable_Fields__r.isEmpty())
                 else //if object have a record in Custom_Lookup_Field__c but dont have filter records
                 {
                     List<Filterable_Fields__c> filtersList= createFillter(lstCustomLookupWithFilters[0],lstFieldFilters); 
                 }
            } // end of else for if(lstCustomLookupWithFilters.isEmpty())
            
            return null;
        } // end of save method
        
} //end of class StroreAndFetchFilterConditions