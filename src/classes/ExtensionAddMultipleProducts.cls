public with sharing class ExtensionAddMultipleProducts 
{
    /*public List<Product2> prods {get; set;}
    //private final Lit_Order__c parOrd;
    public ExtensionAddMultipleProducts(ApexPages.StandardController myController) 
    {
        //parOrd=(Lit_Order__c)myController.getrecord();
        prods = new List<Product2>();
        Product2 objProd = new Product2();
        //LitOrd.Lit_Order__c = parOrd.id;
        prods.add(objProd);
    }

    public void addrow() 
    {
        List<Product2> prods = new List<Product2>();
        Product2 objProd = new Product2();
        //LitOrd.Lit_Order__c = parOrd.id;
        prods.add(objProd);
    }
            
    public void removerow()
    {
        Integer i = prods.size();
        prods.remove(i-1);
    }
            
    public PageReference save() 
    {
        insert prods;
        PageReference home = new PageReference('/home/home.jsp');
        //return new PageReference('/' + Schema.getGlobalDescribe().get('Product2').getDescribe().getKeyPrefix() + '/o');
        home.setRedirect(true);
        return home; 
    }*/
    
    public List<Product2Wrapper> wrappers {get; set;}
    public List<PricebookEntry>lstPrice  = new List<PricebookEntry>();
    public static Integer toDelIdent {get; set;}
    public static Integer addCount {get; set;}
    private Integer nextIdent=0;
    public String stdPriceBookId;
  
    public ExtensionAddMultipleProducts(ApexPages.StandardController con)
    {
        wrappers=new List<Product2Wrapper>();
        Id pId=[select Id from Pricebook2 where isStandard=true limit 1].Id;
        stdPriceBookId =pId; 
        for (Integer idx=0; idx<1; idx++)
        {
        wrappers.add(new Product2Wrapper(nextIdent++));
        }
    }
  
    public void delWrapper()
    {
        if(wrappers.size()>1)
        {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrappers.size(); idx++)
        {
            if (wrappers[idx].ident==toDelIdent)
            {
            toDelPos=idx;
            }
        }
        system.debug('%%%%%%%%%%%%%%%ToDelPos:'+toDelPos);
        if (-1!=toDelPos)
        {
        wrappers.remove(toDelPos);
        }
        }
    }
  
    public void addRows()
    {
        for (Integer idx=0; idx<addCount; idx++)
        {
        wrappers.add(new Product2Wrapper(nextIdent++));
        }
    }
  
    public PageReference save()
    {
        system.debug('%%%%%%%%%%%%%%%%%%%%%PBKENTID:'+stdPriceBookId);
        List<Product2> lstProd=new List<Product2>();
        for (Product2Wrapper wrap : wrappers)
        {
            if(wrap.prod.name!=null)
            {
            lstProd.add(wrap.prod);
            }
        }
        
        system.debug('%%%%%%%%%%%%%%%%%%%%%lstProd:'+lstProd);
   
        insert lstProd;         
        
        Integer i=0;
        for(Product2Wrapper objProd:wrappers)
        {
            if(wrappers[i].pricebk.UnitPrice!=null)
            {
                system.debug('%%%%%%%%%%%%%UnitPrice:'+wrappers[i].pricebk.UnitPrice);
                system.debug('%%%%%%%%%%%%%UnitPrice:'+objProd.pricebk.UnitPrice);
            wrappers[i].pricebk.Pricebook2Id=stdPriceBookId;
            wrappers[i].pricebk.Product2Id=objProd.prod.Id;
            wrappers[i].pricebk.IsActive=true;
            lstPrice.add(wrappers[i].pricebk);          
            }
            i++;
        }
        system.debug('%%%%%%%%%%%%%%%%%%%%%lstPrice:'+lstPrice);
        insert lstPrice;    
        
        
   
        return new PageReference('/' + Schema.getGlobalDescribe().get('Product2').getDescribe().getKeyPrefix() + '/o');
    }
  
    public class Product2Wrapper
    {
        public Product2 prod {get; set;}
        public Integer ident {get; set;}
        public PricebookEntry pricebk{get;set;}  
   
        public Product2Wrapper(Integer inIdent)
        {
        ident=inIdent;
        prod=new Product2();
        pricebk=new PricebookEntry();
        }
    }

}