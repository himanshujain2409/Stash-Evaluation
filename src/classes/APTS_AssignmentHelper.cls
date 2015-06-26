public with sharing class APTS_AssignmentHelper {
    
    public string sError = '';
    public decimal dcumactualweek = 0;
    public decimal dcumPlannedweek = 0;
    //Update the project end date if the assignment end date is greater than project end date
    //This function will be called from ATPS_updateProjectTime_Trigger
    public boolean UpdateProjectEndDate(List<pse__Assignment__c> OAssigmentList)
    {
        Try
        {
            
            Map<id,pse__Assignment__c> oProjectAssignmentMap = new Map<id,pse__Assignment__c>();
            //Generate map for assigment
            for(pse__Assignment__c OAssign  :OAssigmentList )
            {
                oProjectAssignmentMap.put(OAssign.pse__Project__c,OAssign);
                
            }
            
            //Fetch project data with the highest assignment date
            MAP<id,pse__Proj__c> OProjectMap = new MAP<id,pse__Proj__c>(
                                                                        [select id, pse__End_Date__c
                                                                            FROM  pse__Proj__c
                                                                            WHERE id in :oProjectAssignmentMap.keyset()
                                                                            ]       
                                                                        );
                                                                        
            List<pse__Proj__c> oProjectList = new   List<pse__Proj__c>();                                                       
            
            ///Loop throw all projects
            for(id ProjectID : oProjectAssignmentMap.keyset())
            {
                Date DEndDate;
                pse__Assignment__c OAssign  = oProjectAssignmentMap.get(ProjectID);
                pse__Proj__c  oProject = OProjectMap.get(ProjectID);
                
                
                If(oProject.pse__End_Date__c < OAssign.pse__End_Date__c)
                {
                    oProject.pse__End_Date__c = OAssign.pse__End_Date__c;
                    oProjectList.Add(oProject);
                }
            }   
             
            If(oProjectList.size() > 0 )
            {
                Update oProjectList;
            }   
             
        }
        catch(exception e)
        {
            
            sError = e.getMessage()+e.getLineNumber();
            System.debug('Error'+sError);
            Return False;
        }                                               
        Return True;
    } 

//****START DATE FEB 12, 2015 ADDED LOGIC TO Track ActualVSPlannedHours  ***////
    public boolean DeleteActualvsPlanned(List<pse__Timecard_Header__c> oTimeCardList)
    {
        Try
        {
            Set<id> setTimeCardID  = new set<id>();
            //Create the time card id set
            For(pse__Timecard_Header__c oTCard : oTimeCardList)
            {
                setTimeCardID.add(oTCard.id);  
            }
                
            
            List<Est_vs_Actual_Daily__c> ODailyList = [select id 
                                                                FROM        Est_vs_Actual_Daily__c
                                                                Where   TimecardHeader__c = :setTimeCardID];
            //Delete all the existing data  
            if(ODailyList!=null)                                            
            DELETE ODailyList;
        } 
        catch(exception e)
        {
            sError = e.getMessage();
              System.debug('Error'+sError);
            Return False;
        }   
        Return True;
    }

    public boolean AddActualvsPlanned(List<pse__Timecard_Header__c> oTimeCardList)
    {
        Try
        {
            Set<id> setassignmentID  = new set<id>();               ///create the assignment set
            Set<id> setScheduleID  = new set<id>();                 ///create the schedule id set
            Set<id> setResourceId  = new set<id>();                 ///create the schedule id set
            List<Est_vs_Actual_Daily__c> ODailyList = new list<Est_vs_Actual_Daily__c>();   
            
            ///Create the assignment id set
            For(pse__Timecard_Header__c oTCard : oTimeCardList)
            {
                setassignmentID.add(oTCard.pse__Assignment__c); 
                setResourceId.add(oTCard.pse__Resource__c);
             //   System.Debug('!!!oTCard.pse__Assignment__c'+oTCard.pse__Assignment__c);
               // System.Debug('!!!oTCard.pse__Assignment__c'+oTCard.pse__Resource__c);
            }
            
            //Fetch the assignment data based on the Schedule
            MAP<id,pse__Assignment__c> OAssignementMap;
           if(setassignmentID!= null && setassignmentID.size()>0) { OAssignementMap = NEW MAP<id,pse__Assignment__c>(
                                                                                            [SELECT Id, 
                                                                                                    pse__Schedule__c,                                                                                           
                                                                                                    pse__Schedule__r.pse__Start_Date__c,
                                                                                                    pse__Schedule__r.Name,
                                                                                                    pse__Schedule__r.pse__Monday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Tuesday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Wednesday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Thursday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Friday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Saturday_Hours__c,
                                                                                                    pse__Schedule__r.pse__Sunday_Hours__c
                                                                                                                                                                                            
                                                                                             FROM  pse__Assignment__c
                                                                                             WHERE id =:setassignmentID
                                                                                            ]
                                                                                                
                                                                                        );}
                                                                                        
            MAP<id,Contact> OResourceMAp = new MAP<id,Contact>(
                                                            [select id,
                                                                    ReportsToId,
                                                                    Apttus_PS_Contact_Type__c,
                                                                    pse__Practice__c,
                                                                    pse__Resource_Role__c
                                                                FRom Contact 
                                                                WHERE id = :setResourceId
                                                                    ]   
                                                        );                                                                          
            //Create the schedule id map
            MAP<id,pse__Schedule__c> OExceptionMap;
            if(OAssignementMap!=null){
            for( id tempid :OAssignementMap.keyset() )
            {
                setScheduleID.add(OAssignementMap.Get(tempid).pse__Schedule__c);
            }                                                                   
            
            ///Fetch the schedule exceptions based on the schedules                     
             OExceptionMap = NEW MAP<id,pse__Schedule__c>(
                                                                                            [select id,
                                                                                             (SELECT pse__Schedule__c,
                                                                                                    Id,                                                                                             
                                                                                                    Name,
                                                                                                    pse__Date__c,
                                                                                                    pse__End_Date__c,
                                                                                                    pse__Monday_Hours__c,
                                                                                                    pse__Tuesday_Hours__c,
                                                                                                    pse__Wednesday_Hours__c,
                                                                                                    pse__Thursday_Hours__c,
                                                                                                    pse__Friday_Hours__c,
                                                                                                    pse__Sunday_Hours__c,
                                                                                                    pse__Saturday_Hours__c                                                                                                                                                                          
                                                                                             FROM  pse__Schedule_Exceptions__r )
                                                                                             FROM pse__Schedule__c
                                                                                             WHERE id  = :setScheduleID
                                                                                              
                                                                                            ]
                                                                                                
                                                                                        );   }                                                                       
            
            ///Loop for all the timecards
            For(pse__Timecard_Header__c oTCard : oTimeCardList)
            {
                ///Get the assignement id
                id tempid = oTCard.pse__Assignment__c;
               if(tempid != null){ //get the assignemtn object
                pse__Assignment__c oAssign = OAssignementMap.get(tempid);
                
                pse__Schedule__c oSchedule = OExceptionMap.get(oAssign.pse__Schedule__c);
                 Contact   oResource =  OResourceMAp.get(oTCard.pse__Resource__c);
                Date dStartDate = oTCard.pse__Start_Date__c;
                ///Loop for all the days of week
                //dcumactualweek
                dcumactualweek = 0;
                dcumPlannedweek = 0;
                While(dStartDate < oTCard.pse__End_Date__c) 
                {
                    AddToEstvsActual(dStartDate ,oTCard, oAssign,oSchedule, oResource,  ODailyList );
                    dStartDate = dStartDate.AddDays(1);
                }
             }   
            }   
            
            If(ODailyList.Size() > 0 ) 
            {
                Insert ODailyList;
            }   
        }   
            catch(exception e)
        {
            sError = e.getMessage()+e.getLineNumber();
              System.debug('Error'+sError);
            Return False;
        }                                                               
        Return true;
        
    }
    
    //Create the aactualvsest data set
    private boolean AddToEstvsActual(Date dScheduleDate, pse__Timecard_Header__c oTCard, pse__Assignment__c oAssign, pse__Schedule__c oSchedule, Contact oResource, List<Est_vs_Actual_Daily__c> ODailyList)
    {
        decimal dActualHours = 0;               ///check the actual hours
        decimal dPlannedHours = 0;              ///Check the planne hours
        
        //Get the day for schedule date
        Datetime dt = DateTime.newInstance(dScheduleDate, Time.newInstance(0, 0, 0, 0));  
        String dayOfWeek=dt.format('EEEE').ToLowerCase();
        
        list<pse__Schedule_Exception__c> OExceptionList  =  oSchedule.pse__Schedule_Exceptions__r;
        pse__Schedule_Exception__c OException = new pse__Schedule_Exception__c();
        
        //Loop throw all the exceptions 
        for(pse__Schedule_Exception__c OTempException : OExceptionList)
        {
            if(OTempException.pse__Date__c <=dScheduleDate && OTempException.pse__End_Date__c >= dScheduleDate )
            {
                OException = OTempException;
            }
            
        }
        
        ///Check for the dayof week and fetch the proper allocation from date
        If(dayOfWeek == 'sunday')
        {
            dActualHours = oTCard.pse__Sunday_Hours__c;
           
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Sunday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Sunday_Hours__c;
            }
        } else If(dayOfWeek == 'monday')
        {
            dActualHours = oTCard.pse__Monday_Hours__c;
            
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Monday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Monday_Hours__c;
            }
        } else If(dayOfWeek == 'tuesday')
        {
            dActualHours = oTCard.pse__Tuesday_Hours__c;
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Tuesday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Tuesday_Hours__c;
            }
        } else If(dayOfWeek == 'wednesday')
        {
            dActualHours = oTCard.pse__Wednesday_Hours__c;
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Wednesday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Wednesday_Hours__c;
            }
        } else If(dayOfWeek =='thursday')
        {
            dActualHours = oTCard.pse__Thursday_Hours__c;
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Thursday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Thursday_Hours__c;
            }
        } else If(dayOfWeek == 'friday')
        {
            dActualHours = oTCard.pse__Friday_Hours__c;
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Friday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Friday_Hours__c;
            }
        } else If(dayOfWeek == 'saturday')
        {
            dActualHours = oTCard.pse__Saturday_Hours__c;
            If(OException.id != NULL)
            {
                dPlannedHours = OException.pse__Saturday_Hours__c;
            }
            Else
            {
                dPlannedHours = oAssign.pse__Schedule__r.pse__Saturday_Hours__c;
            }
        }
       // SYstem.debug('MS Test1:'+dScheduleDate+dcumactualweek);
         //SYstem.debug('MS Test2:'+dScheduleDate+dcumPlannedweek);
         dcumactualweek = dcumactualweek + dActualHours;
        dcumPlannedweek = dcumPlannedweek + dPlannedHours;
        //  SYstem.debug('MS Test3:'+dScheduleDate+dcumactualweek);
        // SYstem.debug('MS Test4:'+dScheduleDate+dcumPlannedweek);
        //Create a object record and insert a record
        Est_vs_Actual_Daily__c OEstDaily  = new Est_vs_Actual_Daily__c();
        OEstDaily.Allocated_Hours__c = dPlannedHours; 
        OEstDaily.Assignment__c = oAssign.id;
        OEstDaily.Project__c = oTCard.pse__Project__c;
        OEstDaily.TimecardHeader__c = oTCard.id;
        OEstDaily.Resource__c = oTCard.pse__Resource__c; 
        OEstDaily.TimeCard_Date__c = dScheduleDate;
        OEstDaily.TimeCard_Hours__c = dActualHours;
        OEstDaily.Contact_Type__c = oResource.Apttus_PS_Contact_Type__c;
        OEstDaily.Practice__c = oResource.pse__Practice__c;
        OEstDaily.Resource_Reports_To__c = oResource.ReportsToId;
        OEstDaily.Resource_Role__c = oResource.pse__Resource_Role__c;
        OEstDaily.Cumulative_Actual_Hours__c = dcumactualweek;
        OEstDaily.Cumulative_Estimated_Hours__c = dcumPlannedweek;
        ODailyList.Add(OEstDaily);
        Return true;
        
    }
    //****End DATE FEB 12, 2015 ADDED LOGIC TO Track ActualVSPlannedHours  ***////
    
    

}