trigger UpdateTargetDateTrigger on Legal_Information__c (before insert, before update, after update,after insert) {

    UpdateTargetDateTriggerHandler hndlr = new UpdateTargetDateTriggerHandler();
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            hndlr.onBeforeInsert(trigger.new);
        }
        if(trigger.isUpdate){
            hndlr.onBeforeUpdate(trigger.oldMap, trigger.newMap);
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             //Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();  
             User recipient1 = [SELECT id, firstname FROM user where id = : trigger.new[0].OwnerId];
             //List<ID> recipientIds = new List<ID>();
             //List<ID> whatids = new List<ID>();
             //whatIds.add(trigger.new[0].id);
             //recipientIds.add(recipient1.id); 
             //recipientIds.add(trigger.new[0].Country_Party__c);
             EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'VFMailSent'];
            
             mail.setTargetObjectId(recipient1.Id); // Specify who the email should be sent to.
             mail.setTemplateId(et.id);
             mail.saveAsActivity = false;
             mail.setwhatid(trigger.new[0].id);
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
            //hndlr.onAfterUpdate(trigger.oldMap, trigger.newMap);
        }
    }
}