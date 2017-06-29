public with sharing class AccountToVFController 
{
	
// Initialize setCon and return a list of records
	public List<Account> accounts 
	{
		get 
		{
	      	if(accounts != null) 
			{
	        	return accounts;
	      	} 	
	      	else 
	      	{
	        	accounts = [Select Id, Name, Full_Name__c, Email__c from Account limit 10];
	        	return accounts;
	      	}
	    }
	    set;
	}
}