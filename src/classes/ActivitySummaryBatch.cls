global class ActivitySummaryBatch implements Database.Batchable<sObject> 
{
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
	
		return Database.getQueryLocator('Select c.Lastupdated_Date__c, c.Id, c.ContactId, c.CampaignId From CampaignMember c');
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
		 List<CampaignMember> lstCampaignMembers = (List<CampaignMember>)scope;
		  
		 Map<Id,Integer> mapAllContact=new Map<Id,Integer>();
		 
		 /*List<CampaignMember> lstyesterdayCampaign=new List<CampaignMember>();
		 List<CampaignMember> lst90Campaign=new List<CampaignMember>();
		  List<CampaignMember> lst180Campaign=new List<CampaignMember>();
		   List<CampaignMember> lst365Campaign=new List<CampaignMember>();
		   
		    List<CampaignMember> listAll=new List<CampaignMember>();
		   
		   Map<Id,Integer> mapyesterdayContact=new Map<Id,Integer>();
		   Map<Id,Integer> map90Contact=new Map<Id,Integer>();
		   Map<Id,Integer> map180Contact=new Map<Id,Integer>();
		   Map<Id,Integer> map365Contact=new Map<Id,Integer>();
		   
		     Map<Id,Integer> mapAllContact=new Map<Id,Integer>();
		 
		  Datetime dt=null; 
			Date d=null;
		  Integer i=0;
		for(CampaignMember objCamp:lstCampaignMembers)
		{
				i++;
					 dt=objCamp.Lastupdated_Date__c;
			 d=dt.date();

		
				if(d.isSameDay(date.today()-1)) 	
	        	{
	        		
	        		
	        		lstyesterdayCampaign.add(objCamp);
	        		
	        	}
	        	
	        	if((d.daysBetween((date.today()-2))>1) && (d.daysBetween((date.today()-2))<90) ) 	
	        	{
	        		
	        	
	        		lst90Campaign.add(objCamp);
	        		
	        	}
	        	
	        	if((d.daysBetween((date.today()-91))>1) && (d.daysBetween((date.today()-91))<180)) 	
	        	{
	        		
	        	
	        		lst180Campaign.add(objCamp);
	        		
	        	}
	        	
	        	if((d.daysBetween((date.today()-181))>1) && (d.daysBetween((date.today()-181))<365)) 	
	        	{
	        		
	        		
	        		lst365Campaign.add(objCamp);
	        		
	        	}
		
		
		
		 }
		 
		 
		 for(CampaignMember objCamp:lstyesterdayCampaign)
		 {
		 	if(!(mapyesterdayContact.containsKey(objCamp.ContactId)))
		 	{
		 		mapyesterdayContact.put(objCamp.ContactId,1);
		 	}
		 	else if(mapyesterdayContact.containsKey(objCamp.ContactId))
		 	{
		 		Integer counter=mapyesterdayContact.get(objCamp.ContactId);
		 		mapyesterdayContact.put(objCamp.ContactId,counter+1);
		 	}
		 }
		 
		 
		 for(CampaignMember objCamp:lst90Campaign)
		 {
		 	if(!(map90Contact.containsKey(objCamp.ContactId)))
		 	{
		 		map90Contact.put(objCamp.ContactId,1);
		 	}
		 	else if(map90Contact.containsKey(objCamp.ContactId))
		 	{
		 		Integer counter=map90Contact.get(objCamp.ContactId);
		 		map90Contact.put(objCamp.ContactId,counter+1);
		 	}
		 }
		 
		 for(CampaignMember objCamp:lst180Campaign)
		 {
		 	if(!(map180Contact.containsKey(objCamp.ContactId)))
		 	{
		 		map180Contact.put(objCamp.ContactId,1);
		 	}
		 	else if(map180Contact.containsKey(objCamp.ContactId))
		 	{
		 		Integer counter=map180Contact.get(objCamp.ContactId);
		 		map180Contact.put(objCamp.ContactId,counter+1);
		 	}
		 }
		 
		 for(CampaignMember objCamp:lst365Campaign)
		 {
		 	if(!(map365Contact.containsKey(objCamp.ContactId)))
		 	{
		 		map365Contact.put(objCamp.ContactId,1);
		 	}
		 	else if(map365Contact.containsKey(objCamp.ContactId))
		 	{
		 		Integer counter=map365Contact.get(objCamp.ContactId);
		 		map365Contact.put(objCamp.ContactId,counter+1);
		 	}
		 }
		 */
		 
		 		 
		 for(CampaignMember objCamp:lstCampaignMembers)
		 {
		 	if(!(mapAllContact.containsKey(objCamp.ContactId)))
		 	{
		 		mapAllContact.put(objCamp.ContactId,1);
		 	}
		 	else if(mapAllContact.containsKey(objCamp.ContactId))
		 	{
		 		Integer counter=mapAllContact.get(objCamp.ContactId);
		 		mapAllContact.put(objCamp.ContactId,counter+1);
		 	}
		 }
		 
		 
		 List<Contact> lstallContact=new List<Contact>();	 
		for(Contact objCnt:[select Id,Lifetime_Action_Count__c from Contact where Id IN:mapAllContact.keyset()])
		{
		
			objCnt.Lifetime_Action_Count__c=mapAllContact.get(objCnt.Id);
			lstallContact.add(objCnt);
		
		}
		
		update lstallContact;
		  
		 
		 
		/*		 
	List<Contact> lstYesContact=new List<Contact>();	 
	for(Contact objCnt:[select Id,Yesterday_count__c from Contact where Id IN:mapyesterdayContact.keyset()])
	{
		
		objCnt.Yesterday_count__c=mapyesterdayContact.get(objCnt.Id);
		lstYesContact.add(objCnt);
		
	}	 

	
	List<Contact> lst90Contact=new List<Contact>();	 
	for(Contact objCnt1:[select Id,X90_Day_Count__c from Contact where Id IN:map90Contact.keyset()])
	{
			
		
		objCnt1.X90_Day_Count__c=map90Contact.get(objCnt1.Id);
		lst90Contact.add(objCnt1);
		
	}	 
	
	List<Contact> lst180Contact=new List<Contact>();	 
	for(Contact objCnt2:[select Id,X180_Day_Count__c from Contact where Id IN:map180Contact.keyset()])
	{
		
		objCnt2.X180_Day_Count__c=map180Contact.get(objCnt2.Id);
		lst180Contact.add(objCnt2);
	
	}	 
	
	List<Contact> lst365Contact=new List<Contact>();	 
	for(Contact objCnt3:[select Id,X365_Day_Count__c from Contact where Id IN:map365Contact.keyset()])
	{
		
		objCnt3.X365_Day_Count__c=map365Contact.get(objCnt3.Id);
		lst180Contact.add(objCnt3);
	
	}	 
	
	update lstYesContact;
	update lst90Contact;
	update lst180Contact;
	update lst365Contact;*/
	
	
	

		System.debug('%%%%%%%%%%%%%%%%lstallcontact:'+lstallContact);
		
		
		//System.debug('%%%%%%%%%%%%%%%%map90:'+map90Contact);
		
		//System.debug('%%%%%%%%%%%%%%%%map180:'+map180Contact);
		
		//System.debug('%%%%%%%%%%%%%%%%map365:'+map365Contact);
		
		
	//	System.debug('%%%%%%%%%%%%%%%%lst-1:'+(date.today()-1));
				
	//	System.debug('%%%%%%%%%%%%%%%%lstcont:'+lstyesterdayCampaign);
			//	System.debug('%%%%%%%%%%%%%%%%lst90cont:'+lst90Campaign);
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}

}