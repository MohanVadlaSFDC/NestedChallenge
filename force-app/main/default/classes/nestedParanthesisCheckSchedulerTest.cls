@IsTest
public class nestedParanthesisCheckSchedulerTest {
    @IsTest
    static void createSchduler() {    
        Custom_Widget__c cwRec = CreateCustomWidgetTestDataFactory.getValidCustomWidgetRecord(); 
        test.startTest();
            String cronExpression = '0 0 * * * ?'; // Every hour at the start of the hour
            String jobName = 'HourlySchedulerJob';            
        	System.schedule(jobName, cronExpression, (Schedulable)new nestedParanthesisCheckScheduler());
        Test.stopTest();
        // Retrieve the scheduled job
        CronTrigger scheduledJob = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        // Perform assertions
        System.assertEquals(cronExpression, scheduledJob.CronExpression);
        System.assertNotEquals(null, scheduledJob.NextFireTime);
    }
}