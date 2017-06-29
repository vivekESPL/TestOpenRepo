/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestActivitySummaryBatch {

    static testMethod void testBatch() 
    {
    	Contact objContact=new Contact(FirstName='XYZ', LastName='PQR');
    	
       List<CampaignMember> lstCampMemb=new  List<CampaignMember>();
       List<Campaign> lstCamp=new  List<Campaign>();
       
       insert objContact;
       
       for(Integer i=0;i<200;i++)
       {
       		Campaign objCamp=new Campaign(Name='Test'+i);
       		lstCamp.add(objCamp);
       }
       
       insert lstCamp;
    
       Contact objContact1=[select Id from Contact where FirstName='XYZ'];
       
       for(Campaign objCmp:[select Id,Name from Campaign where Id IN:lstCamp]) 
       {
       	CampaignMember objCampMemb=new CampaignMember(CampaignId=objCmp.Id,ContactId=objContact1.Id);
       	lstCampMemb.add(objCampMemb);
       }
       
       insert lstCampMemb;
       
       test.startTest();
       ActivitySummaryBatch actBatch=new ActivitySummaryBatch();
	   database.executebatch(actBatch);
       test.stopTest();
       
       List<Contact> lstCounter=[select Lifetime_Action_Count__c from Contact where FirstName='XYZ'];
       
       System.AssertEquals(lstCounter.get(0).Lifetime_Action_Count__c,200);
       
       
       
       
    }
}