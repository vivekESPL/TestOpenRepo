public with sharing class GDC 
{

    public List<selectoption> supportedObject {get; set;}   //Objects List displayed on UI 
    public List<selectoption> supportedFields {get;set;}    //FieldsList displayed on UI 
    public List<selectoption> supportedoperator {get;set;}
    public List<selectoption> supportedoperator1 {get;set;}  //OperatorsList displayed on UI 
    public list<String> totalfield {set;get;}
    public list<String> newFieldsName {set;get;}

    public String SelectedObject {get; set;} //Selected Object 
    public String value1{get;set;}
    public String value2{get;set;}  
    
    Map<String, Schema.SObjectType> GlobalDescribe = Schema.getGlobalDescribe(); //Global describe 
    Set<String> objectKeys = GlobalDescribe.keySet();  //we fetched all keys in objectKeys variable

    public List<SelectOption> fieldLableAPI {get; set;}  //Field Select List
    public String SelectedFields {get; set;}  //first fields to be displayed in table
    public String SelectedFields2 {get; set;} //Second fields to be displayed in table 
     
    public List<sObject> ObjectList {get; set;}  //List to maintain dynamic query result 
    public String str1 {get;set;}
    public list<SObject> slst {get;set;}
    public String selectedoperator {get;set;}
    public String str2 {get;set;}  
    
    public Integer count = 1;
    public String selectedRowIndex
    {get;set;}
    
    public List<innerClass> lstInner 
    {   get;set;    }
    
    public SelectOption[] ListOptions 
    { 
        //this is where we're going to pull the list
        public get;
        private set;
    }
      
      
      public GDC()
      {  //Constructor
        //Initialize  
        supportedObject = new List<selectoption>() ;  
        SelectedObject = '' ;  
        supportedFields = new List<SelectOption>() ;  
        //supportedoperator = new List<String>() ;  
        str1='';
        str2=''; 
        value1='';
        value2='';
        SelectedFields = '' ; 
        SelectedFields2 = '' ; 
        ObjectList = new List<sObject>() ; 
        slst = new list<SObject>();
        totalfield = new list<String>(); 
        newFieldsName = new list<String>();
        
        lstInner = new List<innerClass>();
        addMore();
        selectedRowIndex = '0';    
        
        
        supportedObject.add(new Selectoption('--None--','--None--'));
        //Get only reference to objects  
        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())  
        {  
            //Excluding custom setting objects  
            if(!item.getDescribe().isCustomSetting())
            {  
                if(item.getDescribe().isAccessible())
                {
                    if(item.getDescribe().isQueryable())
                    {
                        //Adding to list  
                        supportedObject.add(new SelectOption(item.getDescribe().getLocalName().toLowerCase() , item.getDescribe().getLabel() )); 
                    }
                }
                 
            }  
        }
        String[] ViewList = new String[]{'equals','not equal to','starts with','contains'};
        this.listOptions = new SelectOption[]{};
  
        for (String VL: ViewList) {
        this.ListOptions.add(new SelectOption(VL,VL));
        }
    }
    
    //Get fields of selected object  
    public void ObjectFields()
    {
        supportedFields = new List<SelectOption>();
        //Creating sObject for dynamic selected object  
        Schema.SObjectType systemObjectType = GlobalDescribe.get(SelectedObject);  
        //Fetching field results  
        Schema.DescribeSObjectResult r = systemObjectType.getDescribe();  
                  
        Map<String, Schema.SObjectField> M = r.fields.getMap();  
        //Creating picklist of fields  
        supportedFields.add(new Selectoption('--None--','--None--'));
        for(Schema.SObjectField fieldAPI : M.values())
        {
            supportedFields.add(new SelectOption(fieldAPI.getDescribe().getName() , fieldAPI.getDescribe().getLabel())) ;
        }
            newFieldsName.add(SelectedFields);
            newFieldsName.add(SelectedFields2);
    } 
    
    
    public void op()
    {
     	Integer indexCount = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
     	
     	for(innerClass obj:lstInner)
     	{
     		if(indexCount == obj.recCount)
     		{
     			obj.supportedoperator = new list<SelectOption>();
         
		        Map<String, Schema.SObjectField> objectFieldsMap= new Map<String, Schema.SObjectField>();
		        objectFieldsMap = Schema.getGlobalDescribe().get(SelectedObject).getDescribe().fields.getMap();
		        System.debug('>>>>>>>>>>>>>>>>objectFieldsMap<<<<<<<<<<<<<<<<<<<<<'+objectFieldsMap);                                          
		        Schema.Describefieldresult fieldResult = objectFieldsMap.get(obj.field).getDescribe();
		        System.debug('>>>>>>>>>>>>>>>>fieldResult<<<<<<<<<<<<<<<<<<<<<'+fieldResult);
		        String Oper = OperatorHelper.getAvailableOperators(fieldResult);
		        System.debug('field supported operators>>>>>>>>>>>>>'+Oper);
		    // strFieldDataType = fieldResult.getType().name().toLowerCase();
		   
		        String[] selectedvalues = Oper.split(',');
		         //System.debug('selectedSubs2 list at the top ' + selectedSubs2);
		        for (String selectedvalue: selectedvalues) 
		        {
		            obj.supportedoperator.add(new SelectOption(selectedvalue,selectedvalue));
		        }  
		        
		        break;  	
     		}	
     	}   
        
        /*supportedoperator = new list<SelectOption>();
         
        Map<String, Schema.SObjectField> objectFieldsMap= new Map<String, Schema.SObjectField>();
        objectFieldsMap = Schema.getGlobalDescribe().get(SelectedObject).getDescribe().fields.getMap();
        System.debug('>>>>>>>>>>>>>>>>objectFieldsMap<<<<<<<<<<<<<<<<<<<<<'+objectFieldsMap);                                          
        Schema.Describefieldresult fieldResult = objectFieldsMap.get(SelectedFields).getDescribe();
        System.debug('>>>>>>>>>>>>>>>>fieldResult<<<<<<<<<<<<<<<<<<<<<'+fieldResult);
        String Oper = OperatorHelper.getAvailableOperators(fieldResult);
        System.debug('field supported operators>>>>>>>>>>>>>'+Oper);
    // strFieldDataType = fieldResult.getType().name().toLowerCase();
   
        String[] selectedvalues = Oper.split(',');
         //System.debug('selectedSubs2 list at the top ' + selectedSubs2);
        for (String selectedvalue: selectedvalues) 
        {
            supportedoperator.add(new SelectOption(selectedvalue,selectedvalue));
        }*/    
    
    } 
    
    public void op1()
    {
        supportedoperator1= new list<SelectOption>();
        Map<String, Schema.SObjectField> objectFieldsMap= new Map<String, Schema.SObjectField>();
        objectFieldsMap = Schema.getGlobalDescribe().get(SelectedObject).getDescribe().fields.getMap();                                          
        Schema.Describefieldresult fieldResult = objectFieldsMap.get(SelectedFields2).getDescribe();
        String Oper = OperatorHelper.getAvailableOperators(fieldResult);
        System.debug('field supported operators>>>>>>>>>>>>>'+Oper);
           // strFieldDataType2 = fieldResult.getType().name().toLowerCase();
    
        String[] selectedvalues = Oper.split(',');
         //System.debug('selectedSubs2 list at the top ' + selectedSubs2);
        for (String selectedvalue: selectedvalues) 
        {
            supportedoperator1.add(new SelectOption(selectedvalue,selectedvalue));
        }
    }
    
    
    public void generatequery()
    { 
   
       Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
       Schema.SObjectType objectSchema = schemaMap.get(SelectedObject);
       Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
       String query = 'SELECT';
       Integer i = 0;
       for(String s1 : fieldMap.keySet()) 
       {
                if(i < fieldMap.keySet().size() - 1)
                {
                    query += ' ' + s1 + ', ';
                    // options.add(new SelectOption(f.fields.getLabel(),f.fields.getLabel()));
                }
                else
                {
                    query += ' ' + s1;
                }
                i++;        
        }
        for(String s:fieldMap.keySet()) 
        {
            totalfield.add(s);
        }
        if(str1.equals('equals') && str2.equals('equals'))
        {
            query=query+ ' From '+SelectedObject+' Where '+SelectedFields+' = \''+ value1 + '\'' + ' AND '+SelectedFields2+' =\''+ value2 + '\'';
        }
        
         system.debug(query);
         slst=Database.query(query);
    }
    
    public void Add()
    {
        System.debug('>>>>>>>>>>>>>>>>>>>In Add function<<<<<<<<<<<<<<<<<<<<<<<');
        count = count+1;
        System.debug('===========Value of count is============= '+ count);
        addMore();
    }
    
    public void addMore()
    {
        //call to the iner class constructor
        System.debug('In addMore function=============');
        innerClass objInnerClass = new innerClass(count);
        
        //add the record to the inner class list
        lstInner.add(objInnerClass);    
        system.debug('lstInner---->'+lstInner);            
    }
    
    public class innerClass
    {       
        /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
        public Integer recCount{get;set;}
        public string field{get;set;}
        public string operator{get;set;}
        public string value{get;set;}
        public list<SelectOption> supportedoperator{get;set;}
                        
        /*Inner Class Constructor*/
        public innerClass(Integer intCount)
        {
            system.debug('<<<<<<<<<inside inner class construnctor<<<<<<<<<<');
            recCount = intCount;        
        }/*End Inner class Constructor*/    
    }/*End inner Class*/
}