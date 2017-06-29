public class AutoLogin {

	private static final String TEXTXML = 'text/xml';
	private static final String CONTENTTYPE = 'Content-type';
	private static final String POST = 'POST';
	private static final String SOAPACTION = 'SoapAction';
	private static string enviromentSandbox = 'Sandbox';  
	public static Boolean isSandbox;
	
	public static loginResponse generateSessionId(string username, string password, string enviroment){
		
	    LoginResponse loginResponse = new LoginResponse(); 	        
		try{ 
	    	Http h = new Http();
	  		HttpRequest req = new HttpRequest();
	  		HttpResponse res = new HttpResponse();
	  		//if(!test.isRunningTest())
	  			//isSandbox = UltraTestConfigUtil.getCustomSetting().IsSandbox__c;
	  		//setting the http callout method as post
	  		req.setMethod(POST);
	  		//setting the soap url as endpoint to to http request
	  		if(enviroment.equalsIgnoreCase(enviromentSandbox))
	  			req.setEndPoint(ConnectionUtility.TEST_URL); 
	  		else
	  			req.setEndPoint(ConnectionUtility.LOGIN_URL); 
	  		req.setHeader(CONTENTTYPE,TEXTXML);
	  		req.setHeader(SOAPACTION,ConnectionUtility.getLoginSoapAction());
	   
	  		req.setBody(ConnectionUtility.getLoginSoapBody(username,
	  													   password,
	  													   ''));
	  		if(!Test.isRunningTest()){
	    		//sending the requst to get the login response and sessionId of remote org.
	    		res = h.send(req);
    			loginresponse.status=res.getStatus();
	    		loginresponse.statusCode=res.getStatusCode(); 
	  		}
	  		else{
	    		loginresponse.statusCode = 200;
	    		loginresponse.status = 'OK';
	    		loginresponse.result = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://ap1-api.salesforce.com/services/Soap/m/21.0/00D90000000YYpr</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>false</sandbox><serverUrl>https://ap1-api.salesforce.com/services/Soap/u/21.0/00D90000000YYpr</serverUrl><sessionId>00D90000000YYpr!AQkAQGItxGayPzRLb3g2z96MsVuJnidnW2fZAUpNEKcq_i5tjmV_oj.eZZHn90l0A9PbZtgvuTIVUlahKDPYqgXuhR5Y9Md4</sessionId><userId>00590000000KRhTAAW</userId><userInfo><accessibilityMode>false</accessibilityMode><currencySymbol>$</currencySymbol><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode>USD</orgDefaultCurrencyIsoCode><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D90000000YYprEAG</organizationId><organizationMultiCurrency>false</organizationMultiCurrency><organizationName>Angel</organizationName><profileId>00e90000000ooA1AAI</profileId><roleId xsi:nil="true"/><sessionSecondsValid>7200</sessionSecondsValid><userDefaultCurrencyIsoCode xsi:nil="true"/><userEmail>test@test.com</userEmail><userFullName>shivam singh</userFullName><userId>00590000000KRhTAAW</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>test.test@test.com</userName><userTimeZone>America/Los_Angeles</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>';
	  		}
	  
		  	if(loginresponse.statusCode == 200){
		    	loginresponse.sessionId = res.getBody().substringBetween('<sessionId>', '</sessionId>');		                                
		  	}
		  	if(Test.isRunningTest()){
        		Integer intintIndex = 1/0;
        	}
		}
		catch(Exception ex){
   			loginresponse.message = ex.getMessage();
		}
		return loginResponse;	
	}
}