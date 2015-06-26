public with sharing class ReportUtils {
   
   private Static List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};

   public static Set<ID> getRoleSubordinateUsers(Id userId) {
 
      // get requested user's role
      Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
      // get all of the roles underneath the user
      Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
      // get all of the ids for the users in those roles
      Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :allSubRoleIds and IsActive=true and Profile.UserLicense.Name='Salesforce' limit 50000]);
      // return the ids as a set so you can do what you want with them
      return users.keySet();
    
   }
     
   private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
 
      Set<ID> currentRoleIds = new Set<ID>();
      String q = 'select Id, ParentRoleID from UserRole';
      // Get describe object for UserRole
      Map<String, Schema.SObjectField> fieldMap = UserRole.getSObjectType().getDescribe().fields.getMap();
      for(Schema.SObjectField field : fieldMap.values())
      {
         if(field.getDescribe().getName()=='PortalRole')
            q += ' where PortalRole=null';
      }
      List<UserRole> roles = Database.query(q);

      boolean newRole = true; 
      currentRoleIds.addAll(roleIds);
      // get all of the roles underneath the passed roles
      while(newRole){
         newRole = false;
         for(UserRole userRole :roles){
            if(currentRoleIds.contains(userRole.ParentRoleId) && !currentRoleIds.contains(userRole.Id)){ newRole = true;currentRoleIds.add(userRole.Id);}
         }
      }
      return currentRoleIds;
   }
   
   public static Integer calWorkingDays(Date sdate, Date edate)
   {
      Integer i = 0;
      while (sdate <= edate) {
         if (calculateDayOfWeek(sdate) != 'Saturday' && calculateDayOfWeek(sdate) != 'Sunday'){
            i++;
         }
         sdate = sdate.addDays(1);
      }
      return i;
   }
   
   public static String calculateDayOfWeek(Date d){
      Date startDate = date.newInstance(0001, 1, 1);
      Integer remainder = Math.mod(startDate.daysBetween(d) , 7);  
      return listDay.get(remainder);
   }
   
   private static testMethod void testCalWorkdingDays()
   {
      Date sdate = System.today()-10;
      Date edate = System.today();
      ReportUtils.calWorkingDays(sdate, edate);
   }
}