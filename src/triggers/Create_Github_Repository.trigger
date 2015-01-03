trigger Create_Github_Repository on Github_Repository__c (before insert, before update) {
	if(Trigger.isInsert && Trigger.isAfter)
    	new Create_Github_Repository_Handler().execute(Trigger.new);
}