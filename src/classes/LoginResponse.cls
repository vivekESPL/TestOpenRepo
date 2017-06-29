public with sharing class LoginResponse {
   public boolean isError {get;set;}     //to set true if error is there
   public string message {get;set;}      //http response message
   public string result {get;set;}       //http repponse result
   public string status {get;set;}       //http callout status as response, ok=success
   public integer statusCode {get;set;}  //http callout statucode as reponse, 200=success
   public string sessionId {get;set;}    //session Id of remotely connected org 
   public string serverUrl {get;set;}    //Server Url of remotely connected org
   public string userName {get;set;}     //username by which connected to remote org 
   public string orgId {get;set;}        // salesforce org Id to which got connected
   public string orgName{get;set;}         // remote org name to which got connected
   public string orgUserName{get;set;}    // remote org username
    
   public LoginResponse(){
      isError = false;
      message = '';
      result = '';
      status = '';
      sessionId = '';
      serverUrl = '';
      statuscode = 0;
      userName = '';
      orgId = '';
      orgName = '';
      orgUserName ='';
   }
}