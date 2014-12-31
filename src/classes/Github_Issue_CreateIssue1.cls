public class Github_Issue_CreateIssue1 {

private static Github_Integration_Setting__c gitbugDetails = Github_Integration_Setting__c.getInstance('Github Credentials');

    public void execute(list<Github_Issue__c> listGithubIssues){
        system.debug('listGithubIssues-----------'+listGithubIssues);
        
        system.debug('Github_Integration_Setting__c------------'+gitbugDetails);
        
        /*list<User> listUser = [Select u.Name, 
                                      u.Id, 
                                      u.GitHub_Username__c 
                               From User u
                               Where  u.Id=: Userinfo.getUserId() limit 1];
        
        String githubUserName = (listUser!=null && listUser.size()>0)?listUser[0].GitHub_Username__c:'HitendraEspl';
        system.debug('githubUserName---------'+githubUserName);*/
        
        if(listGithubIssues.size()>0 && listGithubIssues!=null){
            Integer cnt=0;
            for(Github_Issue__c issueRec : listGithubIssues){
                if(cnt<10){
                    String IssueJSON = createJSON(issueRec);
                    system.debug('IssueJSON----------'+IssueJSON);
                    string endpointUrl = gitbugDetails.Github_Basic_API_URL__c + gitbugDetails.GitHub_Username__c + '/' + issueRec.Repo__c + '/issues';
                    system.debug('endpointUrl----------'+endpointUrl);
                    string issueId = issueRec.Id;
                    Github_Issue_CreateIssue1.createGithubCallout(IssueJSON, endpointUrl,issueId);
                    cnt++;
                }
                else
                    break;
            }
        }
    }
        
    public string createJSON(Github_Issue__c ObjGithubIssue){
        String jsonString ='';
        
        if(ObjGithubIssue != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('title', ObjGithubIssue.Name);
            gen.writeStringField('body', ObjGithubIssue.Description__c);
            gen.writeEndObject();
            
            system.debug('gen---------'+gen.getAsString());
            jsonString = gen.getAsString();
        }
        return jsonString;
    }
    
    @future (callout=true)
    public static void createGithubCallout(string jsonString, string endpoint, string IssueId){
        system.debug('jsonString---'+jsonString+'---insied future method----'+endpoint);
        new Salesforce_Github_APIResource().githubPostRequest(jsonString,endpoint,IssueId);
    }

}