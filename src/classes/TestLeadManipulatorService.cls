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
private class TestLeadManipulatorService {
	
	private static final String statusSuccess='success';
	private static final String statusFail='fail';

    static testMethod void TestInsert() 
    {
        // TO DO: implement unit test

		Test.StartTest();

  		RestRequest req = new RestRequest();     
       	RestResponse res = new RestResponse();    // pass the req and resp objects to the method     
       	
       	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';     
       	req.httpMethod = 'POST';
       	req.addParameter('firstname','ABC');
       	req.addParameter('lastname','XYZ');
       	req.addParameter('email','abc@abc.com');
       	req.addParameter('phone','9898989898');
       	req.addParameter('company','ESPL');
       	req.addParameter('status','Closed - Converted');
       
       	RestContext.request = req;
       	RestContext.response = res;
       	//Test.startTest();
       	LeadManipulatorService.BindVar results = LeadManipulatorService.doPost();
       	//Test.stopTest();
    	System.assertEquals(true, results.isSuccess);    
    	System.assert(results.lead!=null);    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusSuccess)==0);
    
    	Test.StopTest();
    
    }
    
    
    static testMethod void TestDeleteSuccess() 
    {
        // TO DO: implement unit test

		Test.StartTest();
	
		Lead objLead=new Lead(FirstName='ABC',LastName='XYZ',Email='abc@abc.com',Phone='9898989898',Company='ESPL',Status='Closed - Converted');
		insert objLead;
	
  		RestRequest req = new RestRequest();     
    	RestResponse res = new RestResponse();    // pass the req and resp objects to the method       
    	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';     
    	req.httpMethod = 'DELETE';
    	req.addParameter('firstname','ABC');
    	req.addParameter('lastname','XYZ');
    	req.addParameter('email','abc@abc.com');
    	req.addParameter('phone','9898989898');
       
    	RestContext.request = req;
    	RestContext.response = res;
       	//Test.startTest();
    	LeadManipulatorService.BindVar results = LeadManipulatorService.doDelete();
       	//Test.stopTest();
    	System.assertEquals(true, results.isSuccess);    
    	System.assertEquals(results.lead,'ABCXYZ');    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusSuccess)==0);
    
    	Test.StopTest();
    }
    
    
    static testMethod void TestUpdateSuccess() 
    {
        // TO DO: implement unit test

		Test.StartTest();
	
		Lead objLead=new Lead(FirstName='ABC',LastName='XYZ',Email='abc@abc.com',Phone='9898989898',Company='ESPL',Status='Closed - Converted');
		insert objLead;
	
  		RestRequest req = new RestRequest();     
    	RestResponse res = new RestResponse();    // pass the req and resp objects to the method       
    	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';    
    	req.httpMethod = 'PUT';
    	req.addParameter('firstname','ABC');
    	req.addParameter('lastname','XYZ');
    	req.addParameter('email','abc@abc.com');
    	req.addParameter('phone','9898989898');
       
    	RestContext.request = req;
    	RestContext.response = res;
       	//Test.startTest();
    	LeadManipulatorService.BindVar results = LeadManipulatorService.doUpdate();
       	//Test.stopTest();
    	System.assertEquals(true, results.isSuccess);    
    	System.assert(results.lead!=null);    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusSuccess)==0);
    
    	Test.StopTest();
    }
    
    
    static testMethod void TestInsertFail() 
    {
        // TO DO: implement unit test

		Test.StartTest();

  		RestRequest req = new RestRequest();     
       	RestResponse res = new RestResponse();    // pass the req and resp objects to the method       
       	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';      
       	req.httpMethod = 'POST';
       	req.addParameter('firstname','ABC');
       	req.addParameter('lastname','XYZ');
       	req.addParameter('email','abc-abc.com');
       	req.addParameter('phone','9898989898');
       	req.addParameter('company','ESPL');
       	req.addParameter('status','Closed - Converted');
       
       	RestContext.request = req;
       	RestContext.response = res;
       	//Test.startTest();
       	LeadManipulatorService.BindVar results = LeadManipulatorService.doPost();
       	//Test.stopTest();
    	System.assertEquals(false, results.isSuccess);    
    	System.assert(results.lead==' ');    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusFail)==0);
    
    	Test.StopTest();
    
    }
    
    static testMethod void TestDeleteFail() 
    {
        // TO DO: implement unit test

		Test.StartTest();
	
		Lead objLead=new Lead(FirstName='ABC',LastName='XYZ',Email='abc@abc.com',Phone='9898989898',Company='ESPL',Status='Closed - Converted');
		insert objLead;
	
  		RestRequest req = new RestRequest();     
    	RestResponse res = new RestResponse();    // pass the req and resp objects to the method       
    	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';    
    	req.httpMethod = 'DELETE';
    	req.addParameter('firstname','ABC');
    	req.addParameter('lastname','XYZ');
    	req.addParameter('email','xyz@abc.com');
    	req.addParameter('phone','9898989898');
       
    	RestContext.request = req;
    	RestContext.response = res;
       	//Test.startTest();
    	LeadManipulatorService.BindVar results = LeadManipulatorService.doDelete();
       	//Test.stopTest();
    	System.assertEquals(false, results.isSuccess);    
    	System.assertEquals(results.lead,' ');    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusFail)==0);
    
    	Test.StopTest();
    }
    
    
    static testMethod void TestUpdateFail() 
    {
        // TO DO: implement unit test

		Test.StartTest();
	
		Lead objLead=new Lead(FirstName='ABC',LastName='XYZ',Email='abc@abc.com',Phone='9898989898',Company='ESPL',Status='Closed - Converted');
		insert objLead;
	
  		RestRequest req = new RestRequest();     
    	RestResponse res = new RestResponse();    // pass the req and resp objects to the method       
    	Url Url=System.URL.getSalesforceBaseUrl();  
       	req.requestURI = Url+'/services/apexrest/Lead';    
    	req.httpMethod = 'PUT';
    	req.addParameter('firstname','ABC');
    	req.addParameter('lastname','PQR');
    	req.addParameter('email','xyz@abc.com');
    	req.addParameter('phone','9898989898');
       
    	RestContext.request = req;
    	RestContext.response = res;
       	//Test.startTest();
    	LeadManipulatorService.BindVar results = LeadManipulatorService.doUpdate();
       	//Test.stopTest();
    	System.assertEquals(false, results.isSuccess);    
    	System.assert(results.lead==' ');    
    	System.assert(results.status.trim().toLowerCase().compareTo(statusFail)==0);
    
    	Test.StopTest();
    }
}