public with sharing class SearchVFPageController 
{
	String searchText;
	List<Lead> results_lead;	
	List<Contact> results_contact;
	List<Opportunity> results_opportunity;
	List<Account> results_account;
	String textAreaStyle='';
	
	Map<string,List<SObject>> mapSobj=new Map<string,List<SObject>>();
	
	public String getSearchText() 
	{
		return searchText;
	} 
	
	
	public string getTextAreaStyle()
	{
		return textAreaStyle ;
	}


	public void setSearchText(String s) 
	{
		searchText = s;
	}
	
	public List<Lead> getResults_lead() 
	{
		return results_lead;
	}
	

	public List<Contact> getResults_contact() 
	{
		return results_contact;
	}
	
	
	public List<Account> getResults_account() 
	{
		return results_account;
	}
	
	
	public List<Opportunity> getResults_opportunity() 
	{
		return results_opportunity;
	}

	
		public PageReference doSearch() 
		{
			/*results_lead = (List<Lead>)[FIND :searchText RETURNING Lead(Name, Email, Phone)][0];
			doSearch_contact();
			doSearch_account();
			doSearch_opportunity();*/
				
			String findCharacter=searchText+'*';
			Boolean flag=false;
			
		    if(searchText=='' || searchText.length()<2)
		    {
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Search text can not be kept blank and should be of length greater than 1'));
		    textAreaStyle='border-size:2px; border-color:red;border-style:solid;';
		    }
		    else
		    {
		    	for(Integer i=0;i<searchText.length();i++)
		    	{
		    		if(searchText.subString(i,i+1)=='&' || 
		    		searchText.subString(i,i+1)=='$' || 
		    		searchText.subString(i,i+1)=='#' || 
		    		searchText.subString(i,i+1)=='@' || 
		    		searchText.subString(i,i+1)=='*' || 
		    		searchText.subString(i,i+1)=='!' || 
		    		searchText.subString(i,i+1)=='(' || 
		    		searchText.subString(i,i+1)=='{' ||
		    		searchText.subString(i,i+1)=='}' ||
		    		searchText.subString(i,i+1)=='+' ||
		    		searchText.subString(i,i+1)=='=' ||
		    		searchText.subString(i,i+1)=='<' ||
		    		searchText.subString(i,i+1)=='>' ||
		    		searchText.subString(i,i+1)=='?' ||
		    		searchText.subString(i,i+1)=='/' ||
		    		searchText.subString(i,i+1)==':' ||
		    		searchText.subString(i,i+1)=='^' ||
		    		searchText.subString(i,i+1)==')')
		    		{
		    			flag=true;		    		
		    		} 
		    	}
		    	if(flag)
		    	{
		    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Special characters are not allowed'));
		    		textAreaStyle='border-size:2px; border-color:red;border-style:solid;';	
		    	}		    		
		    	else
		    	{
				List<List<SObject>> searchList = [FIND :findCharacter IN NAME FIELDS RETURNING Account (Id, Name,First_Name__c,Last_Name__c,Email__c), Contact(Id, Name,FirstName,LastName,Email), Opportunity(Id, Name,Type,CloseDate), Lead(Id, Name,FirstName,LastName,Email)];		
			
				results_account = ((List<Account>)searchList[0]);
				results_contact = ((List<Contact>)searchList[1]);
				results_opportunity = ((List<Opportunity>)searchList[2]);
				results_lead = ((List<Lead>)searchList[3]);
		    	}	
		    }

			return null;
		}

		public String getLink()
		{
			String Url = System.URL.getSalesforceBaseUrl().toExternalForm();
			return Url;
		}

}