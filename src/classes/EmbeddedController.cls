public without sharing class EmbeddedController
{
 public ApexPages.StandardController stdCtrl {get; set;}
 public String chosenCountry {get; set;}
 public Boolean refreshPage {get; set;}
  
 public EmbeddedController(ApexPages.standardController std)
 {
  stdCtrl=std;
  refreshPage=false;
 }
  
 public PageReference save()
 {
  Account acc=(Account) stdCtrl.getRecord();
  acc.BillingCountry=chosenCountry;
  refreshPage=true;
  stdCtrl.save();
   
                return null;
 }

}