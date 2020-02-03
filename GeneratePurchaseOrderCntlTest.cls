@isTest
public class GeneratePurchaseOrderCntlTest {
	
    @isTest static void GeneratePurchaseOrder(){
        Request_Material__c thisRequestMaterial = new Request_Material__c();
        insert thisRequestMaterial;
        
        Request_Material_Item__c thisRequest_MaterialItem = new Request_Material_Item__c();
        
        thisRequest_MaterialItem.Material_Name__c = 'testMAterial';
        thisRequest_MaterialItem.Material_Price__c = 124590.00;
        thisRequest_MaterialItem.Material_Quantity__c = 34;
        thisRequest_MaterialItem.Product_Name__c = 'Cricket';
        thisRequest_MaterialItem.Request_Material__c = thisRequestMaterial.id;
        insert thisRequest_MaterialItem;
        
        Test.startTest();
       		ApexPages.StandardController sc = new ApexPages.StandardController(thisRequestMaterial);
         	GeneratePurchaseOrderCntl thisGeneratePurchaseOrderCntl = new GeneratePurchaseOrderCntl(sc);
        
        	PageReference pageRef = Page.GeneratePurchaseOrder;
            Test.setCurrentPage(pageRef);
        
        	thisGeneratePurchaseOrderCntl.purchaseOrder();
        	thisGeneratePurchaseOrderCntl.back();
        Test.stopTest();
    }
}