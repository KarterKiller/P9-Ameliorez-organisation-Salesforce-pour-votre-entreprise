public without sharing class MyTeamOrdersController {

    /**
     * Méthode pour récupérer la somme des montants des commandes activées pour un compte donné.
     * @param accountId L'ID du compte pour lequel calculer le total des commandes activées.
     * @return La somme des montants (Decimal) ou 0 si aucune commande activée n'est trouvée.
     * @throws AuraHandledException si l'ID du compte est null ou invalide.
     */
    @AuraEnabled
    public static Decimal getSumOrdersByAccount(Id accountId) {

            // Requête pour récupérer la somme des commandes activées
            AggregateResult groupedResults = [
                SELECT SUM(TotalAmount) total 
                FROM Order 
                WHERE Status = 'Activated' AND AccountId = :accountId
            ];

            // Retourner le total ou 0 si aucun résultat
            return (Decimal)groupedResults.get('total') != null ? (Decimal)groupedResults.get('total') : 0;

        
        
    }
}