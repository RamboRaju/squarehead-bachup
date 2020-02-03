public class RequestMaterialScreenCntl{
    
    public List<Request_Material_Item__c> requestMaterialItemList{get;set;}
    public List<RequestMaterialItem> requestMaterialItemWrapList {get;set;}
    public Map<String,PurchaseOrderWrapper> requestMaterialItemMap = new Map<String,PurchaseOrderWrapper>();
    public Set<Id> requestMaterialIds = new Set<Id>();
    public requestMaterialScreenCntl(){
        requestMaterialItemList = new List<Request_Material_Item__c>();
        requestMaterialItemWrapList =  new List<RequestMaterialItem>();
        requestMaterialItemList = [Select id ,Material_Name__c,Material_Price__c,Request_Material__r.Purchase_Order__c,Material_Quantity__c,Product_Name__c,Request_Material__c,Request_Material__r.Name from Request_Material_Item__c where Request_Material__r.Purchase_Order__c = ''];
        
        for(Request_Material_Item__c a : requestMaterialItemList){
            requestMaterialItemWrapList.add(new RequestMaterialItem(a,true,a.Request_Material__c));
        }
    }
    
    public PageReference processChecked(){
        
        Integer counter = 0;
        
        for(RequestMaterialItem a :requestMaterialItemWrapList){
            if(a.isCkeck){
                if(requestMaterialItemMap.containsKey(a.thisRequestMaterialItem.Material_Name__c)){                                      
                    requestMaterialItemMap.get(a.thisRequestMaterialItem.Material_Name__c).quantity  +=  (integer)a.thisRequestMaterialItem.Material_Quantity__c;                   
                }else{
                    PurchaseOrderWrapper thisPurchaseOrderWrapper = new PurchaseOrderWrapper();
                    thisPurchaseOrderWrapper.item = a.thisRequestMaterialItem.Material_Name__c;
                    thisPurchaseOrderWrapper.quantity = (integer)a.thisRequestMaterialItem.Material_Quantity__c;
                    thisPurchaseOrderWrapper.rate = a.thisRequestMaterialItem.Material_Price__c;
                    thisPurchaseOrderWrapper.requestMaterialId = a.thisRequestMaterialItem.Request_Material__c;
                    requestMaterialItemMap.put(a.thisRequestMaterialItem.Material_Name__c,thisPurchaseOrderWrapper);
                }
                
            }
            a.isCkeck = false;
        }
        
        System.debug('requestMaterialItemMap++ '+requestMaterialItemMap);
        
        id thisId = generatePurchaseOrde();
        PageReference nextPage = new PageReference('/' + thisId);
        return nextPage;
    
    }
    
    public id generatePurchaseOrde(){
        List<Request_Material__c> thisRequestMaterialList = new List<Request_Material__c>();
        thisRequestMaterialList = [Select id ,name,Purchase_Order__c from Request_Material__c];
        
        Purchase_Order__c thisPurchaseOrder = new Purchase_Order__c();
        thisPurchaseOrder.Date__c = System.today();
        insert thisPurchaseOrder;
        
        List<Purchase_Order_Item__c> thisPurchaseOrderItemList = new List<Purchase_Order_Item__c>();
        
        for(PurchaseOrderWrapper thisItem : requestMaterialItemMap.values()){
            Purchase_Order_Item__c thisPurchaseOrderItem = new Purchase_Order_Item__c();
            thisPurchaseOrderItem.Item__c = thisItem.item;
            thisPurchaseOrderItem.Quantity__c = thisItem.quantity;
            thisPurchaseOrderItem.Rate__c = thisItem.rate;
            thisPurchaseOrderItem.Purchase_Order__c = thisPurchaseOrder.id;
            thisPurchaseOrderItemList.add(thisPurchaseOrderItem);   
           // System.debug('thisItem '+thisItem);        
        
        }
        
        for(Request_Material__c a : thisRequestMaterialList){
            a.Purchase_Order__c = thisPurchaseOrder.id;
        }
        
        insert thisPurchaseOrderItemList;
        update thisRequestMaterialList;
        
        return thisPurchaseOrder.id;
               
    }
    
    public class PurchaseOrderWrapper{
        public String item;
        public Integer quantity;
        public Decimal rate;
        public String requestMaterialId;
    }
    
       
    public class RequestMaterialItem{
        public Boolean isCkeck{get;set;}
        public Request_Material_Item__c thisRequestMaterialItem{get;set;}
        public String requestMaterialId {get;set;}
        
        public requestMaterialItem(Request_Material_Item__c thisRequestMaterialItem,Boolean isCkeck, String requestMaterialId){
            this.thisRequestMaterialItem = thisRequestMaterialItem;     
            this.isCkeck = isCkeck; 
            this.requestMaterialId = requestMaterialId;
        }
    }
}