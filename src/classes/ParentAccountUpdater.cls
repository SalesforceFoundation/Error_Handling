public with sharing class ParentAccountUpdater {

    private static Boolean parentAccsAlreadyUpdated = false;
    public static Boolean useReentrancyFlag = false;
    
    public static void processContacts(List<Contact> contacts) {
       
        if(!parentAccsAlreadyUpdated) {
	        List<SObject> objectsToInsert = new List<SObject>(); 	
	        List<SObject> objectsToUpdate = new List<SObject>();
	        
	    	try {	
		    	for(Contact c : contacts) {
		    		//This is when an exception gets thrown if the parent account has been deleted
		    		c.Account.Name = 'New Acc Name';
		    		objectsToUpdate.add(c.Account);
		    	}
	    	} catch(Exception e) {
	    		System.debug(LoggingLevel.WARN, '****Exception thrown: ' + e.getMessage());
	    		Error__c error = new Error__c();
		        error.Datetime__c = System.now();        
		        error.Error_Type__c = e.getTypeName();
		        error.Full_Message__c = e.getMessage();
		        error.Stack_Trace__c = e.getStackTraceString();
		        objectsToInsert.add(error);
	    	}
	    	
	    	Database.insert(objectsToInsert, false);
	    	Database.update(objectsToUpdate, false);
	    	
	    	if(useReentrancyFlag) 
	    	  parentAccsAlreadyUpdated = true;
        }
    }
}