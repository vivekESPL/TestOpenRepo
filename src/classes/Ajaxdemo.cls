public with sharing class Ajaxdemo {
	  public List<Account> account {get; set;}

//public Contact con;

  public Ajaxdemo(ApexPages.StandardController stdControl)
	{
		
	}
   public List<Account> getAccounts() {
   	//Contact con=new Contact();
   	account=[Select a.Phone, a.Name,a.Id From Account a limit 5];
  	return account; 
   }

	public  List<account> listName;
	public string accId{get; set;}
 

    
public Team[] getTeamNames() {
    String id=ApexPages.currentPage().getParameters().get('id');
	List<Account> accountContactsLst =[Select (Select Id,Name From Contacts) From Account a where  a.Id=:id LIMIT 50000]; 
	
	system.debug('------accId:'+accId);
	system.debug('--------accountContactsLst:'+accountContactsLst);
	List<Contact> contactObjLst = new List<Contact>();
	
	for(Account curAccountObj: accountContactsLst){
		contactObjLst.addAll(curAccountObj.Contacts);
	}
	
	System.debug('accountContactsLst.size()'+accountContactsLst.size());
	
	//String[] contactStrLst = new String[contactObjLst.size()];
    Team[] contactLst = new  Team[contactObjLst.size()];
	Integer index=0;
	for(Contact contactObj : contactObjLst){
		
		Team teamObj = new Team(contactObj.Name);
		contactLst[index] = teamObj;
		Integer teamNos=5;
		while(teamNos>0){
			teamObj.doctors.add(contactObj.Name +' doctor '+teamNos);
			teamNos--;
		}
		
		index++;	
	}
	
	
	System.debug('accountContactsLst.size()'+accountContactsLst.size());
	return contactLst;
}

public class Team{
		public String teamName{get;set;}
		public String linkName {get;set;}
		public List<String> doctors {get;set;}
		public Team(String pTeamName){
		this.teamName  = pTeamName;
		this.linkName  =  pTeamName.replaceAll(' ','_');
		doctors = new List<String>();
		}
}
 
// public Contact getCon() {
 //   	con=[Select c.Phone, c.Name, c.MobilePhone, c.FirstName, c.Email From Contact c where id='0039000000MqLr2'];
 //  	return con; 
//   }
 

}