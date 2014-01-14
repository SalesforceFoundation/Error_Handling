@isTest
public with sharing class ERR_Handler_TEST {

    //Note: debug levels are set to warning just to be able to only see our debug messages by changing the log levels
   
    /** To demonstrate that in this case the reentrancy flag does not matter, since the trigger will be run only once
        and everything in it will be rolled back. **/
    public testmethod static void oneInvalidContact() {
    	ParentAccountUpdater.useReentrancyFlag = false;
    	
    	//Create account
    	Account acc1 = new Account(Name='test1');
    	insert acc1;
    	
    	//Create contact
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson1', AccountId = acc1.Id, Title = 'VP1');
        
        //Delete the account to get the code to throw an exception
        delete acc1;
        
        Test.startTest();
        Database.SaveResult result = Database.insert(contact1, false);
        Test.stopTest();
        
        System.assertEquals(false, result.isSuccess());
        
        //Verify NO error record was created - the operation was rolled back
        List<Error__c> errors = [select Id, Full_Message__c, Stack_Trace__c from Error__c limit 10];
        System.assertEquals(0, errors.size());
    }
    
    /** To demonstrate that NO error record was created - the first insert was rolled back, and when second insert run 
        the reentrancy flag stopped the code ParentAccountUpdater from running. **/ 
    public testmethod static void oneInvalidTwoValidContactsWithReentrancyFlag() {
        
        ParentAccountUpdater.useReentrancyFlag = true;
        
        //Create accounts
        Account acc1 = new Account(Name='test1');
        Account acc2 = new Account(Name='test2');
        Account acc3 = new Account(Name='test3');
        insert new Account[] {acc1, acc2, acc3};
        
        //Create contacts
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson1', AccountId = acc1.Id, Title = 'VP1');
        Contact contact2 = new Contact(FirstName = 'test', LastName = 'testerson2', AccountId = acc2.Id, Title = 'VP2');
        Contact contact3 = new Contact(FirstName = 'test', LastName = 'testerson3', AccountId = acc3.Id, Title = 'VP3');   
        
        //Delete the account to get the code to throw an exception
        delete acc2;
        
        Test.startTest();
        List<Contact> contacts = new Contact[]{contact1, contact2, contact3};
        LIST<database.SaveResult> results = Database.insert(contacts, false);
        Test.stopTest();
        
        //Verify the records that were correctly processed
        System.assertEquals(true, results[0].isSuccess());  
        System.assertEquals(false, results[1].isSuccess()); 
        System.assertEquals(true, results[2].isSuccess()); 
        
        //Verify two contacts were properly inserted
        list<Contact> insertedContacts = [select Id from Contact where Id in :contacts];
        System.assertEquals(2, insertedContacts.size());
        
        List<Error__c> errors = [select Id, Full_Message__c, Stack_Trace__c from Error__c limit 10];
        System.assertEquals(0, errors.size()); 
    }
    
    /** To demonstrate that errors records are created NOT because of the deleted account (the error created at that 
        point is rolled back), but because the Name field has not been queried the secound time the Database.insert 
        run with only those records that did not fail the first time. **/
    public testmethod static void oneInvalidTwoValidContactsWithoutReentrancyFlag() {
        
        ParentAccountUpdater.useReentrancyFlag = false;
        
        //Create accounts
        Account acc1 = new Account(Name='test1');
        Account acc2 = new Account(Name='test2');
        Account acc3 = new Account(Name='test3');
        insert new Account[] {acc1, acc2, acc3};
        
        //Create contacts
        Contact contact1 = new Contact(FirstName = 'test', LastName = 'testerson1', AccountId = acc1.Id, Title = 'VP1');
        Contact contact2 = new Contact(FirstName = 'test', LastName = 'testerson2', AccountId = acc2.Id, Title = 'VP2');
        Contact contact3 = new Contact(FirstName = 'test', LastName = 'testerson3', AccountId = acc3.Id, Title = 'VP3');   
        
        //Delete the account to get the code to throw an exception
        delete acc2;
        
        Test.startTest();
        List<Contact> contacts = new Contact[]{contact1, contact2, contact3};
        LIST<database.SaveResult> results = Database.insert(contacts, false);
        Test.stopTest();
        
        //Verify the records that were correctly processed
        System.assertEquals(true, results[0].isSuccess());  
        System.assertEquals(false, results[1].isSuccess()); 
        System.assertEquals(true, results[2].isSuccess()); 
        
        //Verify two contacts were properly inserted
        list<Contact> insertedContacts = [select Id from Contact where Id in :contacts];
        System.assertEquals(2, insertedContacts.size());
        
        //Verify 2 error records were created
        List<Error__c> errors = [select Id, Full_Message__c, Stack_Trace__c from Error__c limit 10];
        System.assertEquals(2, errors.size()); 
    }
    
     /** To prove that there are different types of null pointer exceptions. In this case the account
    name is always available. The error does not get stored because the second time that Database.insert 
    runs there are no errors. **/
    public testmethod static void oneInvalidTwoValidContactsAccNameQueried() {
                
        //Create accounts
        Account acc1 = new Account(Name='test1');
        Account acc2 = new Account(Name='test2');
        Account acc3 = new Account(Name='test3');
        insert new Account[] {acc1, acc2, acc3};
        
        //Create contacts
        Contact contact1 = new Contact(FirstName = 'test2', LastName = 'testerson1', AccountId = acc1.Id, Title = 'VP1');
        Contact contact2 = new Contact(FirstName = 'test2', LastName = 'testerson2', AccountId = acc2.Id, Title = 'VP2');
        Contact contact3 = new Contact(FirstName = 'test2', LastName = 'testerson3', AccountId = acc3.Id, Title = 'VP3');   
        
        //Delete the account to get the code to throw an exception
        delete acc2;
        
        Test.startTest();
        List<Contact> contacts = new Contact[]{contact1, contact2, contact3};
        LIST<database.SaveResult> results = Database.insert(contacts, false);
        Test.stopTest();
        
        //Verify the records that were correctly processed
        System.assertEquals(true, results[0].isSuccess());  
        System.assertEquals(false, results[1].isSuccess()); 
        System.assertEquals(true, results[2].isSuccess()); 
        
        //Verify two contacts were properly inserted
        list<Contact> insertedContacts = [select Id from Contact where Id in :contacts];
        System.assertEquals(2, insertedContacts.size());
        
        //Verify no error records created. The second time Database.insert runs there are no issues.
        List<Error__c> errors = [select Id, Full_Message__c, Stack_Trace__c from Error__c limit 10];
        System.assertEquals(0, errors.size()); 
    }
}