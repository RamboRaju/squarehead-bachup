public class ProductionHelper {

    public static Map<String,Integer> checkProductFromInventory(String thisOrderId){
         List<Inventory_Item__c> prodcutInventoryList = new List<Inventory_Item__c>();
         Map<String,Integer> inventoryProductMap = new Map<String,Integer>();
         Map<String,Integer> productNotAvailableMap = new Map<String,Integer>();
                 
         prodcutInventoryList = [Select id,Name,Product__c,Product__r.Name,Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name = 'My Inventory' and  recordtype.Name = 'Product'];
         for(Inventory_Item__c thisInventory : prodcutInventoryList){           
            inventoryProductMap.put(thisInventory.Product__r.Name,(Integer)thisInventory.Quantity_Remaining__c);
         }
         
        List<OrderItem> thisOrderItemList = new List<OrderItem>();
        thisOrderItemList = [Select id,Product2.Name,UnitPrice,Quantity,OrderId,Product2.ProductCode,Product2.Description,PricebookEntryId,Product2Id from OrderItem where OrderId=:thisOrderId];        
         for(OrderItem thisOrder : thisOrderItemList){
             if(thisOrder.Quantity > inventoryProductMap.get(thisOrder.Product2.Name)){
                 productNotAvailableMap.put(thisOrder.Product2.Name, (integer)thisOrder.Quantity - inventoryProductMap.get(thisOrder.Product2.Name));
             }
         }
         
         return productNotAvailableMap;
    }
    
    public static List<MaterialNotAvailableWrapper> checkMaterialFromInventory(Map<String,Integer> productNotAvailableMap){
        List<Inventory_Item__c> materialInventoryList = new List<Inventory_Item__c>();
        Map<String,Integer> inventoryMaterialMap = new Map<String,Integer>();
        //Map<String,Integer> materialNotAvailableMap = new Map<String,Integer>();
        List<MaterialNotAvailableWrapper> materialNotAvailableMap = new List<MaterialNotAvailableWrapper>();
               
        materialInventoryList = [Select id,Name,Raw_Material__r.Name,Raw_Material_Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name = 'My Inventory' and  recordtype.Name = 'Raw Material'];
         for(Inventory_Item__c thisInventory : materialInventoryList){
            inventoryMaterialMap.put(thisInventory.Raw_Material__r.Name,(Integer)thisInventory.Raw_Material_Quantity_Remaining__c);
        }
        
        for(String productMap : productNotAvailableMap.keySet()){
            System.debug('productMap++++ '+productMap);
            for(Product_Raw_Material__c thisMaterial : [select id,name ,Product__r.Name,Quantity__c,Raw_Material__r.Name,Raw_Material__r.Price__c,Raw_Material__r.Raw_Material_Description__c from Product_Raw_Material__c where Product__r.Name =:productMap]){
                if((productNotAvailableMap.get(productMap) * thisMaterial.Quantity__c)  > (inventoryMaterialMap.get(thisMaterial.Raw_Material__r.Name))){
                    system.debug('(productNotAvailableMap.get(productMap) * thisMaterial.Quantity__c)===' +(productNotAvailableMap.get(productMap) * thisMaterial.Quantity__c));
                    //materialNotAvailableMap.put(thisMaterial.Raw_Material__r.Name,(productNotAvailableMap.get(productMap) * (Integer)thisMaterial.Quantity__c)  - (inventoryMaterialMap.get(thisMaterial.Raw_Material__r.Name)));
                    MaterialNotAvailableWrapper thisMaterialNotAvailableWrapper = new MaterialNotAvailableWrapper();
                    thisMaterialNotAvailableWrapper.materialName = thisMaterial.Raw_Material__r.Name;
                    thisMaterialNotAvailableWrapper.productName = productMap;
                    thisMaterialNotAvailableWrapper.materialQuantity = (productNotAvailableMap.get(productMap) * (Integer)thisMaterial.Quantity__c)  - (inventoryMaterialMap.get(thisMaterial.Raw_Material__r.Name));
                    thisMaterialNotAvailableWrapper.materialPrice = thisMaterial.Raw_Material__r.Price__c;
                    thisMaterialNotAvailableWrapper.rawMaterialDescription = thisMaterial.Raw_Material__r.Raw_Material_Description__c;
                    materialNotAvailableMap.add(thisMaterialNotAvailableWrapper);
                }
            } 
        }
        
        return materialNotAvailableMap;
    }
    
    public class MaterialNotAvailableWrapper{
        public String materialName;
        public Integer materialQuantity;
        public String productName;
        public Decimal materialPrice; 
        public String rawMaterialDescription;       
    }
}