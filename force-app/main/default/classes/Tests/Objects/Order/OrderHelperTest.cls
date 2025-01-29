@isTest
public class OrderHelperTest {

    @isTest
    static void testCalculateNetAmount() {
        //System.debug('=== Début du test pour OrderHelper.calculateNetAmount ===');

        // Créer un compte via TestDataFactory
        Account testAccount = TestDataFactory.createAccount('Test Account');

        // Créer un produit via TestDataFactory
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);

        // Créer une entrée dans le Standard Pricebook via TestDataFactory
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);

        // Créer une commande via TestDataFactory
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');

        // Ajouter des lignes de commande via TestDataFactory
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 100.00); // Total = 200
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 50.00);  // Total = 50

        // Recharger la commande pour inclure TotalAmount calculé
        testOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];

        // Vérifiez que TotalAmount est bien calculé
        System.assertEquals(250.00, testOrder.TotalAmount, 'TotalAmount devrait être égal à la somme des lignes de commande.');

        // Ajouter un ShipmentCost__c à la commande
        testOrder.ShipmentCost__c = 20.00;
        update testOrder;

        // Appeler la méthode helper
        OrderHelper.calculateNetAmount(testOrder);

        // Vérifier que NetAmount est correctement calculé
        Decimal expectedNetAmount = testOrder.TotalAmount - testOrder.ShipmentCost__c;
        System.assertEquals(expectedNetAmount, testOrder.NetAmount__c,
            'NetAmount__c devrait être égal à TotalAmount - ShipmentCost__c.');

        //System.debug('=== Fin du test pour OrderHelper.calculateNetAmount ===');
    
}

@isTest
static void testCalculateNetAmountWithNullValues() {
    System.debug('=== Début du test pour OrderHelper.calculateNetAmount avec des valeurs nulles ===');

    // Étape 1 : Créer un compte via TestDataFactory
    Account testAccount = TestDataFactory.createAccount('Test Account Null Values');

    // Étape 2 : Créer une commande via TestDataFactory avec ShipmentCost__c = null
    Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');
    testOrder.ShipmentCost__c = null; // Définir ShipmentCost__c comme null
    update testOrder;

    // Étape 3 : Appeler la méthode helper pour calculer NetAmount
    OrderHelper.calculateNetAmount(testOrder);

    // Étape 4 : Valider les résultats
    Order reloadedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];

    // Vérifier que TotalAmount est égale à 0
    System.assertEquals(0.00, reloadedOrder.TotalAmount, 'TotalAmount devrait être égale à 0 car aucune ligne de commande n\'est ajoutée.');

    // Vérifier que ShipmentCost__c est null
    System.assertEquals(null, reloadedOrder.ShipmentCost__c, 'ShipmentCost__c devrait être null.');

    // Vérifier que NetAmount__c est calculé correctement (à 0 dans ce cas)
    System.assertEquals(0, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être égal à 0 lorsque TotalAmount et ShipmentCost__c sont null.');

    System.debug('=== Fin du test pour OrderHelper.calculateNetAmount avec des valeurs nulles ===');
}
}