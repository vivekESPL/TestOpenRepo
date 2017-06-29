public with sharing class UpdateTargetDateTriggerHandler1 {

	public void onBeforeInsert(List<Legal_Information__c> legalInfoList){
		List<Stage_Detail__c> stageDetailList = [select Agreement_Type__c, Status__c, Timeline__c from Stage_Detail__c];
		for(Legal_Information__c legalInfoObject: legalInfoList){
			for(Stage_Detail__c stageDetailObject: stageDetailList){
				
				if(legalInfoObject.Agreement_Type__c.compareTo(stageDetailObject.Agreement_Type__c) == 0 && 
				legalInfoObject.Status__c.compareTo(stageDetailObject.Status__c) == 0){
					legalInfoObject.Timeline__c = stageDetailObject.Timeline__c;
					legalInfoObject.Target_Date__c = legalInfoObject.Start_Date__c + (Integer)stageDetailObject.Timeline__c;
				}
			}
		}			
	}
	
	public void onBeforeUpdate(Map<Id, Legal_Information__c> legalInfoMapOld, Map<Id, Legal_Information__c> legalInfoMapNew){	
		List<Stage_Detail__c> stageDetailList = [select Agreement_Type__c, Status__c, Timeline__c from Stage_Detail__c];
		List<History_Tracking__c> historyTrackingList = new List<History_Tracking__c>();
		for(Id legalInfoId: legalInfoMapOld.keySet()){
			if(legalInfoMapNew.containsKey(legalInfoId)){
				if(legalInfoMapOld.get(legalInfoId).Target_Date__c != legalInfoMapNew.get(legalInfoId).Target_Date__c){
					Legal_Information__c legalInfoObject = legalInfoMapNew.get(legalInfoId);
					
					History_Tracking__c historyTrackingObject = new History_Tracking__c();
					historyTrackingObject.Subject__c='Target date change';
					historyTrackingObject.Old_Status__c = legalInfoMapOld.get(legalInfoId).Status__c;
					historyTrackingObject.New_Status__c = legalInfoObject.Status__c;
					historyTrackingObject.Target_Date__c = legalInfoObject.Target_Date__c;
					historyTrackingObject.Comment__c = legalInfoObject.Comment__c;
					historyTrackingObject.Status_Changed_Date__c = system.now();
					historyTrackingObject.Legal_Information__c = legalInfoObject.Id;
					historyTrackingList.add(historyTrackingObject);
				}
				else if(legalInfoMapOld.get(legalInfoId).Status__c != legalInfoMapNew.get(legalInfoId).Status__c){
					Legal_Information__c legalInfoObject = legalInfoMapNew.get(legalInfoId);
						for(Stage_Detail__c stageDetailObject: stageDetailList){
					
							if(legalInfoObject.Agreement_Type__c.compareTo(stageDetailObject.Agreement_Type__c) == 0 && 
							legalInfoObject.Status__c.compareTo(stageDetailObject.Status__c) == 0){
								legalInfoObject.Start_Date__c = system.today();
								legalInfoObject.Timeline__c = stageDetailObject.Timeline__c;
								legalInfoObject.Target_Date__c = system.today() + (Integer)stageDetailObject.Timeline__c;
							}
						}
					//}		
				}
			}
			
		}
		
		if(!historyTrackingList.isEmpty())
			insert historyTrackingList;
	}
	
	public void onAfterUpdate(Map<Id, Legal_Information__c> legalInfoMapOld, Map<Id, Legal_Information__c> legalInfoMapNew){

		List<History_Tracking__c> historyTrackingList = new List<History_Tracking__c>();
		for(Id legalInfoId: legalInfoMapOld.keySet()){
			if(legalInfoMapNew.containsKey(legalInfoId)){
				if(legalInfoMapOld.get(legalInfoId).Status__c != legalInfoMapNew.get(legalInfoId).Status__c){
					Legal_Information__c legalInfoObject = legalInfoMapNew.get(legalInfoId);
					
					History_Tracking__c historyTrackingObject = new History_Tracking__c();
					historyTrackingObject.Subject__c='Status change';
					historyTrackingObject.Old_Status__c = legalInfoMapOld.get(legalInfoId).Status__c;
					historyTrackingObject.New_Status__c = legalInfoObject.Status__c;
					historyTrackingObject.Target_Date__c = legalInfoObject.Target_Date__c;
					historyTrackingObject.Comment__c = legalInfoObject.Comment__c;
					historyTrackingObject.Status_Changed_Date__c = system.now();
					historyTrackingObject.Legal_Information__c = legalInfoObject.Id;
					historyTrackingList.add(historyTrackingObject);
				}
			}
		}
		
		if(!historyTrackingList.isEmpty())
			insert historyTrackingList;		
	}
}