public with sharing class AddMultipleAttachmentsExtension {
	public Attachment objAttachment{get;set;}
	public String accId;
	
	public AddMultipleAttachmentsExtension(ApexPages.StandardController std){
		accId = ApexPages.currentPage().getParameters().get('Id');		
		objAttachment = new Attachment();
	}
	
	public void SaveAttachments(){
		insert(new Attachment(parentid = accId, name = objAttachment.Name, body = objAttachment.Body));
	}

}