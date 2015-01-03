public class Salesforce_Github_APIResource {

private static Github_Integration_Setting__c gitbugDetails = Github_Integration_Setting__c.getInstance('Github Credentials');

    public void githubPostRequest(string issueJsonString, String endPointUrl, string issueId){
        
        system.debug('Github_Integration_Setting__c------------'+gitbugDetails);
        
        Http httpCall = new Http();
        HttpRequest request = new HttpRequest();
        system.debug('===gitbugDetails==='+gitbugDetails);
        system.debug('===gitbugDetails.Access_token__c=='+gitbugDetails.Access_token__c);
        request.setHeader('Authorization','Bearer '+gitbugDetails.Access_token__c);//'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e'
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept','application/json');
        
        request.setBody(issueJsonString);//Send JSON body
        request.setMethod('POST');
        //request.setEndpoint('https://api.github.com/repos/hitendra01/GitHubDemoProject/issues');//URL will be your Salesforce REST API end point where you will do POST,PUT,DELETE orGET
        request.setEndpoint(endPointUrl);
        
        HttpResponse response = httpCall.send(request);
        system.debug('issueId-----------------'+issueId);
        
        system.debug('RESPONSE_BODY-----------------'+response .getbody());
        Map<String, Object> body = (Map<String, Object>) System.JSON.deserializeUntyped(response .getbody());
        system.debug('body------------'+body);
        for (string s:body.keySet()){
            system.debug('key value---'+s+'---value is ----'+body.get(s));
        }
        
        set<Github_Issue__c> issueNeedToUpdate = new set<Github_Issue__c>();
        
        for(Github_Issue__c SFissue : [Select g.Repo__c, g.Repo_Name__c, g.Repo_Id__c, g.State__c,
                                              g.Issue_Number__c, g.Id, g.GitHub_Milestone__c, g.Github_URL__c
                                       From Github_Issue__c g Where g.Id=:issueId limit 1]){
            system.debug('SFissue ---------'+SFissue );
            
            if(SFissue!=null){
                SFissue.Issue_Number__c = (Decimal)body.get('number');
                SFissue.Github_URL__c = (String)body.get('html_url');
                SFissue.State__c = (String)body.get('state');
                
                if(SFissue.GitHub_Labels__c != null){
                    list<string> listLabel = (SFissue.GitHub_Labels__c).split(';');
                    if(listLabel != null && listLabel.size()>0){
                        for(String lbl : listLabel){
                            if(lbl.contains('story-points')){
                                SFissue.Story_Points__c = Integer.ValueOf(lbl.substring(13,lbl.length()));
                            }
                        }
                    }
                }
            
                issueNeedToUpdate.add(SFissue);
            }
        }
        system.debug('issueNeedToUpdate---------'+issueNeedToUpdate);
        
        list<Github_Issue__c> listissueUpdate = new list<Github_Issue__c>();
        listissueUpdate.addAll(issueNeedToUpdate);
        system.debug('listissueUpdate---------'+listissueUpdate);
        
        if(listissueUpdate!=null){
        system.debug('listissueUpdate---------'+listissueUpdate);
            update listissueUpdate;
        } 
        
        
    }
    
    public void githubPatchRequest(string issueJsonString, String endPointUrl, string issueId){
        
        system.debug('Github_Integration_Setting__c------------'+gitbugDetails);
         
        Http httpCall = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization','Bearer '+gitbugDetails.Access_token__c);//'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e'
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept','application/json');
        //request.setBody('{"title":"test Issue 16-6-2014","body":"body for test Issue 16-6-2014","assignee":"HitendraEspl","milestone":"1","labels":[{"name":"bug"}]}');
        request.setBody(issueJsonString);//Send JSON body
        request.setMethod('POST');
        //request.setEndpoint('https://api.github.com/repos/HitendraEspl/Salesforce-Github-Integration/issues/29?_HttpMethod=PATCH');
        request.setEndpoint(endPointUrl);
        
        HttpResponse response = httpCall.send(request);
        system.debug('response=========='+response);
        
    }
    
    public void getAllRepositoryDetails(){
    	system.debug('--getAllRepositoryDetails--');
    	///repos/:owner/:repo
    	Http httpCall = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization','Bearer '+gitbugDetails.Access_token__c);//'ba1237dcf955ecc7447875e0fe12fa2fc4bba91e'
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept','application/json');
        
        //request.setBody(issueJsonString);//Send JSON body
        request.setMethod('GET');
        request.setEndpoint('https://api.github.com/repos/hitendra01/Salesforce-Github-Integration');//URL will be your Salesforce REST API end point where you will do POST,PUT,DELETE orGET
        //request.setEndpoint(endPointUrl);
        
        HttpResponse response = httpCall.send(request);
        system.debug('RESPONSE_BODY-----------------'+response .getbody());
    	//return '';
    }
    
}