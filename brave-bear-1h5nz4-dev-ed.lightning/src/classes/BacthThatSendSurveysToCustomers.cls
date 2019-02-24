global class BacthThatSendSurveysToCustomers implements Database.Batchable<sObject>, Database.Stateful  {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;  //Date.today()
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
		Date todayDate = date.today();
        return Database.getQueryLocator( 'Select Name, Id, FirstName,  language__c, survey_date__c, Email from Contact ' +
            'where survey_date__c <:todayDate order by LastModifiedDate desc' 
            
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> listOfContacts){
        // process each batch of records
      
        this.recordsProcessed=listOfContacts.size();
        date myDate = date.newInstance(2011, 11, 21);
       
        List<Contact> updatedContacts = new List<Contact>();
        
      
        for(Integer i=0 ; i<listOfContacts.size()  ; i++ ){ //&& i<1 
            
         	//System.debug(listOfContacts.get(i).Email);
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            String[] sendingTo = new String[]{listOfContacts.get(i).Email};
         
            semail.setToAddresses(sendingTo);
            semail.setSubject('Survey');
           
            String emailBody; 
            
            //check language of email 
            if(listOfContacts.get(i).language__c !='de'){

				emailBody = 'Hey ' + listOfContacts.get(i).Name+ ', please fill out our survey: http://n26.com/survey/' +  listOfContacts.get(i).Id;
                  
            }else{

                emailBody = 'Hey ' + listOfContacts.get(i).Name+ ', bitte fülle unsere Umfrage aus: http://n26.com/survey/' +  listOfContacts.get(i).Id;
                
            }

            semail.setPlainTextBody(emailBody );
			// if you are getting a the error SINGLE_EMAIL_LIMIT_EXCEEDED , comment this line, you reach the limit of emails, try tomorrow   
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
           
            //reset date of each survey should be sent
            listOfContacts.get(i).survey_date__c=null;
            
        }

        update listOfContacts;
    
    }
    
    global void finish(Database.BatchableContext bc){

        List<CronTrigger> listBatchOnHold;  
        
        // check if bach already is running, query  null position CronTrigger trows an expetion
        try{
            
            listBatchOnHold = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger ];
            
            Boolean batchAlreadyWasSchedualed = false;
            
            for(CronTrigger bacthRunning :listBatchOnHold){
                
                System.debug(bacthRunning.CronJobDetail.Name);
                // if already has a batch schedualed, do not initiate another one
                if(bacthRunning.CronJobDetail.Name=='Send  surveys every day'){
                    
                    batchAlreadyWasSchedualed=true;
                    break;
                }
                
            }
            
            if(!batchAlreadyWasSchedualed){
                
                BacthThatSendSurveysToCustomers schedualeSendNextSurveys = new BacthThatSendSurveysToCustomers();
                //next bacth it was schedualed to the next 24 hours.
                System.scheduleBatch(schedualeSendNextSurveys, 'Send  surveys every day', 60*24);  // time in minutes
                System.debug('batch alive');
            }
            
        }catch( Exception e){
            
            System.debug(e);
       
        }
   
  
    }    
}