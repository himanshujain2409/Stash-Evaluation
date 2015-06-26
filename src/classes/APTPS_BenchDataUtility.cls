global class APTPS_BenchDataUtility implements Database.Batchable<sObject>, Database.Stateful
{
    private String listSize;
    public static List<Contact> psResources = new List<Contact>();
    public static List<pse__Assignment__c> assignmentList;
    public static List<pse__Schedule__c> schedules;
    public static List<pse__Schedule_Exception__c> scheduleExcList  = new List<pse__Schedule_Exception__c>(); 
    
    public static Set<Id> resourceIds = new Set<Id>();
    public static Set<Id> scheduleIds =  new Set<Id>();
    public static map<Id, Contact> mapIdToResource = new map<Id, Contact>();
    public static map<Id, Id> mapResourceToScheduleId  = 
        new Map<Id, Id>();
    public static Map<pse__Schedule__c, List<pse__Schedule_Exception__c>> mapScheduleAndExceptions 
        = new Map<pse__Schedule__c, List<pse__Schedule_Exception__c>>();
    public static Map<Id, List<pse__Schedule__c>> mapResourceToSchedules
        = new Map<Id, List<pse__Schedule__c>>();
    
    
    global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
       //delete existing bench data
        delete [Select Id from Bench_Data__c limit 2000]; 
        return Database.getQueryLocator( [Select Id, Name from Contact where ( pse__Resource_Role__c != 'PS Management' AND pse__Resource_Role__c != 'PS OPS' ) AND RecordType.Name = 'PS Resource'  AND pse__Is_Resource_Active__c = TRUE
                                         ] );
    }
    global void execute( Database.BatchableContext BC, List<Contact> psContact )
    {   
        Try
        {
            
            //set up data
            psResources = psContact;
            mapIdToResource = new map<Id, Contact>(psResources);    
            resourceIds = new Map<Id, Contact>(psResources).keySet();
            System.debug('ResourceidMIHIR:'+resourceIds);
            assignmentList = prepareAssignmentList(resourceIds);
            System.debug('ResourceidMIHIR:'+assignmentList);
            for(pse__Assignment__c pAssignment : assignmentList) {
                //mapResourceToScheduleId.put(pAssignment.pse__Resource__c, pAssignment.pse__Schedule__c) ;
                mapResourceToScheduleId.put( pAssignment.pse__Schedule__c, pAssignment.pse__Resource__c) ;
                scheduleIds.add(pAssignment.pse__Schedule__c);
            }
            
            schedules = prepareScheduleList(scheduleIds);
            
            for(pse__Schedule__c shd : schedules) {
                
                id tempResourceId = mapResourceToScheduleId.get(shd.id);
                
                If(mapResourceToSchedules.get(tempResourceId) != NULL)
                {
                    List<pse__Schedule__c> otempList = mapResourceToSchedules.get(tempResourceId);
                    otempList.add(shd);
                }
                else            
                {
                    List<pse__Schedule__c> otempList = new List<pse__Schedule__c>();
                    otempList.add(shd);
                    mapResourceToSchedules.Put(tempResourceId,otempList);
                }
            } 
            
            List<Bench_Data__c> benchDataList = new List<Bench_Data__c>();
            
            Decimal benchHours;
            //update : Week range should be Monday to Sunday
            //Week-1
            DateTime currentDate = DateTime.newInstance(System.today(), Time.newInstance(1, 0, 0, 0));
            DateTime startDateWeek1 = DateTime.newInstance(System.today(), Time.newInstance(1, 0, 0, 0));         
            
            String startdayOfWeek1 = startDateWeek1.format('EEE').ToLowerCase();
            
            DateTime endDateWeek1;
            System.debug('start date'+startDateWeek1);
            System.debug('startdayOfWeek1'+startdayOfWeek1);
            if(startdayOfWeek1 == 'Mon') {
                startDateWeek1 = startDateWeek1.addDays(-1);
            } else if(startdayOfWeek1 == 'Tue') {
                startDateWeek1 = startDateWeek1.addDays(-2);
            } else if(startdayOfWeek1 == 'Wed') {
                startDateWeek1 = startDateWeek1.addDays(-3);
            } else if(startdayOfWeek1 == 'Thu') {
                startDateWeek1 = startDateWeek1.addDays(-4);
            } else if(startdayOfWeek1 == 'Fri') {
                startDateWeek1 = startDateWeek1.addDays(-5);
            } else if(startdayOfWeek1 == 'Sat') {
                startDateWeek1 = startDateWeek1.addDays(-6);
            } 
            endDateWeek1 = startDateWeek1.addDays(6);
            
            //week - 2 
            
            DateTime startDateWeek2 = startDateWeek1.addDays(7);            
            DateTime startDateWeek3 = startDateWeek2.addDays(7);
            DateTime startDateWeek4 = startDateWeek3.addDays(7); // + 7 + 1;
            DateTime startDateWeek5 = startDateWeek4.addDays(7); //+ 7 + 1;
            DateTime startDateWeek6 = startDateWeek5.addDays(7); //+ 7 + 1;
            DateTime startDateWeek7 = startDateWeek6.addDays(7); //+ 7 + 1;
            DateTime startDateWeek8 = startDateWeek7.addDays(7); // + 7 + 1; 
            DateTime startDateWeek9 = startDateWeek8.addDays(7); //+ 7 + 1;
            DateTime startDateWeek10 = startDateWeek9.addDays(7); //+ 7 + 1;
            DateTime startDateWeek11 = startDateWeek10.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek12 = startDateWeek11.addDays(7); //+ 7 + 1;
            DateTime startDateWeek13 = startDateWeek12.addDays(7); //+ 7 + 1;
            DateTime startDateWeek14 = startDateWeek13.addDays(7); //+ 7 + 1;
            DateTime startDateWeek15 = startDateWeek14.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek16 = startDateWeek15.addDays(7); //+ 7 + 1;  
            DateTime startDateWeek17 = startDateWeek16.addDays(7); //+ 7 + 1;
            DateTime startDateWeek18 = startDateWeek17.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek19 = startDateWeek18.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek20 = startDateWeek19.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek21 = startDateWeek20.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek22 = startDateWeek21.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek23 = startDateWeek22.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek24 = startDateWeek23.addDays(7); //+ 7 + 1; 
            DateTime startDateWeek25 = startDateWeek24.addDays(7); //+ 7 + 1;
            DateTime startDateWeek26 = startDateWeek25.addDays(7); //+ 7 + 1;
            
            Integer workingDaysMonth1 = getWorkingDaysOfMonth(currentDate);
            Integer workingDaysMonth2 = getWorkingDaysOfMonth(currentDate.addMonths(1));
            Integer workingDaysMonth3 = getWorkingDaysOfMonth(currentDate.addMonths(2));
            Integer workingDaysMonth4 = getWorkingDaysOfMonth(currentDate.addMonths(3));
            Integer workingDaysMonth5 = getWorkingDaysOfMonth(currentDate.addMonths(4));
            Integer workingDaysMonth6 = getWorkingDaysOfMonth(currentDate.addMonths(5));
            
            DateTime startDateMonth1 = DateTime.newInstance(currentDate.year(), currentDate.month(), 1,1,0,0);
            DateTime startDateMonth2 = startDateMonth1.addMonths(1);
            DateTime startDateMonth3 = startDateMonth1.addMonths(2);
            DateTime startDateMonth4 = startDateMonth1.addMonths(3);
            DateTime startDateMonth5 = startDateMonth1.addMonths(4);
            DateTime startDateMonth6 = startDateMonth1.addMonths(5);
            
            
            For (id tempResourceId : resourceIds )
            {
                Bench_Data__c benchData = new Bench_Data__c();
                 benchData.Week_1_Date_Range__c = startDateWeek1.format('d-MMMM-yyyy');
                // benchData.Week_2_Date_Range__c = startDateWeek2 + ' To ' +  startDateWeek2.addDays(6);
                benchData.Week_1_Bench_Hours__c = 40;
                benchData.Week_2_Bench_Hours__c = 40;
                benchData.Week_3_Bench_Hours__c = 40; //benchData.Week_3_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek3);
                benchData.Week_4_Bench_Hours__c = 40; //benchData.Week_4_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek4);
                benchData.Week_5_Bench_Hours__c = 40; //benchData.Week_5_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek5);
                benchData.Week_6_Bench_Hours__c = 40; //benchData.Week_6_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek6);
                benchData.Week_7_Bench_Hours__c = 40; //benchData.Week_7_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek7);
                benchData.Week_8_Bench_Hours__c = 40; //benchData.Week_8_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek8);
                benchData.Week_9_Bench_Hours__c = 40; //benchData.Week_9_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek9);
                benchData.Week_10_Bench_Hours__c = 40; //benchData.Week_10_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek10);
                benchData.Week_11_Bench_Hours__c = 40; //benchData.Week_11_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek11);
                benchData.Week_12_Bench_Hours__c = 40; //benchData.Week_12_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek12);
                benchData.Week_13_Bench_Hours__c = 40; //benchData.Week_13_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek13);
                benchData.Week_14_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_15_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_16_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_17_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_18_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_19_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_20_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_21_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_22_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_23_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_24_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_25_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchData.Week_26_Bench_Hours__c = 40; //benchData.Week_14_Bench_Hours__c + calculateTotalBenchHours(schedule, startDateWeek14);
                benchdata.Name = 'Bench Record - ' + mapIdToResource.get(tempResourceId).name;
                benchdata.Month_1__c = workingDaysMonth1 * 8;
                benchdata.Month_2__c = workingDaysMonth2 * 8;
                benchdata.Month_3__c = workingDaysMonth3 * 8;
                benchdata.Month_4__c = workingDaysMonth4 * 8;
                benchdata.Month_5__c = workingDaysMonth5 * 8;
                benchdata.Month_6__c = workingDaysMonth6 * 8;
                benchData.Resource__c = tempResourceId;
                
                
                
                List<pse__Schedule__c> oTempScheduleList  = new List<pse__Schedule__c>();
                If(mapResourceToSchedules.get(tempResourceId) != NULL)
                {
                    oTempScheduleList = mapResourceToSchedules.get(tempResourceId);
                }
                
                for(pse__Schedule__c schedule : oTempScheduleList) {
                    
                    //DateTime startDateOfSchedule = (DateTime)schedule.pse__Start_Date__c;
                    //String startdayOfWeek = startDateOfSchedule.format('EEE');
                    //DateTime endDateOfScheduke = (DateTime)schedule.pse__End_Date__c;
                    
                    benchData.Week_1_Bench_Hours__c = benchData.Week_1_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek1);    
                    
                    benchData.Week_2_Bench_Hours__c = benchData.Week_2_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek2);
                    
                    benchData.Week_3_Bench_Hours__c = benchData.Week_3_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek3);
                    
                    benchData.Week_4_Bench_Hours__c = benchData.Week_4_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek4);
                    benchData.Week_5_Bench_Hours__c = benchData.Week_5_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek5);
                    
                    benchData.Week_6_Bench_Hours__c = benchData.Week_6_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek6);
                    
                    benchData.Week_7_Bench_Hours__c = benchData.Week_7_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek7);
                    benchData.Week_8_Bench_Hours__c = benchData.Week_8_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek8);
                    benchData.Week_9_Bench_Hours__c = benchData.Week_9_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek9);
                    benchData.Week_10_Bench_Hours__c = benchData.Week_10_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek10);
                    benchData.Week_11_Bench_Hours__c = benchData.Week_11_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek11);
                    benchData.Week_12_Bench_Hours__c = benchData.Week_12_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek12);
                    benchData.Week_13_Bench_Hours__c = benchData.Week_13_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek13);
                    benchData.Week_14_Bench_Hours__c = benchData.Week_14_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek14);
                    benchData.Week_15_Bench_Hours__c = benchData.Week_15_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek15);
                    benchData.Week_16_Bench_Hours__c = benchData.Week_16_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek16);
                    benchData.Week_17_Bench_Hours__c = benchData.Week_17_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek17);
                    benchData.Week_18_Bench_Hours__c = benchData.Week_18_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek18);
                    benchData.Week_19_Bench_Hours__c = benchData.Week_19_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek19); 
                    benchData.Week_20_Bench_Hours__c = benchData.Week_20_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek20);
                    benchData.Week_21_Bench_Hours__c = benchData.Week_21_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek21);
                    benchData.Week_22_Bench_Hours__c = benchData.Week_22_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek22);
                    benchData.Week_23_Bench_Hours__c = benchData.Week_23_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek23);
                    benchData.Week_24_Bench_Hours__c = benchData.Week_24_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek24);    
                    benchData.Week_25_Bench_Hours__c = benchData.Week_25_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek25);
                    benchData.Week_26_Bench_Hours__c = benchData.Week_26_Bench_Hours__c - calculateTotalBenchHours(schedule, startDateWeek26);
                    
                    system.debug('Resource--->' + benchData.Resource__c);
                    benchData.Month_1__c = benchData.Month_1__c - calculateTotalBenchHours(schedule, startDateMonth1,startDateMonth2);
                    benchData.Month_2__c = benchData.Month_2__c - calculateTotalBenchHours(schedule, startDateMonth2,startDateMonth3);
                    benchData.Month_3__c = benchData.Month_3__c - calculateTotalBenchHours(schedule, startDateMonth3,startDateMonth4);
                    benchData.Month_4__c = benchData.Month_4__c - calculateTotalBenchHours(schedule, startDateMonth4,startDateMonth5);
                    benchData.Month_5__c = benchData.Month_5__c - calculateTotalBenchHours(schedule, startDateMonth5,startDateMonth6);
                    benchData.Month_6__c = benchData.Month_6__c - calculateTotalBenchHours(schedule, startDateMonth6,startDateMonth6.addMonths(1));
                    
                }
                
                benchDataList.add(benchData);
            }
            
            insert benchDataList;
            
        }
        catch(exception e)
        {
            System.debug('Mihir Test'+e.getMessage()+e.getLineNumber());
        }
    }
    
    global Decimal calculateTotalBenchHours(pse__Schedule__c schedule, DateTime startDateWeek) {
        
        Decimal plannedHours = 0;
        dateTime dStartDate = startDateWeek;
        //scheduleException 
        Boolean bLastDay = false;
        DateTime endDateWeek = startDateWeek.addDays(6); //Not for first week  
        list<pse__Schedule_Exception__c> OExceptionList  =  new list<pse__Schedule_Exception__c>();
        
        
        if(schedule.pse__Schedule_Exceptions__r != null && !schedule.pse__Schedule_Exceptions__r.isEmpty()) {
            OExceptionList.addAll(schedule.pse__Schedule_Exceptions__r);
        }
        
        if(schedule.pse__Start_Date__c >  endDateWeek  || schedule.pse__End_Date__c < dStartDate ){
            return plannedHours;
        }
        
        //Added current date to avoid date.add day issue in sfdc.
        DateTime currentDate = DateTime.newInstance(dStartDate.date(), Time.newInstance(1, 0, 0, 0));
        
        While(!bLastDay) 
        { 
            String dayOfWeek= currentDate.format('EEEE').ToLowerCase();                             
            pse__Schedule_Exception__c OException = new pse__Schedule_Exception__c();
            //Loop throw all the exceptions 
            for(pse__Schedule_Exception__c OTempException : OExceptionList)
            {
                if(OTempException.pse__Date__c <=currentDate.date() && OTempException.pse__End_Date__c >= currentDate.date() )
                {
                    OException = OTempException;
                }               
                
            }
            ///Check for the dayof week and fetch the proper allocation from date
            If(dayOfWeek == 'sunday')
            {
                
                
                If(OException.id != NULL)
                {
                    plannedHours =  plannedHours + OException.pse__Sunday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Sunday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'monday')
            {
                
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Monday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Monday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'tuesday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Tuesday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Tuesday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'wednesday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Wednesday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Wednesday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek =='thursday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Thursday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Thursday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'friday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours =plannedHours +  OException.pse__Friday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Friday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'saturday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Saturday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=currentDate.date() && schedule.pse__End_Date__c >= currentDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Saturday_Hours__c;
                    }
                    
                }
                bLastDay = True;
            }
            
            System.debug('MSTEST:'+dStartDate+':'+dayOfWeek+':'+plannedHours+':'+OException);
            // AddToEstvsActual(dStartDate ,oTCard, oAssign,oSchedule, oResource,  ODailyList );
            currentDate = currentDate.AddDays(1);
        }
        return plannedHours;
    }
    
    
    global Decimal calculateTotalBenchHours(pse__Schedule__c schedule, DateTime startDate, DateTime endDate) {
        
        Decimal plannedHours = 0;
        dateTime dStartDate = startDate;
        list<pse__Schedule_Exception__c> OExceptionList  =  new list<pse__Schedule_Exception__c>();
        
        if(schedule.pse__Start_Date__c >  endDate || schedule.pse__End_Date__c < startDate){
            return plannedHours;
        }
        
        if(schedule.pse__Schedule_Exceptions__r != null && !schedule.pse__Schedule_Exceptions__r.isEmpty()) {
            OExceptionList.addAll(schedule.pse__Schedule_Exceptions__r);
        }
        
        dStartDate = DateTime.newInstance(dStartDate.date(), Time.newInstance(1, 0, 0, 0));
            
        While(endDate > dStartDate) 
        { 
            String dayOfWeek= dStartDate.format('EEEE').ToLowerCase();                             
            pse__Schedule_Exception__c OException = new pse__Schedule_Exception__c();
            //Loop throw all the exceptions 
            for(pse__Schedule_Exception__c OTempException : OExceptionList)
            {
                if(OTempException.pse__Date__c <=dStartDate.date() && OTempException.pse__End_Date__c >= dStartDate.date() )
                {
                    OException = OTempException;
                }               
                
            }
            ///Check for the dayof week and fetch the proper allocation from date
            If(dayOfWeek == 'sunday')
            {
                If(OException.id != NULL)
                {
                    plannedHours =  plannedHours + OException.pse__Sunday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Sunday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'monday')
            {
                
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Monday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Monday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'tuesday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Tuesday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Tuesday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'wednesday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Wednesday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Wednesday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek =='thursday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Thursday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date() )
                    {
                        plannedHours = plannedHours + schedule.pse__Thursday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'friday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours =plannedHours +  OException.pse__Friday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Friday_Hours__c;
                    }
                    
                }
            } else If(dayOfWeek == 'saturday')
            {
                
                If(OException.id != NULL)
                {
                    plannedHours = plannedHours + OException.pse__Saturday_Hours__c;
                }
                Else
                {
                    if(schedule.pse__Start_Date__c <=dStartDate.date() && schedule.pse__End_Date__c >= dStartDate.date())
                    {
                        plannedHours = plannedHours + schedule.pse__Saturday_Hours__c;
                    }
                    
                }
            }
            
            System.debug('StartDate: DayOfWeek : Planned Hours : Schedule Exception--->'+dStartDate+':'+dayOfWeek+':'+plannedHours+':'+OException);
            dStartDate = dStartDate.AddDays(1);
        }
        return plannedHours;
    }
    
    
    
    
    
    global void finish( Database.BatchableContext BC )
    {
        
    }
    
    
    
    
    //retrieve schedules from assignments
    global List<pse__Schedule__c> prepareScheduleList(Set<Id> sIds) {
        return [Select pse__Week_Total_Hours__c, pse__Start_Date__c, pse__Scheduled_Hours__c, pse__End_Date__c,
                pse__Sunday_Hours__c, pse__Monday_Hours__c, pse__Tuesday_Hours__c, pse__Wednesday_Hours__c, pse__Thursday_Hours__c, 
                pse__Friday_Hours__c, pse__Saturday_Hours__c, 
                (Select Id, pse__Resource__c, pse__Resource__r.Name from pse__Assignments__r), 
                (select Id, pse__Schedule__c, Week_Total_Hours__c, pse__Date__c, pse__End_Date__c,
                 pse__Monday_Hours__c, pse__Tuesday_Hours__c, pse__Wednesday_Hours__c, pse__Thursday_Hours__c,pse__Sunday_Hours__c,pse__Saturday_Hours__c,
                 pse__Friday_Hours__c from pse__Schedule_Exceptions__r) 
                from pse__Schedule__c where Id in :sIds];  
    }
    
    //retrieve associated assignments to resource
    public static List<pse__Assignment__c> prepareAssignmentList(Set<Id> contactIds) {
        return  [Select Id, pse__Assignment_Number__c, pse__Schedule__c, pse__Schedule__r.pse__Week_Total_Hours__c,
                 pse__Resource__c, pse__Resource__r.Name, pse__Schedule__r.pse__End_Date__c ,  pse__Schedule__r.No_of_Weeks__c
                 from pse__Assignment__c where pse__Resource__c in :contactIds  ];
        //;and pse__Assignment_Number__c = 'A-0005682'
    }
    
    global Integer getWorkingDaysOfMonth(DateTime gDate)
    {
        Integer monthDays = Date.daysInMonth(gdate.year(), gDate.month());
                
        System.Debug('MonthDays--->'+ monthDays);
        
        Integer workingDays = 0;
        
        DateTime currentDate = DateTime.newInstance(gdate.year(), gDate.month(), 1,1,0,0);
        DateTime endDate = currentDate.addDays(monthDays-1);
        while (currentDate <= endDate) {
            if (!currentDate.format('E').equalsIgnoreCase('Sat') && !currentDate.format('E').equalsIgnoreCase('Sun')){
                workingDays = workingDays + 1;
            }
            currentDate = currentDate.addDays(1);
        }
        System.Debug('workingDays--->'+ workingDays);
        return workingDays;

    }
}