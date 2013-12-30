@isTest
public with sharing class SimpleInsertWithCatch_TEST {

    //What result the calling method gets if there is an error in an insert
    public testmethod static void test() {
        Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        delete acc1;
        
        Test.startTest();
        List<SObject> results = Helper.insertRecordsWithCatch(new SObject[]{contact1});
        Test.stopTest();
        
        for(SObject result : results) {
           System.debug('****' + result);
        }
    }
    /* Result --> exception is thrown on insert, which halts the test is not caught. 
    If we catch the exception we see that nothing (no error message) is added to the record that we could 
    not insert. 

    The debug in the called method prints:
    
        ****Exception: System.DmlException: Insert failed. First exception on row 0; first error: ENTITY_IS_DELETED, 
                        entity is deleted: []
        ****Element Id: null
        ****Row number: 0
    
    We could add an error message manually, but if we are operating in more than one record the only way to associate 
    the exception with one specific record is by row number. (Which we get with 'getDmlIndex' - See method.)
    
    If we do not manually add an error message to the record, the debug line above prints:
        
        ****Contact:{AccountId=001i000000XTfWXAA1, FirstName=test, LastName=testerson, Title=VP}
           
    */
}