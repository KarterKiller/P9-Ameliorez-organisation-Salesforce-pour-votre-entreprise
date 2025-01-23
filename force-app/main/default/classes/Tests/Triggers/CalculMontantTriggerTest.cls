@isTest
private class CalculMontantTriggerTest {

    
    @isTest
static void testCalculMontantInsert() {
    System.debug('=== DÉBUT DU TEST CalculMontantTrigger pour insert ===');

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Test Account');
    System.debug('Compte créé avec ID : ' + testAccount.Id);

    // Crée un produit
    Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
    System.debug('Produit créé avec ID : ' + testProduct.Id);

    // Crée une entrée dans le Standard Pricebook
    TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

    // Crée un Pricebook de test
    Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 150.00, false);

    // Insère une commande avec EffectiveDate et ShipmentCost
    System.debug('Création d\'une commande.');
    Order testOrder = new Order(
        AccountId = testAccount.Id,
        Pricebook2Id = testPricebook.Id,
        Status = 'Draft',
        EffectiveDate = Date.today(),
        ShipmentCost__c = 50.00
    );
    insert testOrder;

    //Vérification du statut initiale de la commande
    System.assertEquals('Draft', testOrder.Status, 'Le statut de la commande doit être initialement en satut Draft');

    // Ajoute une ligne de commande pour calculer TotalAmount
    System.debug('Ajout d\'une ligne de commande.');
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00); // 1 x 200.00 = TotalAmount = 200.00

    // Passe la commande en statut Activated
    System.debug('Passage de la commande en statut Activated.');
    testOrder.Status = 'Activated';
    update testOrder;

    // Recharge la commande après l'ajout des lignes de commande et mise à jour du statut
    System.debug('Recharge de la commande après activation.');
    Order reloadedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c, Status FROM Order WHERE Id = :testOrder.Id];
    System.debug('Commande rechargée : ' + reloadedOrder);

    // Vérifie les valeurs calculées
    System.assertEquals(200.00, reloadedOrder.TotalAmount, 'TotalAmount devrait être calculé à partir des lignes de commande.');
    System.assertEquals(150.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être TotalAmount - ShipmentCost.');
    System.assertEquals('Activated', reloadedOrder.Status, 'Le statut de la commande devrait être Activated.');

    System.debug('=== FIN DU TEST CalculMontantTrigger pour insert ===');
}


@isTest
static void testCalculMontantUpdate() {
    System.debug('=== DÉBUT DU TEST CalculMontantTrigger pour update ===');

    // Crée un compte via TestDataFactory
    Account testAccount = TestDataFactory.createAccount('Test Account');
    System.debug('Compte créé avec ID : ' + testAccount.Id);

    // Crée un produit via TestDataFactory
    Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
    System.debug('Produit créé avec ID : ' + testProduct.Id);

    // Crée une entrée dans le Standard Pricebook
    TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

    // Crée un Pricebook de test via TestDataFactory
    Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 150.00, false);

    // Crée une commande avec EffectiveDate et ShipmentCost
    System.debug('Création d\'une commande.');
    Order testOrder = new Order(
        AccountId = testAccount.Id,
        Pricebook2Id = testPricebook.Id,
        Status = 'Draft',
        EffectiveDate = Date.today(),
        ShipmentCost__c = 50.00 // Coût initial d'expédition
    );
    insert testOrder;

    // Ajoute une ligne de commande pour calculer TotalAmount
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 100.00); // TotalAmount = 2 x 100.00 = 200.00

    // Passe la commande en statut Activated
    testOrder.Status = 'Activated';
    update testOrder;

    // Recharge la commande après activation
    Order activatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c, Status FROM Order WHERE Id = :testOrder.Id];
    System.debug('Commande après activation : ' + activatedOrder);

    // Vérifie les valeurs calculées après activation
    System.assertEquals(200.00, activatedOrder.TotalAmount, 'TotalAmount devrait être calculé à partir des lignes de commande.');
    System.assertEquals(200.00 - 50.00, activatedOrder.NetAmount__c, 
        'NetAmount__c devrait être égal à TotalAmount - ShipmentCost initial.');

    // Mise à jour du champ ShipmentCost
    System.debug('Mise à jour du champ ShipmentCost__c.');
    testOrder.ShipmentCost__c = 150.00;
    update testOrder;

    // Recharge la commande après mise à jour
    Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
    System.debug('Commande après mise à jour : ' + updatedOrder);

    // Vérifie les valeurs calculées après mise à jour
    System.assertEquals(200.00, updatedOrder.TotalAmount, 'TotalAmount ne doit pas changer après la mise à jour de ShipmentCost.');
    System.assertEquals(200.00 - 150.00, updatedOrder.NetAmount__c, 
        'NetAmount__c devrait être recalculé après la mise à jour de ShipmentCost.');

    System.debug('=== FIN DU TEST CalculMontantTrigger pour update ===');
    }

    @isTest
static void testCalculMontantWithNullShipmentCost() {
    System.debug('=== DÉBUT DU TEST CalculMontantTrigger avec ShipmentCost null ===');

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Test Account');
    System.debug('Compte créé avec ID : ' + testAccount.Id);

    // Crée un produit
    Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
    System.debug('Produit créé avec ID : ' + testProduct.Id);

    // Crée une entrée dans le Standard Pricebook
    TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

    // Crée un Pricebook de test
    Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 150.00, false);

    // Insère une commande avec ShipmentCost null
    System.debug('Création d\'une commande avec ShipmentCost null.');
    Order testOrder = new Order(
        AccountId = testAccount.Id,
        Pricebook2Id = testPricebook.Id,
        Status = 'Draft',
        EffectiveDate = Date.today(), // EffectiveDate est obligatoire
        ShipmentCost__c = null // Null pour simuler l'absence de coût d'expédition
    );
    insert testOrder;

    // Ajoute une ligne de commande pour calculer TotalAmount
    System.debug('Ajout d\'une ligne de commande.');
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 100.00); // 1 x 100.00 = TotalAmount = 100.00

    // Passe la commande en statut Activated
    System.debug('Passage de la commande en statut Activated.');
    testOrder.Status = 'Activated';
    update testOrder;

    // Recharge la commande après l'ajout des lignes de commande
    Order reloadedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
    System.debug('Commande après insertion : ' + reloadedOrder);

    // Vérifie que les calculs sont corrects
    System.assertEquals(100.00, reloadedOrder.TotalAmount, 'TotalAmount devrait être calculé à partir des lignes de commande.');
    System.assertEquals(100.00, reloadedOrder.NetAmount__c, 'NetAmount__c devrait être égal à TotalAmount lorsque ShipmentCost est null.');

    System.debug('=== FIN DU TEST CalculMontantTrigger avec ShipmentCost null ===');
}

@isTest
static void testCalculMontantWithMultipleOrderItems() {
    System.debug('=== TEST : Calcul avec plusieurs lignes de commande ===');

    // Crée un compte et un produit
    Account testAccount = TestDataFactory.createAccount('Test Account');
    Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
    PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);

    // Crée une commande
    Order testOrder = new Order(
        AccountId = testAccount.Id,
        Pricebook2Id = Test.getStandardPricebookId(),
        Status = 'Draft',
        EffectiveDate = Date.today(),
        ShipmentCost__c = 20.00
    );
    insert testOrder;

    // Ajoute plusieurs lignes de commande
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 100.00); // Ligne 1
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 150.00); // Ligne 2
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 3, 200.00); // Ligne 3

    // Passe la commande en statut Activated
    testOrder.Status = 'Activated';
    update testOrder;

    // Vérifie les calculs
    Order reloadedOrder = [SELECT TotalAmount, NetAmount__c FROM Order WHERE Id = :testOrder.Id];
    System.assertEquals(100.00 + (2 * 150.00) + (3 * 200.00), reloadedOrder.TotalAmount, 'TotalAmount devrait être la somme des lignes.');
    System.assertEquals((100.00 + 300.00 + 600.00) - 20.00, reloadedOrder.NetAmount__c, 
        'NetAmount__c devrait être TotalAmount - ShipmentCost.');

    System.debug('=== FIN DU TEST : Calcul avec plusieurs lignes de commande ===');
}
   
}

