public class Create_Github_Repository_Handler {
	
	public Create_Github_Repository_Handler(){
		
	}
	public void execute(list<Github_Repository__c> listGithubRepositories){
		createNewRepository(listGithubRepositories);
	}
	
	public void createNewRepository(list<Github_Repository__c> listGithubRepositories){
		system.debug('---listGithubRepositories----'+listGithubRepositories);
	}
	
	@future (callout=true)
    public static void createGithubCalloutToCreateRepository(){
        //system.debug('===createGithubCallout===');
        String repoNames = new Salesforce_Github_APIResource().getAllRepositoryDetails();
    }
}