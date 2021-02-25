trigger AppointmentConflictTrigger on Appointment__c (before insert) {

    DateTime newTime;
    String newDoctor;
    
   List<Appointment__c> isConflictStartTimeDoctor;

    for(Appointment__c item : Trigger.new) {

    newTime = item.Date__c;
    newDoctor = item.Doctor__c;
    
isConflictStartTimeDoctor = [SELECT Date__c, Doctor__c, Duration__c 
             FROM Appointment__c
             WHERE Date__c = :newTime  
             AND Doctor__c = :newDoctor
             ];

if (isConflictStartTimeDoctor.size() > 0) {
item.addError('This time is not available for Appointment for this Doctor');
	}
  }
}