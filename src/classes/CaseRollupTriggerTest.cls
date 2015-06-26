@isTest
private class CaseRollupTriggerTest {

    static testMethod void caseRollupTest() {
        Test.startTest();
        try{
                Case_Status_Duration__c oCusSettAddInfo = new Case_Status_Duration__c();
                oCusSettAddInfo.Name = 'Additional Info';
                oCusSettAddInfo.Number_of_Days__c = 5;
                insert oCusSettAddInfo;
                
                Case_Status_Duration__c oCusSettConfRes = new Case_Status_Duration__c();
                oCusSettConfRes.Name = 'Confirm Resolution';
                oCusSettConfRes.Number_of_Days__c = 5;
                insert oCusSettConfRes;
        
                system.debug('value : ' + Integer.valueof(Case_Status_Duration__c.getValues('Additional Info').Number_of_Days__c));        
                system.debug('value : ' + Integer.valueof(Case_Status_Duration__c.getValues('Confirm Resolution').Number_of_Days__c) );
                
                Account acc =new Account();
                acc.name='apttus test account';
                insert acc;
                
                contact c=new contact();
                 c.lastname='test last';
                 c.accountid = acc.id;
                 c.Active_Portal_User__c = true;
                 insert c;         
                 
                case ca=new case();
                 ca.Contactid=c.id;
                 ca.accountid = acc.id;
                 ca.Subject='test';
                 ca.Product__c='Contract Management';
                 ca.Case_Category__c='Error';
                 ca.Description='test';
                 ca.Status= 'New';
                 //ca.Account= 'Symantec';                
                 insert ca;         
                ca.Status = 'Additional Info';
                update ca;
                ca.Status = 'Confirm Resolution';
                update ca;
                delete ca; 
        }
        catch(Exception E){
            system.debug('Error : ' + e.getMessage());
        }
        Test.stopTest();
    }
}