import { createElement } from 'lwc';
import SumOrdersComponent from 'c/sumOrdersComponent';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';
import { registerLdsTestWireAdapter } from '@salesforce/sfdx-lwc-jest';

// Simuler un appel Apex
jest.mock('@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount', () => ({
    default: jest.fn()
}));

describe('c-sum-orders-component', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks(); // Nettoyer les mocks entre chaque test
    });

    it('affiche le montant total des commandes retourné par Apex', async () => {
        // Arrange : Simuler un retour d'Apex avec une valeur
        getSumOrdersByAccount.mockResolvedValue(500);

        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        document.body.appendChild(element);

        // Attendre la fin des promesses
        await Promise.resolve();

        // Act : Vérifier l'affichage du montant récupéré
        const sumDisplay = element.shadowRoot.querySelector('.sum-orders');
        expect(sumDisplay.textContent).toBe('500');
    });

    it('affiche un message d\'erreur en cas d\'échec de l\'appel Apex', async () => {
        // Arrange : Simuler une erreur de l'appel Apex
        getSumOrdersByAccount.mockRejectedValue(new Error('Erreur Apex'));

        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        document.body.appendChild(element);

        // Attendre la fin des promesses
        await Promise.resolve();

        // Act : Vérifier l'affichage du message d'erreur
        const errorMessage = element.shadowRoot.querySelector('.error-message');
        expect(errorMessage).not.toBeNull();
        expect(errorMessage.textContent).toContain('Erreur');
    });

    it('ne charge pas de valeur si aucun ID de compte n\'est fourni', async () => {
        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });

        document.body.appendChild(element);

        // Attendre la fin des promesses
        await Promise.resolve();

        // Vérifier que l'appel Apex n'a pas été fait
        expect(getSumOrdersByAccount).not.toHaveBeenCalled();
    });
});
