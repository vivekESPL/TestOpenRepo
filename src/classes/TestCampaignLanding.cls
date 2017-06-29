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
private class TestCampaignLanding {

    static testMethod void AllCampaigns()
    {
    	PageReference pageRef = Page.CampaignLanding;

		//Test.setCurrentPageReference(pageRef);
		
    	CampaignController campcntlr=new CampaignController();	
   	
    	Campaign objCamp1=new Campaign(Name='Test1',StartDate=date.valueOf('2012-12-12'));
    	//List<Campaign> lstCamp=new List<Campaign>();
    	
    	test.startTest();
    	insert objCamp1;
    	Test.setCurrentPageReference(pageRef);
    	
    	campcntlr.view.Name='All Campaigns';
    	campcntlr.GetRecords();
    	List<Campaign> lstCamp=campcntlr.CampaignRecords;
    	
    	//Campaign view=new Campaign(Name='All Campaigns');
    	
    	//campCntlr.view(view);
    	
    	
    	
    	Campaign objCamp2=[select Campaign.Name,Status,Type,Startdate from Campaign where name='Test1'];
    	system.assert(objCamp1.StartDate==objCamp2.StartDate);
    	
    	test.stopTest();
    	
    }

   
    
    static testMethod void AllActiveCampaigns()
    {
    	PageReference pageRef = Page.CampaignLanding;

		//Test.setCurrentPageReference(pageRef);
		
    	CampaignController campcntlr=new CampaignController();   	
    	
    	Campaign objCamp1=new Campaign(Name='Test1',IsActive=true,StartDate=date.valueOf('2012-12-12'));
    	//List<Campaign> lstCamp=new List<Campaign>();
    	
    	test.startTest();
    	insert objCamp1;
    	Test.setCurrentPageReference(pageRef);
    	
    	campcntlr.view.Name='All Active Campaigns';
    	campcntlr.GetRecords();
    	List<Campaign> lstCamp=campcntlr.CampaignRecords;    	
    	
    	Campaign objCamp2=[select Campaign.Name,Status,Type,Startdate,IsActive from Campaign where name='Test1'];
    	system.assert(objCamp1.IsActive==objCamp2.IsActive);
    	
    	test.stopTest();
    	
    		 
    }
    
    static testMethod void RecentlyModified()
    {
    	PageReference pageRef = Page.CampaignLanding;

		//Test.setCurrentPageReference(pageRef);
		
    	CampaignController campcntlr=new CampaignController();
   	
    	Campaign objCamp1=new Campaign(Name='Test1');
   
    	//List<Campaign> lstCamp=new List<Campaign>();
    	
    	test.startTest();
    	insert objCamp1;
    	Test.setCurrentPageReference(pageRef);
    	
    	campcntlr.view.Name='Recently Modified';
    	campcntlr.GetRecords();
		List<Campaign> lstCamp=campcntlr.CampaignRecords;  	
    	
    	Campaign objCamp2=[select Campaign.Name,Status,Type,Startdate from Campaign where name='Test1'];
    	system.assert(objCamp1.StartDate==objCamp2.StartDate);
    	
    	test.stopTest();
    	
    	
    }
    
    static testMethod void InactiveCampaigns()
    {
    	PageReference pageRef = Page.CampaignLanding;

		//Test.setCurrentPageReference(pageRef);
		
    	CampaignController campcntlr=new CampaignController();   	
    	
    	Campaign objCamp1=new Campaign(Name='Test1',IsActive=false,StartDate=date.valueOf('2012-12-12'));
    	//List<Campaign> lstCamp=new List<Campaign>();
    	
    	test.startTest();
    	insert objCamp1;
    	Test.setCurrentPageReference(pageRef);
    	
    	campcntlr.view.Name='Inactive Campaigns';
    	campcntlr.GetRecords();   
    	List<Campaign> lstCamp=campcntlr.CampaignRecords; 	
    	
    	Campaign objCamp2=[select Campaign.Name,Status,Type,Startdate,IsActive from Campaign where name='Test1'];
    	system.assert(objCamp1.IsActive==objCamp2.IsActive);
    	
    	test.stopTest();
    }
    
    static testMethod void MyActiveCampaigns()
    {
    	PageReference pageRef = Page.CampaignLanding;

		//Test.setCurrentPageReference(pageRef);
		
    	CampaignController campcntlr=new CampaignController();
    	   	
    	Campaign objCamp1=new Campaign(Name='Test1',IsActive=true,OwnerId=UserInfo.getUserId(),StartDate=date.valueOf('2012-12-12'));
    	//List<Campaign> lstCamp=new List<Campaign>();
    	
    	test.startTest();
    	insert objCamp1;
    	Test.setCurrentPageReference(pageRef);
    	
    	campcntlr.view.Name='My Active Campaigns';
    	campcntlr.GetRecords();
    	List<Campaign> lstCamp=campcntlr.CampaignRecords;     	
    	
    	Campaign objCamp2=[select Campaign.Name,Status,Type,Startdate,IsActive,OwnerId from Campaign where name='Test1'];
    	system.assert(objCamp1.OwnerId==objCamp2.OwnerId);
    	system.assert(objCamp1.IsActive==objCamp2.IsActive);
    	
    	test.stopTest();

    }
    
    static testMethod void testHasNext() 
    {

		PageReference pageRef = Page.CampaignLanding;

		CampaignController campcntlr=new CampaignController();	
		List<Campaign> lstCampaign=new List<Campaign>();
 		
 		for(Integer i=0;i<50;i++)
 		{  	
    	Campaign objCamp1=new Campaign(Name='Test'+i,StartDate=date.valueOf('2012-12-12'));
    	lstCampaign.add(objCamp1);
 		}

		Test.startTest();

		insert lstCampaign;
		
		Test.setCurrentPageReference(pageRef);

		campcntlr.view.Name='Recently Modified';
    	campcntlr.GetRecords();  

		List<Campaign> lstCamp=campcntlr.CampaignRecords;
   
		system.assert(!campcntlr.hasPrevious);

		system.assert(campcntlr.hasNext);

		campcntlr.stdcampaign.next();

		system.assert(campcntlr.hasPrevious);
		
		campcntlr.stdcampaign.previous();
		
		system.assert(!campcntlr.hasPrevious);		
		
		Test.stopTest();

	}
	
}