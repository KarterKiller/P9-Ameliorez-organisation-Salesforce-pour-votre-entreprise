import { LightningElement, api } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class Orders extends LightningElement {
    @api recordId; // ID du compte transmis au composant
    sumOrdersOfCurrentAccount = 0; // Montant total des commandes
    error; // Gestion des erreurs

    // Chargé lorsque le composant est monté
    connectedCallback() {
        this.fetchSumOrders();
    }

    // Méthode pour appeler la méthode Apex
    fetchSumOrders() {
        getSumOrdersByAccount({ accountId: this.recordId })
            .then((result) => {
                console.log('Résultat retourné par Apex :', result);
                if (result > 0) {
                    this.sumOrdersOfCurrentAccount = result;
                    this.error = null; // Réinitialiser les erreurs
                } else {
                    this.sumOrdersOfCurrentAccount = 0;
                    this.error = 'Erreur, pas de commandes rattachées à ce compte ou le montant des commandes est égale à 0';
                }
            })
            .catch((error) => {
                console.error('Erreur Apex :', error);
                this.error = 'Erreur lors de la récupération des données : ' + (error.body ? error.body.message : error);
                this.sumOrdersOfCurrentAccount = 0;
            });
    }
}
