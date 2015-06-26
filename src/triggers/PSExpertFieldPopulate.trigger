trigger PSExpertFieldPopulate on Case (before Update) {

    IF(Trigger.size==1)
    {
        Case oCase = Trigger.New[0];
        
        if(Trigger.isUpdate){
                if(oCase.PS_Practice__c == 'Global' && oCase.Status=='Expert Review')
                    {
                        if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Kavitha Gondi';
                        }
                        else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Kavitha Gondi';
                        }
                        else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Kathy Gilbert-ONeil';
                        }
                        else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'Kavitha Gondi';
                        }
                        else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                        
                   
                   }
                else if(oCase.PS_Practice__c == 'NA West' && oCase.Status=='Expert Review')
                    {
                       if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Punit Baxi';
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Punit Baxi';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Sridhar Rajamani';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                     
                    }
                else if(oCase.PS_Practice__c =='NA Central' && oCase.Status=='Expert Review')
                    {
                         if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Szymon Marciniewicz';
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Szymon Marciniewicz';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Raja Saladi';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                    
                    }
                else if(oCase.PS_Practice__c =='NA East' && oCase.Status=='Expert Review')
                    {
                        if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Gary Sanders';
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Gary Sanders';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Upendra Venkata';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                    
                    }
                else if(oCase.PS_Practice__c == 'EMEA' && oCase.Status=='Expert Review')
                    {
                        if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Izabela Petrovicova';    
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Izabela Petrovicova';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Karan Bhadiadra';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                    
                    }
                else if(oCase.PS_Practice__c =='CBU' && oCase.Status=='Expert Review')
                    {
                        if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Kanchan Sadhwani';    
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Kanchan Sadhwani';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Kanchan Sadhwani';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                    
                    }
                else if(oCase.PS_Practice__c =='APAC' && oCase.Status=='Expert Review')
                    {
                        if(oCase.Product__c == 'Contract Management' ||oCase.Product__c == 'Supplier Relationship Management (SRM)'||oCase.Product__c == 'X-Author for Word'||oCase.Product__c == 'DocGen' ||oCase.Product__c == 'Merge Server'||oCase.Product__c == 'Docusign'||oCase.Product__c == 'Echosign')
                        {
                            oCase.PS_Expert__c = 'Jivixa Saraiya';    
                        }
                       else if(oCase.Product__c == 'Advanced Approvals')
                        {
                            oCase.PS_Expert__c = 'Jivixa Saraiya';
                        }
                       else if(oCase.Product__c == 'Configure, Price, Quote' || oCase.Product__c == 'Deal Maximizer' || oCase.Product__c == 'Renewals Management' || oCase.Product__c == 'X-Author for Excel')
                        {
                            oCase.PS_Expert__c = 'Karan Bhadiadra';
                        }
                       else if(oCase.Product__c == 'Billing' || oCase.Product__c == 'Revenue Recognition' || oCase.Product__c == 'Rebate Management' || oCase.Product__c == 'X-Author for Chatter' || oCase.Product__c == 'Salesforce CRM' || oCase.Product__c == 'Success Portal' || oCase.Product__c == 'Other')
                        {
                            oCase.PS_Expert__c = 'N/A';
                        }
                         else
                        {
                            oCase.PS_Expert__c = ''; 
                        }
                    
                    }
                else 
                    {
                        oCase.PS_Expert__c = ''; 
                    }
                if (oCase.PS_Expert__c!=''&& oCase.Status=='Expert Review' && oCase.Global_Expert__c!= null)
                {
                    List<String> names = oCase.Global_Expert__c.split(';');
                    set<String> uniquenames =new Set<String>();
                    uniquenames.addall(names);
                    uniquenames.add(oCase.PS_Expert__c);
                    uniquenames.add(oCase.Currently_Assigned_To_Name__c);
                    uniquenames.add(oCase.Project_Manager__c);
                    List<Contact> contactList = [select Id, email,AccountId from contact where name IN : uniquenames];
                    APTSHelperCaseTrigger.sendEmail(contactList,oCase);
                    
                }
                     
        
        }
        
    }
}