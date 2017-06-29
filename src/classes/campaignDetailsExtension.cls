public class campaignDetailsExtension {
 public Campaign page;
 
	
public campaignDetailsExtension(ApexPages.StandardSetController Scontroller)
{
	//this.page=(Campaign)Scontroller.getRecord();
	this.page=[select createdbyid,NumberSent,Description,StartDate,EndDate,Id,Name, Status, Type from Campaign where Id=: ApexPages.currentPage().getParameters().get('id')];
/*
for(Campaign objCamp: [select ParentId,NumberSent,OwnerID,CreatedbyId,Description,StartDate,EndDate,Id, Name, Status, Type from Campaign where Id=: ApexPages.currentPage().getParameters().get('id')])

{

page.add(objCamp);
} */
}

public String geteditlink()
{
	
String testid= ApexPages.currentPage().getParameters().get('id');

string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+'/e';
return Url;

}


public String getcopylink()
{
	
String testid= ApexPages.currentPage().getParameters().get('id');

string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+'/e?clone=1';
return Url;

}

public Campaign getpage()
{
	return page;

}


}