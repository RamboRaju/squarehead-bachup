public class InventoryCntl {
    // select Inventory from pickList Product or Raw Mateial
    public string selectedInventry{get;set;}    
    
    //product Inventory
    public Boolean productPanel{get;set;} 
    public Inventory__c thisInventory{get;set;}
    public String selectedPrduct{get;set;}
    public List<Inventory_Item__c> thisInventoryItemList {get;set;}
    public String itemID {get;set;}
    public String itemCode {get;set;}
    public String itemDescription {get;set;}
    public String itemBarcode {get;set;}
    
    //Raw Matrial Inventory
    public Boolean materialPanel{get;set;} 
    public Inventory__c thisInventory1{get;set;}
    public String selectedPrduct1{get;set;}
    public List<Inventory_Item__c> thisInventoryItemList1 {get;set;}
    public String rawMaterialID {get;set;}
    public String rawMaterialCode {get;set;}
    public String rawMaterialDescription {get;set;}
    

    public InventoryCntl(){
        System.debug('selectedInventry '+selectedInventry);
        //product Inventory variable initialization
        itemID = '';
        itemCode = '';
        itemDescription = '';
        itemBarcode = '';
        thisInventoryItemList = new List<Inventory_Item__c>();
        thisInventory = new Inventory__c();
        thisInventoryItemList = [Select id , Name ,Item_Barcode__c,Item_Code__c,Item_Description__c,Item_ID__c,Stock__c,
        Cases__c,Bundles__c,Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name ='My Inventory' AND Product__c <> null];
        
        //Raw Matrial Inventory variable initialization
        rawMaterialID = '';
        rawMaterialCode = '';
        rawMaterialDescription = '';
        thisInventoryItemList1 = new List<Inventory_Item__c>();
        thisInventory1 = new Inventory__c();
        thisInventoryItemList1 = [Select id , Name ,Raw_Material_ID__c,Raw_Material_Code__c,Raw_Material_Description__c,
        Quantity_on_Hand__c,Quantity_on_Purchase_Orders__c ,Raw_Material_Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name ='My Inventory' AND Raw_Material__c <> null];
        
    }
    
    //Inventory Picklist 
    public List<SelectOption> getInventoryOption() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-None-'));
        options.add(new SelectOption('Product','Product'));
        options.add(new SelectOption('Raw Material','Raw Material'));
        return options;
    }
    
    public void myMethod(){
        System.debug('selectedInventry from method '+selectedInventry);
        if(selectedInventry == 'Product'){
            productPanel = true;
            materialPanel = false;
        }
        if(selectedInventry == 'Raw Material'){
            productPanel = false;
            materialPanel = true;
        }  
        System.debug('productPanel '+productPanel); 
        System.debug('materialPanel'+materialPanel);      
    }
    
    
     public List<SelectOption> getProductAvailableOption() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-None-'));
        options.add(new SelectOption('Available','Available'));
        options.add(new SelectOption('Not Available','Not Available'));
        return options;
    }
    
     public void productSearch(){
        System.debug('selectedPrduct++++ '+selectedPrduct);
        String qry = 'Select id , Name ,Item_Barcode__c,Item_Code__c,Item_Description__c,Item_ID__c,Stock__c,Cases__c,Bundles__c,Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name =\'My Inventory\' AND Product__c <> null  ';
        if(!String.isBlank(itemID) ){
            qry = qry + ' AND Item_ID__c ='+'\'' + itemID+'\'' ;
        }
        if(!String.isBlank(itemCode)){
            qry = qry + ' AND Item_Code__c ='+'\'' + itemCode +'\'' ;
        }
        if(!String.isBlank(itemDescription) ){
            qry = qry + ' AND Item_Description__c ='+'\'' + itemDescription+'\'' ;
        }
        if(!String.isBlank(itemBarcode) ){
            qry = qry + ' AND Item_Barcode__c ='+'\'' + itemBarcode+'\'' ;
        }
        if(selectedPrduct == 'Available'){
            qry = qry + ' AND Quantity_Remaining__c >'+' ' + 0.0+'' ;
        }
        
        if(selectedPrduct == 'Not Available'){
            qry = qry + ' AND Quantity_Remaining__c ='+' ' + null+'' ;
        }
        selectedPrduct = '';
        System.debug('qry++++ '+qry);
        thisInventoryItemList = Database.query(qry);
        itemID = '';
        itemCode = '';
        itemDescription = '';
        itemBarcode = '';
    }
    
    
    //Raw Matrial Inventory Methods
     public List<SelectOption> getMatrialAvailableOption () {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-None-'));
        options.add(new SelectOption('Available','Available'));
        options.add(new SelectOption('Not Available','Not Available'));
        return options;
    }
    
     public void rawMatrialsearch(){
        String qry = 'Select id , Name ,Raw_Material_ID__c,Raw_Material_Code__c,Raw_Material_Description__c,Quantity_on_Hand__c,Quantity_on_Purchase_Orders__c ,Raw_Material_Quantity_Remaining__c from Inventory_Item__c where Inventory__r.Name =\'My Inventory\' AND Raw_Material__c <> null ';
        if(!String.isBlank(rawMaterialID) ){
            qry = qry + ' AND Raw_Material_ID__c ='+'\'' + rawMaterialID+'\'' ;
        }
        if(!String.isBlank(rawMaterialCode)){
            qry = qry + ' AND Raw_Material_Code__c ='+'\'' + rawMaterialCode+'\'' ;
        }
        if(!String.isBlank(rawMaterialDescription) ){
            qry = qry + ' AND Raw_Material_Description__c ='+'\'' + rawMaterialDescription+'\'' ;
        }
         if(selectedPrduct1 == 'Available'){
            qry = qry + ' AND Raw_Material_Quantity_Remaining__c  >'+' ' + 0.0+'' ;
        }
        
        if(selectedPrduct1 == 'Not Available'){
            qry = qry + ' AND Raw_Material_Quantity_Remaining__c  ='+' ' + null+'' ;
        }
       
        
        System.debug('qry++++ '+qry);
        thisInventoryItemList1 = Database.query(qry);
        rawMaterialID = '';
        rawMaterialCode = '';
        rawMaterialDescription = '';
    }
    
}