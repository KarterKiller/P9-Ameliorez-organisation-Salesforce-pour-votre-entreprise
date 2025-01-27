@isTest
private class UpdateAllAccountsTest {

    @isTest 
    static void testUpdateAccountWithOrder() {
        // Crée un compte de test via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Compte de Test');

        // Crée un produit (Chemise Verte) via TestDataFactory
        Product2 greenShirtProduct = TestDataFactory.createProduct('Chemise Verte longue XYX', true);

        // Crée une entrée dans le catalogue de prix (PricebookEntry) pour le produit
        PricebookEntry greenShirtPricebookEntry = TestDataFactory.createStandardPricebookEntry(greenShirtProduct.Id, 1020);

        // Crée une commande associée au compte de test via TestDataFactory
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute des lignes de commande à la commande (OrderItems)
        TestDataFactory.createOrderItem(testOrder.Id, greenShirtPricebookEntry.Id, 10, 150);  // 10 unités à 150 chacune
        TestDataFactory.createOrderItem(testOrder.Id, greenShirtPricebookEntry.Id, 20, 1000); // 20 unités à 1000 chacune

        // Passe la commande en statut Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // Vérifie que les champs de la commande sont correctement mis à jour
        Order reloadedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(21500.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être égal à la somme des lignes de commande.');

        // Vérifie que le chiffre d'affaires du compte reflète le NetAmount__c de la commande
        Account reloadedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(21500.00, reloadedAccount.Chiffre_d_affaire__c, 'Le Chiffre_d_affaire__c du compte doit refléter NetAmount__c de la commande.');
    }
}
