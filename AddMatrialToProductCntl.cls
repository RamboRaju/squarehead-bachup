/*We are using this before the junction object "Product Raw Material" Not this code is not in Use Deprecated*/
public class AddMatrialToProductCntl {
    
    Public Product2 thisProduct{get;set;}
    public List<Raw_Material__c> rawMaterialList{get;set;}
    public List<MaterialWrapper> materialWrapperList{get;set;}
    
    public AddMatrialToProductCntl(){
        rawMaterialList = new List<Raw_Material__c>();
        materialWrapperList = new List<MaterialWrapper>();
        rawMaterialList = [Select  id ,Name,Raw_Material_Code__c,Raw_Material_Description__c,Raw_Material_ID__c from Raw_Material__c];
        
        for(Raw_Material__c thisRawMaterial :rawMaterialList){
            materialWrapperList.add(new MaterialWrapper(thisRawMaterial));
        }
        
        thisProduct = new Product2();
        thisProduct = [select id , name from product2 where id=:ApexPages.CurrentPage().getparameters().get('id')];
    }
    
    public PageReference processSelected(){
        List<Raw_Material__c> selectedMatrial = new List<Raw_Material__c>();
        selectedMatrial.clear();
        
        for(MaterialWrapper wrapUnitObj: materialWrapperList){
             if(wrapUnitObj.selected == true){
                selectedMatrial.add(wrapUnitObj.thisRawMaterial );
                wrapUnitObj.selected =false;
             }
           
         }
               
         PageReference nextPage = new PageReference('/' + thisProduct.id);
         return nextPage;
       
    }
    
    public PageReference back(){
        PageReference nextPage = new PageReference('/' + thisProduct.id);
        return nextPage;
    }
    
    public class MaterialWrapper{
        public Raw_Material__c thisRawMaterial {get; set;}
        public Boolean selected {get; set;}
        public MaterialWrapper(Raw_Material__c a){
            thisRawMaterial = a;
            selected = false;
        }
    }
}