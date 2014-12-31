public class Github_Issue_CreateIssue {
    private static Github_Integration_Setting__c GITHUB_DETAIL_SETTING = (Github_Integration_Setting__c.getInstance('Github Credentials') != null)?
                                                                     Github_Integration_Setting__c.getInstance('Github Credentials') :
                                                                        new Github_Integration_Setting__c();
   //public static list<String> lstmilestone = new list<String>();
    //code to insert the Issue from Salesforce to Github
    private static Map<String, Github_Repo_Details__c> REPO_DETAILS_SETTING = Github_Repo_Details__c.getAll();
    
    public void executeInsert(list<Github_Issue__c> listGithubIssues){
        
        if(listGithubIssues==null || listGithubIssues.size()==0)
           return;
        
        Integer cnt=0;
        for(Github_Issue__c issueRec : listGithubIssues){
            if(cnt<10){
                Github_Repo_Details__c repoDetail = REPO_DETAILS_SETTING.get(issueRec.Repo__c);
                system.debug('repoDetail-----------'+repoDetail);
                String IssueJSON = createJSON(issueRec);
                String endpointUrl;
                if(repoDetail!=null)
                    endpointUrl = GITHUB_DETAIL_SETTING.Github_Basic_API_URL__c + repoDetail.Repo_Owner_Name__c + '/' + issueRec.Repo__c + '/issues';
                else
                    endpointUrl = GITHUB_DETAIL_SETTING.Github_Basic_API_URL__c + GITHUB_DETAIL_SETTING.GitHub_Username__c + '/' + issueRec.Repo__c + '/issues';
                    
                String issueId = issueRec.Id;
                system.debug('====2=====');
                Github_Issue_CreateIssue.createGithubCallout(IssueJSON, endpointUrl,issueId);
                cnt++;
            }
            else break;
        }
        updateMilestoneTotalPoints(listGithubIssues);
    }
    

    //code to update the Issue from Salesforce to Github
    public void executeUpdate(list<Github_Issue__c> listGithubIssues, map<Id, Github_Issue__c> mapIssuesOld){
        
        if(listGithubIssues==null || listGithubIssues.size()==0)
           return;
        
        Integer cnt=1;
        system.debug('===listGithubIssues==='+listGithubIssues.size());
        for(Github_Issue__c issueRec : listGithubIssues){
            system.debug('===for loop called====');
            
            if(issueRec.Issue_Number__c == mapIssuesOld.get(issueRec.Id).Issue_Number__c){
                system.debug('issueRec.Story_Points__c----'+issueRec.Story_Points__c);
                system.debug('mapIssuesOld.get(issueRec.Id).Story_Points__c----'+mapIssuesOld.get(issueRec.Id).Story_Points__c);
                if(cnt<10){
                    Github_Repo_Details__c repoDetail = REPO_DETAILS_SETTING.get(issueRec.Repo__c);
                    String IssueJSON = createJSON(issueRec);
                    String endpointUrl;
                    if(repoDetail!=null)
                        endpointUrl = GITHUB_DETAIL_SETTING.Github_Basic_API_URL__c + repoDetail.Repo_Owner_Name__c + '/' + issueRec.Repo__c + '/issues/'+issueRec.Issue_Number__c+'?_HttpMethod=PATCH';
                    else
                        endpointUrl = GITHUB_DETAIL_SETTING.Github_Basic_API_URL__c + GITHUB_DETAIL_SETTING.GitHub_Username__c + '/' + issueRec.Repo__c + '/issues/'+issueRec.Issue_Number__c+'?_HttpMethod=PATCH';
                    
                    String issueId = issueRec.Id;
                    Github_Issue_CreateIssue.updateGithubCallout(IssueJSON, endpointUrl, issueId);
                    cnt++;
                }
                else break;
           }
            
        }
        
        updateMilestoneTotalPoints(listGithubIssues);
    }
    
    public void updateMilestoneTotalPoints(list<Github_Issue__c> githubIssues){
        set<Id> milestoneIdSet = new set<Id>();
        
        for (Github_Issue__c issue : githubIssues) {
            milestoneIdSet.add(issue.GitHub_Milestone__c);
        }
        
        list<GitHub_Milestones__c> listMilStone = [
                        select Name
                             , Milestone_Id__c
                             , Total_Story_Points__c
                             , Id
                             , (Select Id
                                     , Story_Points__c
                                  FROM Github_Issues__r )
                          From GitHub_Milestones__c    
                         where Id IN :milestoneIdSet
        ];
        
        list<GitHub_Milestones__c> listMilestoneToUpdate = new list<GitHub_Milestones__c>();
        
        for(GitHub_Milestones__c m : listMilStone){
            Decimal storyPointCounter = 0;
            for(Github_Issue__c issue : m.Github_Issues__r){
                if(issue.Story_Points__c !=null)
                    storyPointCounter += issue.Story_Points__c;
            }
            m.Total_Story_Points__c = storyPointCounter;
            listMilestoneToUpdate.add(m);
        }
        
        if(listMilestoneToUpdate.size()>0)
            update listMilestoneToUpdate;
    }
    
    //Method to update Story-Point in issue object
    public void updateIssueStoryPoint(list<Github_Issue__c> listGithubIssues, map<Id, Github_Issue__c> mapIssuesOld){
        system.debug('inside updateIssueStoryPoint');
        system.debug('listGithubIssues--------'+listGithubIssues);
        if(listGithubIssues!=null && listGithubIssues.size()>0){
            Integer cnt=0;
            for(Github_Issue__c SFissue : listGithubIssues){
                if(SFissue.GitHub_Labels__c != null){
                    list<string> listLabel = (SFissue.GitHub_Labels__c).split(';');
                    if(listLabel != null && listLabel.size()>0){
                        for(String lbl : listLabel){
                            if(lbl.contains('story-points')){
                                cnt++;
                                SFissue.Story_Points__c = Integer.ValueOf(lbl.substring(13,lbl.length()));
                            }
                            
                            if(cnt==0)
                                SFissue.Story_Points__c =0;
                        }
                    }
                }
            }
        }
            
            
    } 
    
    // Code to create JSON String
    public string createJSON(Github_Issue__c ObjGithubIssue){
        
        String jsonString ='';
        list<String> listLabels;
        if(ObjGithubIssue.GitHub_Labels__c != null)
            listLabels = (ObjGithubIssue.GitHub_Labels__c).split(';');
            
        system.debug('listLabels---------'+listLabels);
        if(ObjGithubIssue != null){
       
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('title', ObjGithubIssue.Name);
            
            if(ObjGithubIssue.Description__c != null)
                gen.writeStringField('body', ObjGithubIssue.Description__c);
            else
                gen.writeStringField('body', '');
                
            //Add assignee to issue.
            if(ObjGithubIssue.OwnerId != null){
                list<User> userList = [Select u.Id, u.GitHub_Username__c From User u Where u.Id =: ObjGithubIssue.OwnerId];
                User assignOwner = (userList != null) ? userList[0] : null;
                if(userList != null && userList.size()>0){
                    if(assignOwner.GitHub_Username__c != null){
                        gen.writeStringField('assignee', assignOwner.GitHub_Username__c);            
                    }
                }
            }
            
            //Add milestone to issue.
            //if(ObjGithubIssue.GitHub_Milestone__c != null){
                list<GitHub_Milestones__c> milestoneList = [Select g.Milestone_Number__c, g.Name, g.Milestone_Id__c, g.Id From GitHub_Milestones__c g Where g.Id =: ObjGithubIssue.GitHub_Milestone__c];
                GitHub_Milestones__c assignMilestone = (milestoneList != null && milestoneList.size()>0) ? milestoneList[0] : null;
                if(assignMilestone != null){
                    if(assignMilestone.Milestone_Number__c != null)
                        gen.writeStringField('milestone', String.valueOf(assignMilestone.Milestone_Number__c));
                }           
            //}
            //else
               // gen.writeStringField('milestone', '');
            
            if(ObjGithubIssue.State__c != null && ObjGithubIssue.State__c != '')
                gen.writeStringField('state', ObjGithubIssue.State__c);
            
            //Add Labels to issue.    
            if(listLabels != null && listLabels.size()>0){  
                gen.writeFieldName('labels');  
                gen.writeStartArray();
                for(string lbl: listLabels){
                    gen.writeStartObject();
                    gen.writeStringField('name', lbl);            
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            }
            
            gen.writeEndObject();
            
            system.debug('gen---------'+gen.getAsString());
            jsonString = gen.getAsString();
        }
        return jsonString;
    }
        
    @future (callout=true)
    public static void createGithubCallout(string jsonString, string endpoint, string IssueId){
        system.debug('===createGithubCallout===');
        new Salesforce_Github_APIResource().githubPostRequest(jsonString,endpoint,IssueId);
    }
    
    @future (callout=true)
    public static void updateGithubCallout(string jsonString, string endpoint, string IssueId){
        new Salesforce_Github_APIResource().githubPatchRequest(jsonString,endpoint,IssueId);
    }

}