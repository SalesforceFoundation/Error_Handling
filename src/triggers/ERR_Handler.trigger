trigger ERR_Handler on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    System.debug(LoggingLevel.WARN, '****In Contact Trigger');
    
    if(trigger.new[0].FirstName == 'test')
        ParentAccountUpdater.processContacts(trigger.new);
    else
        ParentAccountUpdater2.processContacts(trigger.new);
}