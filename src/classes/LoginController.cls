public with sharing class LoginController 
{
    public String username{get; set;}
    public String password{get; set;}
    public String environment{get; set;} 
    
    public LoginController()
    {
        username = 'test@test.com';
    }
    
    public PageReference submit()
    {
        system.debug('%%%%%%%%%%%%%%%%%%%%%Username:'+userName);
        system.debug('%%%%%%%%%%%%%%%%%%%%%Password:'+password);
        if(username == '' || password == '')
        {
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Username or password cannot be left blank'));
           return null;
        }
        
        PageReference nxtPage=Page.Schema_Comparator;
        nxtPage.setRedirect(true);
        
        return nxtPage;
    }
        

}