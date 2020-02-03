@isTest
public class InventoryCntlTest {
    
    @isTest static void productSearch(){
        
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
        thisInventory.Name = 'MyInventory';
        insert thisInventory;
        
        Inventory_Item__c thisInventoryItem = new Inventory_Item__c();
        thisInventoryItem.Inventory__c = thisInventory.id;
        thisInventoryItem.Product__c = thisProduct.id;
        insert thisInventoryItem;
        
        Test.startTest();
        	InventoryCntl thisInventoryCntl = new InventoryCntl();
        	thisInventoryCntl.getInventoryOption();
        	thisInventoryCntl.getProductAvailableOption();
        	thisInventoryCntl.getMatrialAvailableOption();
        	thisInventoryCntl.selectedInventry = 'Product';
        	thisInventoryCntl.itemID = 'CB100';
        	thisInventoryCntl.itemCode = 'testitemCode';
            thisInventoryCntl.itemDescription = 'testitemDescription';
            thisInventoryCntl.itemBarcode =	'testitemBarcode';
        	thisInventoryCntl.myMethod();
        	thisInventoryCntl.productSearch();
        Test.stopTest();
    }
    
    @isTest static void materialSearch(){
        
        Raw_Material__c thisRawMaterial = new Raw_Material__c();
        thisRawMaterial.Name = 'cricketBat';
        thisRawMaterial.Raw_Material_Code__c = 'CB10001';
        thisRawMaterial.Raw_Material_Description__c = 'This is a cricket bat';
        insert thisRawMaterial;
        
        Inventory__c thisInventory = new Inventory__c();
        thisInventory.Name = 'MyInventory';
        insert thisInventory;
        
        Inventory_Item__c thisInventoryItem = new Inventory_Item__c();
        thisInventoryItem.Inventory__c = thisInventory.id;
        thisInventoryItem.Raw_Material__c = thisRawMaterial.id;       
        insert thisInventoryItem;
        
        Test.startTest();
        	InventoryCntl thisInventoryCntl = new InventoryCntl();        	 
        	thisInventoryCntl.selectedInventry = 'Raw Material';
        	thisInventoryCntl.rawMaterialID = 'testrawMaterialID';
            thisInventoryCntl.rawMaterialCode = 'testrawMaterialCode';
            thisInventoryCntl.rawMaterialDescription = 'testrawMaterialDescription';
        	thisInventoryCntl.rawMatrialsearch();
        	thisInventoryCntl.myMethod();
        Test.stopTest();
        
    }

}