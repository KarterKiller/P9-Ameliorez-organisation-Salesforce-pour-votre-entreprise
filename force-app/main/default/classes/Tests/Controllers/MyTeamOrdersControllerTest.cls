@isTest
private class MyTeamOrdersControllerTest {

    @isTest
    static void testGetSumOrdersByAccount() {
        System.debug('=== DÉBUT DU TEST MyTeamOrdersController.getSumOrdersByAccount ===');

        // Crée un compte de test
        System.debug('Création du compte de test.');
        Account testAccount = TestDataFactory.createAccount('Test Account');
        System.debug('Compte créé avec ID : ' + testAccount.Id);

        // Crée un produit
        System.debug('Création du produit de test.');
        Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
        System.debug('Produit créé avec ID : ' + testProduct.Id);

        // Crée une entrée dans le Standard Pricebook
        System.debug('Création dune entrée dans le Standard Pricebook.');
        TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);

        // Crée un Pricebook de test
        System.debug('Création dun Pricebook de test.');
        Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
        System.debug('Pricebook de test créé avec ID : ' + testPricebook.Id);

        // Crée une entrée dans le Pricebook de test
        System.debug('Création dune entrée dans le Pricebook de test.');
        PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 100.00, false);
        System.debug('Entrée de Pricebook créée avec ID : ' + testPricebookEntry.Id);

        // Crée une commande activée
        System.debug('Création dune commande activée associée au compte.');
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, testPricebook.Id, 'Draft');
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 100.00);

        System.debug('Activation de la commande.');
        testOrder.Status = 'Activated';
        update testOrder;
        System.debug('Commande activée avec ID : ' + testOrder.Id);

        // Exécution de la méthode testée
        System.debug('Appel de MyTeamOrdersController.getSumOrdersByAccount.');
        Test.startTest();
        Decimal totalAmount = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();
        System.debug('Résultat de la méthode : ' + totalAmount);

        // Vérifications
        System.assertEquals(200.00, totalAmount, 'Le montant total des commandes activées devrait être 200.00.');

        System.debug('=== FIN DU TEST MyTeamOrdersController.getSumOrdersByAccount ===');
    }

    @isTest
    static void testGetSumOrdersByAccountNoOrders() {
        System.debug('=== DÉBUT DU TEST MyTeamOrdersController.getSumOrdersByAccountNoOrders ===');

        // Crée un compte sans commandes activées
        System.debug('Création dun compte sans commandes.');
        Account testAccount = TestDataFactory.createAccount('Empty Account');
        System.debug('Compte créé avec ID : ' + testAccount.Id);

        // Exécution de la méthode testée
        System.debug('Appel de MyTeamOrdersController.getSumOrdersByAccount pour un compte sans commandes.');
        Test.startTest();
        Decimal totalAmount = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
        Test.stopTest();
        System.debug('Résultat de la méthode : ' + totalAmount);

        // Vérifications
        System.assertEquals(0, totalAmount, 'Le montant total des commandes activées devrait être 0.');

        System.debug('=== FIN DU TEST MyTeamOrdersController.getSumOrdersByAccountNoOrders ===');
    }

    @isTest
static void testGetSumOrdersByAccountMultipleOrders() {
    System.debug('=== DÉBUT DU TEST testGetSumOrdersByAccountMultipleOrders ===');

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Test Account Multiple Orders');

    // Crée un produit
    Product2 testProduct = TestDataFactory.createProduct('Test Product Multiple Orders', true);

    // Crée une entrée dans le Standard Pricebook
    TestDataFactory.createStandardPricebookEntry(testProduct.Id, 150.00);

    // Crée un Pricebook de test
    Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 150.00, false);

    // Crée plusieurs commandes activées
    Decimal expectedTotal = 0;
    for (Integer i = 1; i <= 3; i++) {
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, testPricebook.Id, 'Draft');
        TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, i, 150.00);
        testOrder.Status = 'Activated';
        update testOrder;

        expectedTotal += i * 150.00; // TotalAmount = quantité * prix unitaire
    }

    // Appelle la méthode testée
    Test.startTest();
    Decimal actualTotal = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
    Test.stopTest();

    // Vérifie le résultat
    System.assertEquals(expectedTotal, actualTotal, 'Le montant total des commandes activées devrait correspondre à la somme des montants.');
    System.debug('=== FIN DU TEST testGetSumOrdersByAccountMultipleOrders ===');

}


@isTest
static void testGetSumOrdersByAccountWithZeroTotal() {
    System.debug('=== DÉBUT DU TEST testGetSumOrdersByAccountWithZeroTotal ===');

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Test Account Zero Total');

    // Crée un produit
    Product2 testProduct = TestDataFactory.createProduct('Test Product Zero Total', true);

    // Crée une entrée dans le Standard Pricebook
    TestDataFactory.createStandardPricebookEntry(testProduct.Id, 0.00);

    // Crée un Pricebook de test
    Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
    PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct.Id, testPricebook.Id, 0.00, false);

    // Crée une commande activée avec un montant total de 0
    Order testOrder = TestDataFactory.createOrder(testAccount.Id, testPricebook.Id, 'Draft');
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 2, 0.00);
    testOrder.Status = 'Activated';
    update testOrder;

    // Appelle la méthode testée
    Test.startTest();
    Decimal actualTotal = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
    Test.stopTest();

    // Vérifie que le total est 0
    System.assertEquals(0, actualTotal, 'Le montant total des commandes activées devrait être 0.');
    System.debug('=== FIN DU TEST testGetSumOrdersByAccountWithZeroTotal ===');

}

@isTest
static void testGetSumOrdersByAccountWithNoActivatedOrders() {
    System.debug('=== TEST : Compte sans commandes activées ===');

    // Crée un compte sans commandes
    Account testAccount = TestDataFactory.createAccount('Test Account No Orders');

    Test.startTest();
    Decimal result = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
    Test.stopTest();

    System.assertEquals(0, result, 'La méthode devrait retourner 0 pour un compte sans commandes activées.');

    System.debug('=== FIN DU TEST : Compte sans commandes activées ===');

    
}


    

@isTest
static void testGetSumOrdersByAccountWithValidData() {
    System.debug('=== TEST : Méthode retourne un résultat valide ===');

    // Crée un compte
    Account testAccount = TestDataFactory.createAccount('Test Account Valid Data');

    // Crée un produit et une entrée dans le Pricebook
    Product2 testProduct = TestDataFactory.createProduct('Test Product', true);
    PricebookEntry testPricebookEntry = TestDataFactory.createStandardPricebookEntry(testProduct.Id, 100.00);

    // Crée une commande activée avec un montant total
    Order testOrder = TestDataFactory.createOrder(testAccount.Id, Test.getStandardPricebookId(), 'Draft');
    TestDataFactory.createOrderItem(testOrder.Id, testPricebookEntry.Id, 1, 200.00);
    testOrder.Status = 'Activated';
    update testOrder;

    // Exécute la méthode et vérifie le résultat
    Test.startTest();
    Decimal result = MyTeamOrdersController.getSumOrdersByAccount(testAccount.Id);
    Test.stopTest();

    System.assertEquals(200.00, result, 'La méthode devrait retourner la somme correcte des montants activés.');

    System.debug('=== FIN DU TEST : Méthode retourne un résultat valide ===');

}

}










            
       