global with sharing class TestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	private String userName;
	private String password;
	private String environment; 
	private String securitytoken;
	
	global TestBatch(String pUserName, String pPassword, String pEnvironment){
		userName = pUserName;
		password = pPassword;
		environment = pEnvironment;
		//securitytoken = pSecurityToken;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator('select id, name from A__c limit 1');
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<A__c> lst = (List<A__c>)scope;
		system.debug('-----username:'+username); 
		system.debug('-----pwd:'+password);
		system.debug('-----env:'+environment); 
		String securitytoken='';
		SendRequests sendRequests = new SendRequests();
    	LoginResponse loginresponse = AutoLogin.generateSessionId(username, password, environment);  
	    system.debug('loginresponse...$$$'+loginresponse);
		if(loginresponse.statusCode == 200){
			Integer counter = lst.size() + 1;			
			lst[0].Name = username + counter; 
			update lst;			
		}
		else{
			system.debug('-----login failed');
			system.debug('-----message:'+loginresponse.message);
		}
	}
	
	global void finish(Database.BatchableContext BC){
		
	}
}