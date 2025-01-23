@isTest
private class UpdateAccountCATriggerTest {

    @isTest
    static void testInsertOrder() {
        System.debug('=== TEST : Insertion de commande ===');
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        testOrder.ShipmentCost__c = 50.00;
        update testOrder;

        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00);

        testOrder.Status = 'Activated';
        update testOrder;

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        Decimal expectedNetAmount = 200.00 - 50.00;
        System.assertEquals(expectedNetAmount, updatedAccount.Chiffre_d_affaire__c, 
            'Chiffre_d_affaire__c doit correspondre au NetAmount.');
    }

    @isTest
    static void testUpdateOrder() {
        System.debug('=== TEST : Mise à jour de commande ===');
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        testOrder.ShipmentCost__c = 50.00;
        update testOrder;

        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00);

        testOrder.Status = 'Activated';
        update testOrder;

        testOrder.ShipmentCost__c = 100.00;
        update testOrder;

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        Decimal expectedNetAmount = 200.00 - 100.00;
        System.assertEquals(expectedNetAmount, updatedAccount.Chiffre_d_affaire__c, 
            'Chiffre_d_affaire__c doit être mis à jour correctement.');
    }

    @isTest
    static void testDeleteOrder() {
        System.debug('=== TEST : Suppression de commande ===');
        Account testAccount = TestDataFactory.createAccount('Test Account');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        testOrder.ShipmentCost__c = 50.00;
        update testOrder;

        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00);

        testOrder.Status = 'Activated';
        update testOrder;

        testOrder.Status = 'Draft';
        update testOrder;

        delete testOrder;

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(0, updatedAccount.Chiffre_d_affaire__c, 
            'Chiffre_d_affaire__c doit être égal à 0 après suppression.');
    }
}
