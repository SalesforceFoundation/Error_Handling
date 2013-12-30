@isTest
public with sharing class DatabaseInsert_TEST {
    
    //What result the calling method gets if there is an error in a Database.insert
    public testmethod static void test() {
        Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        delete acc1;
        
        Test.startTest();
        List<Database.Saveresult> results = Helper.databaseInsertRecords(new SObject[]{contact1});
        Test.stopTest();
        
        for(Database.SaveResult result : results) {
           System.debug('****' + result);
           //The following debug lines are actually unnecessary, since everything is contained in the result object itself
           System.debug('****Record Id: ' + result.getId());
           List<Database.Error> errors = result.getErrors();
           for(Database.Error error : errors) {
                System.debug('    *****Error Message: ' + error.getMessage());
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
        *****Error Message: entity is deleted
    */
}