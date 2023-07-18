@IsTest
public class nestedParanthesisCheckBatchTest {
    @IsTest
    static void withInvalidPatternForBatchTest() {    
        Custom_Widget__c cwRec = CreateCustomWidgetTestDataFactory.getInValidCustomWidgetRecord(); 
        test.startTest();       
           database.executeBatch(new nestedParanthesisCheckBatch());        
        test.stopTest();
        Custom_Widget__c cwRec1 = [select id,Is_Properly_Nested__c from Custom_Widget__c where Id=:cwRec.Id];  
        system.assertEquals(false,cwRec1.Is_Properly_Nested__c);
    }
    @IsTest
    static void withValidPatternForBatchTest() {    
        Custom_Widget__c cwRec = CreateCustomWidgetTestDataFactory.getValidCustomWidgetRecord(); 
        test.startTest();       
           database.executeBatch(new nestedParanthesisCheckBatch());        
        test.stopTest();
        Custom_Widget__c cwRec1 = [select id,Is_Properly_Nested__c from Custom_Widget__c where Id=:cwRec.Id];  
        system.assertEquals(true,cwRec1.Is_Properly_Nested__c);       
    }
}