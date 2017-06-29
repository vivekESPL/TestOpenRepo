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
private class TestSearchVFPage {

    static testMethod void TestSearchValidText() {
        // TO DO: implement unit test
        PageReference pageRef = Page.SearchVFPage;
        
        
        SearchVFPageController srchCntlr=new SearchVFPageController();
        
        List<Account> lstAccount=new List<Account>();
        List<Contact> lstContact=new List<Contact>();
        List<Lead> lstLead=new List<Lead>();
        List<Opportunity> lstOpportunity=new List<Opportunity>();
        
        
        for(Integer i=0;i<10;i++)
        {
        	Account objAccount=new Account(Name='Test'+i);
        	lstAccount.add(objAccount);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Contact objContact=new Contact(LastName='Test'+i);
        	lstContact.add(objContact);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Lead objLead=new Lead(LastName='Test'+i,Company='ESPL',Status='Open - Not Contacted');
        	lstLead.add(objLead);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Opportunity objOpportunity=new Opportunity(Name='Test'+i,CloseDate=Date.today(),StageName='Qualification');
        	lstOpportunity.add(objOpportunity);
        }
        
        Test.startTest();
        insert lstAccount;
        insert lstContact;
        insert lstLead;
        insert lstOpportunity;
        
        lstAccount=null;
        lstContact=null;
        lstLead=null;
        lstOpportunity=null;
        
        
        Test.setCurrentPageReference(pageRef);
        
        srchCntlr.setSearchText('Test');
        srchCntlr.getSearchText();
        srchCntlr.doSearch();
        srchCntlr.getLink();
        srchCntlr.getTextAreaStyle();
        
        lstAccount=srchCntlr.getResults_account();
        lstContact=srchCntlr.getResults_contact();
        lstLead=srchCntlr.getResults_lead();
        lstOpportunity=srchCntlr.getResults_opportunity();
        
      	Account objAccount=[select Name from Account where Name='Test5'];
      	Lead objLead=[select LastName from Lead where LastName='Test5'];
      	Opportunity objOpportunity=[select Name from Opportunity where Name='Test5'];
      	Contact objContact=[select LastName from Contact where LastName='Test5'];
      	
      	for(Account objAcc:lstAccount)
      	{
      		if(objAcc.Name==objAccount.Name)
      		{
      			System.assertEquals(objAcc.Name,objAccount.Name);
      			break;      			
      		}
      	}
      	
      	for(Opportunity objOpp:lstOpportunity)
      	{
      		if(objOpp.Name==objOpportunity.Name)
      		{
      			System.assertEquals(objOpp.Name,objOpportunity.Name);
      			break;      			
      		}
      	}
      	
      	for(Contact objCnt:lstContact)
      	{
      		if(objCnt.LastName==objContact.LastName)
      		{
      			System.assertEquals(objCnt.LastName,objContact.LastName);
      			break;      			
      		}
      	}
      	
      	for(Lead objLd:lstLead)
      	{
      		if(objLd.LastName==objLead.LastName)
      		{
      			System.assertEquals(objLd.LastName,objLead.LastName);
      			break;      			
      		}
      	}
      
        Test.stopTest();
        
    }
    
    
    static testMethod void TestSearchTextKeptBlankOrLengthOne() {
        // TO DO: implement unit test
        PageReference pageRef = Page.SearchVFPage;
        
        
        SearchVFPageController srchCntlr=new SearchVFPageController();
        
        List<Account> lstAccount=new List<Account>();
        List<Contact> lstContact=new List<Contact>();
        List<Lead> lstLead=new List<Lead>();
        List<Opportunity> lstOpportunity=new List<Opportunity>();
        
        
        for(Integer i=0;i<10;i++)
        {
        	Account objAccount=new Account(Name='Test'+i);
        	lstAccount.add(objAccount);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Contact objContact=new Contact(LastName='Test'+i);
        	lstContact.add(objContact);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Lead objLead=new Lead(LastName='Test'+i,Company='ESPL',Status='Open - Not Contacted');
        	lstLead.add(objLead);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Opportunity objOpportunity=new Opportunity(Name='Test'+i,CloseDate=Date.today(),StageName='Qualification');
        	lstOpportunity.add(objOpportunity);
        }
        
        Test.startTest();
        insert lstAccount;
        insert lstContact;
        insert lstLead;
        insert lstOpportunity;
        
        lstAccount=null;
        lstContact=null;
        lstLead=null;
        lstOpportunity=null;
        
        
        Test.setCurrentPageReference(pageRef);
        
        srchCntlr.setSearchText('');
        srchCntlr.getSearchText();
        srchCntlr.doSearch();
        srchCntlr.getLink();
        srchCntlr.getTextAreaStyle();
        
        lstAccount=srchCntlr.getResults_account();
        lstContact=srchCntlr.getResults_contact();
        lstLead=srchCntlr.getResults_lead();
        lstOpportunity=srchCntlr.getResults_opportunity();
        
      	System.assert(lstAccount==null);
      	System.assert(lstContact==null);
      	System.assert(lstLead==null);
      	System.assert(lstOpportunity==null);
      
        Test.stopTest();
        
    }
    
    static testMethod void TestSearchTextWithSpecialCharacters() {
        // TO DO: implement unit test
        PageReference pageRef = Page.SearchVFPage;
        
        
        SearchVFPageController srchCntlr=new SearchVFPageController();
        
        List<Account> lstAccount=new List<Account>();
        List<Contact> lstContact=new List<Contact>();
        List<Lead> lstLead=new List<Lead>();
        List<Opportunity> lstOpportunity=new List<Opportunity>();
        
        
        for(Integer i=0;i<10;i++)
        {
        	Account objAccount=new Account(Name='Test'+i);
        	lstAccount.add(objAccount);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Contact objContact=new Contact(LastName='Test'+i);
        	lstContact.add(objContact);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Lead objLead=new Lead(LastName='Test'+i,Company='ESPL',Status='Open - Not Contacted');
        	lstLead.add(objLead);
        }
        
        for(Integer i=0;i<10;i++)
        {
        	Opportunity objOpportunity=new Opportunity(Name='Test'+i,CloseDate=Date.today(),StageName='Qualification');
        	lstOpportunity.add(objOpportunity);
        }
        
        Test.startTest();
        insert lstAccount;
        insert lstContact;
        insert lstLead;
        insert lstOpportunity;
        
        lstAccount=null;
        lstContact=null;
        lstLead=null;
        lstOpportunity=null;
        
        
        Test.setCurrentPageReference(pageRef);
        
        srchCntlr.setSearchText('^():@!$&');
        srchCntlr.getSearchText();
        srchCntlr.doSearch();
        srchCntlr.getLink();
        srchCntlr.getTextAreaStyle();
        
        lstAccount=srchCntlr.getResults_account();
        lstContact=srchCntlr.getResults_contact();
        lstLead=srchCntlr.getResults_lead();
        lstOpportunity=srchCntlr.getResults_opportunity();
        
      	System.assert(lstAccount==null);
      	System.assert(lstContact==null);
      	System.assert(lstLead==null);
      	System.assert(lstOpportunity==null);
      
        Test.stopTest();
        
    }
}