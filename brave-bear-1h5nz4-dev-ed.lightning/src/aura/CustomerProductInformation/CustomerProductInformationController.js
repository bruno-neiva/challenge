({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getContacts");
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state === "SUCCESS"){
                
                var listOfContacts = JSON.parse(response.getReturnValue());
                //build pagination
               var customerProductFeeTable=helper.buildTableInformation(component, event, helper, listOfContacts);
  				component.set('v.customerProductFeeTable',customerProductFeeTable);          
                //console.log(listOfContacts);
                
            } else if(state === "ERROR"){
                
                console.log('Error: ' + JSON.stringify(response.error));
                
            }
        });
        $A.enqueueAction(action);
        
    }
})