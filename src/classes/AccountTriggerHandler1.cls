public with sharing class AccountTriggerHandler1 
{
	public void onAfterInsert(Map<Id,Account> mapNew)
	{
		List<Contact> lstCnt=new List<Contact>();
		for(Id obj: mapNew.keyset())
		{
			Contact objCnt=new Contact();
			objCnt.AccountId=mapnew.get(obj).Id;
			objCnt.LastName=mapnew.get(obj).name;
			
			lstCnt.add(objCnt);
		}
		
		if(lstCnt!=null && lstCnt.size()>0)
		{ 
			insert lstCnt;
		}
	}

}