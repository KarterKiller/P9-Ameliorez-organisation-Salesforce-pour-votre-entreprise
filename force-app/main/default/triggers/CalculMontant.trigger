trigger CalculMontant on Order (before insert, before update) { // Ce trigger garantit que NetAmount__c est toujours correctement calculé avant qu’une commande (Order) ne soit enregistrée ou mise à jour.
    for (Order order : Trigger.new) {
        // Calcul du NetAmount via la classe helper
        OrderHelper.calculateNetAmount(order);
    }
}
