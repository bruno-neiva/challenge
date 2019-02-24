({
	buildTableInformation  : function(component, event, helper, listOfContacts) {
       
        var listOfProductCustomerInformation = [];
        
        for(var i=0; i< listOfContacts.length; i++){
       		
           var feeProduct = helper.checkFeeProduct(component, event, helper, listOfContacts, listOfContacts[i].Product__c, listOfContacts[i].Home_Country__c);
           var rowTable = {customer_Contact:listOfContacts[i].Name,
                           productSubscription:listOfContacts[i].Product__c,
                           costPerCalendarMonth:listOfContacts[i]=feeProduct.costPerCalendarMonth,
                           atmFeeInOtherCurrencies:listOfContacts[i]=feeProduct.atmFeeInOtherCurrencies,
                           cardReplacementCost:listOfContacts[i]=feeProduct.cardReplacementCost
                          };
            
            
            listOfProductCustomerInformation.push(rowTable);
           // console.log(listOfProductCustomerInformation);
        }
        
        return listOfProductCustomerInformation;
		
	},
    
    
    checkFeeProduct : function(component, event, helper, listOfContacts, product, country){
    
        var productFees={costPerCalendarMonth:null,
                         atmFeeInOtherCurrencies:null,
                         cardReplacementCost:null
                        };

        if(product=="Standard"){
            
            if(country!='UK'){
                
                productFees.costPerCalendarMonth='€ 0';
                productFees.atmFeeInOtherCurrencies='1.7%';
                productFees.cardReplacementCost='€ 6';
                
            }else{
                
                productFees.costPerCalendarMonth='£ 0';
                productFees.atmFeeInOtherCurrencies='1.7%';
                productFees.cardReplacementCost='£ 6';
                
            }
            
        }else if(product=="Black" ){
            
            if(country!='UK'){
                
                productFees.costPerCalendarMonth='€ 9,90';
                productFees.atmFeeInOtherCurrencies='Free';
                productFees.cardReplacementCost='€ 6';
                
            }else{
                
                productFees.costPerCalendarMonth='N/a';
                productFees.atmFeeInOtherCurrencies='Free';
                productFees.cardReplacementCost='£ 6';
                
            }
            
        }else if(product=="Metal" ){
            
            if(country!='UK'){
                
                productFees.costPerCalendarMonth='€ 16,90';
                productFees.atmFeeInOtherCurrencies='Free';
                productFees.cardReplacementCost='€ 45';
                
            }else{
                
                productFees.costPerCalendarMonth='N/a';
                productFees.atmFeeInOtherCurrencies='Free';
                productFees.cardReplacementCost='£ 45';
                
            }
        }

        return productFees;

    },
    
})