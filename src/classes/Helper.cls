public with sharing class Helper {

     //Simple insert
    public static List<SObject> insertRecordsNoCatch(List<SObject> records) {
    	insert records;
    	return records;
    }
    
    //Simple insert with try-catch
    public static List<SObject> insertRecordsWithCatch(List<SObject> records) {
    	try {
    	   insert records;
    	} catch(DmlException e) {
    	   System.debug('****Exception: ' + e);
    	   for(Integer i=0; i<e.getNumDml(); i++) {
                System.debug('****Failed Element Id: ' + e.getDmlId(i));
                System.debug('****Position of failed record in original list: ' + e.getDmlIndex(i));
	            Integer failedRecordIndex = e.getDmlIndex(i); //Position of failed record in original list
                addErrorMessage(records[failedRecordIndex], e.getDmlMessage(i));
    	   }
    	}
    	return records;
    }
    
    //Database insert
    public static List<Database.Saveresult> databaseInsertRecords(List<SObject> records) {
    	List<Database.Saveresult> results = Database.insert(records, false);
    	processDml(records, results);
    	return results;
    }
    
    //Simple update with try-catch
    public static List<SObject> updateRecordsNoCatch(List<SObject> records) { 
    	update records;
    	return records;
    }
    
    //Simple update with try-catch
    public static List<SObject> updateRecordsWithCatch(List<SObject> records) {	
     	try {
     	  update records;
     	} catch(DmlException e) {
     		System.debug('****Exception: ' + e);
     		for(Integer i=0; i<e.getNumDml(); i++) {
                   System.debug('****Failed Element Id: ' + e.getDmlId(i));
                   System.debug('****Position of failed record in original list: ' + e.getDmlIndex(i));
                   Integer failedRecordIndex = e.getDmlIndex(i); //Position of failed record in original list
                   addErrorMessage(records[failedRecordIndex], e.getDmlMessage(i));
     		}
     	}
     	return records;
     }
     
    //Database update
    public static List<Database.Saveresult> databaseUpdateRecords(List<SObject> records) {
        List<Database.Saveresult> results = Database.update(records, false);
        processDml(records, results);
        return results;
    }
    
    //Adds the error message, if any, to the corresponding record
    private static void processDml(List<SObject> records, List<Database.Saveresult> results) {
    	for(Integer i=0; i<results.size(); i++) {
            if(!results[i].isSuccess()) {
                //Adding error message to the record
                addErrorMessage(records[i], results[i].getErrors()[0].getMessage());
                //Here it's we could do some error processing, such as saving it to the database, sending email...
            }
        }
    }
    
    private static void addErrorMessage(SObject record, String defaultMessage) {
        String message = '';
        if(record.getSObjectType().getDescribe().getName() != null)
            message = 'Error on record of type ' + record.getSObjectType().getDescribe().getName() + ' - ';
        if(record.get('Id') != null)
            message = message + 'Record ID: ' + record.get('Id') + ' - ';
        if(record.get('Name') != null)
            message = message + 'Record Name: ' + record.get('Name') + ' - ';
        message = message + '"' + defaultMessage + '"';
        record.addError(message);
    }
}