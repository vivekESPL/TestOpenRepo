@RestResource(urlMapping='/AccountService/*')
global with sharing Class AccountService
{
    global Class AccountDetails
    {
        global List<Account> lstAccount;
        global String message;
    }
    
    //Method which is used for creating an account when a HTTP POST request is made
    @HttpPost
    global static String createAccount(String accountName) //RestRequest req
    {
        Account objAccount = new Account();
        objAccount.Name = accountName;
        insert objAccount;
        
        return objAccount.Id;
    }
    
    //Method which is used to fetch an account details when a HTTP GET request is made
    @HttpGet
    global static AccountDetails getAccountDetails()
    {
        String accountName = RestContext.request.params.get('accountName');
        List<Account> lstAccount = [Select Id, Name From Account Where Name Like :('%'+ accountName +'%')];
        
        AccountDetails objAccountDetails = new AccountDetails();
        if(lstAccount != null && !lstAccount.isEmpty())
        {
            objAccountDetails.lstAccount = lstAccount;
            objAccountDetails.message = 'There are ' + lstAccount.size() + ' accounts found.';
        }
        else
        {
            objAccountDetails.lstAccount = lstAccount;
            objAccountDetails.message = 'There are no accounts for the requested account name.';
        }
        return objAccountDetails;
    }
}