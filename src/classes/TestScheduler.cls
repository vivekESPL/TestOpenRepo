global with sharing class TestScheduler implements Schedulable{
	private String userName;
	private String password;
	private String environment;
	
	global TestScheduler(String pUserName, String pPassword, String pEnvironment){
		userName = pUserName;
		password = pPassword;
		environment = pEnvironment;
	}

	global void execute(SchedulableContext pSchedulableContext)
    {
         Database.executeBatch(new TestBatch(userName, password, environment));
    }
}