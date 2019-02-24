@isTest
public class Test_BacthThatSendSurveysToCustomers {
@testSetup 
    
    static void setup() {
        //create list of Accounts
        List<Contact> contactsEnDE = new List<Contact>();
        date dateBeforeNow = date.newInstance(2011, 11, 21);
      
        // create list of contacts
		// if the maximum limit of emails was reached, only pass the test with only one conatct  xD
        for(Integer i=0;i<10;i++) {
            
            String language = (Math.mod(i,2)== 0 ? 'en':'de' );
            
            Contact contactSuveryEnglish =new Contact(FirstName='Cristiano', 
                                                      LastName='Ronaldo',
                                                      Email='cr70@gmail.com', // put your email here so receive the emails 
                                                      language__c=language,
                                                      survey_date__c=dateBeforeNow
                                                     );
            
            contactsEnDE.add(contactSuveryEnglish);
        }

        insert contactsEnDE;
        
    
   
    }
    static testmethod void test() {        
        
        List<Contact> contactsEnDE_BeforeBatch = [Select Name, Id, FirstName, Email, language__c, survey_date__c, Product__c, Home_Country__c from Contact where LastName='Ronaldo'];
        date dateBeforeNow = date.newInstance(2011, 11, 21);
        
        // check  before bacth
        for(Integer i=0;i<contactsEnDE_BeforeBatch.size();i++){
            System.debug(contactsEnDE_BeforeBatch.get(i));
            System.assertEquals(dateBeforeNow, contactsEnDE_BeforeBatch.get(i).survey_date__c);
            
        }	
        
        
        Test.startTest();
        
        BacthThatSendSurveysToCustomers myBatchObject = new BacthThatSendSurveysToCustomers(); 
        Id batchId = Database.executeBatch(myBatchObject);
        
        Test.stopTest();
       
        // check  after bacth
        List<Contact> contactsEnDE = [Select Name, Id, FirstName, Email, language__c, survey_date__c, Product__c, Home_Country__c from Contact where LastName='Ronaldo'];
		
        for(Integer i=0;i<contactsEnDE.size();i++){
            System.debug(contactsEnDE.get(i));
            System.assertEquals(null, contactsEnDE.get(i).survey_date__c);
            
        }	
    }
}