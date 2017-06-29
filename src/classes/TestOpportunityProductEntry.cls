/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @isTest(seeAllData=true)
private class TestOpportunityProductEntry 
{
    static testMethod void opportunityProductEntryTest()
    {
    	Test.startTest();
     	Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
      	Pricebook2 objPriceBk=new Pricebook2( Name='Standard',IsActive=true);
        insert objPriceBk;
        Product2 objProd=new Product2(Name='TestProduct');
        insert objProd;
      
      	PricebookEntry objPrBkEntry=new PricebookEntry(UnitPrice=50, Product2Id=objProd.Id, Pricebook2Id=standardPB.Id,IsActive=true);
    	insert objPrBkEntry;
       
     	Opportunity objOpp=new Opportunity(Name='Vivek',StageName='Qualification',Type='Existing Customer - Upgrade',CloseDate=Date.ValueOf('2012-09-26'));
           
        insert objOpp;
        Id id=objOpp.Id;
        system.debug('%%%%%%%%%%%%%%%%%%%%%%Value:'+id);
                   
    	OpportunityLineItem objChild=new OpportunityLineItem (Quantity=2,UnitPrice=350,OpportunityId=id,PricebookEntryId=objPrBkEntry.Id); 
 		insert objChild;
    
   		system.debug('%%%%%%%%%%%%%%%%%PbkEntry'+objChild.PricebookEntryId);
             
        PageReference pageref=page.OpportunityProductEntry;
     	pageref.getParameters().put('Id',objOpp.Id);
     	test.setCurrentPageReference(pageref);
     
     	ApexPages.StandardController sc = new ApexPages.standardController(objOpp);
   		OpportunityProductEntryExtension  extOppProdEntry=new OpportunityProductEntryExtension(sc);
     
     	Integer counter=(extOppProdEntry.shoppingCart.size());
     
       	extOppProdEntry.searchString = 'Blank';
        extOppProdEntry.updateAvailableList();
        system.assert(extOppProdEntry.AvailableProducts.size()==0);
        
        extOppProdEntry.toUnselect = objChild.PricebookEntryId;
        extOppProdEntry.removeFromShoppingCart();
        system.assert(extOppProdEntry.shoppingCart.size()==counter-1);
        
        extOppProdEntry.onSave();
        extOppProdEntry = new OpportunityProductEntryExtension(new ApexPages.StandardController(objOpp));
        system.assert(extOppProdEntry.shoppingCart.size()==counter-1);
        
        for(OpportunityLineItem o : extOppProdEntry.ShoppingCart)
        {
            o.quantity = 5;
            o.unitprice = 300;
        }
        extOppProdEntry.onSave(); 
        
        
        extOppProdEntry.toSelect = extOppProdEntry.AvailableProducts[0].Id; 
        extOppProdEntry.addToShoppingCart();
        system.assert(extOppProdEntry.shoppingCart.size()==counter);
        
        extOppProdEntry.searchString = objChild.PricebookEntry.Name;  
        extOppProdEntry.updateAvailableList();
        system.assert(extOppProdEntry.AvailableProducts.size()>0);    
        
        extOppProdEntry.onCancel();   
         
         extOppProdEntry.priceBookCheck();
         extOppProdEntry.changePricebook();   
         
         Test.stopTest();
         
       }
}