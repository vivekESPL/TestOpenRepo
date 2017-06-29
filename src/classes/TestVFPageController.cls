public with sharing class TestVFPageController {
	public boolean displayPopUp{get;set;}
	public string userName{get;set;}
	public string password{get;set;}
	public string enviroment {get;set;} 
	
	public TestVFPageController(){
		displayPopUp = false;
	}
	
	public List<SelectOption> getEnviromentOptions(){
		List<SelectOption> options = new List<SelectOption>();    //list of all org instances
		//adding select options in the select list
		options.add(new Selectoption('Developer/Production','Developer/Production'));
		options.add(new Selectoption('Sandbox','Sandbox'));
		return options; 
	}
	
	public PageReference showPopup(){
		displayPopUp = true;
		return null;
	}
	
	public PageReference closePopup() {         
        displayPopup = false;
        //String page = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TestVFPage';
		//Pagereference pref = new Pagereference(page);
		return null;    
    }
    
    public PageReference getCredentials(){
    	Datetime systemDateTime = System.now(); 
    	String cronExpression = constructCronExpression();
    	system.debug('cronExpression..............'+cronExpression);
    	System.schedule('TestScheduler'+ systemDateTime.getTime(), cronExpression, 
    						new TestScheduler(userName, password, enviroment));
		system.debug('------user name:'+userName);
		system.debug('------pwd:'+password);
		
    	String page = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TestVFPage';
		Pagereference pref = new Pagereference(page);
		return pref; 
    }
    
    private String constructCronExpression(){
		Datetime currentDateTime = System.now();
	    currentDateTime = currentDateTime.addSeconds(600);
	    return '' + currentDateTime.second() + ' ' + currentDateTime.minute() + ' ' + currentDateTime.hour() 
	              + ' ' + currentDateTime.day() + ' ' + currentDateTime.month() + ' ? ' + currentDateTime.year();
	}

}