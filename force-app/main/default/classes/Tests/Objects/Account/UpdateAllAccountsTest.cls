@isTest
private class UpdateAllAccountsTest {

    @isTest static void test() {
        // Crée un compte via TestDataFactory
        Account acc1 = TestDataFactory.createAccount('Test Account 1');

        // Crée un produit via TestDataFactory
        Product2 pd1 = TestDataFactory.createProduct('Chemise Verte longue XYX', true);

        // Crée une entrée de catalogue de prix via TestDataFactory
        PricebookEntry pbe = TestDataFactory.createStandardPricebookEntry(pd1.Id, 1020);

        // Crée une commande via TestDataFactory
        Order o1 = TestDataFactory.createOrder(acc1.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajoute des lignes de commande via TestDataFactory
        TestDataFactory.createOrderItem(o1.Id, pbe.Id, 10, 150); // 10 unités à 150 chacune
        TestDataFactory.createOrderItem(o1.Id, pbe.Id, 20, 1000); // 20 unités à 1000 chacune

        // Passe la commande en statut Activated
        o1.Status = 'Activated';
        update o1;

        // Vérifie que les champs sont mis à jour
        Order reloadedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        System.assertEquals(21500.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être égal à la somme des lignes de commande.');

        Account reloadedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(21500.00, reloadedAccount.Chiffre_d_affaire__c, 'Le Chiffre_d_affaire__c du compte doit refléter NetAmount__c de la commande.');
    }
}
