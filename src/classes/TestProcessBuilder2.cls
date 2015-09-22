@isTest
private class TestProcessBuilder2 
{
  private static testMethod void ClosedWonOppsGetContracts()
  {
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;
    Opportunity testOpp = new Opportunity(Name = 'Test',
                                        AccountId = testAccount.Id,
                                        StageName = 'Closed Won',
                                        CloseDate = Date.today(),
                                        Type = 'New Customer',
                                        Amount = 10000);
    insert testOpp;

    List<Contract> contracts = [SELECT Id FROM Contract WHERE AccountId =: testAccount.Id];
    System.assertEquals(1, contracts.size(), 'Contract for Closed/Won opp was not created.');
  }

  private static testMethod void VerifyOrderCreate()
  {
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;
    Opportunity testOpp = new Opportunity(Name = 'Test',
                                        AccountId = testAccount.Id,
                                        StageName = 'Closed Won',
                                        CloseDate = Date.today(),
                                        Type = 'New Customer',
                                        Amount = 10000);
    insert testOpp; 

    List<Order> orders = [SELECT Id FROM Order WHERE OpportunityId =: testOpp.Id];
    System.assertEquals(1, orders.size(), 'Order for Closed/Won opp was not created.');
  }
}