public class CaseTriggerHandler extends TriggerHandler {

    private List<Case> requestsList;

    public CaseTriggerHandler() {
        requestsList = (List<Case>) Trigger.new;
    }

    protected override void beforeInsert() {
        CaseTriggerHelper.controlReservationRequestCreation(requestsList);
    }

    protected override void beforeUpdate() {
        CaseTriggerHelper.manageReservationRequestClosure(requestsList);
    }
    
} 
