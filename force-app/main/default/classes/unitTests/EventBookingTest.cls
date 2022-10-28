@isTest
public class EventBookingTest {  

        @isTest
        public static void closeCaseSuccessfully(){
            // Given
            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);
            
            Contact c1 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'elephant',
                                                                        'Email'     => 'selmaadadi@salesforce.com',
                                                                        'AccountId' => a1.ID},
                                                                    true);
                                                                  
            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Web',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book One Spot for Company A1',
                                                                        'AccountId'   => a1.ID},
                                                                    true);
        
            request.Status = 'Closed';
            
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock());

            // When
            Test.startTest();

            Database.SaveResult result = Database.update(request, false);
            Test.stopTest();

            // Then
            System.assert(result.isSuccess(),'Failed to close case');
           
        }

        @isTest
        public static void successfullyNotifyAttendeeByEmail(){

            // When
            Test.startTest();

            System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
            ExternalServiceHelper.notifyAttendeeByEmail('Soukaina','selmaadadi@salesforce.com');
           
            // Then
            System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
            
            Test.stopTest();    
           
        }

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Given
            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Phone',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book Spots'},
                                                                    false);            
            // When 

            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then

            System.assert(!result.isSuccess(),'Case creation should fail');
            System.assert(result.getErrors().size() > 0,'Case creation should return an error');
            System.assertEquals('You cannot create a request without attaching an account',
                                result.getErrors()[0].getMessage(),'Wrong error message returned upon case creation');
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Given

            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);

            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Phone',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book Spots',
                                                                        'AccountId'   => a1.ID},
                                                                    false);                                                                           
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess(),'Case creation should fail');
            System.assert(result.getErrors().size() > 0,'Case creation should return an error');
            System.assertEquals('You cannot create a request for accounts without contacts',
                                result.getErrors()[0].getMessage(),'Wrong error message returned upon case creation');
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // Given
            
            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);

            Contact c1 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 1',
                                                                        'AccountId' => a1.ID},
                                                                    true);
                                                                    
            Contact c2 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 2',
                                                                        'AccountId' => a1.ID},
                                                                    true);  

            Contact c3 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 3',
                                                                        'AccountId' => a1.ID},
                                                                    true);  
    
            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Phone',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book Spots for Company A1 & their 3 employees',
                                                                        'AccountId'   => a1.ID},
                                                                    false);   

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess(),'Event should be successfully booked from phone');

        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given

            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);
            
            Contact c1 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 1',
                                                                        'AccountId' => a1.ID},
                                                                    true);
                                                                    
            Contact c2 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 2',
                                                                        'AccountId' => a1.ID},
                                                                    true);  

            Contact c3 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 3',
                                                                        'AccountId' => a1.ID},
                                                                    true);                                                             

            Contact c4 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 4',
                                                                        'AccountId' => a1.ID},
                                                                    true);                                                             
    
            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Phone',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book Spots for Company A1 & their 4 employees',
                                                                        'AccountId'   => a1.ID},
                                                                    false);                                                           
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess(),'Case creation should fail');
            System.assert(result.getErrors().size() > 0,'Case creation should return an error');
            System.assertEquals('Phone request are only allowed to have three attendee',
                                 result.getErrors()[0].getMessage(),'Wrong error message returned upon case creation');

        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            // Given
            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);
                
            Contact c1 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 1',
                                                                        'AccountId' => a1.ID},
                                                                    true);
    
            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Web',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book One Spot for Company A1',
                                                                        'AccountId'   => a1.ID},
                                                                    false);                                                                 
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess(),'Case should be succesffuly created');

        } 
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given
            Account a1 = (Account)TestDataFactory.createSObject ( 'Account',
                                                                    new Map<String,Object> {
                                                                        'Name' => 'Salesforce'},
                                                                    true);

            Contact c1 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 1',
                                                                        'AccountId' => a1.ID},
                                                                    true);
                                                                    
            Contact c2 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 2',
                                                                        'AccountId' => a1.ID},
                                                                    true);  

            Contact c3 = (Contact)TestDataFactory.createSObject ( 'Contact',
                                                                    new Map<String,Object> {
                                                                        'LastName'  => 'Contact 3',
                                                                        'AccountId' => a1.ID},
                                                                    true);                                               

            Case request = (Case)TestDataFactory.createSObject (  'Case',
                                                                    new Map<String,Object> {
                                                                        'Origin'      => 'Web',
                                                                        'Subject'     => 'Event Booking',
                                                                        'Description' => 'Book Spots for Company A1 & their 3 employees',
                                                                        'AccountId'   => a1.ID},
                                                                    false);             
                                                                    
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess(),'Case creation should fail');
            System.assert(result.getErrors().size() > 0,'Case creation should return an error');
            System.assertEquals('Web request are only allowed to have one attendee',
                                result.getErrors()[0].getMessage(),'Wrong error message returned upon case creation');    
        } 
    
}