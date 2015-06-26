/**
 *  Apttus Approvals Management
 *  CustomApprovalsTestSupport
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public with sharing class CustomApprovalsTestSupport {

    /**
     * Creates a product for the given user
     * @param user the user to create the product for
     * @param productName the product name
     * @param productCode the product code
     * @param productFamily the product family
     * @param productDesc the product description
     * @return the product
     */
    public static Product2 createProduct(User user, 
                                         String productName, 
                                         String productCode, 
                                         String productFamily, 
                                         String productDesc) {
        
        // create a new product
        Product2 productSO = new Product2(Name=productName);
        
        // setup product data
        
        // product code
        productSO.ProductCode = productCode;
        // product family
        productSO.Family = productFamily;
        // description
        productSO.Description = productDesc;
        
        // insert product
        insert productSO;
        
        System.assert(productSO.Id != null, 'Failed to create the product for owner ' + user.Id);
        
        return productSO;
        
    } 
    
    /**
     * Creates a price list for the given user
     * @param user the user to create the price list for
     * @param priceListName the price list name
     * @param priceListDesc the price list description
     * @param effectiveDate the price list effective date
     * @param expirationDate the price list expiration date
     * @return the price list
     */
    public static Apttus_Config2__PriceList__c createPriceList(User user, 
                                                           String priceListName, 
                                                           String priceListDesc,
                                                           Date effectiveDate,
                                                           Date expirationDate) {
        
        // create a new pricelist
        Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(Name = priceListName, OwnerId = user.Id);
        
        // setup price list data
        
        // description
        priceListSO.Apttus_Config2__Description__c = priceListDesc;
        // effective date
        priceListSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        priceListSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        // active
        priceListSO.Apttus_Config2__Active__c = true;
        
        // insert price list
        insert priceListSO;
        
        System.assert(priceListSO.Id != null, 'Failed to create the price list for owner ' + user.Id);
            
        return priceListSO;
        
    } 
    
    /**
     * Creates a price list item for the given user
     * @param user the user to create the price list item for
     * @param priceListId the price list Id
     * @param productId the product Id
     * @param chargeType the charge type
     * @param priceType the price type
     * @param priceMethod the price method
     * @param listPrice the list price
     * @param minPrice the minimum price
     * @param maxPrice the maximum price
     * @param minMaxPriceAppliesTo the minmax price applies to
     * @param effectiveDate the entry effective date
     * @param expirationDate the entry expiration date
     * @return the price list item
     */
    public static Apttus_Config2__PriceListItem__c createPriceListItem(User user, 
                                                                   ID priceListId,
                                                                   ID productId, 
                                                                   String chargeType,
                                                                   String priceType,
                                                                   String priceMethod,
                                                                   Decimal listPrice,
                                                                   Decimal minPrice,
                                                                   Decimal maxPrice,
                                                                   String minMaxPriceAppliesTo,
                                                                   Date effectiveDate,
                                                                   Date expirationDate) {
        
        // create a new pricelist item
        Apttus_Config2__PriceListItem__c itemSO = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceListId);
        
        // setup price list entry data
        
        // product id
        itemSO.Apttus_Config2__ProductId__c = productId;
        // charge type
        itemSO.Apttus_Config2__ChargeType__c = chargeType;
        // price type
        itemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        itemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // list price
        itemSO.Apttus_Config2__ListPrice__c = listPrice;
        // min price
        itemSO.Apttus_Config2__MinPrice__c = minPrice;
        // max price
        itemSO.Apttus_Config2__MaxPrice__c = maxPrice;
        // max price
        itemSO.Apttus_Config2__MinMaxPriceAppliesTo__c = minMaxPriceAppliesTo;
        // effective date
        itemSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        itemSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        
        // insert price list item
        insert itemSO;
        
        System.assert(itemSO.Id != null, 'Failed to create the price list item for owner ' + user.Id);
            
        return itemSO;
        
    } 
    
    /**
     * Creates a price book entry for the given user
     * @param user the user to create the price book entry for
     * @param pricebookId the price book id
     * @param productId the product Id
     * @param unitPrice the unit price
     * @return the price book entry
     */
    public static PricebookEntry createPricebookEntry(User user, 
                                                      Id pricebookId, 
                                                      Id productId, 
                                                      Decimal unitPrice) {
        
        // create a new price book entry
        PricebookEntry entrySO = new PricebookEntry(Pricebook2Id = pricebookId);
        
        // product
        entrySO.Product2Id = productId; 
        // standard price
        entrySO.UseStandardPrice = false;
        // zero unit price
        entrySO.UnitPrice = 0;
        // active
        entrySO.IsActive = true;
            
        // insert price book entry
        insert entrySO;
        
        System.assert(entrySO.ID != null, 'Failed to create the price book entry for owner ' + user.Id);
            
        return entrySO;
        
    } 
    
    /**
     * Creates an agreement for the given user
     * @param user the user to create the agreement for
     * @param agmtName the agreement name
     * @param opptyId the related opportunity id
     * @param startDate the contract start date
     * @param endDate the contract end date
     * @return the agreement
     */
    public static Apttus__APTS_Agreement__c createAgreement(User user, 
                                                        String agmtName, 
                                                        ID opptyId,
                                                        Date startDate, 
                                                        Date endDate) {
        
        // create a new agreement
        Apttus__APTS_Agreement__c agreementSO = new Apttus__APTS_Agreement__c(Name=agmtName, OwnerId = user.Id);
        // setup agreement data
        
        // opportunity
        agreementSO.Apttus__Related_Opportunity__c = opptyId;
        // category
        agreementSO.Apttus__Agreement_Category__c = 'Other';
        // start date
        agreementSO.Apttus__Contract_Start_Date__c = startDate;
        // end date
        agreementSO.Apttus__Contract_End_Date__c = endDate;
        // requestor
        agreementSO.Apttus__Requestor__c = user.ID;
        // contract value
        agreementSO.Apttus__Total_Contract_Value__c = 25000;
        
        // insert agreement
        insert agreementSO;
        
        System.assert(agreementSO.Id != null, 'Failed to create the agreement for owner ' + user.Id);
            
        return agreementSO;
        
    } 
    
    /**
     * Creates a product configuration for the given user
     * @param user the user to create the product configuration for
     * @param configName the configuration name
     * @param versionNbr the version number
     * @param bObjectId the business object id
     * @param bObjectType the business object type
     * @param groupType the summary group type
     * @param priceListId the price list Id
     * @param ancestorId the ancestor id
     * @param status the configuration status
     * @param finalizedDate the finalized date
     * @param effectiveDate the effective date
     * @param isTransient the transient configuration indicator
     * @param configDesc the configuration description
     * @return the product configuration group
     */
    public static Apttus_Config2__ProductConfiguration__c createProductConfiguration(User user, 
                                                                                 String configName,
                                                                                 Integer versionNbr,
                                                                                 ID bObjectId,
                                                                                 String bObjectType,
                                                                                 String groupType,
                                                                                 ID priceListId, 
                                                                                 ID ancestorId, 
                                                                                 String status, 
                                                                                 Datetime finalizedDate, 
                                                                                 Datetime effectiveDate, 
                                                                                 Boolean isTransient,
                                                                                 String configDesc) {
        
        // create a new classification name
        Apttus_Config2__ProductConfiguration__c configSO = new Apttus_Config2__ProductConfiguration__c(Name = configName, OwnerId = user.Id);
        
        // setup product configuration data
        
        // version number
        configSO.Apttus_Config2__VersionNumber__c = versionNbr;
        // summary group type
        configSO.Apttus_Config2__SummaryGroupType__c = groupType;
        // business object 
        configSO.Apttus_Config2__BusinessObjectId__c = bObjectId;
        // business object type
        configSO.Apttus_Config2__BusinessObjectType__c = bObjectType;
        // price list id
        configSO.Apttus_Config2__PriceListId__c = priceListId;
        // ancestor id
        configSO.Apttus_Config2__AncestorId__c = ancestorId;
        // status 
        configSO.Apttus_Config2__Status__c = status;
        // is transient
        configSO.Apttus_Config2__IsTransient__c = isTransient;
        // finalized date
        configSO.Apttus_Config2__FinalizedDate__c = finalizedDate;
        // effective date
        configSO.Apttus_Config2__EffectiveDate__c = effectiveDate; 
        // description
        configSO.Apttus_Config2__Description__c = configDesc;
        
        // insert product configuration
        insert configSO;
        
        System.assert(configSO.Id != null, 'Failed to create the product configuration for owner ' + user.Id);
            
        return configSO;
        
    } 
    
    /**
     * Creates a line item for the given user
     * @param user the user to create the line item for
     * @param configId the product configuration Id
     * @param groupId the summary group id
     * @param lineNumber the line number
     * @param isPrimaryLine the primary line indicator
     * @param itemSeq the item sequence
     * @param lineType the line type
     * @param productId the product Id
     * @param customizable the product customizable indicator
     * @param productOptionId the product option Id
     * @param optionId the option Id
     * @param classId the leaf classification id
     * @param classHierarchy the classification hierarchy
     * @param quantity the line quantity
     * @param isQtyModifiable the quantity modifiable indicator
     * @param uom the unit of measure
     * @param term the term
     * @param priceListId the price list Id
     * @param plItemId the price list item id
     * @param priceType the price type
     * @param priceMethod the price method
     * @param chargeType the charge type
     * @param frequency the frequency
     * @param allowManualAdj the manual adjustment indicator
     * @param allocateGroupAdj the allocate group adjustment indicator
     * @param listPrice the list price
     * @param basePrice the base price
     * @param basePriceMethod the base price method
     * @param baseExtPrice the base extended price
     * @param optionPrice the option price
     * @param extPrice the extended price
     * @param lineDesc the line item description
     * @return the line item
     */
    public static Apttus_Config2__LineItem__c createLineItem(User user, 
                                                         ID configId,
                                                         ID groupId,
                                                         Integer lineNumber,
                                                         Boolean isPrimaryLine,
                                                         Integer itemSeq,
                                                         String lineType,
                                                         ID productId,
                                                         Boolean customizable,
                                                         ID productOptionId,
                                                         ID optionId,
                                                         ID classId,
                                                         String classHierarchy,
                                                         Decimal quantity,
                                                         Boolean isQtyModifiable,
                                                         String uom,
                                                         Integer term,
                                                         ID priceListId,
                                                         ID plItemId,
                                                         String priceType,
                                                         String priceMethod,
                                                         String chargeType,
                                                         String frequency,
                                                         Boolean allowManualAdj,
                                                         Boolean allocateGroupAdj,
                                                         Decimal listPrice,
                                                         Decimal basePrice,
                                                         String basePriceMethod,
                                                         Decimal baseExtPrice,
                                                         Decimal optionPrice,
                                                         Decimal extPrice,
                                                         String lineDesc) {
        
        // create a new line item
        Apttus_Config2__LineItem__c lineItemSO = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configId);
        
        // setup line item data
        
        // line number
        lineItemSO.Apttus_Config2__LineNumber__c = lineNumber;
        // primary line
        lineItemSO.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        if (isPrimaryLine) {
            lineItemSO.Apttus_Config2__PrimaryLineNumber__c = lineNumber;
        }
        // item sequence
        lineItemSO.Apttus_Config2__ItemSequence__c = itemSeq;
        // summary group id
        lineItemSO.Apttus_Config2__SummaryGroupId__c = groupId;
        // line type
        lineItemSO.Apttus_Config2__LineType__c = lineType;
        // product id
        lineItemSO.Apttus_Config2__ProductId__c = productId;
        // customizable
        lineItemSO.Apttus_Config2__Customizable__c = customizable;
        // product option id
        lineItemSO.Apttus_Config2__ProductOptionId__c = productOptionId;
        // option id
        lineItemSO.Apttus_Config2__OptionId__c = optionId;
        // classification id
        lineItemSO.Apttus_Config2__ClassificationId__c = classId;
        // classification hierarchy
        lineItemSO.Apttus_Config2__ClassificationHierarchy__c = classHierarchy;
        // quantity
        lineItemSO.Apttus_Config2__Quantity__c = quantity;
        // quantity modifiable
        lineItemSO.Apttus_Config2__IsQuantityModifiable__c = isQtyModifiable;
        // uom
        lineItemSO.Apttus_Config2__Uom__c = uom;
        // term
        lineItemSO.Apttus_Config2__Term__c = term;
        // price list id
        lineItemSO.Apttus_Config2__PriceListId__c = priceListId;
        // price list item id
        lineItemSO.Apttus_Config2__PriceListItemId__c = plItemId;
        // price type
        lineItemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        lineItemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // charge type
        lineItemSO.Apttus_Config2__ChargeType__c = chargeType;
        // frequency
        lineItemSO.Apttus_Config2__Frequency__c = frequency;
        // allow manual adjustment
        lineItemSO.Apttus_Config2__AllowManualAdjustment__c = allowManualAdj;
        // allocate group adjustment
        lineItemSO.Apttus_Config2__AllocateGroupAdjustment__c = allocateGroupAdj;
        // list price
        lineItemSO.Apttus_Config2__ListPrice__c = listPrice;
        // base price
        lineItemSO.Apttus_Config2__BasePrice__c = basePrice;
        // base price mthod
        lineItemSO.Apttus_Config2__BasePriceMethod__c = basePriceMethod;
        // base extended price
        lineItemSO.Apttus_Config2__BaseExtendedPrice__c = baseExtPrice;
        // option price
        lineItemSO.Apttus_Config2__OptionPrice__c = optionPrice;
        // extended price
        lineItemSO.Apttus_Config2__ExtendedPrice__c = extPrice;
        // description
        lineItemSO.Apttus_Config2__Description__c = lineDesc;
     
        // insert line item
        insert lineItemSO;
        
        System.assert(lineItemSO.Id != null, 'Failed to create the line item for owner ' + user.Id);
            
        return lineItemSO;
        
    } 
    
    /**
     * Creates an opportunity for the given user
     * @param user the user to create the opportunity for
     * @param opptyName the opportunity name
     * @param description the opportunity description
     * @param stageName the stage name
     * @param closeDate the close date
     * @return the opportunity
     */
    public static Opportunity createOpportunity(User user, 
                                                String opptyName, 
                                                String description, 
                                                Decimal amount, 
                                                String stageName, 
                                                Date closeDate) {
        
        // create a new opportunity
        Opportunity opptySO = new Opportunity(Name = opptyName, OwnerId = user.Id);
        
        // description
        opptySO.Description = description;
        // amount
        opptySO.Amount = amount;
        // stage name
        opptySO.StageName = stageName;
        // close out date
        opptySO.CloseDate = closeDate;
        
        // insert opportunity
        insert opptySO;
            
        System.assert(opptySO.Id != null, 'Failed to create the opportunity for owner ' + user.Id);
        
        return opptySO;
        
    } 
    
    /**
     * Creates an opportunity line item for the given user
     * @param user the user to create the line item for
     * @param opptyId the opportunity id
     * @param pbEntryId the price book entry id
     * @param quantity the product quantity
     * @param totalPrice the total price
     * @param description the line item description
     * @return the opportunity line item
     */
    public static OpportunityLineItem createOpportunityLineItem(User user, 
                                                                ID opptyId, 
                                                                ID pbEntryId, 
                                                                Decimal quantity,
                                                                Decimal totalPrice,
                                                                String description) {
        
        // create a new opportunity line item
        OpportunityLineItem lineItemSO = new OpportunityLineItem(OpportunityId = opptyId);
        
        // price book entry
        lineItemSO.PricebookEntryId = pbEntryId;
        // quantity
        lineItemSO.Quantity = quantity;
        // total price (unit price is system updated based on total price and quantity)
        lineItemSO.TotalPrice = totalPrice;
        // description
        lineItemSO.Description = description;
        
        // insert line item
        insert lineItemSO;
        
        System.assert(lineItemSO.ID != null, 'Failed to create the opportunity line item for owner ' + user.Id);
            
        return lineItemSO;
        
    } 
    
    /**
     * Gets the system admin user
     * @return the system admin user
     */
    public static User getSysAdminUser() {
        // get the sys admin profile
        Id profileId = getProfileId('System Administrator');
        // get the system admin user
        List<User> users = [SELECT Id, 
                                   Name, 
                                   ProfileId, 
                                   UserName,
                                   FirstName,
                                   LastName,
                                   Email,
                                   TimeZoneSidKey, 
                                   EmailEncodingKey, 
                                   LocaleSidKey, 
                                   LanguageLocaleKey
                            FROM User 
                            WHERE IsActive = TRUE AND 
                                  ProfileId = :profileId 
                            LIMIT 1];
        
        return (!users.isEmpty() ? users[0] : null);
    
    }
    
    /**
     * Gets the current user
     * @return the current user
     */
    public static User getCurrentUser() {
        
        // get the current user id
        Id userId = UserInfo.getUserId();
        // get the current user
        List<User> users = [SELECT Id, 
                                   Name, 
                                   ProfileId, 
                                   UserName,
                                   FirstName,
                                   LastName,
                                   Email,
                                   TimeZoneSidKey, 
                                   EmailEncodingKey, 
                                   LocaleSidKey, 
                                   LanguageLocaleKey
                            FROM User 
                            WHERE Id = :userId];
        
        return (!users.isEmpty() ? users[0] : null);
    
    }
    
    /**
     * Gets the user sobject for the given user id
     * @param userId the user id
     * @return the user sobject
     */
    public static User getUserSO(Id userId) {
        
        // get the system admin user
        List<User> users = [SELECT Id, 
                                   Name, 
                                   Username,
                                   UserType,
                                   UserRoleId,
                                   TimeZoneSidKey, 
                                   ProfileId, 
                                   LocaleSidKey, 
                                   LastName,
                                   LanguageLocaleKey,
                                   IsActive,
                                   FirstName,
                                   EmailEncodingKey,
                                   Email
                            FROM User 
                            WHERE Id = :userId 
                            LIMIT 1];
        
        return (!users.isEmpty() ? users[0] : null);
    
    }
    
    /**
     * Gets the profile id for the given profile name
     * @param profileName the profile name
     * @return the profile id
     */
    public static ID getProfileId(String profileName) {
        
        // get the profile
        List<Profile> profiles = [SELECT Id
                                  FROM Profile 
                                  WHERE Name = :profileName 
                                  LIMIT 1];
        
        return (!profiles.isEmpty() ? profiles[0].Id : null);
    
    }
    
    /**
     * Gets the id of the standard price book
     * @return the id of the standard price book
     */
    public static ID getStandardPriceBookId() {
        
        // get the standard price book id
        List<Pricebook2> books = [SELECT Id
                                  FROM Pricebook2
                                  WHERE IsStandard = true 
                                  LIMIT 1];
                
        return (!books.isEmpty() ? books[0].Id : null);
        
    }
    
    /**
     * Creates a step group for the given user
     * @param user the user to create the step group for
     * @param processId the process id
     * @param groupName the group name
     * @param sequence the group sequence
     * @return the step group
     */
    public static Apttus_Approval__Approval_Process__c createStepGroup(User user,  
                                                                      ID processId,
                                                                      String groupName,
                                                                      Integer sequence) {
        
        // create step group
        Apttus_Approval__Approval_Process__c groupSO = new Apttus_Approval__Approval_Process__c(OwnerId = user.Id);
        
        // setup step group data
        
        // process id
        groupSO.Apttus_Approval__Step_Group__c = processId;
        // group name
        groupSO.Apttus_Approval__Step_Group_Name__c = groupName;
        // sequence
        groupSO.Apttus_Approval__Step_Group_Seq_Number__c = sequence;
        // active
        groupSO.Apttus_Approval__Step_Group_Active__c = true;
        // record type
        RecordType recordType = getRecordTypeForName('' + Apttus_Approval__Approval_Process__c.getSObjectType(),'Step Group');
        
        if (recordType != null) {
            groupSO.RecordTypeId = recordType.Id;
        
        }
        
        // insert step group
        insert groupSO;
            
        System.assert(groupSO.Id != null, 'Failed to create step group for user ' + user.Id);
        
        return groupSO;
        
    } 
    
    /**
     * Creates a step for the given user
     * @param user the user to create the step for
     * @param groupId the group id
     * @param stepName the step name
     * @param sequence the step sequence
     * @param assigneeType the assignee type
     * @param assignee the assignee 
     * @param autoComplete the auto complete indicator 
     * @param notifyOnly the notify only indicator 
     * @param sendEmail the send email indicator 
     * @return the step 
     */
    public static Apttus_Approval__Approval_Process__c createStep(User user,  
                                                                 ID groupId,
                                                                 String stepName,
                                                                 Integer sequence,
                                                                 String assigneeType,
                                                                 String assignee,
                                                                 Boolean autoComplete,
                                                                 Boolean notifyOnly,
                                                                 Boolean sendEmail) {
        
        // create step 
        Apttus_Approval__Approval_Process__c stepSO = new Apttus_Approval__Approval_Process__c(OwnerId = user.Id);
        
        // setup step data
        
        // step type
        stepSO.Apttus_Approval__StepType__c = 'Standard';
        
        // group id
        stepSO.Apttus_Approval__Step__c = groupId;
        // step name
        stepSO.Apttus_Approval__Step_Name__c = stepName;
        // step label
        stepSO.Apttus_Approval__StepLabel__c = stepName;
        // sequence
        stepSO.Apttus_Approval__Step_Seq_Number__c = sequence;
        // assignee type
        stepSO.Apttus_Approval__Step_Assignee_Type__c = assigneeType;
        // assignee
        stepSO.Apttus_Approval__Step_Assignee__c = assignee;
        // auto complete
        stepSO.Apttus_Approval__Step_Auto_Complete__c = autoComplete;
        // notify only
        stepSO.Apttus_Approval__Step_Notify_Only__c = notifyOnly;
        // send email
        stepSO.Apttus_Approval__Send_Email__c = sendEmail;
        // active
        stepSO.Apttus_Approval__Step_Active__c = true;
        // record type
        RecordType recordType = getRecordTypeForName('' + Apttus_Approval__Approval_Process__c.getSObjectType(),'Step');
        
        if (recordType != null) {
            stepSO.RecordTypeId = recordType.Id;
        
        }
        
        // insert step 
        insert stepSO;
            
        System.assert(stepSO.Id != null, 'Failed to create step for user ' + user.Id);
        
        return stepSO;
        
    } 

    /**
     * Gets the record type associated with the given sobject name and record type name
     * @param sObjectName the sobject name
     * @param recordTypeName the record type name to get the record type for
     * @return the record type 
     */
    public static RecordType getRecordTypeForName(String sObjectName, String recordTypeName) {
        
        // get the record type name 
        List<RecordType> recordTypes = [SELECT Id,
                                               Name,
                                               DeveloperName,
                                               SobjectType,
                                               NamespacePrefix,
                                               Description
                                        FROM RecordType
                                        WHERE Name = :recordTypeName AND 
                                              SobjectType = :sObjectName
                                        LIMIT 1];
                
        return (!recordTypes.isEmpty() ? recordTypes[0] : null);
        
    }
    

}