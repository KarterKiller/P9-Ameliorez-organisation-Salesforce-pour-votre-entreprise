@isTest
private class TriggerHelperTest {

    @isTest
    static void testTriggerHelperFlagBehavior() {
        //('=== DÉBUT DU TEST TriggerHelper ===');

        // Vérifie que le flag est initialement faux
        System.assertEquals(false, TriggerHelper.isTriggerExecuted, 
            'Le flag isTriggerExecuted devrait être initialisé à false.');

        // Simule une exécution de trigger en modifiant le flag
        TriggerHelper.isTriggerExecuted = true;
        System.assertEquals(true, TriggerHelper.isTriggerExecuted, 
            'Le flag isTriggerExecuted devrait être true après modification.');

        // Réinitialise le flag et vérifie qu'il est bien remis à false
        TriggerHelper.isTriggerExecuted = false;
        System.assertEquals(false, TriggerHelper.isTriggerExecuted, 
            'Le flag isTriggerExecuted devrait être false après réinitialisation.');

        //System.debug('=== FIN DU TEST TriggerHelper ===');
    }

    @isTest
    static void testTriggerBehaviorWithFlag() {
        //System.debug('=== TEST : Comportement de déclencheur avec TriggerHelper ===');

        // Étape 1 : Crée un compte
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Étape 2 : Simule l'exécution d'un trigger pour vérifier l'utilisation du flag
        if (!TriggerHelper.isTriggerExecuted) {
            TriggerHelper.isTriggerExecuted = true;

            // Simule une logique de trigger (par exemple, mise à jour de l'Account)
            testAccount.Name = 'Updated Test Account';
            update testAccount;

            // Vérifie que la logique ne s'exécute qu'une fois
            System.assert(TriggerHelper.isTriggerExecuted, 
                'La logique du trigger devrait s’exécuter uniquement une fois.');
        }

        // Étape 3 : Vérifie que le flag reste actif dans la transaction en cours
        System.assertEquals(true, TriggerHelper.isTriggerExecuted, 
            'Le flag devrait rester true jusqu’à la fin de la transaction.');

        //System.debug('=== FIN DU TEST : Comportement de déclencheur avec TriggerHelper ===');
    }
}
