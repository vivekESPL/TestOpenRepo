trigger DemoTrigger on Account (after insert, after update) 
{
    AccountTriggerHandler objhdlr=new AccountTriggerHandler();
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        objhdlr.onAfterInsert(trigger.new);
    }
    
    /*if(trigger.isAfter && trigger.isUpdate)
    {
        objhdlr.onAfterUpdate(trigger.oldMap,trigger.newMap);
    }*/

}