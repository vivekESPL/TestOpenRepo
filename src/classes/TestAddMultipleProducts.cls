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
@isTest (seeAllData=true)
private class TestAddMultipleProducts 
{
	
	static ExtensionAddMultipleProducts addProdExt;
  	static Product2 objProd;
  	static PageReference pageRef;
  	static Pricebook2 objPricebk2;
	
	static private void init()
	{
		pageRef = Page.AddMultipleProducts;
    	Test.setCurrentPageReference(pageRef);
    	
    	objProd=new Product2(Name='TestProduct');
    	insert objProd;
    	
    	objPricebk2=new Pricebook2(Name='TestPB', IsActive=true);
    	insert objPricebk2;
    	
    	ApexPages.StandardController con = new ApexPages.StandardController(objProd);
    	
    	addProdExt=new ExtensionAddMultipleProducts(con);		
	}

    static testMethod void addMultipleProductsTest() 
    {    
    	init();
    	Test.startTest();	
    	//List<ExtensionAddMultipleProducts.Product2Wrapper> lstProdWrap=addProdExt.Wrappers; 
    	   
    	ExtensionAddMultipleProducts.addCount=10; 	
    	addProdExt.addRows();
    	   	
    	for(Integer i=0;i<ExtensionAddMultipleProducts.addCount;i++)
    	{
    	ExtensionAddMultipleProducts.Product2Wrapper objProdWrap=new ExtensionAddMultipleProducts.Product2Wrapper(i);
    	
    	objProdWrap.prod.Name='TestProduct'+i;
    	objProdWrap.prod.ProductCode='TP000'+i;
    	objProdWrap.prod.Family='Entertainment';
    	objProdWrap.prod.Description='Test Product';
    	objProdWrap.pricebk.UnitPrice=120.00;
    	
    	addProdExt.wrappers.add(objProdWrap); 
    	}
    	    	
    	//system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%PBENTRY:'+objProd)
    	system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@wrappers:'+addProdExt.wrappers);
    	
    	pageRef=addProdExt.save();
    	
     	Test.stopTest();
     	
     	Product2 objProd2=[select Id,Name from Product2 where Name='TestProduct5'];
     	system.assertEquals(1,[select count() from PricebookEntry where Product2Id=:objProd2.Id]);
    }
    
    static testMethod void addSingleProductTest() 
    {    
    	init();
    	Test.startTest();	
    	//List<ExtensionAddMultipleProducts.Product2Wrapper> lstProdWrap=addProdExt.Wrappers; 
    	
    	ExtensionAddMultipleProducts.Product2Wrapper objProdWrap=new ExtensionAddMultipleProducts.Product2Wrapper(0);
    	
    	objProdWrap.prod.Name='TestProduct1';
    	objProdWrap.prod.ProductCode='TP0001';
    	objProdWrap.prod.Family='Entertainment';
    	objProdWrap.prod.Description='Test Product';
    	objProdWrap.pricebk.UnitPrice=120.00;
    	
    	addProdExt.wrappers.add(objProdWrap); 
    	
    	
    	//system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%PBENTRY:'+objProd)
    	system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@wrappers:'+addProdExt.wrappers);
    	
    	
    	pageRef=addProdExt.save();
    	
    	
     	Test.stopTest();
     	
     	Product2 objProd2=[select Id,Name from Product2 where Name='TestProduct1'];
     	system.assertEquals(1,[select count() from PricebookEntry where Product2Id=:objProd2.Id]);
     	
     	
    }
    
    static testMethod void deleteRowsTest() 
    {    
    	init();
    	Test.startTest();	
    	//List<ExtensionAddMultipleProducts.Product2Wrapper> lstProdWrap=addProdExt.Wrappers; 
    	
    	ExtensionAddMultipleProducts.Product2Wrapper objProdWrap=new ExtensionAddMultipleProducts.Product2Wrapper(0);
    	
    	objProdWrap.prod.Name='TestProduct1';
    	objProdWrap.prod.ProductCode='TP0001';
    	objProdWrap.prod.Family='Entertainment';
    	objProdWrap.prod.Description='Test Product';
    	objProdWrap.pricebk.UnitPrice=120.00;
    	
    	addProdExt.wrappers.add(objProdWrap); 
    	
    	
    	//system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%PBENTRY:'+objProd)
    	system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@wrappersDel:'+addProdExt.wrappers);
    	
    	
    	
  		ExtensionAddMultipleProducts.toDelIdent=0; 	
    	addProdExt.delWrapper();
    	
    	
     	Test.stopTest();
     	
     	system.assertEquals(1,addProdExt.wrappers.size());
    }
}