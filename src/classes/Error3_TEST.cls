@isTest
public with sharing class Error3_TEST {

    //What result the calling method gets if there is an error in an update
    public testmethod static void callFromMethodSimpleUpdateWithCatch() {
        Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson', AccountId = acc1.Id, Title = 'VP');
        insert contact1;
        
        delete acc1;
        contact1.FirstName = 'changed';
        
        Test.startTest();
        List<SObject> results = Helper.updateRecordsWithCatch(new SObject[]{contact1});
        Test.stopTest();
        
        for(SObject result : results) {
           System.debug('****' + result);
        }
    }
    /* Result --> exception is thrown on insert, which halts the test is not caught. 
    If we catch the exception we see that nothing (no error message) is added to the record that we could 
    not insert. 
    
    The debug in the called method prints:
    
        ****Exception: System.DmlException: Update failed. First exception on row 0 with id 003i000000URRDzAAP; 
                        first error: ENTITY_IS_DELETED, entity is deleted: []
        ****Element Id: 003i000000URRawAAH
        ****Row number: 0
    
    We could add an error message manually. Since we are doing an update we can associate the exception with one specific 
    record by Id or by row number.
        
    If we do not manually add an error message to the record, the debug line above prints:
        
        ****Contact:{AccountId=001i000000XTfjrAAD, FirstName=changed, Id=003i000000URRawAAH, LastName=testerson, Title=VP}
     */      
}