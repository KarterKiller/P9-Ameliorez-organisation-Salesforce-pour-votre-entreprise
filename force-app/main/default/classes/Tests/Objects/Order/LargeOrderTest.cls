@isTest
private class LargeOrderTest {
    @isTest
    static void testLargeOrderProcessing() {
        // Générer 5 000 commandes, avec 3 lignes de commande par commande
        List<Order> orders = TestDataFactory.generateLargeOrderData(5000, 3);

        // Vérifier que les commandes et lignes de commande ont été créées
        System.assertEquals(5000, [SELECT COUNT() FROM Order], 'Le nombre total de commandes doit être 5 000.');
        System.assertEquals(15000, [SELECT COUNT() FROM OrderItem], 'Le nombre total de lignes de commande doit être 15 000.');

        // Simuler une mise à jour des commandes pour les passer en statut "Activated"
        for (Order ord : orders) {
            ord.Status = 'Activated';
        }
        update orders;

        // Vérifier que toutes les commandes ont le statut "Activated"
        Integer activatedOrders = [SELECT COUNT() FROM Order WHERE Status = 'Activated'];
        System.assertEquals(5000, activatedOrders, 'Toutes les commandes doivent être activées.');
    }
}
