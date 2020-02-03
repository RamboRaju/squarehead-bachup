/* This class is use to generate Order from Oppotunity Object Including Opportunty Product*/
public class GenerateOrderCntl {

    public Opportunity opp;
    //This order store that this opportunity already a order not 
    public Order checkBackTrack;
    
    public GenerateOrderCntl(ApexPages.StandardController stdController){
        checkBackTrack = new Order();
        this.opp = (Opportunity)stdController.getRecord();
    }
    
    public PageReference generateOrder(){
               
        Opportunity thisOpp =  new Opportunity();
        thisOpp = [Select id , name , AccountId,pricebook2Id,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
        Account.BillingCountry,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingPostalCode,Account.ShippingCountry
        from  Opportunity where id =:opp.id];
         
        if(opp <> null){ 
            try{
                checkBackTrack = [Select id ,OpportunityId from  order where OpportunityId =:opp.id];
            }catch(Exception e){
                checkBackTrack = null;
                System.debug('e====' +e);
            }         
            
        }      
        
        
        //Opprotunity Product
        List<OpportunityLineItem> oppItemList = new List<OpportunityLineItem>();
        oppItemList = [SELECT id, UnitPrice, TotalPrice,product2id, Quantity,PricebookEntryId,ListPrice, 
        Discount, Description FROM OpportunityLineItem WHERE OpportunityId =:opp.Id];
        
        Order thisOrder = new Order();
        // if this opp not contain any order then this block run
        if(checkBackTrack == null){
            List<OrderItem> orderProducts = new List<OrderItem>();
                   
            thisOrder.Pricebook2Id = thisOpp.Pricebook2Id;
            thisOrder.AccountId = thisOpp.AccountId;
            thisOrder.OpportunityId = thisOpp.Id;
            thisOrder.EffectiveDate = System.today();
            thisOrder.Status = 'Draft';
            //billing Address
            thisOrder.BillingStreet = thisOpp.Account.BillingStreet;
            thisOrder.BillingCity = thisOpp.Account.BillingCity;
            thisOrder.BillingState = thisOpp.Account.BillingState;
            thisOrder.BillingPostalCode = thisOpp.Account.BillingPostalCode;
            thisOrder.BillingCountry = thisOpp.Account.BillingCountry;
            
            //Shiping Address
            thisOrder.ShippingStreet = thisOpp.Account.ShippingStreet;
            thisOrder.ShippingCity = thisOpp.Account.ShippingCity;
            thisOrder.ShippingState = thisOpp.Account.ShippingState;
            thisOrder.ShippingPostalCode = thisOpp.Account.ShippingPostalCode;
            thisOrder.ShippingCountry = thisOpp.Account.ShippingCountry;
            insert thisOrder;
            
            for(OpportunityLineItem oppItem : oppItemList){
                OrderItem thisOrderItem = new OrderItem();
                thisOrderItem.UnitPrice = oppItem.UnitPrice;
                thisOrderItem.Quantity =  oppItem.Quantity;
                thisOrderItem.PricebookEntryId  = oppItem.PricebookEntryId;
                thisOrderItem.OrderId  = thisOrder.id;
                thisOrderItem.Product2Id = oppItem.product2Id;
                orderProducts.add(thisOrderItem);
            }
            
            insert orderProducts;
        }else{
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'You have already a Order for this Opportunity' );
            ApexPages.addmessage(msg);
            return null;
        }
        
        PageReference nextPage = new PageReference('/' + thisOrder.id);
        return nextPage;
    }
    
    //Back to Opportuntity Record
    public PageReference back(){
        PageReference nextPage = new PageReference('/' + opp.id);
        return nextPage;  
    }
    
    // Redirect to already exiting Order Record
    public PageReference redirectToOrder(){
        PageReference nextPage = new PageReference('/' + checkBackTrack.id);
        return nextPage;  
    }
    
}