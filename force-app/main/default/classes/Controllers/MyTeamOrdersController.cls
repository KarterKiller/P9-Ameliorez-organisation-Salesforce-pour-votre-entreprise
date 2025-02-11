public with sharing class MyTeamOrdersController {

    /**
     * Méthode pour récupérer la somme des montants des commandes activées pour un compte donné et les afficher sur le composant SumOrdersComponent.
     * @param accountId L'ID du compte pour lequel calculer le total des commandes activées.
     * @return La somme des montants (Decimal) ou 0 si aucune commande activée n'est trouvée.
     * @throws AuraHandledException si l'ID du compte est null ou invalide.
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        // Vérifier que l'ID du compte est valide
        if (accountId == null) {
            throw new AuraHandledException('L\'ID du compte est invalide.');
        }

            // Requête pour récupérer la somme des commandes activées
            AggregateResult groupedResults = [ // La requête est une requête sélectionnée (SELECT) qui récupère des données d'une seule ligne (SUM) et qui est ensuite agrégée par la clé (GROUP BY).
                SELECT SUM(TotalAmount) total 
                FROM Order 
                WHERE Status = 'Activated' AND AccountId = :accountId
            ];

            // Retourner le total ou 0 si aucun résultat
            return (Decimal)groupedResults.get('total') != null ? (Decimal)groupedResults.get('total') : 0;

        
        
    }
}