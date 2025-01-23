public without sharing class OrderHelper {
    /**
     * Méthode statique pour calculer NetAmount__c.
     * @param order L'objet Order à traiter.
     * @throws IllegalArgumentException si l'objet Order est null.
     */
    public static void calculateNetAmount(Order order) {
        // Vérification de l'objet Order
        if (order == null) {
            throw new IllegalArgumentException('L\'objet Order ne peut pas être null.');
        }

        // Initialiser ShipmentCost__c à 0 s'il est null
        Decimal shipmentCost = order.ShipmentCost__c != null ? order.ShipmentCost__c : 0;

        // Vérifier que TotalAmount est défini (calculé par Salesforce)
        if (order.TotalAmount != null) {
            Decimal calculatedNetAmount = order.TotalAmount - shipmentCost;

            // Éviter les mises à jour inutiles
            if (order.NetAmount__c == null || order.NetAmount__c != calculatedNetAmount) {
                order.NetAmount__c = calculatedNetAmount;

                // Log sécurisé
                if (order.Id != null) {
                    System.debug('NetAmount__c mis à jour pour Order ID : ' + order.Id);
                } else {
                    System.debug('NetAmount__c mis à jour pour une nouvelle commande (ID non défini).');
                }
            }
        } else {
            if (order.NetAmount__c != 0) {
                order.NetAmount__c = 0;

                // Log sécurisé
                if (order.Id != null) {
                    System.debug('NetAmount__c mis à 0 pour Order ID : ' + order.Id + ' car TotalAmount est null.');
                } else {
                    System.debug('NetAmount__c mis à 0 pour une nouvelle commande (ID non défini) car TotalAmount est null.');
                }
            }
        }
    }
}