public class ST_Utilities {
  // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
  public static string getCreatableFieldsSOQL(String objectName, String whereClause){
    String selects = '';
      if (whereClause == null || whereClause == ''){
        return null;
      }
      // Get a map of field name and field token
      Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
      list<string> selectFields = new list<string>();
      if (fMap != null){
        for (Schema.SObjectField ft : fMap.values()){
           // loop through all field tokens (ft)
             Schema.DescribeFieldResult fd = ft.getDescribe();
             // describe each field (fd)
             if (fd.isCreateable()){
               // field is creatable
               selectFields.add(fd.getName());
             }
         }
      }
      if (!selectFields.isEmpty()){
        for (string s:selectFields){
          selects += s + ',';
        }
      if (selects.endsWith(',')){
        selects = selects.substring(0,selects.lastIndexOf(','));
      }
    }
    return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
  }

  public static sObject Populate_sObject(sObject target)
  {
    map<String, Schema.SObjectField> fieldMap = target.getSObjectType().getDescribe().fields.getMap();
    for(Schema.SObjectField field : fieldMap.values())
        {
         if(!field.getDescribe().isNillable() && field.getDescribe().isUpdateable()
           && !field.getDescribe().isDefaultedOnCreate() )
         {
           if(field.getDescribe().getType() == Schema.Displaytype.Boolean)
              target.put(field.getDescribe().getName(), true);
            else if(field.getDescribe().getType() == Schema.Displaytype.Combobox)
              target.put (field.getDescribe().getName(), 'Anything');
      else if(field.getDescribe().getType() == Schema.Displaytype.Currency)
              target.put (field.getDescribe().getName(), 5000);
      else if(field.getDescribe().getType() == Schema.Displaytype.Date)
              target.put (field.getDescribe().getName(), Date.today().addDays(30));
      else if(field.getDescribe().getType() == Schema.Displaytype.DateTime)
              target.put (field.getDescribe().getName(), DateTime.now().addDays(30));
      else if(field.getDescribe().getType() == Schema.Displaytype.Double ||
        field.getDescribe().getType() == Schema.Displaytype.Percent)
              target.put (field.getDescribe().getName(), 0.5);
      else if(field.getDescribe().getType() == Schema.Displaytype.Email)
              target.put (field.getDescribe().getName(), 'email@test.com');
       else if(field.getDescribe().getType() == Schema.Displaytype.Integer)
              target.put (field.getDescribe().getName(), 55);
            else if(field.getDescribe().getType() == Schema.Displaytype.Phone ||
              field.getDescribe().getType() == Schema.Displaytype.String ||
              field.getDescribe().getType() == Schema.Displaytype.TextArea)
              target.put (field.getDescribe().getName(), 'Text value');
            else if(field.getDescribe().getType() == Schema.Displaytype.Picklist ||
              field.getDescribe().getType() == Schema.Displaytype.MultiPicklist)
              target.put (field.getDescribe().getName(), getPicklistVal(field));
            else if(field.getDescribe().getType() == Schema.Displaytype.Time)
              target.put (field.getDescribe().getName(), 60);

         }
        }
        return target;
  }

  public static string getPicklistVal(SObjectField field)
  {
    Schema.DescribeFieldResult fieldRes = field.getDescribe();
    List<Schema.PicklistEntry> pickVals = fieldRes.getPicklistValues();
    if(pickVals.size() > 0)
      return pickVals[0].getValue();
    else
      return 'None';
  }
}