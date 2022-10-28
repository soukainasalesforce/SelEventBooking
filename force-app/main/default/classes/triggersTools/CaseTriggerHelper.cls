public with sharing class CaseTriggerHelper {

    public static void controlReservationRequestCreation (List<Case> requestsList) {

        // WE GET THE CASE FIRST 
        Case request = requestsList[0];
        // Testing if the content of case is null or not to avoid NPE ;) 
        if(request != null && request.AccountId != null){

            Account account =  [SELECT ID, (select id from contacts) FROM Account where id = :request.AccountId WITH SECURITY_ENFORCED LIMIT 1];
            Integer numberOfAttendees = account.Contacts.size();
            if(numberOfAttendees == 0){
                request.addError('You cannot create a request for accounts without contacts');
                return;
            }      
            switch on request.Origin {
                when 'Web' {
                    if(numberOfAttendees >= 2 ){
                        request.addError('Web request are only allowed to have one attendee');
                    }
                }
                when 'Phone'{
                    if(numberOfAttendees >= 4 ){
                        request.addError('Phone request are only allowed to have three attendee');
                    }
                 }
            }    
            return;
        }
        // case when request has 0 attendees
        request.addError('You cannot create a request without attaching an account');
    }

    public static void manageReservationRequestClosure (List<Case> requestsList) {
        for (Case request : requestsList) {
            if (request.Status == 'Closed') {
                ExternalSystemService service = new ExternalSystemService();
                service.registerAttendees(request);
            }
        }
    }
}