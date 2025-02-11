public with sharing class UpdateAccountCAHelper { // Classe pour mettre à jour le chiffre d'affaires des comptes
    public static void updateAccountChiffreDAffaire(List<Order> newOrders, List<Order> oldOrders, Boolean isInsert, Boolean isUpdate, Boolean isDelete) {
        Map<Id, Decimal> accountTotals = new Map<Id, Decimal>(); // Initialisation d'une Map pour stocker les totaux avec une Key = CompteId et Value = Total

        // Ajouter ou mettre à jour les montants des commandes activées
        if (isInsert || isUpdate) { // Ajout des montants des nouvelles commandes activées en vérifiant si évenement est un insert ou un update. 
            for (Order order : newOrders) {
                if (order.AccountId != null && order.Status == 'Activated' && order.NetAmount__c != null) { // 3 cdts à respecter
                    if (!accountTotals.containsKey(order.AccountId)) {
                        accountTotals.put(order.AccountId, 0); // Si l'acc n'existe pas, alors l'acc de la map n'aura pas de valeur. Donc on initialise à 0.                 
                    }
                    accountTotals.put(order.AccountId, accountTotals.get(order.AccountId) + order.NetAmount__c); // Ajouter le montant de la commande (NetAmount__c).
                }
            }
        }

        // Soustraire les montants des commandes activées dans l'ancien état
        if (isUpdate || isDelete) {
            List<Order> ordersToProcess = isDelete ? oldOrders : oldOrders;
            for (Order order : ordersToProcess) {
                if (order.AccountId != null && order.Status == 'Activated' && order.NetAmount__c != null) {
                    if (!accountTotals.containsKey(order.AccountId)) {
                        accountTotals.put(order.AccountId, 0);
                    }
                    accountTotals.put(order.AccountId, accountTotals.get(order.AccountId) - order.NetAmount__c); // Cette ligne enlève l'ancien montant (Trigger.old)
                }
            }
        }

        // Récupérer les comptes associés et mettre à jour leur chiffre d'affaires
        if (!accountTotals.isEmpty()) {
            List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountTotals.keySet()]; //On récupère seulement les comptes qui sont présents dans accountTotals.
            
            for (Account account : accountsToUpdate) {
                Decimal currentTotal = account.Chiffre_d_affaire__c != null ? account.Chiffre_d_affaire__c : 0; // On récupère le chiffre d'affaires actuel du compte et on initialise à 0 si il n'existe pas. ( null) sinon erreur NullPointerException
                Decimal newTotal = currentTotal + accountTotals.get(account.Id); // On additionne le montant stocké dans accountTotals au chiffre d'affaires actuel du compte. 
                account.Chiffre_d_affaire__c = newTotal; // On met à jour le chiffre d'affaires du compte.
                //System.debug('Compte mis à jour : ' + account.Id + ' avec Chiffre_d_affaire__c : ' + newTotal);
            }

            try {
                update accountsToUpdate; // On met à jour les comptes avec le nouveau chiffre d'affaires. Une seule MAJ pour tous les comptes. 
            } catch (DmlException e) { // Si une erreur survient, on relance l'erreur pour un traitement éventuel par la plateforme.
                //System.debug('Erreur lors de la mise à jour des comptes : ' + e.getMessage());
                throw e; // Avec throw e;, Salesforce peut afficher un message d'erreur clair dans l’interface utilisateur
            }
        }
    }
} // "isUpdate est dans les deux parties parce qu'une mise à jour implique deux actions : d'abord soustraire l'ancien montant (Trigger.old),
 // puis ajouter le nouveau (Trigger.new). Cela évite les erreurs de double comptage."