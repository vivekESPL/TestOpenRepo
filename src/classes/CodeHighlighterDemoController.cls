public class CodeHighlighterDemoController {
    public String apexCode {get; set;}
    public String vfCode {get; set;}
    
    private static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() 
    + '/services/data/v36.0/tooling/';
    
    private static final String JSONBodyKey = 'Body';

    public CodeHighlighterDemoController() {
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(baseUrl + 'query/?q=select+Id,Name,Body+from+ApexClass+Where+Name=\'CodeHighlighterDemoController\'');
        req.setMethod('GET');
        // OAuth header
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');

        Http h = new Http();
        HttpResponse res = h.send(req);
        if(res.getStatus().equalsIgnoreCase('ok')) {
            //apexCode = res.getBody();
            JSONParser jsonParser = JSON.createParser(res.getBody());
            while(jsonParser.nextToken() != null) {
                if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) &&(jsonParser.getText() == JSONBodyKey)){
                    jsonParser.nextToken();
                    apexCode = jsonParser.getText();
                }
            }

        }
        /*apexCode = 'public Class Test {' +
                   '    public void testMethod() {' +
                   '        public List<String> lstStr = new List<String>()' +
                   '    }' +
                   '}';*/
                 
        vfCode = '';
    }
}