@isTest
public class RequestMaterialScreenCntlTest {
	
    @isTest static void requestMaterialScreenMethod(){
        
        Request_Material_Item__c thisRequestMaterialItem = new Request_Material_Item__c();
        thisRequestMaterialItem.Material_Quantity__c = 23.0;
        thisRequestMaterialItem.Product_Name__c = 'Cricket Bat';
        insert thisRequestMaterialItem;
        
        Test.startTest();
        	RequestMaterialScreenCntl thisObj = new RequestMaterialScreenCntl();
        	thisObj.processChecked();
        	thisObj.generatePurchaseOrde();
        Test.stopTest();
    }
}