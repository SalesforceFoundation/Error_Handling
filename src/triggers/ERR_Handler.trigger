trigger ERR_Handler on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    System.debug(LoggingLevel.WARN, '****In Contact Trigger');
    
    ParentAccountUpdater.processContacts(trigger.new);
}