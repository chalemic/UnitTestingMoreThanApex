@isTest
private class TestProcessBuilder 
{
  /*
    BigDealsAutoSubmit: Verifies that Big Deal opportunities
    automatically go into the approval process.
  */
  private static testMethod void BigDealsAutoSubmit()
  {
    User testUser = [SELECT Id, ManagerId FROM User WHERE ManagerId <> null AND IsActive = TRUE LIMIT 1];
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;
    Opportunity testOpp = new Opportunity(Name = 'Test',
                                        AccountId = testAccount.Id,
                                        StageName = 'Negotiation/Review',
                                        CloseDate = Date.today(),
                                        Type = 'New Customer',
                                        Amount = 100001);

    System.runAs(testUser)
    {
      insert testOpp;
    }

    List<ProcessInstance> results = [SELECT Id, Status FROM ProcessInstance WHERE TargetObjectId =: testOpp.Id];

    System.assertEquals(1, results.size(), 'Opportunity did not enter Approval Process as expected.');
    System.assertEquals('Pending', results[0].Status, 'Opportunity is not Pending approval as expected.');
  }

  /*
    ManagerIsAlertedToBigDeal: Verifies that a Chatter post is made to the 
    Opportunity owner's manager.
  */
  private static testMethod void ManagerIsAlertedToBigDeal()
  {
    User testUser = [SELECT Id, ManagerId FROM User WHERE ManagerId <> null AND IsActive = TRUE LIMIT 1];
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;
    Opportunity testOpp = new Opportunity(Name = 'Test',
                                        AccountId = testAccount.Id,
                                        StageName = 'Negotiation/Review',
                                        CloseDate = Date.today(),
                                        Type = 'New Customer',
                                        Amount = 100001);

    System.runAs(testUser)
    {
      insert testOpp;
    }

    List<FeedItem> chatterPosts = [SELECT Body, InsertedById FROM FeedItem WHERE ParentId =: testUser.ManagerId AND Type = 'TextPost'];
    System.assertEquals(1, chatterPosts.size(), 'Unexpected number of Chatter posts.');
    System.assert(chatterPosts[0].Body.contains('I have a big deal'), 'Expected big deal message not found.');
  }
}