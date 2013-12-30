@isTest
public with sharing class Trigger_TEST {

    public testmethod static void test() {
    	Account acc1 = new Account(Name='test');
        insert acc1;
        Contact contact1 = new Contact(FirstName = 'TriggerTest', LastName = 'test', AccountId = acc1.Id, Title = 'VP');
        
        Test.startTest();
        Database.insert(contact1);
        Test.stopTest();        
    }
}