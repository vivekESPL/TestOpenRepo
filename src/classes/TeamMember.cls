public class TeamMember {
        public ID id{get; set;}
        public  List<account> listName;
 
 public TeamMember(ApexPages.StandardController control)
 {
  id=ApexPages.currentPage().getParameters().get('id');
  
 // listName =[Select (Select Name From Contacts) From Account a where  a.Id=:id];
  
  //name=[Select (Select Name From Contacts) From Account a where  a.Id='id'];
 }
    
public Team[] getTeamNames() {

        List<Account> accountContactsLst =[Select (Select Id,Name From Contacts) From Account a where  a.Id=:id LIMIT 50000];
        
        
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
                //contactLst[index] = teamObj;
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

 
}