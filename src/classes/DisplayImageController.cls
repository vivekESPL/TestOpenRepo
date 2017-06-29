public with sharing class DisplayImageController {
	
	public String imageURL{get;set;}
   
	public DisplayImageController()
	{
	    imageURL='/servlet/servlet.FileDownload?file=';
	    List< Attachment > documentList=[select id from Attachment where
	                                    id='00P900000041RmA'];
	   
	    if(documentList.size()>0)
	    {
	      imageURL=imageURL+documentList[0].id;
	    }
	}

}