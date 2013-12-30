trigger DeletesParentAcc on Contact (before insert, before update) {

    List<Id> accsToDelete = new List<Id>();
    
    for(Contact c : trigger.new) {
    	if(c.Name == 'TriggerTest') {
    	   accsToDelete.add(c.AccountId);
    	}
    }
    
    Database.delete(accsToDelete);
    
   //The goal of this trigger would be to check if the data loader gets any error messages by default when using
   //the Database methods... I think we still need to manually add it to the SObject with addError...
}