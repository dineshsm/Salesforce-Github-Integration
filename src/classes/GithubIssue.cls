public class GithubIssue {
    
    public String Name;
    public String body;
    public Datetime closed_at;
    public Datetime created_at;
    public Decimal issueNumber;
    public String state;
    public Datetime updated_at;
    public String url;
    public String repoFullName;
    public String repoName;
    public Decimal repoId;
    public String labels;
    public Decimal storyPoints;
    public String comments;
    public String githubIssueId;
    public String assignee;
    // Fields for the milestones   Milestone_Number__c
    public String milestone_title;
    public Date milestone_due_on;
    public Datetime milestone_created_at;
    public String milestone_state;
    public Decimal milestone_Id;
    public Decimal milestone_Number;
    public String milestone_Url;
    
    public GithubIssue() {
        comments='';
        
    }
    public GithubIssue(Map<String, Object> m) {
        this.Name        = (String)  m.get('title');
        this.body        = (String)  m.get('body');
        this.url         = (String)  m.get('html_url');
        this.issueNumber = (Decimal) m.get('number');
        this.state       = (String)  m.get('state');
        this.created_at  = parseDatetime((String) m.get('created_at'));
        this.updated_at  = parseDatetime((String) m.get('updated_at'));
        
        if (m.get('closed_at') != null)
            this.closed_at = parseDatetime((String) m.get('closed_at'));
        
        this.repoName = (String) ((Map<String, Object>) m.get('repo')).get('name');
        system.debug('this.repoName---------'+this.repoName);
        
        this.repoFullName    = (String) ((Map<String, Object>) m.get('repo')).get('full_name');
        this.repoId      = (Decimal) ((Map<String, Object>) m.get('repo')).get('id');
        system.debug('this.repoFullName---------'+this.repoFullName);
        
        if(((Map<String, Object>) m.get('comment')) != null)
            this.comments    = (String) ((Map<String, Object>) m.get('comment')).get('body');

        //  Add Milestone details
        if(m.get('milestone') != null){
            this.milestone_title   = (String) ((Map<String, Object>) m.get('milestone')).get('title');
            this.milestone_Id   = (Decimal)((Map<String, Object>) m.get('milestone')).get('id');
            this.milestone_Number   = (Decimal)((Map<String, Object>) m.get('milestone')).get('number');
            if(((Map<String, Object>) m.get('milestone')).get('due_on') !=null)
                this.milestone_due_on   = parseDate((String)((Map<String, Object>) m.get('milestone')).get('due_on'));
            this.milestone_created_at   = parseDatetime((String)((Map<String, Object>) m.get('milestone')).get('created_at'));
            this.milestone_state   = (String)((Map<String, Object>) m.get('milestone')).get('state');
            this.milestone_Url   = (String)((Map<String, Object>) m.get('milestone')).get('url');
        }
        
        if(m.get('assignee') != null)
            this.assignee   = (String)((Map<String, Object>) m.get('assignee')).get('login');
        
        system.debug('this.assignee=========='+this.assignee);
        
        list< Object> issueLabelMap =  (list<Object>)(m.get('labels'));
            system.debug('issueLabelMap==========='+issueLabelMap);
            
            if(issueLabelMap.size()>0 && issueLabelMap!=null){
                string strLabels = '';
                for(Object s:issueLabelMap ){
                    system.debug('Object is ---'+s);
                    Map<String, Object> issueLabelMap1 = (Map<String, Object>)s;
                    system.debug('issueLabelMap1   is ---'+issueLabelMap1.get('name') );
                    strLabels = strLabels + (String)issueLabelMap1.get('name')+ ';';
                    
                    if(((String)issueLabelMap1.get('name')).contains('story-points')){
                        string storyPt = ((String)issueLabelMap1.get('name'));
                        system.debug('storyPt============'+storyPt);
                        system.debug('storyPt.length============'+storyPt.length());
                        this.storyPoints = Integer.ValueOf(storyPt.substring(13,storyPt.length()));
                        system.debug('this.storyPoints============'+this.storyPoints);
                    }
                }
                labels = strLabels.removeEnd(';');
                system.debug('labels ---------'+labels);
            }
            
     
    }
    
    public static Date parseDate(String dt) {
        Datetime dtm = parseDatetime(dt);
        Date d = dtm.date();
        return d;
    }
    
    public static Datetime parseDatetime(String dt) {
        String s = dt; 
        String str = s.replace('T',' ').replace('Z', '');
        return DateTime.valueOf(str);
    }
    
    public static void processIssue(Map<String, Object> issueMap) {
        GithubIssue issue = new GithubIssue(issueMap);
        // condition to add milestone
        system.debug('issue.milestone_Url============'+issue.milestone_Url);
        if(issueMap.get('milestone') != null){
            if(milestoneExists(issue.milestone_Url))
                updateMilestone(issue);
            else
                createMilestone(issue);
        }
        
        if(issue.issueNumber != null && issue.url != null){
            if (issueExists(issue.url))
                updateIssue(issue);
            else
                createIssue(issue);
        }
    }
    
    
    // code to identify Milestone is exist or not
    
    public static boolean milestoneExists(string githubMilestoneUrl) {
        if (findMilestone(githubMilestoneUrl) != null) {
            return True;
        } else {
            return False;
        }
    } 
    
    public static GitHub_Milestones__c findMilestone(string githubMilestoneUrl) {
        List<GitHub_Milestones__c> milestones = [Select g.URL__c, 
                                                        g.State__c, 
                                                        g.Name, 
                                                        g.Milestone_Id__c, 
                                                        g.Id, 
                                                        g.Due_On__c,
                                                        g.Total_Story_Points__c,
                                                        g.Milestone_Number__c
                                                 From GitHub_Milestones__c g Where g.URL__c =: githubMilestoneUrl LIMIT 1];
        
        return (milestones != null && milestones.size() > 0) ? milestones.get(0) : null;
    }
    
    
    // code to identify issue is exist or not
    public static boolean issueExists(String githubUrl) { 
        if (findIssue(githubUrl) != null) {
            return True;
        } else {
            return False;
        }
    } 
    
    public static Github_Issue__c findIssue(String githubUrl) {
        Github_Issue__c issue = null;
        List<Github_Issue__c> issues = [SELECT Id, 
                                               Name, 
                                               Description__c, 
                                               Github_URL__c, 
                                               Issue_Number__c, 
                                               State__c, 
                                               Created_At__c, 
                                               Updated_At__c, 
                                               Closed_At__c, 
                                               Repo_Name__c, 
                                               Repo_Id__c,
                                               GitHub_labels__c,
                                               Comments__c,
                                               Repo__c,
                                               Story_Points__c
                                         FROM Github_Issue__c 
                                         WHERE Github_URL__c=:githubUrl  LIMIT 1];
        if(issues.size() > 0) {
            return issues.get(0);
        } else {
            return issue;
        }
    }

    //Method to create Milestone
    public static void createMilestone(GithubIssue issue) {
        
        GitHub_Milestones__c newGitHubMilestones = new GitHub_Milestones__c();
            
            newGitHubMilestones.URL__c              = issue.milestone_Url;
            newGitHubMilestones.Name                = issue.milestone_title;
            newGitHubMilestones.Milestone_Id__c     = issue.milestone_Id;
            newGitHubMilestones.Due_On__c           = issue.milestone_due_on;
            newGitHubMilestones.State__c            = issue.milestone_state;
            newGitHubMilestones.Milestone_Number__c = issue.milestone_Number;
            
        insert newGitHubMilestones;
        
    }

    //Method to create Issue 
    public static void createIssue(GithubIssue issue) {
        GitHub_Milestones__c m = findMilestone(issue.milestone_Url);
        
        Github_Issue__c newIssue = new Github_Issue__c();
            newIssue.Name               = issue.Name;
            newIssue.Description__c     = issue.body;
            newIssue.Github_URL__c      = issue.url;
            newIssue.Issue_Number__c    = issue.issueNumber;
            newIssue.State__c           = issue.state;
            newIssue.Created_At__c      = issue.created_at;
            newIssue.Updated_At__c      = issue.updated_at;
            newIssue.Closed_At__c       = issue.closed_at;
            newIssue.Repo_Name__c       = issue.repoFullName;
            newIssue.Repo_Id__c         = issue.repoId;
            newIssue.Comments__c        = issue.comments;
            newIssue.GitHub_labels__c   = issue.labels;
            newIssue.Repo__c            = issue.repoName;
            
            if(issue.assignee != null){
                list<User> userList = [Select u.Id, u.GitHub_Username__c From User u Where u.GitHub_Username__c =:issue.assignee];
                User assignOwner = (userList != null && userList.size()>0) ? userList[0] : null;
                if(assignOwner!=null && assignOwner.GitHub_Username__c.equalsIgnoreCase(issue.assignee))
                    newIssue.OwnerId = assignOwner.Id;
                else
                    newIssue.OwnerId = Userinfo.getUserId();
            }
            
            
            if(issue.storyPoints != null)
                newIssue.Story_Points__c = issue.storyPoints;
            
            if(m!=null) newIssue.GitHub_Milestone__c=m.Id;
            else newIssue.GitHub_Milestone__c = null;
            
        insert newIssue;
        
        if(issue.comments !='' && issue.comments != null){
            createComment(newIssue, issue);
        }
    }
    
    //Method to Update Milestone
    public static void updateMilestone(GithubIssue issue) {
        GitHub_Milestones__c m = findMilestone(issue.milestone_Url);
        system.debug('GitHub_Milestones__c m-------------'+m);
            m.URL__c                = issue.milestone_Url;
            m.Name                  = issue.milestone_title;
            m.Milestone_Id__c       = issue.milestone_Id;
            m.Due_On__c             = issue.milestone_due_on;
            m.State__c              = issue.milestone_state;
            m.Milestone_Number__c   = issue.milestone_Number;    
        update m;
        
    }

    //Method to Update Issue 
    public static void updateIssue(GithubIssue issue) {
        GitHub_Milestones__c m = findMilestone(issue.milestone_Url);
        
        Github_Issue__c i   = findIssue(issue.url);
        i.Name              = issue.Name;
        i.Description__c    = issue.body;
        i.Github_URL__c     = issue.url;
        i.Issue_Number__c   = issue.issueNumber;
        i.State__c          = issue.state;
        i.Created_At__c     = issue.created_at;
        i.Updated_At__c     = issue.updated_at;
        i.Closed_At__c      = issue.closed_at;
        i.Repo_Name__c      = issue.repoFullName;
        i.Repo_Id__c        = issue.repoId;
        i.GitHub_labels__c  = issue.labels;
        i.Repo__c           = issue.repoName;
        
        if(issue.storyPoints != null)
                i.Story_Points__c = issue.storyPoints;
                
        if(issue.comments!='')
            i.Comments__c     = issue.comments;
            
        if(m!=null)
            i.GitHub_Milestone__c=m.Id;
        else
            i.GitHub_Milestone__c=null;
        
        if(issue.assignee != null){
            list<User> userList = [Select u.Id, u.GitHub_Username__c From User u Where u.GitHub_Username__c =:issue.assignee];
            User assignOwner = (userList != null && userList.size()>0) ? userList[0] : null;
            if(assignOwner!=null && assignOwner.GitHub_Username__c.equalsIgnoreCase(issue.assignee))
                i.OwnerId = assignOwner.Id;
            else
                i.OwnerId = Userinfo.getUserId();
        }
                
        update i;
        
        if(issue.comments !='' && issue.comments != null){
            createComment(i, issue);
        }
    }
    
    public static void createComment(Github_Issue__c i, GithubIssue issue) {
        Github_Issue_Comment__c issueComment = new Github_Issue_Comment__c();
            issueComment.Github_Issue__c    = i.Id;
            issueComment.Comment_Body__c    = issue.comments;
            issueComment.FeedItem_Title__c  = i.Description__c;
            insert issueComment;
    }
}