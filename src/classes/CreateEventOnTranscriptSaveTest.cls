@isTest 
public with sharing class CreateEventOnTranscriptSaveTest {
    static testmethod void TestCreateEventOnTranscriptSave() {
        Lead lead = new Lead(Company = 'Apttus', LastName = 'Test'); 
        insert lead;
        
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        String body = '<p align="center">Chat Started: Wednesday, February 13, 2013, 03:52:59 (-0800)</p><p align="center">Chat Origin: Chat With Apttus Sales</p><p align="center">Agent John Doe</p>( 2s ) John D: Welcome to Apttus. How may I help you?<br>';
        LiveChatTranscript transcript = new LiveChatTranscript(LiveChatVisitorId = visitor.id, 
                LeadId = lead.id,
                Body = body,
                EndTime = DateTime.now());
        insert transcript;
        
        /*Task task;
        try {
            task = (Task) [SELECT Subject FROM Task WHERE WhoId = :lead.id LIMIT 1];
        } catch(QueryException e) {
            System.assert(false);
        }
        System.assertNotEquals(null, task);
        System.assertEquals('Live Chat', task.Subject);*/
    }
}