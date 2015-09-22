@isTest
private class TestValidationRules 
{
  /*
    ContactInformationRequiredForLeadConversion: Verifies the business rule that
    a Lead cannot be converted without contact information being provided. Either an
    email address or phone number are required.
  */
  private static testMethod void ContactInformationRequiredForLeadConversion()
  {
    Lead testLead = new Lead(FirstName = 'First',
                             LastName = 'Last',
                             Company = 'Company'
                            Company_Size__c = 1);
    insert testLead;

    Database.LeadConvert lc = new Database.LeadConvert();
    lc.setLeadId(testLead.id);
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);

    try
    {
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assertEquals(false, lcr.isSuccess(), 'Lead was converted without contact information!'); // should never run
    }
    catch(DmlException ex)
    {
      String expectedStatusCode = String.valueOf(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
      System.assertEquals(expectedStatusCode, ex.getDmlStatusCode(0), 'Expected validation error.');
    }
  }
}