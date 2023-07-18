import { LightningElement,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import strUserId from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import {getRecord} from 'lightning/uiRecordApi';
import createWidget from '@salesforce/apex/CreateWidgetController.createWidget';

export default class CustomWidgetComponent extends LightningElement {
    @track inputString = ''; // Input string to value
   @track flag = 'true';
   buttonDisable = true;
   @track prfName;
   userId = strUserId;

   @wire(getRecord, {recordId: strUserId, fields: [PROFILE_NAME_FIELD]})
   wireuser({error,data}) {
    if (error) {
       this.error = error ; 
    } else if (data) {
        this.prfName =data.fields.Profile.value.fields.Name.value;        
    }
}
    // Event handler for input change
    getInputChange(event) { 
         this.inputString='';
         this.flag = 'true';        
         this.inputString = event.target.value;
         if(this.inputString.length>0){
            this.buttonDisable=false;
         }else{
            this.buttonDisable=true;
         }
    }

    // Function to validate the iput value(parentheses, brackets, and curly braces)
    handleSave() {
        const stack = [];
        const openingBraces = ['(', '[', '{'];
        const closingBraces = [')', ']', '}'];
        
        for (let i = 0; i < this.inputString.length; i++) {
            const inputVal = this.inputString[i];

            if (openingBraces.includes(inputVal)) {
                stack.push(inputVal);
                debugger;
            } else if (closingBraces.includes(inputVal)) {                
                const requiredOpeningBraces = openingBraces[closingBraces.indexOf(inputVal)];                               
                if (stack.length === 0 || stack.pop() !== requiredOpeningBraces) {
                    this.flag = 'false';//invalid pairing
                    break;                 
                }
            }
        }
    if(stack.length!=0){
        this.flag='false';
    }
    if(this.flag == 'true' || this.prfName === 'System Administrator' || this.prfName === 'Widget Masters') {
        createWidget({ value: this.inputString, isNestedProperly: this.flag});
            /*.then(result => {
                alert('RESULT'+this.flag);
            })
            .catch(error => {
                alert('ERROR:'+JSON.stringify(error));
            });*/
        this.toastNotification('Record Created Successfully',this.inputString,'Success'); 
    }else{  
        this.toastNotification('Invalid Pattern',this.inputString,'Warning'); 
    }
    }

    toastNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}