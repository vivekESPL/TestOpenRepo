public with sharing class LeadTriggerHandler1 
{
    public void onAfterInsert(List<Lead> lstNew)
	{
		system.debug('%%%%%%%%%%%lstNew after insert'+lstNew);
	}
	
	public void onAfterUpdate(List<Lead> lstOld,List<Lead> lstNew)
	{
		system.debug('%%%%%%%%%%%lstNew before update'+lstOld);
		system.debug('%%%%%%%%%%%lstNew after update'+lstNew);
	}
	
	public void onBeforeInsert(List<Lead> lstNew)
	{
		system.debug('%%%%%%%%%%%lstNew before insert'+lstNew);
	}
	
	public void onBeforeUpdate(List<Lead> lstOld,List<Lead> lstNew)
	{
		system.debug('%%%%%%%%%%%lstNew before update'+lstOld);
		system.debug('%%%%%%%%%%%lstNew after update'+lstNew);
	}

}