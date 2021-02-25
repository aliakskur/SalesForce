public class HealthClinicController {
    public List<SelectOption> doctorOptions {get; set;}
    public List<SelectOption> patientOptions {get; set;}
    public List<Doctor__c> doctorWorkTime {get; set;}
    public List<Appointment__c> doctorAppointmentInfo {get; set;}
    public ApexPages.StandardSetController controller {get; set;}
    public final Integer ITEMS_PER_PAGE = 20;
    public String doctorId {get; set;}
    public String patientId {get; set;}
    public Appointment__c newAppointment {get;set;}

    
    public HealthClinicController() {

        doctorPatientOptions();

        doctorInfo();

        newAppointment = new Appointment__c();
    }


    /**
     * Outputs Doctor's info depends of choosen Doctor's name from SelectList on VFP
     * Info includes:
     * Doctor's work time,
     * Doctor's appointments info with pagination
     */
    public void doctorInfo() {
        doctorWorkTime = [SELECT Name, Working_Hours_Start__c, Working_Hours_End__c
                          FROM Doctor__c
                          WHERE Doctor__c.Id = :doctorId];

        doctorAppointmentInfo = [SELECT Doctor__r.Name, Patient__r.Name, Date__c, Duration__c
                                 FROM Appointment__c
                                 WHERE Doctor__r.Id = :doctorId
                                 ORDER BY Patient__r.Name 
                                 ASC];

        controller = new ApexPages.StandardSetController(doctorAppointmentInfo);
        controller.setPageSize(ITEMS_PER_PAGE);
        
    }


    public List<Appointment__c> getAppointmentsForPagination() {
        List<Appointment__c> appointmentList = (List<Appointment__c>) controller.getRecords();
        return appointmentList;
    }
    
    
    /**
     * Gets Doctor's and Patient's SelectOption list for VFP
     */
    public void doctorPatientOptions() {
        doctorOptions = new List<SelectOption>();
        patientOptions = new List<SelectOption>();

        List<Doctor__c> doctorList;
        doctorList = [SELECT Id, Name
                      FROM Doctor__c
                      ORDER BY Name ASC];

        List<Patient__c> patientList;
        patientList = [SELECT Id, Name
                       FROM Patient__c
                       ORDER BY Name ASC];

        doctorId = !doctorList.isEmpty() ? doctorList[0].id : NULL;
        patientId = !patientList.isEmpty() ? patientList[0].id : NULL;

        for (Doctor__c doctor : doctorList) {
            doctorOptions.add(new SelectOption(doctor.Id, doctor.Name));
        }

        for (Patient__c patient : patientList) {
            patientOptions.add(new SelectOption(patient.Id, patient.Name));
        }
    }

    /**
     * Inserts new Appointment in DB
     * In sucess, creates new  Appointment's instance for next Appointment insertion's
     * availability.
     * 
     */
    public PageReference saveAppointmentObj() {
        newAppointment.Doctor__c = doctorId;
        newAppointment.Patient__c = patientId;

        try {
            insert newAppointment;
            System.debug('Successfully added new Appointment');
             Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.CONFIRM,'Successfully added new Appointment'));
			
           newAppointment = new Appointment__c();
        } catch (DmlException e) {
             System.debug('Error adding new Appointment' + e.getMessage());
        }
         return null;
    }
}