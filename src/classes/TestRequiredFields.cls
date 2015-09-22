@isTest
private class TestRequiredFields 
{
  /*
    CompanySizeRequired: Verifies that company size is provided
    when creating a Lead.
  */
  private static testMethod void CompanySizeRequired()
  {
    Lead testLead = new Lead(LastName = 'Test Lead',
                            Company = 'Acme');

    try
    {
      insert testLead;

      System.assert(false, 'Able to create a Lead without company size.'); // should never run
    }
    catch(DmlException ex)
    {
      String expectedStatusCode = String.valueOf(StatusCode.REQUIRED_FIELD_MISSING);
      System.assertEquals(expectedStatusCode, ex.getDmlStatusCode(0), 'Expected REQUIRED_FIELD_MISSING');
    }
  }
}