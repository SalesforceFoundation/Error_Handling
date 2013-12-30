@isTest
public with sharing class DatabaseUpdate_TEST {

    //What result the calling method gets if there is an error in a Database.update
    public testmethod static void test() {
        Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        insert contact1;
        
        delete acc1;
        contact1.FirstName = 'changed';
        
        Test.startTest();
        List<Database.Saveresult> results = Helper.databaseUpdateRecords(new SObject[]{contact1});
        Test.stopTest();
        
        for(Database.Saveresult result : results) {
           System.debug('****' + result);
           //The following debug lines are actually unnecessary, since everything is contained in the result object itself
           System.debug('****Record Id: ' + result.getId());
           List<Database.Error> errors = result.getErrors();
           for(Database.Error error : errors) {
                System.debug('    ****Error Message: ' + error.getMessage());
           }
        }
    }
    /* In this case an exception is not thrown, therefore there is no need for a try-catch block, and the test does not
    halt.
    
    We can add the error we get from the Database.SaveResult to the SObject manually. See processDml method in Helper.cls.
    
    
    The debug lines above print:
    
        ****Database.SaveResult[getErrors=(Database.Error[getFields=();getMessage=entity is deleted;
                                getStatusCode=ENTITY_IS_DELETED;]);getId=null;isSuccess=false;]
        ****Record Id: null
        ****Error Message: entity is deleted
        
    @Question:Why in this case there is no element ID? We already had it, we are just trying to update. We can find the 
    Id when using the simple update (through the exception). Why not here? 
    
    @Answer: From the docs (http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_Database_SaveResult_getId.htm):
        
        "getId() - If this field contains a value, the object was successfully inserted or updated. If this field is empty, 
        the operation was not successful for that object."
        
    If we want to associate the error message with the record that caused it we can do what the method processDml in
    Helper.cls is doing.
    */
}