public class GenerateWorkOrderCntl {

    public Order thisOrder;
    public Work_Order__c backTrackWorkOrder;
    public Production_Plan__c backTrackProductionPan;
    public Request_Material__c backTrackRequestMaterial;
    
    public Boolean workOrderPanel{get;set;}
    public Boolean productionPlanPanel{get;set;}
    public Boolean requestMaterialPanel{get;set;}
    
    public Boolean workOrderBack{get;set;}
    public Boolean productionPlanBack{get;set;}
    public Boolean requestMaterialBack{get;set;}
    
    
    
    public GenerateWorkOrderCntl(ApexPages.StandardController controller) {
           workOrderPanel = false;
           productionPlanPanel = false;
           requestMaterialPanel = false;
           
           workOrderBack = false;
           productionPlanBack = false;
           requestMaterialBack = false;
           
           backTrackWorkOrder = new Work_Order__c();
           backTrackProductionPan = new Production_Plan__c();
           backTrackRequestMaterial = new Request_Material__c();
           
           thisOrder = (Order)controller.getRecord();
    }
    
    public PageReference generateWorkOrder(){
        
        Decimal subTotal = 0.0;
        
        Map<String,Integer> thisRequestedProduct = new Map<String,Integer>();
        thisRequestedProduct = ProductionHelper.checkProductFromInventory(thisOrder.id);
        
        try{
            backTrackWorkOrder = [Select id,Order__c  from Work_Order__c where Order__c =: thisOrder.id];
        }catch(Exception e){
            backTrackWorkOrder= null;
            System.debug('Work Order Exception '+e);
        }
        
        Order thisOrder1 = new Order();
        
        Work_Order__c thisWorkOrder = new Work_Order__c();
        
        List<Work_Order_Item__c> workOrderItemList = new List<Work_Order_Item__c>();
        
        // if this order does not contains any work order generate Work order other wise prevent it
        if(backTrackWorkOrder == null){
             // Work Order Generate Only Product Is availble in the Inventory
             if(thisRequestedProduct.size() == 0){
                thisOrder1 = [Select id,AccountId,Account.AccountNumber,Account.ShippingStreet,Account.ShippingCity,
                Account.ShippingState,Account.ShippingPostalCode,Account.ShippingCountry from Order where Id=:thisOrder.id];
                
                List<OrderItem> thisOrderItemList = new List<OrderItem>();
                thisOrderItemList = [Select id ,UnitPrice,Quantity,OrderId,Product2.ProductCode,Product2.Description,PricebookEntryId,Product2Id from OrderItem where OrderId=:thisOrder.id];
                                
                thisWorkOrder.Account__c = thisOrder1.AccountId;
                thisWorkOrder.Shipping_City__c = thisOrder1.Account.ShippingCity;
                thisWorkOrder.Shipping_Country__c= thisOrder1.Account.ShippingCountry;
                thisWorkOrder.Shipping_Postal_Code__c= thisOrder1.Account.ShippingPostalCode;
                thisWorkOrder.Shipping_State__c= thisOrder1.Account.ShippingState;
                thisWorkOrder.Shipping_Street__c= thisOrder1.Account.ShippingStreet;
                //BackTracking
                thisWorkOrder.Order__c = thisOrder1.id;
                insert thisWorkOrder ;
                        
                
                for(OrderItem a:thisOrderItemList){
                    Work_Order_Item__c thisWorkOrderItem = new Work_Order_Item__c();
                    thisWorkOrderItem.Work_Order__c = thisWorkOrder.id;
                    thisWorkOrderItem.Quantity__c = a.Quantity;
                    thisWorkOrderItem.Product_Code__c = a.Product2.ProductCode;
                    thisWorkOrderItem.Product__c = a.Product2Id ;
                    thisWorkOrderItem.Description__c = a.Product2.Description;
                    thisWorkOrderItem.Price__c = a.UnitPrice;
                    subTotal += a.UnitPrice;
                    
                    workOrderItemList.add(thisWorkOrderItem);
                   
                } 
             }else{
                 workOrderBack = true;
                 
                System.debug('hello There '+thisRequestedProduct.size());
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Product Not Available Please Generate Productin Plan' );
                ApexPages.addmessage(msg);
                return null; 
            }
                           
            insert workOrderItemList;
            thisWorkOrder.SubTotal__c = subTotal;
            update thisWorkOrder;
            
        }else{
            workOrderPanel = true;
            
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Work Order for this Order Already Exist.' );
            ApexPages.addmessage(msg);
            return null;           
        }
        
       
        PageReference nextPage = new PageReference('/' + thisWorkOrder.id);
        return nextPage;
     }
     
     //this methed use to generate invoie from Sales Order
     public PageReference generateInvoice(){
             Map<String,Integer> thisRequestedProduct = new Map<String,Integer>();
             
             thisRequestedProduct = ProductionHelper.checkProductFromInventory(thisOrder.id);
         
             Double stotal = 0.0;
             Order thisOrder1 = new Order();
             thisOrder1 = [Select id,AccountId,Account.AccountNumber,OrderNumber,createddate from Order where Id=:thisOrder.id];
             
             List<OrderItem> thisOrderItemList = new List<OrderItem>();
             thisOrderItemList = [Select id ,UnitPrice,Quantity,OrderId,Product2.ProductCode,Product2.Description,PricebookEntryId,Product2Id from OrderItem where OrderId=:thisOrder.id];
             
             Invoice__c thisInvoice = new Invoice__c();
             thisInvoice.Bill_To__c = thisOrder1.AccountId;
             thisInvoice.S_O_No__c = thisOrder1.OrderNumber;
             thisInvoice.Order_Date__c = date.newinstance(thisOrder1.createddate.year(), thisOrder1.createddate.month(), thisOrder1.createddate.day());
             insert thisInvoice;
             //Subtotal__c
             
             List<Invoice_Item__c> thisInvoiceItemList = new List<Invoice_Item__c>();
             
             for(OrderItem thisOrderItem : thisOrderItemList){
                 Invoice_Item__c thisInvoiceItem = new Invoice_Item__c();
                 stotal = stotal + (thisOrderItem.UnitPrice * thisOrderItem.Quantity); 
                 thisInvoiceItem.Amount__c = thisOrderItem.UnitPrice * thisOrderItem.Quantity;
                 thisInvoiceItem.Invoice__c = thisInvoice.id;
                 thisInvoiceItem.Price__c = thisOrderItem.UnitPrice;
                 thisInvoiceItem.Product__c = thisOrderItem.Product2Id;
                 thisInvoiceItem.Product_Code__c = thisOrderItem.Product2.ProductCode;
                 thisInvoiceItem.Product_Description__c = thisOrderItem.Product2.Description;
                 thisInvoiceItem.Quantity__c = thisOrderItem.Quantity;
                 thisInvoiceItemList.add(thisInvoiceItem);
              
             } 
         
         insert thisInvoiceItemList;
         
         thisInvoice.Subtotal__c = stotal;
         update thisInvoice;
         
         PageReference nextPage = new PageReference('/' + thisInvoice.id);
         return nextPage;
    }
    
    
         
    public PageReference generateProductionPlan(){
        Map<String,Integer> thisRequestedProduct = new Map<String,Integer>();
        thisRequestedProduct = ProductionHelper.checkProductFromInventory(thisOrder.id);
        
        List<Object> thisMaterialNotAvailableWrapper = new List<Object>();
        
        Production_Plan__c thisProductionPlan = new Production_Plan__c();
        //BackTracking
        thisProductionPlan.Order__c = thisOrder.id;
        
        thisMaterialNotAvailableWrapper = ProductionHelper.checkMaterialFromInventory(thisRequestedProduct);
        
        List<Production_Plan_Item__c> thisProductionPlanItemList = new List<Production_Plan_Item__c>();
        
        try{
            backTrackProductionPan = [select id,Order__c  from Production_Plan__c where Order__c =:thisOrder.id];
        }catch(Exception e){
            backTrackProductionPan = null;
            System.debug('This Exception from Production Plan '+e);
        }
        
        // If Production Plan not exist already for this order 
        if(backTrackProductionPan == null){
            if(thisRequestedProduct.size() > 0 && thisMaterialNotAvailableWrapper.size() == 0){           
                insert thisProductionPlan;
                
                for(String thisValue : thisRequestedProduct.keySet()){
                    Production_Plan_Item__c thisProductionPlanItem = new Production_Plan_Item__c();
                    thisProductionPlanItem.Name_of_Product__c = thisValue;
                    thisProductionPlanItem.Pieces__c = thisRequestedProduct.get(thisValue);
                    thisProductionPlanItem.Production_Plan__c = thisProductionPlan.id;
                    thisProductionPlanItemList.add(thisProductionPlanItem);
                }
            }else{
                productionPlanBack = true;
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Material Not Available To Produce this Product Please generate Material Request' );
                ApexPages.addmessage(msg);
                return null; 
            }
            insert thisProductionPlanItemList;
        }else{
        
             productionPlanPanel = true;
             ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Prodution Plan is already Exist for this Order' );
             ApexPages.addmessage(msg);
             return null; 
        }
        
        
        PageReference nextPage = new PageReference('/' + thisProductionPlan.id);
        return nextPage;
    }  
    
    public PageReference generateRequireMaterial(){
        Map<String,Integer> thisRequestedProduct = new Map<String,Integer>();
        thisRequestedProduct = ProductionHelper.checkProductFromInventory(thisOrder.id);
        
        List<ProductionHelper.MaterialNotAvailableWrapper> thisMaterialNotAvailableWrapper = new List<ProductionHelper.MaterialNotAvailableWrapper>();                        
        thisMaterialNotAvailableWrapper = ProductionHelper.checkMaterialFromInventory(thisRequestedProduct);
        
        Request_Material__c thisRequestMaterial = new Request_Material__c();
        thisRequestMaterial.Order__c = thisOrder.id;
        List<Request_Material_Item__c> thisRequestMaterialItemList = new List<Request_Material_Item__c>();
        
        try{
            backTrackRequestMaterial = [Select id,Order__c from Request_Material__c where Order__c =:thisOrder.id];
        }catch(Exception e){
            backTrackRequestMaterial = null;
            System.debug('Exception From Request Material '+e);
        }
        
        //if this order does not contain the request material then generate Request material else Not
        if(backTrackRequestMaterial == null ){
            if(thisRequestedProduct.size() > 0 && thisMaterialNotAvailableWrapper.size() > 0){
                insert thisRequestMaterial;
                for(ProductionHelper.MaterialNotAvailableWrapper thisObject : thisMaterialNotAvailableWrapper){
                    System.debug('thisObject ==== '+thisObject);
                    Request_Material_Item__c thisRequestMaterialItem = new Request_Material_Item__c();
                    thisRequestMaterialItem.Material_Name__c = thisObject.materialName;
                    thisRequestMaterialItem.Material_Quantity__c = thisObject.materialQuantity;
                    thisRequestMaterialItem.Request_Material__c = thisRequestMaterial.id;
                    thisRequestMaterialItem.Product_Name__c = thisObject.productName;              
                    thisRequestMaterialItem.Material_Price__c = thisObject.materialPrice;
                    thisRequestMaterialItem.Description__c = thisObject.rawMaterialDescription;
                    thisRequestMaterialItemList.add(thisRequestMaterialItem);
                }
            }else{
                requestMaterialBack = true;
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Material are already availble to complete this Product' );
                ApexPages.addmessage(msg);
                return null; 
               
            }
               insert thisRequestMaterialItemList;

        }else{
            requestMaterialPanel = true;
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Request Material is already exist for this Order' );
            ApexPages.addmessage(msg);
            return null; 
        }
        
           PageReference nextPage = new PageReference('/' + thisRequestMaterial.id);
           return nextPage; 
    }
    
     //This Method is user to redirect to Order
    public PageReference back(){
        PageReference nextPage = new PageReference('/' + thisOrder.id);
        return nextPage;
    }
    
    //This Method is user to redirect to Existing Work Order
    public PageReference redirectToWorkOrder(){
        PageReference nextPage = new PageReference('/' + backTrackWorkOrder.id);
        return nextPage;
    }
    
    //This Method is user to redirect to Existing Production Plan
    public PageReference redirectToProductionPlan(){
        PageReference nextPage = new PageReference('/' + backTrackProductionPan.id);
        return nextPage;
    }
    
    //This Method is user to redirect to Existing Request Material
    public PageReference redirectToRequestMaterial(){
        PageReference nextPage = new PageReference('/' + backTrackRequestMaterial.id);
        return nextPage;
    }
                  
}