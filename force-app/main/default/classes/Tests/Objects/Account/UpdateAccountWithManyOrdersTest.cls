@isTest
public class UpdateAccountWithManyOrdersTest {

    @isTest
static void testUpdateOrderNetAmountWithShipmentCost() {
    System.debug('DÉBUT DU TEST : Mise à jour du champ NetAmount__c avec ShipmentCost__c.');

    Test.startTest();

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Compte de Test');
    // Crée un produit et une entrée dans le Pricebook
    Product2 testProduct = TestDataFactory.createProduct('Produit de Test', true);
    PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);

    // Crée plusieurs commandes avec lignes de commande associées
    List<Order> orders = TestDataFactory.createOrdersWithItems(
        testAccount.Id,
        Test.getStandardPricebookId(),
        testPricebookEntry.Id,
        100, // Nombre de commandes
        6.99 // ShipmentCost pour chaque commande
    );

    // Passe toutes les commandes en statut Activated
    for (Order order : orders) {
        order.Status = 'Activated';
    }
    update orders;

    // Vérifie les résultats
    List<Order> reloadedOrders = [
        SELECT Id, Status, NetAmount__c, ShipmentCost__c
        FROM Order
        WHERE AccountId = :testAccount.Id
    ];

    Decimal shipmentCost = 6.99;
    for (Integer i = 0; i < reloadedOrders.size(); i++) {
        Decimal expectedNetAmount = (100 + (i * 10)) - shipmentCost;
        System.assertEquals(expectedNetAmount, reloadedOrders[i].NetAmount__c,
            'Le NetAmount__c doit correspondre à TotalAmount - ShipmentCost.');
        System.assertEquals('Activated', reloadedOrders[i].Status, 
            'Le statut de la commande doit être "Activated".');
    }

    System.debug('FIN DU TEST : NetAmount__c mis à jour correctement.');

    Test.stopTest();
}
}