public class nestedParanthesisCheckBatch implements Database.Batchable<SObject>,Database.Stateful {
    Public map<Id,List<Custom_Widget__c>> mapOfInvalidPatternRecords ;

    public nestedParanthesisCheckBatch() {
        mapOfInvalidPatternRecords = new map<Id, List<Custom_Widget__c>>();
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        DateTime currentTime = DateTime.now();
        DateTime oneHourAgo = currentTime.addHours(-1);
        system.debug(oneHourAgo);
        string query ='SELECT Id,Value__c,Is_Properly_Nested__c,OwnerId,owner.email FROM Custom_Widget__c where CreatedDate >= :oneHourAgo';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Custom_Widget__c> customWidgetToUpdate = new List<Custom_Widget__c>();

        for (SObject obj : scope) {
            Custom_Widget__c customWidget = (Custom_Widget__c)obj;
            if(customWidget.Value__c!=''){
                Boolean isValid = isParenthesesNested(customWidget.Value__c);
                customWidget.Is_Properly_Nested__c = isValid;
                customWidgetToUpdate.add(customWidget);
                if(!isValid){
                    if(mapOfInvalidPatternRecords.containsKey(customWidget.OwnerId)){
                        mapOfInvalidPatternRecords.get(customWidget.OwnerId).add(customWidget);  
                    }else{
                        mapOfInvalidPatternRecords.put(customWidget.OwnerId,new List<Custom_Widget__c>{ customWidget });
                    }
                }
            }
        }

        update customWidgetToUpdate;
    }

    public void finish(Database.BatchableContext context) {        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for (Id ownerId : mapOfInvalidPatternRecords.keySet()) {
            List<Custom_Widget__c> records = mapOfInvalidPatternRecords.get(ownerId);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ records[0].owner.email});
            email.setSubject('List of Invalid Pattern Widget Records');

            // Prepare the email body with the list of records as links
            String emailBody = 'Records:\n';
            for (Custom_Widget__c record : records) {
                emailBody += 'Pattern Value: ' + record.Value__c +' - ' + getRecordLink(record.Id) + '\n';
            }
            email.setPlainTextBody(emailBody);

            emailList.add(email);
        }

        Messaging.sendEmail(emailList);
    }

    Private String getRecordLink(Id recordId) {
        // Create the URL link for the record based on your Salesforce organization setup
        return URL.getSalesforceBaseUrl().toExternalForm() + '/' + recordId;
    }

    private Boolean isParenthesesNested(String value) {
        String[] openingBraces = new String[]{'(', '[', '{'};
        String[] closingBraces = new string[]{')', ']', '}'};         
            
            List<String> inputCharList = new List<String>(value.split(''));            
            List<String> Stack = new List<String>();
            for(integer i = 0; i<inputCharList.size(); i++){                 
                    if(openingBraces.contains(inputCharList[i])){
                        Stack.add(inputCharList[i]);                        
                    }
                    else if(closingBraces.contains(inputCharList[i])){
                        String requiredOpeningBraces = openingBraces[closingBraces.indexOf(inputCharList[i])];                                      
                        if (stack.size() == 0 || stack.remove(stack.size() - 1)!= requiredOpeningBraces) {                          
                          return false;//invalid pairing                                       
                        }
    
                    }
            }
        if(Stack.size()>0){
            return false;
        }        
        return true;
    }
}