public with sharing class RestResponse {

    public string status {get;set;}
    public integer statusCode {get;set;}
    public string rest_response_body{get;set;}
    
    public RestResponse(){
        status = '';
        statusCode = 0;
        rest_response_body='';
    }
}