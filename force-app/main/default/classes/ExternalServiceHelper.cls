public with sharing class ExternalServiceHelper {

    @future (callout=true)
    public static void callExternalServiceAndSendEmail(String attendeeName, String attendeeEmail) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';
        request.setEndpoint(webServiceURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        String attendeeData = attendeeName + '-' + attendeeEmail;
        request.setBody('{"name":"+ attendeeData+"}');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            notifyAttendeeByEmail(attendeeName, attendeeEmail);
        }
    }

    public static void notifyAttendeeByEmail(String attendeeName, String attendeeEmail){
      
        if (attendeeEmail != null){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses   = new String[] { attendeeEmail };
            message.optOutPolicy  = 'FILTER';
            message.subject       = 'Reservation confirmation';
            message.plainTextBody = 'Dear '+attendeeName+', Your reservation has been successfully confirmed.';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results     = Messaging.sendEmail(messages);
            
            if (!results[0].success) {
                System.debug('The email failed to send to '+attendeeEmail+'. Received error : ' + results[0].errors[0].message);
            }
        }  
    }


}
