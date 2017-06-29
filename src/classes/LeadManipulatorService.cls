@RestResource(urlMapping='/Lead/*')
global with sharing class LeadManipulatorService 
{

	global class BindVar
	{
   		global Boolean isSuccess;
   		global String lead;
   		global String Status;
	}

	@HttpPost
	global static BindVar doPost() 
	{ 
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		Lead objlead = new Lead();

 		String firstname= req.params.get('firstname');
  		String lastname= req.params.get('lastname');
   		String phone= req.params.get('phone');
    	String email= req.params.get('email');
    	String company= req.params.get('company');
    	String status= req.params.get('status');
		objlead.FirstName = firstname;
		objlead.LastName = lastname;
		objlead.Phone= phone; 
		objlead.Email=email;
		objlead.Company=company;   //'ESPL';
		objlead.Status=status;     //'Closed - Converted';		
		BindVar objBnd=new BindVar();		
		try{
			insert objlead;
	    	objBnd.isSuccess=true;
			objBnd.lead=objlead.id;
			objBnd.Status='Success';
			return objBnd;
		}catch(Exception e)
		{
    		objBnd.isSuccess=false;
    		objBnd.lead=' ';
    		objBnd.Status='Fail';   		
    		return objBnd;
		}
	}

	@HttpPut
	global static BindVar doUpdate() 
	{
   		RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //  Lead leadObj = new Lead();
        String firstname= req.params.get('firstname');
 	    String lastname= req.params.get('lastname');
   		String phone= req.params.get('phone');
    	String email= req.params.get('email');
        System.debug('%%%%%%%%%%%'+firstname+lastname+email+phone);
        
        List<Lead> lstLead= [SELECT Email,Phone from Lead WHERE FirstName=:firstname and LastName=:lastname];
        
        BindVar objBnd=new BindVar();
        
        if(lstLead.size()!=0)
        {
        	lstLead.get(0).Email=email;
        	lstLead.get(0).Phone=phone;
        	update lstLead;
			if(lstLead.get(0).Email==email && lstLead.get(0).Phone==phone)
        	{
            	objBnd.isSuccess=true;
            	objBnd.lead=lstLead.get(0).id;
            	objBnd.Status='Success';
        	}
        }
        else
        {
            objBnd.isSuccess=false;
            objBnd.lead=' ';
            objBnd.Status='Fail';
        }       
        return objBnd;                 
	}



	@HttpDelete
	global static BindVar doDelete() 
	{
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

 		String firstname= req.params.get('firstname');
  		String lastname= req.params.get('lastname');
   		String phone= req.params.get('phone');
    	String email= req.params.get('email');
    	System.debug('paramsparamsparamsparamsparams!!'+firstname+lastname+phone+email);
		List<Lead> lstLeadtoDelete= [SELECT Id FROM Lead WHERE FirstName = :firstname and LastName= :lastname and Phone=:phone and Email=:email];
		

		//List<Lead> lstLead=[SELECT Id FROM Lead WHERE FirstName = :firstname and LastName= :lastname and Phone=:phone and Email=:email];


		System.debug('%%%%%%%%%%leadid'+lstLeadtoDelete);
		BindVar objBnd=new BindVar();

		if(lstLeadtoDelete.size()!=0) 
		{
			delete lstLeadtoDelete;
    		objBnd.isSuccess=true;
    		objBnd.lead=firstname+lastname;
    		objBnd.Status='Success';
		}
		else
		{
    		objBnd.isSuccess=false;
    		objBnd.lead=' ';
    		objBnd.Status='Fail';
		}
		return objBnd;
	}

}