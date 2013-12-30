Error_Handling
==============

Sample application to showcase how error handling can be done in a Salesforce app.

We wanted to compare when DML was performed in these three different ways:

- Simple DML not contained in a try-catch
- Simple DML wrapped in a try-cach
- DML Performed through the Database class

The purpose of the following tests is to allow us to inspect the Database.SaveResult record(s) and see other relevant information through the Debug statements in the error log:

- SimpleInsertWithCatch_TEST
- SimpleUpdateWithCatch_TEST
- DatabaseInsert_TEST
- SimpleUpdateWithCatch_TEST

All these tests use the Helper class, where the two (arguably) most interesting pieces are the ones that associate an error with the record that caused it. This happens in the following places:

- In the catch blocks if we made a simple Dml (not using the Database class)
- In the processDml method is we performed the Dml through the Database class

The VisualForce page (Test1.page) allows us to see how the error message that we manually put inside the SObject using addError is displayed by default in the apex:pageMessages element. Also, we were able to test that no error message is shown in this element if we use the Database dml methods but don't manually add the error message to the object.
