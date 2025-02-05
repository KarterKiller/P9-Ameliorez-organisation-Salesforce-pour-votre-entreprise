import { LightningElement, api } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class SumOrdersComponent extends LightningElement {
    @api recordId; // ID du compte transmis au composant
    @api sumOrdersOfCurrentAccount = 0; //  Stocke la somme des commandes du compte.
    @api error = null; // Gestion des erreurs initialisé à null

    // Chargé lorsque le composant est monté
    connectedCallback() { // Méthode appelée automatiquement lorsque le composant est inséré dans le DOM.
        this.fetchSumOrders(); // pour récupérer les données dès que le composant est chargé
    }

    // Méthode pour appeler la méthode Apex
    fetchSumOrders() {
        // Vérifier si recordId est défini avant d’appeler Apex
        if (!this.recordId) {
            this.error = 'Erreur : Aucun compte sélectionné.';
            this.sumOrdersOfCurrentAccount = 0;
            return;
        }
    
        getSumOrdersByAccount({ accountId: this.recordId })
            .then((result) => {
                
    
                // Vérifier si la réponse est un nombre valide
                if (typeof result === 'number' && result > 0) {
                    this.sumOrdersOfCurrentAccount = result;
                    this.error = null; // Réinitialiser l’erreur
                } else {
                    this.sumOrdersOfCurrentAccount = 0;
                    this.error = 'Erreur, pas de commandes rattachées à ce compte ou le montant des commandes est égal à 0';
                }
            })
            .catch((error) => {
                console.error('Erreur Apex :',  error.message || error);
                this.error = 'Erreur lors de la récupération des données : ' +
                    (error.body && error.body.message ? error.body.message : 
                    error.message || JSON.stringify(error) || 'Erreur inconnue'); // Utilisation de JSON.stringify(error) comme fallback si ni error.body.message ni error.message ne sont disponibles
            })
            .finally(() => {
                // Assurer que la variable est bien définie
                if (this.sumOrdersOfCurrentAccount === undefined) {
                    this.sumOrdersOfCurrentAccount = 0;
                }
            });
    }
}   
