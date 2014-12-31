@isTest
global class Salesforce_Github_APIResource_Test implements HttpCalloutMock { 
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/61","labels_url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/61/labels{/name}","comments_url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/61/comments","events_url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/61/events","html_url":"https://github.com/HitendraEspl/Salesforce-Github-Integration/issues/61","id":36069256,"number":61,"title":"test issue 444","user":{"login":"HitendraEspl","id":5582952,"avatar_url":"https://avatars.githubusercontent.com/u/5582952?","gravatar_id":"4c87fbc5e73b9d3b2e5d4413a79d1ac9","url":"https://api.github.com/users/HitendraEspl","html_url":"https://github.com/HitendraEspl","followers_url":"https://api.github.com/users/HitendraEspl/followers","following_url":"https://api.github.com/users/HitendraEspl/following{/other_user}","gists_url":"https://api.github.com/users/HitendraEspl/gists{/gist_id}","starred_url":"https://api.github.com/users/HitendraEspl/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/HitendraEspl/subscriptions","organizations_url":"https://api.github.com/users/HitendraEspl/orgs","repos_url":"https://api.github.com/users/HitendraEspl/repos","events_url":"https://api.github.com/users/HitendraEspl/events{/privacy}","received_events_url":"https://api.github.com/users/HitendraEspl/received_events","type":"User","site_admin":false},"labels":[{"url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/labels/bug","name":"bug","color":"fc2929"},{"url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/labels/story-points-3","name":"story-points-3","color":"bfd4f2"}],"state":"open","assignee":{"login":"HitendraEspl","id":5582952,"avatar_url":"https://avatars.githubusercontent.com/u/5582952?","gravatar_id":"4c87fbc5e73b9d3b2e5d4413a79d1ac9","url":"https://api.github.com/users/HitendraEspl","html_url":"https://github.com/HitendraEspl","followers_url":"https://api.github.com/users/HitendraEspl/followers","following_url":"https://api.github.com/users/HitendraEspl/following{/other_user}","gists_url":"https://api.github.com/users/HitendraEspl/gists{/gist_id}","starred_url":"https://api.github.com/users/HitendraEspl/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/HitendraEspl/subscriptions","organizations_url":"https://api.github.com/users/HitendraEspl/orgs","repos_url":"https://api.github.com/users/HitendraEspl/repos","events_url":"https://api.github.com/users/HitendraEspl/events{/privacy}","received_events_url":"https://api.github.com/users/HitendraEspl/received_events","type":"User","site_admin":false},"milestone":{"url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/milestones/2","labels_url":"https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/milestones/2/labels","id":690034,"number":2,"title":"Monthly Updates","description":"Monthly Updates","creator":{"login":"HitendraEspl","id":5582952,"avatar_url":"https://avatars.githubusercontent.com/u/5582952?","gravatar_id":"4c87fbc5e73b9d3b2e5d4413a79d1ac9","url":"https://api.github.com/users/HitendraEspl","html_url":"https://github.com/HitendraEspl","followers_url":"https://api.github.com/users/HitendraEspl/followers","following_url":"https://api.github.com/users/HitendraEspl/following{/other_user}","gists_url":"https://api.github.com/users/HitendraEspl/gists{/gist_id}","starred_url":"https://api.github.com/users/HitendraEspl/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/HitendraEspl/subscriptions","organizations_url":"https://api.github.com/users/HitendraEspl/orgs","repos_url":"https://api.github.com/users/HitendraEspl/repos","events_url":"https://api.github.com/users/HitendraEspl/events{/privacy}","received_events_url":"https://api.github.com/users/HitendraEspl/received_events","type":"User","site_admin":false},"open_issues":16,"closed_issues":4,"state":"open","created_at":"2014-06-13T05:45:56Z","updated_at":"2014-06-19T11:13:53Z","due_on":"2014-07-31T07:00:00Z"},"comments":0,"created_at":"2014-06-19T11:13:53Z","updated_at":"2014-06-19T11:13:53Z","closed_at":null,"body":"body for test issue 444","closed_by":null}');
        res.setStatusCode(200);
        return res;
    }
    
    static testMethod void testCallout() {
        Github_Integration_Setting__c setting  = new Github_Integration_Setting__c();
        setting.Name = 'Github Credentials';
        setting.Access_token__c = 'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e';
        setting.Github_Basic_API_URL__c = 'https://api.github.com/repos/';
        setting.GitHub_Username__c = 'HitendraESPL';
        upsert setting;
     
      string jsonString ='{"title":"test Issue 16-6-2014","body":"body for test Issue 16-6-2014","assignee":"HitendraEspl","milestone":"1"}';
        string endpoint = 'https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/29';
       string str1 = 'a0sV0000014XgGIAU';
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Salesforce_Github_APIResource_Test());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
       // Github_Issue_CreateIssue.updateGithubCallout(jsonString,endpoint,str1 );
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Salesforce_Github_APIResource_Test());
          Github_Issue_CreateIssue.updateGithubCallout(jsonString,endpoint,str1);
       Test.stopTest();
        
        // Verify response received contains fake values
        /*String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());*/
    }
    
    static testMethod void testCallout2() {
        Github_Integration_Setting__c setting  = new Github_Integration_Setting__c();
        setting.Name = 'Github Credentials';
        setting.Access_token__c = 'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e';
        setting.Github_Basic_API_URL__c = 'https://api.github.com/repos/';
        setting.GitHub_Username__c = 'HitendraESPL';
        upsert setting;
     
      string jsonString ='{"title":"test Issue 16-6-2014","body":"body for test Issue 16-6-2014","assignee":"HitendraEspl","milestone":"1"}';
        string endpoint = 'https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/29';
       string str1 = 'a0sV0000014XgGIAU';
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Salesforce_Github_APIResource_Test());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        //Github_Issue_CreateIssue.createGithubCallout(jsonString,endpoint,str1);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Salesforce_Github_APIResource_Test());
            Github_Issue_CreateIssue.createGithubCallout(jsonString,endpoint,str1);
        Test.stopTest();
        
        // Verify response received contains fake values
        /*String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());*/
    }
    
    static testMethod void testPostIssue() {
        Github_Integration_Setting__c setting  = new Github_Integration_Setting__c();
        setting.Name = 'Github Credentials';
        setting.Access_token__c = 'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e';
        setting.Github_Basic_API_URL__c = 'https://api.github.com/repos/';
        setting.GitHub_Username__c = 'HitendraESPL';
        upsert setting;
        
        string jsonString ='{"title":"test Issue 16-6-2014","body":"body for test Issue 16-6-2014","assignee":"HitendraEspl","milestone":"1"}';
        string endpoint = 'https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/29';
        
        GitHub_Milestones__c milestone = new GitHub_Milestones__c();
        milestone.URL__c = 'https://api.github.com/repos/aptotude/apto-dev/milestones/10';
        milestone.Name = 'Weekly Update';
        milestone.State__c = 'Open';
        milestone.Milestone_Number__c = 1;
        
        insert milestone;
        
        Github_Issue__c issue = new Github_Issue__c();
        issue.GitHub_Milestone__c = milestone.Id;
        issue.Github_URL__c = 'https://api.github.com/repos/aptotude/apto-dev/issues/85';
        issue.Description__c = 'test issue body description';
        issue.GitHub_Labels__c = 'bug; story-points-5';
        issue.Issue_Number__c = 29;
        issue.Name = 'test issue';
        issue.Repo__c = 'Salesforce-Github-Integration';
        issue.Story_Points__c = 5;
        issue.Repo_Name__c = 'HitendraEspl/Salesforce-Github-Integration';
        issue.State__c = 'Open';
       // insert issue;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Salesforce_Github_APIResource_Test());
        //if ( !Test.isRunningTest() ) new Http().send(request);
          //  new Salesforce_Github_APIResource().githubPostRequest(jsonString,endpoint,issue.Id);
           insert issue;
        Test.stopTest();
    }
}