@isTest
public class GenerateWorkOrderCntlTest {
	
    @isTest static void generateWorkOrder(){
        
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
        
        Work_Order__c thisWorkOrder = new Work_Order__c();
        insert thisWorkOrder;
        
        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.StandardController(thisOrder);
            GenerateWorkOrderCntl thisGenerateWorkOrderCntl = new GenerateWorkOrderCntl(sc);
        
            PageReference pageRef = Page.GenerateWorkOrder;
            Test.setCurrentPage(pageRef);
        	
        	thisGenerateWorkOrderCntl.generateWorkOrder();
        	thisGenerateWorkOrderCntl.backTrackWorkOrder = thisWorkOrder;
        	thisGenerateWorkOrderCntl.redirectToWorkOrder();
        Test.stopTest();
    }
    
    @isTest static void generateInvoice(){
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
        	ApexPages.StandardController sc = new ApexPages.StandardController(thisOrder);
            GenerateWorkOrderCntl thisGenerateWorkOrderCntl = new GenerateWorkOrderCntl(sc);
        
            PageReference pageRef = Page.GenerateWorkOrder;
            Test.setCurrentPage(pageRef);
        	
        	thisGenerateWorkOrderCntl.generateInvoice();
        	thisGenerateWorkOrderCntl.back();
        Test.stopTest();
        	
    }
    
    @isTest static void generateProductionPlan(){
        Account thisAccount = new Account();
        thisAccount.Name ='testAccount';
        insert thisAccount;
        
        Order thisOrder = new Order();
        thisOrder.AccountId = thisAccount.id;	
        thisOrder.EffectiveDate = Date.today();
        thisOrder.Status = 'Draft';
        insert thisOrder;
        
        Production_Plan__c thisProductionPlan = new Production_Plan__c();
        insert thisProductionPlan;
        
        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.StandardController(thisOrder);
            GenerateWorkOrderCntl thisGenerateWorkOrderCntl = new GenerateWorkOrderCntl(sc);
        
            PageReference pageRef = Page.GenerateWorkOrder;
            Test.setCurrentPage(pageRef);
        	
        	thisGenerateWorkOrderCntl.generateProductionPlan();
        	thisGenerateWorkOrderCntl.backTrackProductionPan = thisProductionPlan;
        	thisGenerateWorkOrderCntl.redirectToProductionPlan();
        Test.stopTest();
        
    }
    
    @isTest static void generateRequireMaterial(){
        Account thisAccount = new Account();
        thisAccount.Name ='testAccount';
        insert thisAccount;
        
        Order thisOrder = new Order();
        thisOrder.AccountId = thisAccount.id;	
        thisOrder.EffectiveDate = Date.today();
        thisOrder.Status = 'Draft';
        insert thisOrder;
        
        Request_Material__c thisRequestMaterial = new Request_Material__c();
        insert thisRequestMaterial;
        
        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.StandardController(thisOrder);
            GenerateWorkOrderCntl thisGenerateWorkOrderCntl = new GenerateWorkOrderCntl(sc);
        
            PageReference pageRef = Page.GenerateWorkOrder;
            Test.setCurrentPage(pageRef);
        	
        	thisGenerateWorkOrderCntl.generateRequireMaterial();
        	thisGenerateWorkOrderCntl.backTrackRequestMaterial = thisRequestMaterial;
        	thisGenerateWorkOrderCntl.redirectToRequestMaterial();
        Test.stopTest();

    }
}