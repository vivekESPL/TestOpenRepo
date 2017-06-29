public with sharing class CampaignController {
 
    public List<Campaign> CampaignRecords
    {
        get
        {
            if(stdcampaign != null)
                return (List<Campaign>)stdcampaign.getRecords();
            else
                return null ;
        }
        set;
    }
    
    public Campaign view {get; set;}
    
    public CampaignController()
    {
        CampaignRecords = new List<Campaign>() ;
        view = new Campaign() ;
    }
    
     public PageReference GetRecords()
    {   
        if(view.Name != null)
        {
        
 
   		if(view.Name=='Recently Modified')
        {
         stdcampaign = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,Name,Status,Type,StartDate from Campaign order by LastModifiedDate desc]));
        }
        else if(view.Name=='All Campaigns')
        {
         stdcampaign = new ApexPages.StandardSetController(Database.getQueryLocator([select Name,Status,Type,Startdate from Campaign order by startdate desc]));
        }
       else if(view.Name=='All Active Campaigns')
        {
           stdcampaign = new ApexPages.StandardSetController(Database.getQueryLocator([select Name,Status,Type,Startdate from Campaign where IsActive = TRUE order by startdate desc]));
        }
        else if(view.Name=='My Active Campaigns')
        {
            stdcampaign = new ApexPages.StandardSetController(Database.getQueryLocator([select Name,Status,Type,Startdate from Campaign where IsActive = TRUE and Owner.Id=:UserInfo.getUserId() order by startdate desc]));
        }
        else if(view.Name=='Inactive Campaigns')
        {
            stdcampaign = new ApexPages.StandardSetController(Database.getQueryLocator([select Name,Status,Type,Startdate from Campaign where IsActive = FALSE order by startdate desc]));
        }
        
        stdcampaign.setPageSize(3);
        
        }
        else
        {
            stdcampaign = null;
        }
        return null ;
    }   
   
   
    public ApexPages.StandardSetController stdcampaign{get; set;}
    
    public Boolean hasNext
    {
        get
        {
            return stdcampaign.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevious
    {
        get
        {
            return stdcampaign.getHasPrevious();
        }
        set;
    }
 
    /*public Integer pageNumber
    {
        get
        {
            return stdcampaign.getPageNumber();
        }
        set;
    }*/

    public void previous()
    {
        stdcampaign.previous();
    }
 
    public void next()
    {
        stdcampaign.next();
    }
    
    
     public void first() {
       stdcampaign.first();
    }
 
    public void last() {
        stdcampaign.last();
    }
    
    

}