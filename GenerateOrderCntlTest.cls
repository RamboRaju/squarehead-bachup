@isTest
public class GenerateOrderCntlTest {
	
    @isTest static void generateOrder(){
        
        Account thisAccount = new Account();
        thisAccount.Name ='testAccount';
        insert thisAccount;
        
        Order thisOrder = new Order();
        thisOrder.AccountId = thisAccount.id;	
        thisOrder.EffectiveDate = Date.today();
        thisOrder.Status = 'Draft';
        insert thisOrder;
               
        Date closeDt = Date.Today();
        date myDate = date.today();       
        
        Opportunity thisOpp = new Opportunity();
        thisOpp.Name='testingOpp at 10/21/2015';  
        thisOpp.AccountId= thisAccount.Id;
        thisOpp.StageName = 'Prospecting';           
        thisOpp.CloseDate = closeDt;
        insert thisOpp;
        
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
        
        OpportunityLineItem thisOppLineItem = new OpportunityLineItem();
        thisOppLineItem.OpportunityId = thisOpp.Id;
        thisOppLineItem.Quantity = 5;
        thisOppLineItem.PricebookEntryId = thisPricebookEntry.Id;
        thisOppLineItem.TotalPrice = thisPricebookEntry.UnitPrice;
        insert thisOppLineItem;
       
        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.StandardController(thisOpp);
            GenerateOrderCntl thisGenerateOrderCntl = new GenerateOrderCntl(sc);
        
            PageReference pageRef = Page.GenerateOrder;
            Test.setCurrentPage(pageRef);
        	
        	thisGenerateOrderCntl.generateOrder();
        	thisGenerateOrderCntl.back();
        	thisGenerateOrderCntl.checkBackTrack = thisOrder;      
            thisGenerateOrderCntl.redirectToOrder();
        	// if value of checkBackTrack variable is not null else part of generate order method
        	thisGenerateOrderCntl.generateOrder();
        Test.stopTest();
    }
}