public with sharing class PageBlockTableDemoController {
    public List<Account> lstAccount {get; set;}
    public Account objAccount {get; set;}
    
    public PageBlockTableDemoController() {
        populateAccounts();
    }
    
    private void populateAccounts() {
        lstAccount = [Select Id, Name, Phone, Type, Website From Account limit 50];
        objAccount = lstAccount[0];
    }
}