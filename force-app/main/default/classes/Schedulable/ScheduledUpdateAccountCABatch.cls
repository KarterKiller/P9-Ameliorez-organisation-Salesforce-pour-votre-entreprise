global class ScheduledUpdateAccountCABatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateAccountCABatch());
    }
}
