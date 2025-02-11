import { LightningElement, api, wire } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';
import { refreshApex } from '@salesforce/apex';

export default class SumOrdersComponent extends LightningElement {
    @api recordId;
    sumOrdersOfCurrentAccount = 0;
    error;

    // Stocke la réponse de la méthode Apex pour refreshApex
    wiredSumOrders;

    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredSumOrdersHandler(result) {
        this.wiredSumOrders = result; // Stocke la réponse pour le rafraîchissement

        if (result.data) {
            this.sumOrdersOfCurrentAccount = result.data;
            this.error = null;
        } else if (result.error) {
            console.error('Erreur Apex :', result.error);
            this.sumOrdersOfCurrentAccount = 0;
            this.error = 'Erreur lors de la récupération des données';
        }
    }

    // Méthode pour rafraîchir les données si nécessaire
    refreshData() {
        refreshApex(this.wiredSumOrders);
    }
}
