public with sharing class AccountTriggerHandler 
{
	public void onAfterInsert(List<Account> lstNew)
	{
		/*system.debug('%%%%%%%%%%%%%mapNew'+mapNew);
		
		Contact objCon= [Select Name, AccountId from Contact where AccountId IN: mapNew.keyset()];
		objCon.Related_Account__c=mapNew.get();
		
		*/
		for(Account objAcc: lstNew)
		{
		List<Contact> lstConts=[Select Id, Name, AccountId from Contact where AccountId =: objAcc.Id];
		
		List<Contact> lstCont=new List<Contact>();
		//Account objAcc=lstNew;
		
		system.debug('%%%%%%%%%%%lstCont'+lstCont);
		
		for(Contact objCnt:lstConts)
		{
			objCnt.Related_Account__c=objAcc.AccountNumber;
			lstCont.add(objCnt);
			
		}
		//if( !lstCont.isEmpty)
		//{
   			update lstCont;
		}
		//update c;
	}
	
	public void onAfterUpdate(Map<Id, Account> mapOld, Map<Id, Account> mapNew)
	{
		//system.debug('%%%%%%%%%%%%%mapOld'+mapOld);
		//system.debug('%%%%%%%%%%%%%mapNew'+mapNew);
		
		Map<Id, Contact> mapCon= new Map<Id, Contact>();
		 for(Contact objCon: [Select Name, AccountId from Contact where AccountId IN: mapNew.keyset()])
		 {
		 	mapCon.put(objCon.AccountId, objCon);
		 }
		 
		 system.debug('%%%%%%%%%%%%%mapCon'+mapCon);
		
		for(Id objACC: mapNew.keyset())
		{
					/*Contact objCon = new Contact();
			if(mapCon.get(objACC) != null)
					objCon = mapCon.get(objACC);*/
			if(mapOld.containskey(objACC) && mapOld.get(objACC).Name != mapNew.get(objACC).Name)
			{
				system.debug('%%%%%%%%I am firing on Change');
			}
			else
				system.debug('%%%%%%%%I am firing on not change');
		}
		
	}

}