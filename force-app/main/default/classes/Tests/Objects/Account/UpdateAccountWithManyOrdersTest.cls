@isTest
public class UpdateAccountWithManyOrdersTest {

    @isTest
    static void testUpdateOrderNetAmountWithShipmentCost() {
        System.debug('DÉBUT DU TEST : Mise à jour du champ NetAmount__c avec ShipmentCost__c.');

        Test.startTest();

        // Étape 1 : Création d'un compte de test
        Account testAccount = TestDataFactory.createAccount('Compte de Test');
        System.debug('Compte de test créé avec Id : ' + testAccount.Id);

        // Étape 2 : Création d'un produit et d'une entrée de prix standard
        Product2 testProduct = TestDataFactory.createProduct('Produit de Test', true);
        PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);
        System.debug('Produit et PricebookEntry créés.');

        // Étape 3 : Création de 100 commandes avec des montants variés et ShipmentCost__c
        System.debug('Création de 100 commandes avec des montants variés et ShipmentCost__c.');
        Decimal shipmentCost = 6.99;

        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();

        for (Integer i = 0; i < 100; i++) {
            Decimal orderAmount = 100 + (i * 10); // Montants variés : 100, 110, 120, ...

            // Ajouter une commande à la liste avec ShipmentCost__c
            Order order = new Order(
                AccountId = testAccount.Id,
                Pricebook2Id = Test.getStandardPricebookId(),
                Status = 'Draft',
                EffectiveDate = Date.today(),
                ShipmentCost__c = shipmentCost
            );
            orders.add(order);

            // Ajouter une ligne de commande à la liste
            OrderItem orderItem = new OrderItem(
                PricebookEntryId = testPricebookEntry.Id,
                Quantity = 1,
                UnitPrice = orderAmount
            );
            orderItems.add(orderItem);
        }

        // Insertion des commandes en une seule fois
        insert orders;

        // Mise à jour des OrderId pour les lignes de commande
        for (Integer i = 0; i < orders.size(); i++) {
            orderItems[i].OrderId = orders[i].Id;
        }

        // Insertion des lignes de commande en une seule fois
        insert orderItems;

        System.debug('100 commandes et lignes de commande créées avec succès.');

        // Étape 4 : Activation des commandes
        System.debug('Activation des commandes.');
        for (Order order : orders) {
            order.Status = 'Activated';
        }
        update orders;

        // Étape 5 : Vérification du champ NetAmount__c pour chaque commande
        System.debug('Vérification du champ NetAmount__c des commandes.');
        List<Order> reloadedOrders = [
            SELECT Id, Status, NetAmount__c, ShipmentCost__c
            FROM Order
            WHERE AccountId = :testAccount.Id
        ];

        for (Integer i = 0; i < reloadedOrders.size(); i++) {
            Decimal orderAmount = 100 + (i * 10); // Montant de la ligne de commande
            Decimal expectedNetAmountForOrder = orderAmount - shipmentCost; // Montant attendu

            System.assertEquals(expectedNetAmountForOrder, reloadedOrders[i].NetAmount__c, 
                'Le champ NetAmount__c de la commande doit être mis à jour avec le montant correct après déduction du ShipmentCost__c.');
            System.assertEquals(shipmentCost, reloadedOrders[i].ShipmentCost__c, 
                'Le champ ShipmentCost__c de la commande doit être égal à 6.99.');
            System.assertEquals('Activated', reloadedOrders[i].Status, 
                'Le statut de la commande doit être "Activated" après la mise à jour.');
        }

        System.debug('FIN DU TEST : Le champ NetAmount__c a été correctement mis à jour avec ShipmentCost__c.');

        Test.stopTest();
    }
}
