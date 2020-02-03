@isTest
public class ProductionHelperTest {
	
    @isTest static void checkProductFromInventory(){
        Id pricebookId = Test.getStandardPricebookId();

        Product2 thisProduct = new Product2();
        thisProduct.Name = 'iphone X';
        thisProduct.ProductCode = 'iPro-X';
        thisProduct.isActive = true;
        insert thisProduct;
        
        PricebookEntry thisPricebookEntry = new PricebookEntry();
        thisPricebookEntry.Pricebook2Id = pricebookId;
        thisPricebookEntry.Product2Id = thisProduct.Id;
        thisPricebookEntry.UnitPrice = 100.00;
        thisPricebookEntry.IsActive = true;
        insert thisPricebookEntry;
        
        Inventory__c thisInventory = new Inventory__c();
        thisInventory.Name = 'My Inventory';
        insert thisInventory;
        
        Id RecordTypeIdInventoryItem = Schema.SObjectType.Inventory_Item__c.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        
        Inventory_Item__c thisInventoryItem = new Inventory_Item__c();
        thisInventoryItem.Inventory__c = thisInventory.id;
        thisInventoryItem.Product__c = thisProduct.id;
        thisInventoryItem.RecordTypeId = RecordTypeIdInventoryItem;
        thisInventoryItem.Quantity_Remaining__c = 100;
        insert thisInventoryItem;
        
        Account thisAccount = new Account();
        thisAccount.Name ='testAccount';
        insert thisAccount;
        
        Order thisOrder = new Order();
        thisOrder.AccountId = thisAccount.id;
        thisOrder.Pricebook2Id = pricebookId;
        thisOrder.EffectiveDate = Date.today();
        thisOrder.Status = 'Draft';
        insert thisOrder;
        
        OrderItem thisOrderItem = new OrderItem();
        thisOrderItem.OrderId = thisOrder.id;
        thisOrderItem.PricebookEntryId =  thisPricebookEntry.id;
        thisOrderItem.Product2Id = thisProduct.id;
        thisOrderItem.Quantity = 145;
        thisOrderItem.UnitPrice = 120000;
        insert thisOrderItem;
        
        Test.startTest();
        	ProductionHelper.checkProductFromInventory(thisOrder.Id);       	
        Test.stopTest();
    }
    
    @isTest static void checkMaterialFromInventory(){
       
        Raw_Material__c thisRawMaterial = new Raw_Material__c();
        thisRawMaterial.Name = 'cricketBat';
        thisRawMaterial.Raw_Material_Code__c = 'CB10001';
        thisRawMaterial.Raw_Material_Description__c = 'This is a cricket bat';
        insert thisRawMaterial;
        
        Inventory__c thisInventory = new Inventory__c();
        thisInventory.Name = 'My Inventory';
        insert thisInventory;
        
        Id RecordTypeIdInventoryItem = Schema.SObjectType.Inventory_Item__c.getRecordTypeInfosByName().get('Raw Material').getRecordTypeId();
        
        Inventory_Item__c thisInventoryItem = new Inventory_Item__c();
        thisInventoryItem.Inventory__c = thisInventory.id;
        thisInventoryItem.Raw_Material__c = thisRawMaterial.id; 
        thisInventoryItem.RecordTypeId = RecordTypeIdInventoryItem;
        thisInventoryItem.Raw_Material_Quantity_Remaining__c = 145;
        insert thisInventoryItem;
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 thisProduct = new Product2();
        thisProduct.Name = 'iphone X';
        thisProduct.ProductCode = 'iPro-X';
        thisProduct.isActive = true;
        insert thisProduct;
        
        PricebookEntry thisPricebookEntry = new PricebookEntry();
        thisPricebookEntry.Pricebook2Id = pricebookId;
        thisPricebookEntry.Product2Id = thisProduct.Id;
        thisPricebookEntry.UnitPrice = 100.00;
        thisPricebookEntry.IsActive = true;
        insert thisPricebookEntry;
        
        Product_Raw_Material__c thisProductRawMaterial = new Product_Raw_Material__c();
        thisProductRawMaterial.Product__c = thisProduct.id;
        thisProductRawMaterial.Quantity__c = 200;
        thisProductRawMaterial.Raw_Material__c = thisRawMaterial.id;
        insert thisProductRawMaterial;
        
        
        
        Test.startTest();
        	Map<String ,Integer > thisMap = new Map<String ,Integer >();
        	thisMap.put('iphone X',54);
        	ProductionHelper.checkMaterialFromInventory(thisMap);
        	
        	ProductionHelper thisProductionHelper = new ProductionHelper();        	
        Test.stopTest();
    }
}