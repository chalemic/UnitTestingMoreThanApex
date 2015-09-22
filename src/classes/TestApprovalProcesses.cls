@isTest
private class TestApprovalProcesses 
{
  /*
    BigDealsSubmitProperly: Verifies that Big Deal opportunities
    properly go into the approval process.
  */
  private static testMethod void BigDealsSubmitProperly()
  {
    User testUser = [SELECT Id, ManagerId FROM User WHERE ManagerId <> null AND IsActive = TRUE LIMIT 1];
    Account testAccount = new Account(Name = 'Acme');
    insert testAccount;
    Opportunity testOpp = new Opportunity(Name = 'Test',
                                        AccountId = testAccount.Id,
                                        StageName = 'Prospecting',
                                        CloseDate = Date.today(),
                                        Type = 'New Customer',
                                        Amount = 100001);

    System.runAs(testUser)
    {
      insert testOpp;
    }

    Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
    request.setComments('Test request');
    request.setObjectId(testOpp.Id);
    Approval.ProcessResult result = Approval.process(request);

    // Verify record entered Approval Process as expected
    System.assert(result.isSuccess(), 'Opportunity did not enter Approval Process.');
    System.assertEquals('Pending', result.getInstanceStatus(), 'Unexpected step 1 approval status '+result.getInstanceStatus());
    System.assertEquals(testUser.ManagerId, result.getActorIds()[0], 'Opportunity did not go to Manager for approval.');

    // Approve Step 1.
    List<Id> newWorkItemIds = result.getNewWorkitemIds();
    Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
    req2.setComments('Approving request.');
    req2.setAction('Approve');
    req2.setWorkitemId(newWorkItemIds.get(0));
    Approval.ProcessResult result2 =  Approval.process(req2);

    // Verify the 100k deal entered Step 2
    System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
    System.assertEquals('Pending', result2.getInstanceStatus(), 'Unexpected step 2 approval status '+result2.getInstanceStatus());
  }
}