public with sharing class UpdateAccountCAHelper {
    public static void updateAccountChiffreDAffaire(List<Order> newOrders, List<Order> oldOrders, Boolean isInsert, Boolean isUpdate, Boolean isDelete) {
        Map<Id, Decimal> accountTotals = new Map<Id, Decimal>(); // Initialisation d'une Map pour stocker les totaux

        // Ajouter ou mettre à jour les montants des commandes activées
        if (isInsert || isUpdate) { // Ajout des montants des nouvelles commandes activées
            for (Order order : newOrders) {
                if (order.AccountId != null && order.Status == 'Activated' && order.NetAmount__c != null) {
                    if (!accountTotals.containsKey(order.AccountId)) {
                        accountTotals.put(order.AccountId, 0);
                    }
                    accountTotals.put(order.AccountId, accountTotals.get(order.AccountId) + order.NetAmount__c);
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
                    accountTotals.put(order.AccountId, accountTotals.get(order.AccountId) - order.NetAmount__c);
                }
            }
        }

        // Récupérer les comptes associés et mettre à jour leur chiffre d'affaires
        if (!accountTotals.isEmpty()) {
            List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountTotals.keySet()];
            
            for (Account account : accountsToUpdate) {
                Decimal currentTotal = account.Chiffre_d_affaire__c != null ? account.Chiffre_d_affaire__c : 0;
                Decimal newTotal = currentTotal + accountTotals.get(account.Id);
                account.Chiffre_d_affaire__c = newTotal;
                //System.debug('Compte mis à jour : ' + account.Id + ' avec Chiffre_d_affaire__c : ' + newTotal);
            }

            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                //System.debug('Erreur lors de la mise à jour des comptes : ' + e.getMessage());
                throw e; // Relancer l'erreur pour un traitement éventuel par la plateforme
            }
        }
    }
}
