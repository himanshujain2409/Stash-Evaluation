/*Developed by : Vrajesh Sheth
* Primary function is to set price list to Apttus Current Price List Feb 2013
*/
trigger APTPS_Opportunity on Opportunity (before insert) {
   
    Map<id,User> mapOfUser=new map<id,User>([select id, Region__c from User where isActive=true]);

     for(Opportunity Opp: trigger.new){
        if(mapOfUser.containsKey(Opp.CreatedById) && mapOfUser.get(Opp.CreatedById).Region__c!=null)
            Opp.User_Region__c=mapOfUser.get(Opp.CreatedById).Region__c;
    }

    if(trigger.isbefore && trigger.isinsert){
        String PRICE_LIST = 'Apttus Price List 2013';
        list<Apttus_Config2__PriceList__c> priceListList = new list<Apttus_Config2__PriceList__c>();
        
        //1.Get all the pricelist  in one list
        priceListList = [SELECT id
                                ,Name
                         FROM Apttus_Config2__PriceList__c
                         WHERE (name=:PRICE_LIST or name = 'Apttus Current Price List Feb 2013')];
       //2.assign the pricelist id to opportunity
       for(Opportunity opp : trigger.new){
           for(Apttus_Config2__PriceList__c priceList : priceListList ){
               if(PRICE_LIST == priceList.name){
                   opp.Price_List__c = priceList.id;
               }
           }
       }                  
    }

}