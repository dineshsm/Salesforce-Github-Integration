trigger Github_Issue_CreateIssue on Github_Issue__c (after insert, after update, before update) {
    if(Userinfo.getUserType()!='Guest'){
        if(Trigger.isInsert && Trigger.isAfter)
            new Github_Issue_CreateIssue().executeInsert(Trigger.new);
    }
    else
        new Github_Issue_CreateIssue().updateMilestoneTotalPoints(Trigger.new);
    
    if(Userinfo.getUserType()!='Guest'){
        if(Trigger.isUpdate && Trigger.isAfter){
            system.debug('inside after update');
            new Github_Issue_CreateIssue().executeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    else
        new Github_Issue_CreateIssue().updateMilestoneTotalPoints(Trigger.new); 
    
    if(Userinfo.getUserType()!='Guest'){
        if(Trigger.isUpdate && Trigger.isBefore){
            system.debug('inside isBefore update');
            new Github_Issue_CreateIssue().updateIssueStoryPoint(Trigger.new,Trigger.oldMap);
        }
    }
}