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
private class TestCheckDupAccount {
	/*
		1. check duplicate records in Account before insert operation
			1.1 If duplicate record exists then the existing record should be set as a parent of new record*/
			
			
    static testMethod void checkFullNameandEmailDuplicate() 
    {
    	 List<Account> lstAcc=new List<Account>();
    	 
    	 Account objAc=new Account(Name='Test', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc1=new Account(Name='Test1', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc2=new Account(Name='Test2', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc3=new Account(Name='Test3', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 
    	 
    	 //insert objAc1;
    	 //insert objAc2;
    	 //insert objAc3;
    	 
    	 for(Integer i=1;i<=200;i++)                           
    	 {
    	 	Account objAcc=new Account(Name='Test'+i, First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282'+i);
    	 	
    	 	lstAcc.add(objAcc);
    	 }
    	 
    	 test.startTest();
    	 
    	 insert objAc;
    	     	 
    	 insert lstAcc;
    	 
    	 
    	 /*for(Account objAcc:[select name,Full_Name__c,Email__c,phone, ParentId from Account where Id IN: lstAcc])
    	 {
    	 	System.assert(objAcc.ParentId==objAc.Id);
    	 }*/
    	 
    	 Account objAcc1=[select Id from Account where Name='Test'];
    	 //Account objAcc2=[select Name,Full_Name__c,Email__c,phone, ParentId from Account where First_Name__c='Rahul' and Last_Name__c='Gupta' and Email__c='rahul.gupta@gmail.com' limit 1];
    	 Account objAcc2=[select ParentId from Account where Name='Test20'];
    	 
    	 System.assert(objAcc2.ParentId==objAcc1.Id);
    	 
    	 test.stopTest();
        
    }
    
    static testMethod void checkFullNameandPhoneDuplicate() 
    {
    	 List<Account> lstAcc=new List<Account>();
    	 
    	 Account objAc=new Account(Name='Test', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc1=new Account(Name='Test1', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc2=new Account(Name='Test2', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc3=new Account(Name='Test3', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 
    	 
    	 //insert objAc1;
    	 //insert objAc2;
    	 //insert objAc3;
    	 
    	 for(Integer i=1;i<=200;i++)                           
    	 {
    	 	Account objAcc=new Account(Name='Test'+i, First_Name__c='Rahul', Last_Name__c='Gupta',Email__c=i+'rahul.gupta@gmail.com',Phone='8087853282');
    	 	
    	 	lstAcc.add(objAcc);
    	 }
    	 
    	 test.startTest();
    	 
    	 insert objAc;
    	     	 
    	 insert lstAcc;
    	 
    	 
    	 /*for(Account objAcc:[select name,Full_Name__c,Email__c,phone, ParentId from Account where Id IN: lstAcc])
    	 {
    	 	System.assert(objAcc.ParentId==objAc.Id);
    	 }*/
    	 
    	 Account objAcc1=[select Id from Account where Name='Test'];
    	 //Account objAcc2=[select Name,Full_Name__c,Email__c,phone, ParentId from Account where First_Name__c='Rahul' and Last_Name__c='Gupta' and Phone='8087853282' limit 1];
    	 Account objAcc2=[select ParentId from Account where Name='Test20'];
    	 
    	 System.assert(objAcc2.ParentId==objAcc1.Id);
    	 
    	 test.stopTest();
        
    }
    
    
    static testMethod void checkPhoneandEmailDuplicate() 
    {
    	 List<Account> lstAcc=new List<Account>();
    	 
    	 Account objAc=new Account(Name='Test', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc1=new Account(Name='Test1', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc2=new Account(Name='Test2', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 //Account objAc3=new Account(Name='Test3', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 
    	 
    	 //insert objAc1;
    	 //insert objAc2;
    	 //insert objAc3;
    	 
    	 for(Integer i=1;i<=200;i++)                           
    	 {
    	 	Account objAcc=new Account(Name='Test'+i, First_Name__c='Rahul', Last_Name__c='Gupta'+i,Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 	
    	 	lstAcc.add(objAcc);
    	 }
    	 
    	 test.startTest();
    	 
    	 insert objAc;
    	     	 
    	 insert lstAcc;
    	 
    	
    	 
    	 /*for(Account objAcc:[select name,Full_Name__c,Email__c,phone, ParentId from Account where Id IN: lstAcc])
    	 {
    	 	System.assert(objAcc.ParentId==objAc.Id);
    	 }*/
    	 
    	 Account objAcc1=[select Id from Account where Name='Test'];
    	 //Account objAcc2=[select Name,Full_Name__c,Email__c,phone, ParentId from Account where Email__c='rahul.gupta@gmail.com' and Phone='8087853282' limit 1];
    	 Account objAcc2=[select ParentId from Account where Name='Test20'];
    	 
    	 System.assert(objAcc2.ParentId==objAcc1.Id);
    	 
    	 test.stopTest();
        
    }
    
    
    static testMethod void checkAllUniqueRecordsBeforeInsert() 
    {
    	 List<Account> lstAcc=new List<Account>();
    	 
    	 Account objAc=new Account(Name='Test', First_Name__c='Rahul', Last_Name__c='Gupta',Email__c='rahul.gupta@gmail.com',Phone='8087853282');
    	 
    	 test.startTest();
    	 insert objAc;
    	 
    	 for(Integer i=1;i<=200;i++)                           
    	 {
    	 	Account objAcc=new Account(Name='Test'+i, First_Name__c='Rahul'+i, Last_Name__c='Gupta'+i,Email__c=i+'rahul.gupta@gmail.com',Phone='80878532'+i);
    	 	
    	 	lstAcc.add(objAcc);
    	 }	
    	 
    	 
    	 
    	 insert lstAcc;
    	 
    	test.stopTest();
    	 
    	 /*for(Account objAcc:[select name,Full_Name__c,Email__c,phone, ParentId from Account where Id IN: lstAcc])
    	 {
    	 	System.assert(objAcc.ParentId==objAc.Id);
    	 }*/
    	 
    	 Account objAcc1=[select Id from Account where Name='Test'];
    	 Account objAcc2=[select ParentId from Account where Name='Test2'];
    	 
    	 System.assert(objAcc2.ParentId==null);
    	 
    	  
        
    }
}