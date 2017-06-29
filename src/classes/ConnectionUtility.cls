public with sharing class ConnectionUtility {
    // server endpoint url for http callout to get connected to remote dev/prod SFDC org	
    public static string LOGIN_URL = 'https://login.salesforce.com/services/Soap/u/25.0';
    // server endpoint url for http callout to get connected to remote sandbox SFDC org	
    public static string TEST_URL = 'https://test.salesforce.com/services/Soap/u/25.0';

//creating soap action to send request by http callout for getting connected to other org    
public static string getLoginSoapAction(){
    return '<se:Header xmlns:sfns=\'partner.soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>';
}

//creating soap body to send request by http callout for getting connected to other org  
public static string getLoginSoapBody(string username, string password, string securitytoken){
    return '<se:Envelope xmlns:sfdc=\'urn:enterprise.soap.sforce.com\' xmlns:se=\'http://schemas.xmlsoap.org/soap/envelope/\'><se:Body><login xmlns=\'urn:partner.soap.sforce.com\' xmlns:ns1=\'sobject.partner.soap.sforce.com\'><username>'+username+'</username><password>'+password+securitytoken+'</password></login></se:Body></se:Envelope>';
}   
}