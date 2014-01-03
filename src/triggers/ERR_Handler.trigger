trigger ERR_Handler on Contact (before insert, before update) {

    System.debug(LoggingLevel.WARN, '****In Contact Trigger');
    
    ParentAccountUpdater.processContacts(trigger.new);
}