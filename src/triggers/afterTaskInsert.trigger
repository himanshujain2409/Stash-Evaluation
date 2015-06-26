trigger afterTaskInsert on Task(after insert) {
    if(trigger.new.size()>1) return;
    
    List<Task> tasksToBeDeleted = new List<Task>();
    for(Task t : trigger.new) {
        if(Trigger.IsAfter && Trigger.IsInsert) {
            Task newTask = [SELECT type, subject FROM Task WHERE Id =: t.id limit 1];
            if(newTask.type != 'Email' && newTask.subject == 'Sent For Review') {
                tasksToBeDeleted.add(newTask);
            }
        }
    }
    
    if(tasksToBeDeleted.size() > 0) {
        delete tasksToBeDeleted;
    }
}