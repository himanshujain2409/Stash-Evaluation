global class APTPS_BenchDataUtilitySchedule  implements schedulable{

 	global void execute(SchedulableContext ctx) {
 		 APTPS_BenchDataUtility oBatch = new APTPS_BenchDataUtility();
         database.executeBatch(oBatch,10);
 	}
}