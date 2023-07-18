@IsTest
public class CreateWidgetControllerTest {
    @IsTest
    static void createCwRec() {       
        test.startTest();       
            CreateWidgetController.createWidget('{}{}[',false);
        test.stopTest();
        system.assertEquals(1,[select count() from Custom_Widget__c]);
    }
    
}