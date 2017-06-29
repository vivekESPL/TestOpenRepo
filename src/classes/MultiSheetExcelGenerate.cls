/**
description   : Main page which collects data for different sheets
*/

public class MultiSheetExcelGenerate{

	public DataModel dm {get;set;}

	public MultiSheetExcelGenerate(){
  	
      dm = new DataModel();
      dm.data = new list<DataModel.Model>();
   /**Fetching Accout data*/
 
	DataModel.Model model = new DataModel.Model();
    model.sheetname = 'Account';
    model.headers = new list<string>{'Id','Name','Phone','BillingCountry'};
    model.data = new list<map<string,string>>();
    for(Account act: [SELECT Id, Name, Phone, BillingCountry from Account Where BillingCountry != null and Phone != null]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',act.Id);
    rowdata.put('Name',act.Name);
    rowdata.put('Phone',act.Phone);
    rowdata.put('BillingCountry',act.BillingCountry);
    model.data.add(rowdata); 
    }
        
    dm.data.add(model);
    
    /*
    model = new DataModel.Model();
    model.sheetname = 'Contact';
    model.headers = new list<string>{'Id','Name','Phone','Email'};
    model.data = new list<map<string,string>>();
    for(Contact cnt: [SELECT Id, Name, Phone, Email from Contact Where Email != null and Phone != null]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',cnt.Id);
    rowdata.put('Name',cnt.Name);
    rowdata.put('Phone',cnt.Phone);
    rowdata.put('Email',cnt.Email);
    model.data.add(rowdata);
     }
        dm.data.add(model);
   
    model = new DataModel.Model();
    model.sheetname = 'Lead';
    model.headers = new list<string>{'Id','Name','LastName','Status','Email','Company'};
    model.data = new list<map<string,string>>();
    for(Lead lead: [Select Id,Status,Name,LastName,Email,Company From Lead]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',lead.Id);
    rowdata.put('Name',lead.Name);
    rowdata.put('LastName',lead.LastName);
    rowdata.put('Status',lead.Status);
    rowdata.put('Email',lead.Email);
    rowdata.put('Company',lead.Company );
    model.data.add(rowdata);
     }
        dm.data.add(model);
        
    model = new DataModel.Model();
    model.sheetname = 'Case';
    model.headers = new list<string>{'Id','Status','Origin'};
    model.data = new list<map<string,string>>();
    for(Case cse: [Select Id, Status,Origin From Case]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',cse.Id);
    rowdata.put('Status',cse.Status);
    rowdata.put('Origin',cse.Origin);
    model.data.add(rowdata);
     }
        dm.data.add(model);
   
    model = new DataModel.Model();
    model.sheetname = 'Campaigns';
    model.headers = new list<string>{'Id','Name','LastName','Status','Email','Company'};
    model.data = new list<map<string,string>>();
    for(Campaign cmp: [Select Type, Status, Id,Name From Campaign c]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',cmp.Id);
    rowdata.put('Name',cmp.Name);
    rowdata.put('Status',cmp.Status);
    rowdata.put('Email',cmp.Type);
    model.data.add(rowdata);
     }
        dm.data.add(model);
        
    model = new DataModel.Model();
    model.sheetname = 'Opportunities';
    model.headers = new list<string>{'Id','Name','StageName','CloseDate'};
    model.data = new list<map<string,string>>();
    for(Opportunity opor: [Select  Name,Id,StageName,CloseDate From Opportunity o]){
    map<string,string> rowdata = new map<string,string>();
    rowdata.put('Id',opor.Id);
    rowdata.put('Name',opor.Name);
    rowdata.put('StageName',opor.StageName);
    rowdata.put('CloseDate',opor.CloseDate.format());
    model.data.add(rowdata);
     }
        dm.data.add(model);
   
   */
   }

}