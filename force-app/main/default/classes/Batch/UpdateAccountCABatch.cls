global class UpdateAccountCABatch implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Récupérer tous les comptes actifs
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        // Optimisation : Récupérer toutes les commandes activées en une seule requête
        Map<Id, Decimal> accountNetAmounts = new Map<Id, Decimal>();
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        
        // Une seule requête pour récupérer les montants nets par compte
        for (AggregateResult result : [
            SELECT AccountId, SUM(NetAmount__c) sumNetAmount
            FROM Order
            WHERE AccountId IN :accountIds AND Status = 'Activated'
            GROUP BY AccountId
        ]) {
            accountNetAmounts.put((Id)result.get('AccountId'), (Decimal)result.get('sumNetAmount'));
        }
        
        // Mettre à jour les comptes avec les montants calculés
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            Decimal netAmount = accountNetAmounts.get(acc.Id);
            acc.Chiffre_d_affaire__c = netAmount != null ? netAmount : 0;
            accountsToUpdate.add(acc);
        }
        
        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                System.debug('Erreur lors de la mise à jour des comptes : ' + e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch terminé avec succès.');
    }
}
