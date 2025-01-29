@isTest
private class CalculMontantTriggerTest {

    @isTest
    static void testCalculMontantInsert() {
        //System.debug('=== DÉBUT DU TEST CalculMontantTrigger pour insert ===');

        // Crée un compte et les données nécessaires via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute une ligne de commande et définit ShipmentCost
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00); // TotalAmount = 200
        testOrder.ShipmentCost__c = 50.00;
        update testOrder;

        // Passe la commande en statut Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // Recharge et vérifie les données
        Order reloadedOrder = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c, Status FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(200.00, reloadedOrder.TotalAmount, 'TotalAmount devrait être égal à la somme des lignes de commande.');
        System.assertEquals(150.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être TotalAmount - ShipmentCost.');
        System.assertEquals('Activated', reloadedOrder.Status, 'Le statut de la commande devrait être Activated.');

        //System.debug('=== FIN DU TEST CalculMontantTrigger pour insert ===');
    }

    @isTest
    static void testCalculMontantUpdate() {
        //System.debug('=== DÉBUT DU TEST CalculMontantTrigger pour update ===');

        // Crée un compte et les données nécessaires via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute une ligne de commande et définit ShipmentCost
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 100.00); // TotalAmount = 200
        testOrder.ShipmentCost__c = 50.00;
        update testOrder;

        // Passe la commande en statut Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // Modifie ShipmentCost et recharge la commande
        testOrder.ShipmentCost__c = 150.00;
        update testOrder;

        // Recharge et vérifie les données
        Order updatedOrder = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(200.00, updatedOrder.TotalAmount, 'TotalAmount ne doit pas changer après la mise à jour de ShipmentCost.');
        System.assertEquals(50.00, updatedOrder.NetAmount__c, 'NetAmount__c devrait être recalculé après la mise à jour de ShipmentCost.');

        //System.debug('=== FIN DU TEST CalculMontantTrigger pour update ===');
    }

    @isTest
    static void testCalculMontantWithNullShipmentCost() {
        //System.debug('=== DÉBUT DU TEST CalculMontantTrigger avec ShipmentCost null ===');

        // Crée un compte et les données nécessaires via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute une ligne de commande sans définir ShipmentCost
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 100.00); // TotalAmount = 100
        testOrder.ShipmentCost__c = null;
        update testOrder;

        // Passe la commande en statut Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // Recharge et vérifie les données
        Order reloadedOrder = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(100.00, reloadedOrder.TotalAmount, 'TotalAmount devrait être calculé à partir des lignes de commande.');
        System.assertEquals(100.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être égal à TotalAmount lorsque ShipmentCost est null.');

        //System.debug('=== FIN DU TEST CalculMontantTrigger avec ShipmentCost null ===');
    }

    @isTest
    static void testCalculMontantWithMultipleOrderItems() {
        //System.debug('=== DÉBUT DU TEST CalculMontantTrigger avec plusieurs lignes de commande ===');

        // Crée un compte et les données nécessaires via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute plusieurs lignes de commande
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 100.00); // Ligne 1
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 150.00); // Ligne 2
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 3, 200.00); // Ligne 3
        testOrder.ShipmentCost__c = 20.00;
        update testOrder;

        // Passe la commande en statut Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // Recharge et vérifie les données
        Order reloadedOrder = [SELECT TotalAmount, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(100.00 + (2 * 150.00) + (3 * 200.00), reloadedOrder.TotalAmount, 'TotalAmount devrait être la somme des lignes.');
        System.assertEquals((100.00 + 300.00 + 600.00) - 20.00, reloadedOrder.NetAmount__c, 
            'NetAmount__c devrait être TotalAmount - ShipmentCost.');

        //System.debug('=== FIN DU TEST CalculMontantTrigger avec plusieurs lignes de commande ===');
    }
}
