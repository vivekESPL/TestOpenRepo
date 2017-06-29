public with sharing class WrapperDemo {
    public List<List<Wrapper>> lstWrapper {get; set;}
    
    public WrapperDemo() {
        initializeWrapper();
    }

    public void initializeWrapper() {
        lstWrapper = new List<List<Wrapper>>();
        Integer intColSize = 4;
        
        List<Wrapper> lstMainWrapper = new List<Wrapper>();
        lstMainWrapper.add(new Wrapper('Account', 'Account', true));
        lstMainWrapper.add(new Wrapper('Contact', 'Contact', true));
        lstMainWrapper.add(new Wrapper('Opportunity', 'Opportunity', true));
        lstMainWrapper.add(new Wrapper('Case', 'Case', true));
        lstMainWrapper.add(new Wrapper('PriceBook2', 'PriceBook', true));
        lstMainWrapper.add(new Wrapper('Quote', 'Quote', true));
        lstMainWrapper.add(new Wrapper('Task', 'Task', true));
        lstMainWrapper.add(new Wrapper('Lead', 'Lead', true));
        lstMainWrapper.add(new Wrapper('Campaign', 'Campaign', true));
        
        Integer intCounter = 0;
        List<Wrapper> lstInnerWrapper = new List<Wrapper>();
        
        for(Wrapper objW: lstMainWrapper) {
            if(intCounter < intColSize) {
                lstInnerWrapper.add(objW);
                intCounter++;
            }
            
            if(intCounter == intColSize) {
                intCounter = 0;
                lstWrapper.add(lstInnerWrapper);
                lstInnerWrapper = new List<Wrapper>();
            }
        }
    }

    public class Wrapper {
        public String strObjectName {get; set;}
        public String strObjectLabel {get; set;}
        public Boolean blnCheck {get; set;}
        
        public Wrapper(String pObjectName, String pObjectLabel, Boolean pCheck) {
            strObjectName = pObjectName;
            strObjectLabel = pObjectLabel;
            blnCheck = pCheck;
        }
    }
}