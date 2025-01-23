@isTest
private class UpdateAccountCABatchTest {

    @isTest
    static void testBatchExecution() {
        System.debug('=== DÉBUT DU TEST UpdateAccountCABatch ===');

        // Crée un compte
        System.debug('Création du compte de test.');
        Account acc = TestDataFactory.createAccount('Test Account');
        System.debug('Compte créé avec ID : ' + acc.Id);

        // Crée un produit
        System.debug('Création du produit standard.');
        Product2 prodStandard = TestDataFactory.createProduct('Produit Standard', true);
        System.debug('Produit standard créé avec ID : ' + prodStandard.Id);

        // Crée une entrée dans le Standard Pricebook
        System.debug('Création d\'une entrée dans le Standard Pricebook.');
        TestDataFactory.createStandardPricebookEntry(prodStandard.Id, 100.00);

        // Crée un Pricebook de test
        System.debug('Création d\'un Pricebook de test.');
        Pricebook2 testPricebook = TestDataFactory.createStandardPricebook();
        System.debug('Pricebook de test créé avec ID : ' + testPricebook.Id);

        // Crée une entrée dans le Pricebook de test
        System.debug('Création d\'une entrée dans le Pricebook de test.');
        PricebookEntry pbeStandard = TestDataFactory.createPricebookEntry(prodStandard.Id, testPricebook.Id, 100.00, false);
        System.debug('Entrée du Pricebook créée avec ID : ' + pbeStandard.Id);

        // Crée une commande en statut Draft
        System.debug('Création de la commande associée au compte en statut Draft.');
        Order ord = TestDataFactory.createOrder(acc.Id, testPricebook.Id, 'Draft');
        System.debug('Commande créée avec ID : ' + ord.Id);

        // Ajout d'une ligne de commande pour le produit
        System.debug('Ajout d\'une ligne de commande pour le produit créé.');
        TestDataFactory.createOrderItem(ord.Id, pbeStandard.Id, 2, 100.00);
        System.debug('Ligne de commande créée pour le produit avec ID : ' + prodStandard.Id);

        // Mise à jour de la commande en statut Activated
        System.debug('Activation de la commande.');
        ord.Status = 'Activated';
        update ord;
        System.debug('Commande activée avec ID : ' + ord.Id);

        // Exécute le batch
        System.debug('Début de l\'exécution du batch UpdateAccountCABatch.');
        Test.startTest();
        Database.executeBatch(new UpdateAccountCABatch());
        Test.stopTest();
        System.debug('Fin de l\'exécution du batch.');

        // Vérifie le chiffre d'affaires
        System.debug('Vérification du chiffre d\'affaires mis à jour.');
        Account updatedAcc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.debug('Compte mis à jour avec ID : ' + updatedAcc.Id);
        System.debug('Chiffre d\'affaires attendu : 200.00');
        System.debug('Chiffre d\'affaires réel : ' + updatedAcc.Chiffre_d_affaire__c);
        System.assertEquals(200.00, updatedAcc.Chiffre_d_affaire__c, 'Le chiffre d\'affaire doit être égal à 200.00.');

        System.debug('=== FIN DU TEST UpdateAccountCABatch ===');
    }
}
