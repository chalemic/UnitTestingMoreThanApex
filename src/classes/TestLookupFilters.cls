@isTest
private class TestLookupFilters 
{
  /*
    KeyContactMustBeOnAccount: Verifies that an Account's Key Contact
    is a Contact assigned to that Account.
  */
  private static testMethod void KeyContactMustBeOnAccount()
  {
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;

    Contact testContact = new Contact(LastName = 'Last');
    insert testContact;

    try
    {
      testAccount.Key_Contact__c = testContact.Id;
      update testAccount;

      System.assert(false, 'Able to assign Key Contact that did not belong to Account.'); // should never run
    }
    catch(DmlException ex)
    {
      String expectedStatusCode = String.valueOf(StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION);
      System.assertEquals(expectedStatusCode, ex.getDmlStatusCode(0), 'Expected FIELD_FILTER_VALIDATION_EXCEPTION');
    }
  }
}