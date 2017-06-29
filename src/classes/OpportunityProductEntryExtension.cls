public with sharing class OpportunityProductEntryExtension {

    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    public Boolean isSaveButtonDisabled {get;set;}
    
    public Boolean overLimit {get;set;}
    //public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};


    public OpportunityProductEntryExtension(ApexPages.StandardController controller) 
    {

        /*multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else*/
            theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
        
        shoppingCart = [select Id, Quantity, TotalPrice, UnitPrice, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id from opportunityLineItem where OpportunityId=:theOpp.Id];

		if(shoppingCart.size()==0)
		{
			isSaveButtonDisabled = true;
		}
		else
		{
			isSaveButtonDisabled = false;
		}
		
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
    public PageReference priceBookCheck(){
    
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
            if(theOpp.pricebook2Id != theBook.Id){
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }
       
    /*public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }*/

    public void updateAvailableList() {
    	
    	if(shoppingCart.size()==0)
		{
			isSaveButtonDisabled = true;
		}
		else
		{
			isSaveButtonDisabled = false;
		}
    
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        /*if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';*/
        
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 101';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
    
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

    public PageReference removeFromShoppingCart(){
    
        Integer count = 0;
    
        for(opportunityLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }
    
    public PageReference onSave(){
    
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        try{
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
    
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference changePricebook(){
    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
        
        return ref;
    }
}