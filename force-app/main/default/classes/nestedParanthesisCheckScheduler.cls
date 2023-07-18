public class nestedParanthesisCheckScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        nestedParanthesisCheckBatch batch = new nestedParanthesisCheckBatch();
        Database.executebatch(batch, 200);
    }
}