public class QuoteExtension 
{
	Id quoteId;
    /* The standard controller object which will be used later for navigation and to invoke
       it's save action method to create the new Quote. */
    ApexPages.StandardController controller;
    
    /* The quote property which is used by the quoteNew and quotePDF Pages and this controller
       to provide access to the relevant quote information. */
    //public Quote q {get;set;}
    public List<QuoteLineItem> lstQtLineItem{get;set;}
    
    /* The constructor to this extension class which takes the standard controller as its argument
       which allows this class to access the methods and information available in the instance for 
       the quote.*/
    public QuoteExtension(ApexPages.StandardController c) 
    {	
    
        controller = c;
        
       	quoteId =controller.getRecord().Id;
       	
        
        lstQtLineItem=[Select q.Id, q.QuoteId, q.PricebookEntryId, PriceBookEntry.Product2.Name, q.TotalPrice, q.UnitPrice, q.Subtotal, q.Quantity, q.ListPrice, q.Discount From QuoteLineItem q  where QuoteId=:quoteId];
        
        /*
        Map<Id,Id> mapQtLineItem=new Map<Id,Id>();
        set<Id> setPriceBookEntry = new set<Id>();
        
        for(QuoteLineItem objQtLineItem:lstQtLineItem)
        {
        	mapQtLineItem.put(objQtLineItem.Id,objQtLineItem.PricebookEntryId);
        	setPriceBookEntry.add(objQtLineItem.PricebookEntryId);
        }
        
       List<PricebookEntry> lstPricebookEntry = [Select Product2Id, Id From PricebookEntry where Id IN : setPriceBookEntry];
        
       set<Id> setProduct2=new Set<Id>();
       
       for(PriceBookEntry objPriceBookEntry:lstPriceBookEntry)
       {
       		setProduct2.add(objPriceBookEntry.Product2Id);
       }
       
       List<Product2> lstProduct2=[select Name,ProductCode from Product2 where Id IN: setProduct2];
       
       
        
        
        system.debug('%%%%%%%%%%%%%%%%%%%%>lstQtLineItem:'+lstQtLineItem);
         
         system.debug('%%%%%%%%%%%%%%%%>quoteId'+quoteId);
         
          system.debug('%%%%%%%%%%%%%%%%%%%%>lstQtLineItem:'+lstPricebookEntry);
           system.debug('%%%%%%%%%%%%%%%%%%%%>lstQtLineItem:'+lstProduct2);
       */
    
    }
    
    

}