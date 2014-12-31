// The endpoint is: https://sandbox-orgsync.cs3.force.com/services/apexrest/github
@RestResource(urlMapping='/github/*') 
global class GithubIssue_APIResource {
    
    @HttpPost
    global static void postIssue() { 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {    
            //system.debug('req.requestBody.toString()==========='+req.requestBody.toString());
            Map<String, Object> body = (Map<String, Object>) System.JSON.deserializeUntyped(req.requestBody.toString());
            
            Map<String, Object> issueMap = (Map<String, Object>) body.get('issue');
            Map<String, Object> repoMap = (Map<String, Object>) body.get('repository');
            Map<String, Object> commentMap = (Map<String, Object>) body.get('comment');
            Map<String, Object> milstoneMap = (Map<String, Object>) ((Map<String, Object>) body.get('issue')).get('milestone');
            Map<String, Object> assigneeMap = (Map<String, Object>) ((Map<String, Object>) body.get('issue')).get('assignee');
            
            if(repoMap != null)
                issueMap.put('repo', repoMap);
            if(commentMap != null)    
                issueMap.put('comment', commentMap);
            if(milstoneMap != null)
                issueMap.put('milestone', milstoneMap);
            if(assigneeMap != null)
                issueMap.put('assignee', assigneeMap);
            
            //system.debug('issueMap ==========='+issueMap);
            //system.debug('repoMap==========='+repoMap);
            //system.debug('commentMap==========='+commentMap);
            //system.debug('milstoneMap==========='+milstoneMap);
           
            
            GithubIssue.processIssue(issueMap);            
            res.statusCode = 200;
        }
        catch (Exception e) {
            system.debug('exception---------'+e);
            system.debug('e.getMessage()---------'+e.getMessage());
            res.responseBody = Blob.valueOf(e.getMessage());
            system.debug('res.responseBody---------'+res.responseBody);
            res.statusCode = 500;
        }
    }
}