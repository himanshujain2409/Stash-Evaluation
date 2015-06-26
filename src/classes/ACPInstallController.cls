/*
* Controller for ApttusCustomerPortalInstall page
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/ 
global with sharing class ACPInstallController {
        
    /* packages to display on the view */
    public List<PackageWrapper> packagesToDisplay{get; set;}
    
    /* category selected */
    public String categorySelected{
        get{
            Map<String, String> categories = getCategoriesMap();
            if(!categories.containsKey(categorySelected))
                return categories.values()[0];
            
            return categorySelected;
        }
        
        set;
    }
    
    /* categories to display */
    public List<String> categoriesToDisplay{
        get{
            return getCategoriesList();
        }
        private set;
    }
    
    /* the id of the pacackage version the user selected */
    public String packageVersionId {get; set;}
    
    /* the url of the package the user selected */
    public String packageUrl{get; set;}
    
    /* if the package is for sandbox or production */
    public String sandboxOrProdution{get; set;}
    
    /* helper variables */
    private List<sfLma__License__c> userLicenses;
    private String url1;
    private Map<Id, PackageWrapper> userPackagesMap;
    private Map<Id, PackageWrapper> latestPackagesUserDoesntHave;
    
    
    /* get the sorted list to display in the constructor */
    
    public ACPInstallController(){
        packagesToDisplay = sortResult();
    }
    
    /* helper method to get the categories defined */
    private List<String> getCategoriesList(){
        List<String> result = new List<String>();
        List<Schema.PicklistEntry> catList = sfLma__Package__c.Category__c.getDescribe().getPicklistValues();
        
        for(Schema.PicklistEntry pick : catList){
            result.add(pick.getValue());
        }
        
        return result;
    }
    
    /* helper method to get a categories map */
    private Map<String, String> getCategoriesMap(){
        List<String> categoriesList = getCategoriesList();
        Map<String, String> result = new Map<String, String>();
        
        for(String s : categoriesList){
            result.put(s,s);
        }
        
        return result;
    }
    
    /* track the information about the downloads a user does (packages) */
    
    public PageReference download(){
        
        /* redirect to the package url */
        PageReference pagRef = null;
        
        try{
            pagRef = new PageReference(packageUrl);
        }catch(Exception ex){
            pagRef = null;
        }
        
        List<sfLma__Package_Version__c> packageVersions = [SELECT sfLma__Package__r.Name, sfLma__Version__c, Name, sfLma__Package__r.Customer_Portal_Information__c, Customer_Portal_Information__c FROM sfLma__Package_Version__c WHERE id =:packageVersionId AND sfLma__Package__r.Show_On_Customer_Portal__c = true];
        
        if(packageVersions == null || packageVersions.size() < 1){
            return pagRef;
        }
        
        
        /* save the track informtation */
        ACP_Package_Download__c download = new ACP_Package_Download__c(
            Account__c = ACPUtils.getCurrentUser().Contact.AccountId,
            Package_Version__c = packageVersionId,
            User__c = ACPUtils.getCurrentUser().Id,
            Version__c = packageVersions[0].sfLma__Version__c,
            Name__c = packageVersions[0].sfLma__Package__r.Name,
            Enviroment__c = sandboxOrProdution
        );
        
        insert download;
        
       /* if(!packageUrl.containsIgnoreCase('mailTo')){
        
            // send email with suggested training and documentation
            ACPInstallHelper.emailWithSuggestedTrainingAndDocumentation(ACPUtils.getCurrentUser(), packageVersionId);
        }*/

        return pagRef;
    }
    
    /* track the information about the packages the user ask for */
    
    public void askForTrack(){
        
        List<sfLma__Package_Version__c> packageVersions = [SELECT sfLma__Package__r.Name, sfLma__Version__c, Name, sfLma__Package__r.Customer_Portal_Information__c, Customer_Portal_Information__c FROM sfLma__Package_Version__c WHERE id =:packageVersionId AND sfLma__Package__r.Show_On_Customer_Portal__c = true];
        
        
        /* save the track informtation */
        ACP_Package_Download__c download = new ACP_Package_Download__c(
            Account__c = ACPUtils.getCurrentUser().Contact.AccountId,
            Package_Version__c = packageVersionId,
            User__c = ACPUtils.getCurrentUser().Id,
            Version__c = packageVersions[0].sfLma__Version__c,
            Name__c = packageVersions[0].sfLma__Package__r.Name,
            Enviroment__c = sandboxOrProdution
        );
        
        insert download;
        
       /* if(!packageUrl.containsIgnoreCase('mailTo')){
        
            //send email with suggested training and documentation 
            ACPInstallHelper.emailWithSuggestedTrainingAndDocumentation(ACPUtils.getCurrentUser(), packageVersionId);
        }*/
    }
    
    /* track the infromtation about the downloads a user does (executables) */
    
    public PageReference downloadExe(){
        
        /* redirect to the package url */
        PageReference pagRef = null;
        
        try{
            pagRef = new PageReference(packageUrl);
        }catch(Exception ex){
            pagRef = null;
        }
        
        List<ACP_Executable_File__c> executables = [SELECT Customer_Portal_Version__c, Name, Customer_Portal_Information__c FROM ACP_Executable_File__c WHERE id =:packageVersionId];
        
        if(executables == null || executables.size() < 1){
            return pagRef;
        }
        
        /* save the track informtation */
        ACP_Package_Download__c download = new ACP_Package_Download__c(
            Account__c = ACPUtils.getCurrentUser().Contact.AccountId,
            Executable_File__c = packageVersionId,
            User__c = ACPUtils.getCurrentUser().Id,
            Version__c = executables[0].Customer_Portal_Version__c,
            Name__c = executables[0].Name,
            Enviroment__c = sandboxOrProdution
        );
        
        insert download;

        /* send email with suggested training and documentation */
       // ACPInstallHelper.emailWithSuggestedTrainingAndDocumentationExe(ACPUtils.getCurrentUser(), packageVersionId);
        
        return pagRef;
    }
    
    
    /* get the current user licenses */
    
    private List<sfLma__License__c> getUserLicenses(){
        
        
        /* return the cached list if exists */
        
        if(userLicenses != null){
            return userLicenses;
        }
        
        
        /* get the current user */
        
        User currentUser = ACPUtils.getCurrentUser();
        url1 = URL.getCurrentRequestUrl().toExternalForm();
        
        /* get the user licenses with the packages and packages version info */
        System.debug('$$$UserType'+UserInfo.getUserType());
       // If(url1.contains('sfdc.tabName'))
        If(UserInfo.getUserType() == 'Standard')
        {
             userLicenses = [    
                            SELECT  sfLma__Package_Version__r.sfLma__Package__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Name,
                                    sfLma__Package_Version__r.sfLma__Version__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Customer_Portal_Information__c,
                                    sfLma__Package_Version__r.Customer_Portal_Package_Url__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Latest_Package_Version__c,
                                    sfLma__Package_Version__r.sfLma__Release_Date__c,
                                    sfLma__Package_Version__r.Customer_Portal_Information__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Category__c
                            FROM    sfLma__License__c
                            WHERE   sfLma__Account__r.Name ='Apttus Corporation' AND
                                    sfLma__Package_Version__r.sfLma__Package__r.Show_On_Customer_Portal__c = true
                                    ORDER BY CreatedDate DESC
                        ];
        }
        else
        {
                
        userLicenses = [    
                            SELECT  sfLma__Package_Version__r.sfLma__Package__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Name,
                                    sfLma__Package_Version__r.sfLma__Version__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Customer_Portal_Information__c,
                                    sfLma__Package_Version__r.Customer_Portal_Package_Url__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Latest_Package_Version__c,
                                    sfLma__Package_Version__r.sfLma__Release_Date__c,
                                    sfLma__Package_Version__r.Customer_Portal_Information__c,
                                    sfLma__Package_Version__r.sfLma__Package__r.Category__c
                            FROM    sfLma__License__c
                            WHERE   sfLma__Account__c = :currentUser.Contact.AccountId AND
                                    sfLma__Package_Version__r.sfLma__Package__r.Show_On_Customer_Portal__c = true
                            ORDER BY CreatedDate DESC
                        ];
                        
           }
        return userLicenses;
    }
    
    
    /* get the latest package the user has */
    
    private Map<Id, PackageWrapper> getUserPackages(){
        
        
        /* return the cached list if exists */
        
        if(userPackagesMap != null){
            return userPackagesMap;
        }
        
        
        /* 
         * map of packages to return 
         * Map<Id of the package, PackageWrapper>
        */
        
        Map<Id, PackageWrapper> packagesToReturnMap = new Map<Id, PackageWrapper>();
        
        
        /* create the user packages from the license object */
        
        for(sfLma__License__c license : getUserLicenses()){
            
            
            /* don't add a package that is already in the collection except if is the latest version */
            
            if(!packagesToReturnMap.containsKey(license.sfLma__Package_Version__r.sfLma__Package__c) ||
                license.sfLma__Package_Version__c == license.sfLma__Package_Version__r.sfLma__Package__r.Latest_Package_Version__c){
            
                PackageWrapper wrapper = new PackageWrapper();
                wrapper.title = license.sfLma__Package_Version__r.sfLma__Package__r.name;
                wrapper.version = license.sfLma__Package_Version__r.sfLma__Version__c;
                wrapper.information = license.sfLma__Package_Version__r.sfLma__Package__r.Customer_Portal_Information__c;
                wrapper.releaseDate = license.sfLma__Package_Version__r.sfLma__Release_Date__c;
                wrapper.downloadLink = license.sfLma__Package_Version__r.Customer_Portal_Package_Url__c;
                wrapper.packageCategory = license.sfLma__Package_Version__r.sfLma__Package__r.Category__c;
                wrapper.downloadText = Label.ACPInstallPackageDownloadButton;
                wrapper.userHasThisPackage = true;
                wrapper.packageVersionId = license.sfLma__Package_Version__c;
                wrapper.versionInformation = license.sfLma__Package_Version__r.Customer_Portal_Information__c;
                
                /* check if user has the latest version */
                
                if(license.sfLma__Package_Version__c == license.sfLma__Package_Version__r.sfLma__Package__r.Latest_Package_Version__c){
                    wrapper.userHasLatestVersion = true;
                    wrapper.isLatestVersion = true;
                }
                
                packagesToReturnMap.put(license.sfLma__Package_Version__r.sfLma__Package__c, wrapper);
            }
        }
        
        
        /* cache the collection */
        
        userPackagesMap = packagesToReturnMap; 
        
        return userPackagesMap; 
    }
    
    
    /* 
     *  get the latest package version ids the user doesn't have of
     *  the package the user has.
     */
    
    private Set<Id> getLatestPackageVersionIdsUserDoesntHave(){
        
        
        /* set of ids to return */
        
        Set<Id> idsToReturn = new Set<Id>();
        
        
        /* ids of package version the user already has */
        
        Set<Id> idsUserAlreadyHas = new Set<Id>();
        
        
        for(sfLma__License__c license : getUserLicenses()){
            
            idsUserAlreadyHas.add(license.sfLma__Package_Version__c);   
        }
        
        
        /* search for the ids of the latest packages version the user doesn't have */
        
        List<sfLma__Package__c> packages = [SELECT Latest_Package_Version__c FROM sfLma__Package__c WHERE Latest_Package_Version__c != :idsUserAlreadyHas AND Show_On_Customer_Portal__c = true];
        
        for(sfLma__Package__c p : packages){
            
            idsToReturn.add(p.Latest_Package_Version__c);
        }
        
        return idsToReturn;
    }
    

    /* get the package with the latest version the user doesn't have */
    
    private Map<Id, PackageWrapper> getLatestPackagesUserDoesntHave(){
        
        
        /* return the cached map if exists */
        
        if(latestPackagesUserDoesntHave != null){
            return latestPackagesUserDoesntHave;
        }
        
        
        /* Map to return */
        
        Map<Id, PackageWrapper> packagesMapToReturn = new Map<Id, PackageWrapper>();
        
        
        List<sfLma__Package_Version__c> packageVersion;
        
        
        /* get the user licenses with the packages and packages version info */
                
        packageVersion = [  
                            SELECT  sfLma__Package__c,
                                    sfLma__Package__r.Name,
                                    sfLma__Version__c,
                                    sfLma__Package__r.Customer_Portal_Information__c,
                                    Customer_Portal_Package_Url__c,
                                    sfLma__Package__r.Latest_Package_Version__c,
                                    sfLma__Release_Date__c,
                                    Customer_Portal_Information__c,
                                    sfLma__Package__r.Category__c
                            FROM    sfLma__Package_Version__c
                            WHERE   Id = :getLatestPackageVersionIdsUserDoesntHave() AND
                                    sfLma__Package__r.Show_On_Customer_Portal__c = true
                            
                            ORDER BY CreatedDate DESC
                        ];
        
        
        /* create the wrapper for every package */
        
        for(sfLma__Package_Version__c version : packageVersion){

            PackageWrapper wrapper = new PackageWrapper();
            wrapper.title = version.sfLma__Package__r.name;
            wrapper.version = version.sfLma__Version__c;
            wrapper.information = version.sfLma__Package__r.Customer_Portal_Information__c;
            wrapper.downloadLink = 'mailTo:' + Label.ACPInstallPackageContactSalesEmail + '?subject=' + Label.ACPInstallPackageContactSalesEmailSubject + '&body=' + Label.ACPInstallPackageContactSalesEmailBody;
            wrapper.releaseDate = version.sfLma__Release_Date__c;
            wrapper.packageCategory = version.sfLma__Package__r.Category__c;
            wrapper.downloadText = Label.ACPInstallPackageContactSalesButton;
            wrapper.userHasLatestVersion = false;
            wrapper.isLatestVersion = true;
            wrapper.packageVersionId = version.id;
            wrapper.versionInformation = version.Customer_Portal_Information__c;
            
            
            /* check if the user has this package */
            
            if(getUserPackages().containsKey(version.sfLma__Package__c)){
                wrapper.userHasThisPackage = true;
                wrapper.downloadLink = version.Customer_Portal_Package_Url__c;
                wrapper.downloadText = Label.ACPInstallPackageDownloadButton;
                
                /* add this wrapper to the user package wrapper */
                
                getUserPackages().get(version.sfLma__Package__c).latestVersion = wrapper;
            }
            
            packagesMapToReturn.put(version.sfLma__Package__c, wrapper);
        }
        
        
        /* cache the map */
        
        latestPackagesUserDoesntHave = packagesMapToReturn;
        
        return packagesMapToReturn;
    }
    
    
    /* get all the installers to download */
    
    private List<PackageWrapper> getInstallers(){
        
        List<ACP_Executable_File__c> executables = [SELECT Name, Customer_Portal_File_Url__c, Customer_Portal_Information__c, Customer_Portal_Release_Date__c, Customer_Portal_Version__c, Customer_Portal_Category__c FROM ACP_Executable_File__c LIMIT 1000];
        
        List<PackageWrapper> exeWrappers = new List<PackageWrapper>();
        
        for(ACP_Executable_File__c exe : executables){
            
            PackageWrapper wrapper = new PackageWrapper();
            wrapper.title = exe.name;
            wrapper.version = exe.Customer_Portal_Version__c;
            wrapper.information = exe.Customer_Portal_Information__c;
            wrapper.downloadLink = exe.Customer_Portal_File_Url__c;
            wrapper.releaseDate = exe.Customer_Portal_Release_Date__c;
            wrapper.downloadText = Label.ACPInstallDownloadExecutableButton;
            wrapper.packageCategory = exe.Customer_Portal_Category__c;
            wrapper.packageVersionId = exe.id;
            wrapper.userHasLatestVersion = true;
            wrapper.isLatestVersion = true;
            wrapper.userHasThisPackage = true;
            wrapper.isExecutable = true;
            exeWrappers.add(wrapper);
        }
        
        return exeWrappers;
    }
    
    
    /* sort the results to display */
    
    private List<PackageWrapper> sortResult(){
        
        /* collection to return */
        
        List<PackageWrapper> packagesToReturn = new List<PackageWrapper>();
        
        
        /* add the packages the user has */
        
        packagesToReturn.addAll(getUserPackages().values());
        
        
        /* add the packages the user doesn't have*/
        
        packagesToReturn.addAll(getLatestPackagesUserDoesntHave().values());
        
        
        /* add the executables files */
        
        packagesToReturn.addAll(getInstallers());
        
        
        /* sort the collection */
        
        packagesToReturn.sort();
        
        
        return packagesToReturn;
    }
    
    
    /* wrapper class for the package information */
    
    global class PackageWrapper implements Comparable{
        
        public Boolean isVisible{
            
            get{return !(userHasThisPackage && isLatestVersion && !userHasLatestVersion);}
            
            private set;
        }
        
        public String title{get; private set;}
        public String version{get; private set;}
        public String information{get; private set;}
        public String versionInformation{get; private set;}
        public String downloadLink{get; private set;}
        public String downloadText{get; private set;}
        public String packageCategory{get; private set;}
        public Date releaseDate{get; private set;}
        public Boolean userHasThisPackage{get; private set;}
        public Boolean userHasLatestVersion{get; private set;}
        public Boolean isLatestVersion{get; private set;}
        public PackageWrapper latestVersion{get; private set;}
        public Id packageVersionId{get; private set;}
        public Boolean isExecutable{get; private set;}
        
        public PackageWrapper(){
            title = '';
            version = '';
            information = '';
            versionInformation = '';
            downloadLink = '';
            downloadText = '';
            packageCategory = '';
            releaseDate = null;
            userHasThisPackage = false;
            userHasLatestVersion = false;
            isLatestVersion = false;
            isVisible = false;
            latestVersion = null;
            packageVersionId = null;
            isExecutable = false;
        }
        
        
        /* Implement the compareTo() method */ 
    
        global Integer compareTo(Object compareTo) {
            PackageWrapper compareToWrapper = (PackageWrapper)compareTo;
            
            return title.compareTo(compareToWrapper.title);    
        }
    }
}