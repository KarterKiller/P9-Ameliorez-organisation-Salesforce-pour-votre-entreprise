trigger CalculMontant on Order (before insert, before update) {
    for (Order order : Trigger.new) {
        // Calcul du NetAmount via la classe helper
        OrderHelper.calculateNetAmount(order);
    }
}
