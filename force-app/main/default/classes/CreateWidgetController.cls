public with sharing class CreateWidgetController {
    @AuraEnabled
    public static void createWidget(String value,Boolean isNestedProperly){
        Custom_Widget__c widgtRec = new Custom_Widget__c();
        widgtRec.Value__c=value;
        widgtRec.Is_Properly_Nested__c=isNestedProperly;
        widgtRec.ownerId = UserInfo.getUserId();
        try {            
            insert widgtRec;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }    
}