public class CustomerProductInformation_Controller {
    
     @AuraEnabled
     public static String getContacts(){
         List<Contact> listOfContacts = new List<Contact>();
         listOfContacts= [Select Name, Id, FirstName, Email, language__c, survey_date__c, Product__c, Home_Country__c from Contact order by LastModifiedDate desc];
         
         return JSON.serialize(listOfContacts);
     }

}