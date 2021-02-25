@isTest
private class HealthClinicControllerTest {

    @isTest
    static void healthClinicControllerTest() {
        HealthClinicController controller = new HealthClinicController();
    }


    @isTest
    static void doctorTest() {
        Doctor__c doctor = new Doctor__c(
                Name = 'Petr Ivanov',
                Working_Hours_End__c = Time.newInstance(5, 10, 20, 50),
                Working_Hours_Start__c = Time.newInstance(5, 15, 20, 50));

        Test.startTest();
        Database.SaveResult result = Database.insert(doctor, false);
        Test.stopTest();

        System.assert (!result.isSuccess());
    }


    @isTest
    static void patientTest() {
        Patient__c patient = new Patient__c(
                Name = 'Ivan Petrov');

        Test.startTest();
        Database.SaveResult result = Database.insert(patient, false);
        Test.stopTest();

        System.assert (result.isSuccess());
    }


    @isTest
    static void appointmentTest() {
        HealthClinicController controller = new HealthClinicController();

        Doctor__c doctor = new Doctor__c(
                Name = 'Petr Ivanov',
                Working_Hours_End__c = Time.newInstance(5, 15, 20, 50),
                Working_Hours_Start__c = Time.newInstance(5, 10, 20, 50));
        insert doctor;

        Patient__c patient = new Patient__c(
                Name = 'Ivan Ivanov');
        insert patient;

        Appointment__c appointment = new Appointment__c(
                Date__c = dateTime.newInstance(2021, 2, 17, 12, 30, 0),
                Doctor__c = doctor.id,
                Duration__c = 15,
                Patient__c = patient.id);

        Test.startTest();
        Database.SaveResult result = Database.insert(appointment, false);
        Test.stopTest();

        System.assert (result.isSuccess());
    }


    @isTest
    static void insertTest() {
        HealthClinicController obj = new HealthClinicController();

        obj.getAppointmentsForPagination();

        try {
            obj.saveAppointmentObj();
        } catch (DMLException e) {
        }
    }


    @isTest
    static void appointmentsForPaginationTest() {
        HealthClinicController obj = new HealthClinicController();

        obj.getAppointmentsForPagination();
    }
}