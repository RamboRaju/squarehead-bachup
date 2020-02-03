public class GeneratePurchaseOrderCntl{
    public Request_Material__c thisRequestMaterial;
    
    public GeneratePurchaseOrderCntl(ApexPages.StandardController controller){
        thisRequestMaterial = (Request_Material__c)controller.getRecord();
        system.debug('thisRequestMaterial=== '+thisRequestMaterial);
    }
    
    
    public pageReference purchaseOrder(){
        Request_Material__c updateRequestMaterial = new Request_Material__c(); 
        
        Map<String,Request_Material_Item__c> requestMaterialMap = new Map<String,Request_Material_Item__c>(); 
        Purchase_Order__c thisPurchaseOrder = new Purchase_Order__c();
        List<Purchase_Order_Item__c> thisPurchaseOrderItemList = new List<Purchase_Order_Item__c>();
        List<Request_Material_Item__c> thisRequestMaterialItem = new List<Request_Material_Item__c>();
        thisRequestMaterialItem = [Select id, name,Material_Name__c,Material_Price__c,Material_Quantity__c,Description__c,Request_Material__c,Request_Material__r.Purchase_Order__c  from Request_Material_Item__c where Request_Material__r.Purchase_Order__c = '' AND Request_Material__c =: thisRequestMaterial.id];
        
        //Removing duplicate and add its quantity
        for(Request_Material_Item__c thisItem : thisRequestMaterialItem){
            if(requestMaterialMap.containsKey(thisItem.Material_Name__c)){
                requestMaterialMap.get(thisItem.Material_Name__c).Material_Quantity__c += thisItem.Material_Quantity__c;
            }else{
                requestMaterialMap.put(thisItem.Material_Name__c,thisItem);
            }
        }
        
        
        updateRequestMaterial = [select id, name,Purchase_Order__c from Request_Material__c where id =:thisRequestMaterial.id];
       
        
        
        if(updateRequestMaterial.Purchase_Order__c  == null){
            thisPurchaseOrder.Date__c = System.today();
            insert thisPurchaseOrder;
            
            for(Request_Material_Item__c thisItem : requestMaterialMap.values()){
                Purchase_Order_Item__c thisPurchaseOrderItem = new Purchase_Order_Item__c();
                thisPurchaseOrderItem.Item__c = thisItem.Material_Name__c;
                thisPurchaseOrderItem.Quantity__c = thisItem.Material_Quantity__c;
                thisPurchaseOrderItem.Rate__c = thisItem.Material_Price__c;
                thisPurchaseOrderItem.Purchase_Order__c = thisPurchaseOrder.id;
                thisPurchaseOrderItem.Description__c = thisItem.Description__c;
                thisPurchaseOrderItemList.add(thisPurchaseOrderItem);           
            
            }
        }else{
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'You have already have purchase order for this Request Material' );
            ApexPages.addmessage(msg);
            return null;             
        }
                      
            insert thisPurchaseOrderItemList;
            
            updateRequestMaterial.Purchase_Order__c = thisPurchaseOrder.id;
            update updateRequestMaterial;
            
            PageReference nextPage = new PageReference('/' + thisPurchaseOrder.id);
            return nextPage;       
    }
    
     public PageReference back(){
        PageReference nextPage = new PageReference('/' + thisRequestMaterial.id);
        return nextPage;
    }
}