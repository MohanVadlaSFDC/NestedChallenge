@isTest
public class CreateCustomWidgetTestDataFactory {
    
    public static Custom_Widget__c getValidCustomWidgetRecord() {
		Custom_Widget__c cwRec = new Custom_Widget__c();        
        cwRec.Value__C ='{}{}';       
        insert cwRec;
        return cwRec;
	}
    public static Custom_Widget__c getInValidCustomWidgetRecord() {
		Custom_Widget__c cwRec = new Custom_Widget__c();       
        cwRec.Value__C ='{}{';       
        insert cwRec;
        return cwRec;
	}
}