public with sharing class AccountTriggerHandler3 
{
	public void onAfterInsert(List<Account> lstNew)
	{
		
		
		//Set<String> nameSet = new Set<String>();
		Set<String> phoneSet = new Set<String>();
		Set<String> emailSet = new Set<String>();
		Set<String> fullnameSet=new Set<String>();
		
		Map<String,Id> fullname_emailMap=new Map<String,Id>();
		Map<String,Id> fullname_phoneMap=new Map<String,Id>();
		Map<String,Id> phone_emailMap=new Map<String,Id>();
		
		for(Account acc : lstNew)
		{
			//nameSet.add(acc.Name);
			phoneSet.add(acc.Phone);
			emailSet.add(acc.Email__c);
			fullnameSet.add(acc.Full_Name__c);
			
		}
		
		//Select a.Phone, a.ParentId, a.Id, a.Full_Name__c, a.Email__c From Account a //Id IN: mapNew.keyset()
		for(Account objAcc:[Select Phone, ParentId, Id, Full_Name__c, Email__c From Account where ParentId=null and ((Full_Name__c IN:fullnameSet and Email__c IN:emailSet) OR (Full_Name__c IN:fullnameSet and Phone IN:phoneSet) OR(Email__c IN:emailSet AND Phone IN:phoneSet))])
		{
			if(objAcc.Full_Name__c!=null && objAcc.Email__c!=null)
			fullname_emailMap.put(objAcc.Full_Name__c+objAcc.Email__c,objAcc.Id);
			
			else if(objAcc.Full_Name__c!=null && objAcc.Phone!=null)	
			fullname_phoneMap.put(objAcc.Full_Name__c+objAcc.Phone,objAcc.Id);
			
			else if(objAcc.Phone!=null && objAcc.Email__c!=null)
			phone_emailMap.put(objAcc.Phone+objAcc.Email__c,objAcc.Id);
			
							
		}
		
		/*for(Account objAcc:[Select Phone, ParentId, Id, Full_Name__c, Email__c From Account where Full_Name__c IN:fullnameSet and Phone IN:phoneSet])
		{
			fullname_phoneMap.put(objAcc.Full_Name__c+objAcc.Phone,objAcc.Id);		
		}
		
		for(Account objAcc:[Select Phone, ParentId, Id, Full_Name__c, Email__c From Account where Phone IN:phoneSet and Email__c IN:emailSet])
		{
			phone_emailMap.put(objAcc.Phone+objAcc.Email__c,objAcc.Id);			
		}*/
		
		List<Account> lstAcc=new List<Account>();
		
		for(Account objAcc: lstNew)
		{
			if(fullname_emailMap.containsKey(objAcc.Full_Name__c+objAcc.Email__c))
				objAcc.ParentId=fullname_emailMap.get(objAcc.Full_Name__c+objAcc.Email__c);
				
			else if(fullname_phoneMap.containskey(objAcc.Full_Name__c+objAcc.Phone))
				objAcc.ParentId=fullname_phoneMap.get(objAcc.Full_Name__c+objAcc.Phone);
				
			else if(phone_emailMap.containskey(objAcc.Phone+objAcc.Email__c))
				objAcc.ParentId=phone_emailMap.get(objAcc.Phone+objAcc.Email__c);
				
			else
				objAcc.ParentId=null;
				
				lstAcc.add(objAcc);
		}
		
		if(lstAcc!=null && lstAcc.size()>0)
		{
			insert lstAcc;
		}
		system.debug('%%%%%%%%%%%%%%%%%%%%%lstAcc:'+lstAcc);
	}

}