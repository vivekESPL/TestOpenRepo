trigger CheckDuplicateAccountTrigger on Account (before insert, before update) 
{
	AccountTriggerHandler2 hndlr=new AccountTriggerHandler2();
    if(trigger.isBefore && trigger.isInsert)
    {
    	hndlr.onBeforeInsert(trigger.new);
        
    }

}