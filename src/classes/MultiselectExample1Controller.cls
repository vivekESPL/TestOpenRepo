public with sharing class MultiselectExample1Controller {

    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    public boolean displayPopup {get; set;}     
    
    public String message { get; set; }
    
    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }
    
    public MultiselectExample1Controller() {
    	displayPopup = false;
        /*rightOptions = new List<SelectOption>();
        
        List<Contact> contacts = [SELECT Name, Id FROM Contact];    
        leftOptions = new List<SelectOption>();
        for ( Contact c : contacts ) {
            leftOptions.add(new SelectOption(c.Id, c.Name));
        }*/
        
        rightOptions = new List<SelectOption>();
        leftOptions = new List<SelectOption>();
        
        Schema.Describesobjectresult result = Account.getSObjectType().getDescribe();
       	Map<String, Schema.SObjectField> fieldMap = result.fields.getMap();
            
        for(String strField : fieldMap.keySet()){         	           
        	Schema.Describefieldresult fieldResult = fieldMap.get(strField).getDescribe();  
            leftOptions.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));
        }
    }
	    
    public void closePopup() {        
        displayPopup = false;    
    }     
    
    public void showPopup() {  
    	if(displayPopup)      
        	displayPopup = false;
        else
       		displayPopup = true;   
    }
    
    public PageReference save() {
        message = 'Selected Contacts: ';
        Boolean first = true;
        for ( SelectOption so : selectedContacts ) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel() + ' (' + so.getValue() + ')';
            first = false;
        }
        
        return null;       
    }
    
    // Parse &-separated values and labels from value and 
    // put them in option
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
        }
    }
}