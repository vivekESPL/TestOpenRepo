public with sharing class EmployeeTriggerHandler 
{
	public void onAfterInsert(List<Employee__c> lstNew)
	{
		system.debug('%%%%%%%%%%%%%lstNew'+lstNew);
	}
	
	public void onAfterUpdate()
	{
		
	}

}