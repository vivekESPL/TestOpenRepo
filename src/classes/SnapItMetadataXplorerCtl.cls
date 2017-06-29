public class SnapItMetadataXplorerCtl
{
     private String SelectedFieldCategory = 'all';                                  //Default selected field category 
     private Boolean IsPreviousVisible;                                             //Determines if Previous link is visible on UI
     private Boolean IsNextVisible;                                                 //Determines if Next link is visible on UI
     private Boolean IsFirstLastVisible;                                            //Determines if First and Last links are visible on UI
     private List<Selectoption> SFDCObjectList = new List<Selectoption>();          //List of all Sobjects existing on the org 
     private List<Selectoption> SFDCFldCategoryLblList = new List<Selectoption>();  //List of Label values for Field Category selection
     private List<FieldType> SFDCFieldList = new List<FieldType>();                 //List of Field metadata for all selected Sobjects
     private List<FieldType> DisplaySFDCFieldList;                                  //List of Field metadata for to bind with table on UI
     private static String[] SelectedObjectNameList = new String[]{};               //List of all selected Sobject Names
     private Map<Integer, List<String>> SObjProcessingBatchMap = new Map<Integer, List<String>>();          //Holds created batches for processing
     private Map<Integer, List<FieldType>> DisplaySFDCFieldBatchMap = new Map<Integer, List<FieldType>>();  //Holds created batches to display on UI
     
     //Default Constructor
     public SnapItMetadataXplorerCtl() 
     {  
        MapKey = -1;
        DisplayBatchMapKey = 0;
        IsPollerEnabled = false;
        IsSelectedObjCntLabelVisible = false;
        IsFieldTableVisible = false;
     }
     
     //Custom Type
     public class FieldType
     {
        public FieldType(String pSObjectName, String pLabel, String pName, String pDataType, String pFieldDetails)
        {
            SObjectName = pSObjectName;
            FieldLabel = pLabel;
            FieldName = pName;
            FieldDataType = pDataType;
            FieldDetails = pFieldDetails;
        }
        
        public String SObjectName{get; set;}    //SObject Name
        public String FieldLabel {get; set;}    //Field Label
        public String FieldName {get; set;}     //Field API Name
        public String FieldDataType {get; set;} //Field Datatype
        public String FieldDetails {get; set;}  //Field Details: Picklist values
        
     }//FieldType
         
     //PROPERTIES
     //Returns a list of all fields with their attributes
     public List<FieldType> getSFDCFieldList()
     { return SFDCFieldList; }
     
     //List to bind to the table on UI
     public List<FieldType> getDisplaySFDCFieldList()
     { return DisplaySFDCFieldList; } 
     
     //SFDCObejctsList
     public List<SelectOption> getSFDCObjectList()
     { 
        this.getAllSFDCObjects();
        return SFDCObjectList;
     }
     
     //SelectedObjectNameList       
     public List<String> getSelectedObjectNameList()
     { return SelectedObjectNameList; }
     
     public void setSelectedObjectNameList(String[] pSelectedObjNameList)
     { 
        //Clear any existing selected options if any
        if(!SelectedObjectNameList.isEmpty())
            SelectedObjectNameList.clear(); 
        
        //Identify the list of selected object names
        for(String strSelectedObjName : pSelectedObjNameList) 
        { 
            List<String> SelectedStringList = strSelectedObjName.split('#');
            SelectedObjectNameList.add(SelectedStringList[0]);  
        }
     }
         
     //SelectedFieldCategory
     public String getSelectedFieldCategory()
     { return SelectedFieldCategory; }      

     public void setSelectedFieldCategory(String pSelectedFldCategory)
     { SelectedFieldCategory = pSelectedFldCategory;}
     
     //Field Category Labels 
     public List<Selectoption> getFieldCategoryLabels()
     {
        if(SFDCFldCategoryLblList.isEmpty())
        {
            SFDCFldCategoryLblList.add(new Selectoption('all', 'All Fields'));
            SFDCFldCategoryLblList.add(new Selectoption('standard', 'Standard Fields'));
            SFDCFldCategoryLblList.add(new Selectoption('custom', 'Custom Fields'));
        }
        return SFDCFldCategoryLblList;
     }
     
     public Integer DisplayBatchMapSize                     //Holds the size of the Map containing batches to display
     {
        get { return DisplaySFDCFieldBatchMap.size(); } 
     }
     
     public Boolean getIsPreviousVisible()
     { return IsPreviousVisible = ((DisplayBatchMapKey - 1) >= 1 && DisplayBatchMapSize > 1) ? true : false; }
     
     public Boolean getIsNextVisible()
     { return IsNextVisible = ((DisplayBatchMapKey + 1) <= DisplayBatchMapSize && DisplayBatchMapSize > 1) ? true : false; }
     
     public Boolean getIsFirstLastVisible()
     { return IsFirstLastVisible = (DisplayBatchMapSize > 1) ? true : false; }
     
     public Boolean IsPollerEnabled{get; set;}              //Holds a boolean value to enable or disable the action poller
     public Boolean IsSelectedObjCntLabelVisible{get; set;} //Determines whether to display the SelectedObjCount label
     public Boolean IsFieldTableVisible{get; set;}          //Determines whether the table is visible or not
     public Boolean IsShowMetadataBtnDisabled{get; set;}    //Determines whether the Show Metadata Btn is disabled
     public Integer MapKey{get; set;}                       //Holds the Key value to fetch the appropriate batch for SObjProcessingBatchMap
     public Integer BatchMapSize {get; set;}                //Total number of batches created
     public Integer SelectedObjCnt {get; set;}              //Count of objects selected
     public Integer DisplayBatchMapKey{get; set;}           //Holds the Key value to fetch the appropriate batch to display on UI
     
        
     //METHODS
     //Displays the First Batch of processed objects in the table
     public Pagereference getFirstDisplayBatch()
     {
        if(DisplaySFDCFieldBatchMap.containsKey(1))
        {
            DisplaySFDCFieldList = new List<FieldType>();
            DisplaySFDCFieldList.addAll(DisplaySFDCFieldBatchMap.get(1));
            DisplayBatchMapKey = 1;
        }
        return NULL;
     }
     
     //Displays the Previous Batch of processed objects in the table
     public Pagereference getPreviousDisplayBatch()
     {
        Integer intKey = DisplayBatchMapKey - 1;                        //Retreive the key value for the previous batch to be displayed on UI
        if(DisplaySFDCFieldBatchMap.containsKey(intKey))
        {
            DisplaySFDCFieldList = new List<FieldType>();
            DisplaySFDCFieldList.addAll(DisplaySFDCFieldBatchMap.get(intKey));
            DisplayBatchMapKey = intKey;    
        }
        return NULL;
     }
     
     //Displays the Next Batch of processed objects in the table
     public Pagereference getNextDisplayBatch()
     {
        Integer intKey = DisplayBatchMapKey + 1;                        //Retreive the key value for the next batch to be displayed on UI
        if(DisplaySFDCFieldBatchMap.containsKey(intKey))
        {
            DisplaySFDCFieldList = new List<FieldType>();
            DisplaySFDCFieldList.addAll(DisplaySFDCFieldBatchMap.get(intKey));
            DisplayBatchMapKey = intKey;    
        }
        return NULL;
     }
     
     //Displays the Last Batch of processed objects in the table
     public Pagereference getLastDisplayBatch()
     {
        Integer intKey = DisplaySFDCFieldBatchMap.keySet().size();      //Retreive the key value for the last batch to be displayed on UI
        if(DisplaySFDCFieldBatchMap.containsKey(intKey))
        {
            DisplaySFDCFieldList = new List<FieldType>();
            DisplaySFDCFieldList.addAll(DisplaySFDCFieldBatchMap.get(intKey));
            DisplayBatchMapKey = intKey;    
        }
        return NULL;
     }
     
     //Exports the current batch of displayed 25 objects to Excel
     public Pagereference exportToExcel()
     { return Page.SnapItMetadataExportToExcel; }
     
     //Exports the current batch of displayed 25 objects to PDF
     public Pagereference exportToPdf()
     {  return Page.SnapItMetadataExportToPdf; }
     
     //Retreives the API Name and Label of all SFDC objects in the org
     public void getAllSFDCObjects() 
     {
       Schema.Sobjecttype objSFDCObject;
       
       //Retreive a Map of all SFDC Object Tokens and SFDC Objects from the Org
       Map<String, Schema.Sobjecttype> GlobalDescribeMap = Schema.getGlobalDescribe();
       
       //Check if new objects are created or Object list is requested for the first time
       if(GlobalDescribeMap.size() > SFDCObjectList.size() || SFDCObjectList.isEmpty())
       {
           List<String> KeyList = new List<String>();
           KeyList.addAll(GlobalDescribeMap.keySet());
           KeyList.sort();  //Sort the Objects according to their names
           
           if(!SFDCObjectList.isEmpty())    //clear the list, if elements exist
                SFDCObjectList.clear();
           
           for(String strKey : KeyList)
           {
                if(GlobalDescribeMap.containsKey(strKey))   //check whether the key exists
                    objSFDCObject = GlobalDescribeMap.get(strKey);
                
                //Add the Label and API Name values to be displayed in the picklist in the following format: Label(API Name)
                 SFDCObjectList.add(new Selectoption(
                    objSFDCObject.getDescribe().getName()+ '#' + objSFDCObject.getDescribe().getLabel(), 
                    objSFDCObject.getDescribe().getName() + ' (' + objSFDCObject.getDescribe().getLabel()  + ')'));
           }//for
       }
     }
     
     //Executes when the View On Screen is clicked and enables the action poller
     public void processSelectedSobjects()
     {
        SelectedObjCnt = SelectedObjectNameList.size();
        if(SelectedObjCnt == 0)
        {                       
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.MetadataError));
            return;                 
        }
            IsSelectedObjCntLabelVisible = true;
            DisplaySFDCFieldBatchMap = new Map<Integer, List<FieldType>>(); //Clear any old values
            this.createProcessingBatches();     //Create batches of the selected objects
            this.MapKey = 1;
            if(!SFDCFieldList.isEmpty())        //Clear the old values from SFDCFieldList 
            SFDCFieldList.clear();
            IsShowMetadataBtnDisabled = true;   //Disable the Show Metadata button
            IsFieldTableVisible = false;        //Hide the table on UI during processing
            IsPollerEnabled = true;             //Activate the poller
        
     }
     
     //Divides the selected objects into batches of 25. Each batch would be processed using a new @future call
     public void createProcessingBatches()
     {
       Integer intCount = 1;
       List<String> TmpSelectedObjList = new List<String>();
       List<String> SObjectNameBatchList = new List<String>();
       
       //Clear the Map for each processing iteration
       SObjProcessingBatchMap.clear();
           
       TmpSelectedObjList.addAll(SelectedObjectNameList);   //Add all selected object names to a temporary list
       for(Integer intIndex = 0; intIndex < TmpSelectedObjList.size(); intIndex++)
       {
         SObjectNameBatchList.add(SelectedObjectNameList.get(intIndex));
         if((Math.mod(SObjectNameBatchList.size(), 25) == 0) || intIndex == SelectedObjectNameList.size() - 1)  
         {
            SObjProcessingBatchMap.put(intCount, SObjectNameBatchList);
            ++intCount;     //increment the count
            SObjectNameBatchList = new List<String>();
         }  
       }
       BatchMapSize = SObjProcessingBatchMap.size();    //Store the Batch count to display on UI    
     }
     
     public void getAllFields()
     {
        String strCategory;
        String strFieldDetails;
        
        //Retreive a Map of all SFDC Object Tokens and SFDC Objects from the Org
        Map<String, Schema.Sobjecttype> SobjectMap = Schema.getGlobalDescribe();
        if(SObjProcessingBatchMap.containsKey(this.MapKey))
        {
            //Retreive field details for all selected Sobjects
            List<String> BatchList = SObjProcessingBatchMap.get(MapKey);
            
            for(String strSelectedSObjectName : BatchList)
            {
                //Retreive the describe result for the Object selected by the user and then retreive the all fields for the selected object 
                Schema.Describesobjectresult result = SobjectMap.get(strSelectedSObjectName.toLowerCase()).getDescribe();
                Map<String, Schema.SObjectField> FieldMap = result.fields.getMap();
                
                List<String> KeyList = new List<String>();
                KeyList.addAll(FieldMap.keySet()); 
                KeyList.sort(); //Sort the fields according to their names 
                
                for(String strField : KeyList)
                {
                    //Check whether the selected key exists 
                    if(FieldMap.containsKey(strField))
                    {               
                        Schema.Describefieldresult fieldResult = FieldMap.get(strField).getDescribe();  //Retreive DescribeResult for an Sobject(FIELD)
                        //SFDCFieldList = new List<FieldType>();
                        if(this.SelectedFieldCategory == 'all')
                        {
                            //Add the newly created FieldType instance to a List
                            SFDCFieldList.add(new FieldType(
                                strSelectedSObjectName,
                                fieldResult.getLabel(), 
                                fieldResult.getLocalName(),
                                getFldTypeDisplayDetails(fieldResult),
                                strFieldDetails = getFieldDetails(fieldResult)));
                        }
                        else if(this.SelectedFieldCategory == 'standard')
                        {
                            if(!fieldResult.isCustom())
                            {
                                //Add the newly created FieldType instance to a List
                                SFDCFieldList.add(new FieldType(
                                    strSelectedSObjectName,
                                    fieldResult.getLabel(), 
                                    fieldResult.getLocalName(), 
                                    getFldTypeDisplayDetails(fieldResult),
                                    strFieldDetails = getFieldDetails(fieldResult)));
                            }
                        }
                        else if(this.SelectedFieldCategory == 'custom')
                        {
                            if(fieldResult.isCustom())
                            {
                                //Add the newly created FieldType instance to a List
                                SFDCFieldList.add(new FieldType(
                                    strSelectedSObjectName,
                                    fieldResult.getLabel(), 
                                    fieldResult.getLocalName(), 
                                    getFldTypeDisplayDetails(fieldResult),
                                    strFieldDetails = getFieldDetails(fieldResult)));
                            }
                        }
                    }//if
                }//inner for
            }//outer for
        }
        this.updateMapIndex(); //Update the MapIndex value
     }
     
     //Increments the MapIndex value by 1 till the action poller completes processing for all the batches. If the  
     //SObjProcessingBatchMap limit is reached then the action poller is dsiabled.
     private void updateMapIndex()
     {
        if((this.MapKey + 1) > SObjProcessingBatchMap.size())   //Check whether the current processed batch is the last batch 
        {
            //Check if there is only one Batch for processing
            DisplaySFDCFieldBatchMap.put(MapKey, SFDCFieldList);
            IsShowMetadataBtnDisabled = false;          //Enable the Show Metadata button on UI         
            IsPollerEnabled = false;                        //Disable the Poller
            IsFieldTableVisible = true;                     //Unhide the datatable on UI
            DisplaySFDCFieldList = new List<FieldType>();
            if(DisplaySFDCFieldBatchMap.containsKey(1))
            {
                DisplaySFDCFieldList.addAll(DisplaySFDCFieldBatchMap.get(1));   //Add all the field results to be displayed on the user
                DisplayBatchMapKey = 1;
            }
        }
        else
        {
            //Processing for every iteration of the poller
            Integer intKey = MapKey; 
            DisplaySFDCFieldBatchMap.put(intKey, SFDCFieldList);
            SFDCFieldList = new List<FieldType>();          //Required as the reference of the inserted list should not be deleted
            ++MapKey;   //Increment the Map Index
        }
     }
     
     //STATIC METHODS
     private static String getFldTypeDisplayDetails(Schema.Describefieldresult pFieldResult)
     {
        String strFldTypeDisplayDetails;
        if(pFieldResult.getType().name().toLowerCase().contains('string')){
            strFldTypeDisplayDetails = 'TEXT';
        }
        else if(pFieldResult.getType().name().toLowerCase().contains('integer') || pFieldResult.getType().name().toLowerCase().contains('double')){
            strFldTypeDisplayDetails = 'NUMBER';
        }
        else if(pFieldResult.getType().name().toLowerCase().contains('integer') || pFieldResult.getType().name().toLowerCase().contains('reference')){
            strFldTypeDisplayDetails = 'RELATIONSHIP';
        }
        else{
            return pFieldResult.getType().name().toUpperCase();
        }
        return strFldTypeDisplayDetails;
     }
     
     private static String getFieldDetails(Schema.Describefieldresult pFieldResult)
     {
        String strFieldDetails;
        if(pFieldResult.getType().name().toLowerCase().contains('picklist')){
            strFieldDetails = createPicklistValueCSV(pFieldResult.getPicklistValues()); 
        }
        else if(pFieldResult.getType().name().toLowerCase().contains('string') || pFieldResult.getType().name().toLowerCase().contains('textarea')){
            strFieldDetails = getTextFldLength(pFieldResult); 
        }
        else if(pFieldResult.getType().name().toLowerCase().contains('reference')){
            strFieldDetails = getRelationshipFldDetails(pFieldResult); 
        }
        else if(pFieldResult.getType().name().toLowerCase().contains('integer') || pFieldResult.getType().name().toLowerCase().contains('double')){
            strFieldDetails = getNumberFldScalePrecision(pFieldResult); 
        }
        else{
            return 'NA';
        }
        return strFieldDetails;
     }
     
     private static String createPicklistValueCSV(List<Schema.Picklistentry> pPicklistEntries)
     {
        String strCSV = 'Picklist Values: ';
        for(Schema.Picklistentry pEntry : pPicklistEntries)
        {
            //Append the picklist values in a comma separated string format  e.g.: a,b,c,d
            if(pEntry.getValue() <> NULL)
                strCSV = pEntry.isDefaultValue() ? strCSV + pEntry.getValue() + '*' + ', ' : strCSV + pEntry.getValue() + ', ';
        }
        
        //Remove the extra comma and space appended at the end
        strCSV  = strCSV.contains(',') ? strCSV.substring(0, strCSV.length() - 2) : 'No Values';
        return strCSV;  
     }   
     
     private static String getTextFldLength(Schema.Describefieldresult pFieldResult)
     {
        String strTextFldLength;
        return strTextFldLength = 'Length: ' +  String.valueOf(pFieldResult.getLength()); 
     }
     
     private static String getRelationshipFldDetails(Schema.Describefieldresult pFieldResult)
     {
        String strRelationshipFldDetails = 'Relationship Name: ' + pFieldResult.getRelationshipName() + ', Reference To: ';
        for(Schema.Sobjecttype oSobjectType : pFieldResult.getReferenceTo())
        {
            strRelationshipFldDetails = strRelationshipFldDetails +  oSobjectType.getDescribe().getName() + ',';
        }
        return strRelationshipFldDetails.substring(0, strRelationshipFldDetails.length() - 1);  //Remove the extra comma appended at the end 
     }
     
     private static String getNumberFldScalePrecision(Schema.Describefieldresult pFieldResult)
     {
        String strNumberFldScalePrecision;
        return strNumberFldScalePrecision = 'Scale: ' + String.valueOf(pFieldResult.getScale()) + 
            ' Precision: ' + String.valueOf(pFieldResult.getPrecision());
     }
     
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //                                                 TEST METHODS                                                                 //
     //METHOD TO CHECK IF THE SOBJECT LIST IS GETTING POPULATED PROPERLY
        public static testMethod void SFDCObjectListTest()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();
            
            if(snapObj.getSFDCObjectList().isEmpty())           //Objects being populated for the first time or not
            {
                System.assert(snapObj.getSFDCObjectList().Size() != 0);
            }
        }
        
        //METHOD FOR DETERMINING IF THE SOBJECT HAS NOT BEEN SELECTED
        public static testMethod void checkSelectedList_Test1()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();
            snapObj.processSelectedSobjects(); 
            if(snapObj.SelectedObjCnt == 0)
            {
                System.assert(ApexPages.getMessages().Size() > 0);              
            }
        }
        
        //METHOD FOR DETERMINING IF THE SOBJECT HAS BEEN SELECTED
        public static testMethod void checkSelectedList_Test2()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            Integer totalSelectedObjects = snapObj.getSelectedObjectNameList().Size();          //Number of Objects selected
            Integer batches = Math.mod(totalSelectedObjects,25);        //Number of batched formed
            
            Test.startTest();
             System.assert(snapObj.SelectedObjCnt > 0);         
            Test.stopTest();
        }
        
        //METHOD FOR CHECKING IF THE FIELDS ARE GETTING POPULATED FOR SelectedFieldCategory = 'all'
        public static testMethod void checkFieldList_Test1()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');
            System.assert(snapObj.IsPollerEnabled == true);
            snapObj.MapKey = snapObj.BatchMapSize;              //Displaying the last batch         
            snapObj.getAllFields();
            System.assert(snapObj.IsPollerEnabled == false);
        }
        
        //METHOD FOR CHECKING IF THE FIELDS ARE GETTING POPULATED FOR SelectedFieldCategory = 'standard'
        public static testMethod void checkFieldList_Test2()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('standard');
            System.assert(snapObj.IsPollerEnabled == true);
            snapObj.MapKey = snapObj.BatchMapSize;              //Displaying the last batch         
            snapObj.getAllFields();
            System.assert(snapObj.IsPollerEnabled == false);
        }
        
        //METHOD FOR CHECKING IF THE FIELDS ARE GETTING POPULATED FOR SelectedFieldCategory = 'custom'
        public static testMethod void checkFieldList_Test3()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('custom');
            System.assert(snapObj.IsPollerEnabled == true);
            snapObj.MapKey = snapObj.BatchMapSize;              //Displaying the last batch         
            snapObj.getAllFields();
            System.assert(snapObj.IsPollerEnabled == false);
        }
        
        
        //METHOD TO CHECK IF THE PAGE REDIRECTS TO Excel page 
        //WHEN USER CLICKS ExportToExcel
        public static testMethod void checkExportToExcel_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            snapObj.IsFieldTableVisible = true;
                
                PageReference RefToExcel = snapObj.exportToExcel();
                System.assert(RefToExcel.getUrl()=='/apex/eternustest__snapitmetadataexporttoexcel');
        }
        
        //METHOD TO CHECK IF THE PAGE REDIRECTS TO Excel page 
        //WHEN USER CLICKS ExportToPdf
        public static testMethod void checkExportToPdf_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            snapObj.IsFieldTableVisible = true;
                PageReference RefToPdf = snapObj.exportToPdf();
                System.assert(RefToPdf.getUrl()=='/apex/eternustest__SnapItMetadataExportToPdf');
        }
        
        //  TEST METHODS FOR NAVIGATION
        public static testMethod void checkgetFirstDisplayBatch_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            
            snapObj.DisplayBatchMapKey = 1;
            snapObj.getFirstDisplayBatch();
            System.assert(snapObj.getIsPreviousVisible() == false);         
        }
        
        public static testMethod void checkgetPreviousDisplayBatch_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            snapObj.DisplayBatchMapKey = 2;
            
            snapObj.getPreviousDisplayBatch();
            System.assert(snapObj.getIsNextVisible() == false); 
        }
        
        public static testMethod void checkgetNextDisplayBatch_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            
            snapObj.DisplayBatchMapKey = snapObj.DisplayBatchMapSize - 1;
            snapObj.getNextDisplayBatch();
            System.assert(snapObj.getIsFirstLastVisible() == false);
        }
        
        public static testMethod void checkgetLastDisplayBatch_Test()
        {
            SnapItMetadataXplorerCtl snapObj = new SnapItMetadataXplorerCtl();
            snapObj.getAllSFDCObjects();            //retreiving all sObjects form the org
            List<Selectoption> objList = snapObj.getSFDCObjectList();
            String[] tempSelectedObjects = new String[]{};
            for(Selectoption obj : objList)
            {
                    tempSelectedObjects.add(obj.getValue());        
            }
            snapObj.setSelectedObjectNameList(tempSelectedObjects);
            snapObj.processSelectedSobjects();
            snapObj.setSelectedFieldCategory('all');                
            snapObj.getAllFields();
            
            snapObj.DisplayBatchMapKey = snapObj.DisplayBatchMapSize - 1;
            snapObj.getLastDisplayBatch();
            System.assert(snapObj.getIsNextVisible() == false);
        }
}//SnapItMetadataCtl