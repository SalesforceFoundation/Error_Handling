public with sharing class Controller {

    public String message { public get; set; }
    
    /*** Insert Actions ***/
    public PageReference simpleInsertNoCatch() {
    	Contact contact1 = failingInsertHelper();
        message = '';
        List<SObject> results = Helper.insertRecordsNoCatch(new SObject[]{contact1});
        for(SObject result : results) {
           message =  message + result;
        }
    	return null;
    }
    
    public PageReference simpleInsertWithCatch() {
        Contact contact1 = failingInsertHelper();
        message = '';
        List<SObject> results = Helper.insertRecordsWithCatch(new SObject[]{contact1});
        for(SObject result : results) {
           message =  message + result;
        }
        return null;
    }
    
    public PageReference databaseInsert() {
        Contact contact1 = failingInsertHelper();
        message = '';
        List<Database.Saveresult> results = Helper.databaseInsertRecords(new SObject[]{contact1}); 
        for(Database.Saveresult result : results) {
           message = message + result;
        }   
        return null;
    }
    
    /*** Update Actions ***/
    public PageReference simpleUpdateNoCatch() {
        Contact contact1 = failingUpdateHelper();
        message = '';
        List<SObject> results = Helper.updateRecordsNoCatch(new SObject[]{contact1});
        for(SObject result : results) {
           message =  message + result;
        }
        return null;
    }
    
    public PageReference simpleUpdateWithCatch() {
        Contact contact1 = failingUpdateHelper();
        message = '';
        List<SObject> results = Helper.updateRecordsWithCatch(new SObject[]{contact1});
        for(SObject result : results) {
           message =  message + result;
        }
        return null;
    }
    
    public PageReference databaseUpdate() {
        Contact contact1 = failingUpdateHelper();
        message = '';
        List<Database.Saveresult> results = Helper.databaseUpdateRecords(new SObject[]{contact1}); 
        for(Database.Saveresult result : results) {
           message = message + result;
        }   
        return null;
    }
    
    /*** Helper methods ***/
    public Contact failingInsertHelper() {
    	Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        delete acc1;
        return contact1;
    }
    
    public Contact failingUpdateHelper() {
    	Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        insert contact1;
        
        delete acc1;
        contact1.FirstName = 'changed';
        return contact1;
    }
}