global class ActiviySummaryScheduler implements Schedulable
{
	global void execute(schedulablecontext sc)
	{
		ActivitySummaryBatch actBatch=new ActivitySummaryBatch();
		database.executebatch(actBatch);
	}
	

}