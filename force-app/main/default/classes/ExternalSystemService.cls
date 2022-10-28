public with sharing class ExternalSystemService {


    public void registerAttendees(Case reservationRequest){
        for(Account company : [SELECT Id , (SELECT Id,Name, Email FROM Contacts) FROM Account where Id = :reservationRequest.AccountId WITH SECURITY_ENFORCED]){
            for(Contact attendee : company.Contacts){

                ExternalServiceHelper.callExternalServiceAndSendEmail(attendee.Name,attendee.Email);
               
            }  
        }
    } 
}
