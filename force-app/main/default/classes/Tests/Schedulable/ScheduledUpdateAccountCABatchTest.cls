@isTest
private class ScheduledUpdateAccountCABatchTest {

    @isTest
    static void testScheduledExecution() {
        System.debug('=== DÉBUT DU TEST ScheduledUpdateAccountCABatch ===');

        // Simule l'exécution planifiée
        Test.startTest();

        // Exécute le job planifié
        String jobName = 'Test_ScheduledUpdateAccountCABatch';
        String cronExp = '0 0 12 * * ?'; // Exécution quotidienne à 12h00
        Id jobId = System.schedule(jobName, cronExp, new ScheduledUpdateAccountCABatch());

        System.debug('Job planifié avec ID : ' + jobId);

        // Simule l'exécution du batch dans le contexte planifié
        Test.stopTest();

        // Vérifie que le job planifié existe
        CronTrigger ct = [SELECT Id, CronJobDetail.Name, State FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('Test_ScheduledUpdateAccountCABatch', ct.CronJobDetail.Name, 'Le nom du job planifié devrait correspondre.');
        System.assertEquals('WAITING', ct.State, 'Le job planifié devrait être en attente.');

        System.debug('=== FIN DU TEST ScheduledUpdateAccountCABatch ===');
    }
}
