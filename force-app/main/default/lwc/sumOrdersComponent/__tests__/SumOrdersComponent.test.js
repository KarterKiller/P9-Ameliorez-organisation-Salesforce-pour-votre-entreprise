import { createElement } from 'lwc';
import SumOrdersComponent from 'c/sumOrdersComponent';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

// Mock de la méthode Apex
jest.mock('@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount', () => ({
    default: jest.fn()
}), { virtual: true });

// Fonction pour s'assurer que les Promises sont bien résolues avant de valider les assertions
function flushPromises() {
    return new Promise((resolve) => setTimeout(resolve, 0));
}

describe('c-sum-orders-component', () => {
    afterEach(() => {
        // Nettoie le DOM après chaque test
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    test('✅ Vérifier que le composant est bien affiché', () => {
        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        document.body.appendChild(element);

        // Vérifier que le composant est bien dans le DOM
        expect(element).toBeTruthy();
    });

    test('✅ Tester un appel Apex réussi avec une somme positive', async () => {
        getSumOrdersByAccount.mockResolvedValue(Promise.resolve(500));
    
        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        element.recordId = '001XXXXXXX'; // Simule un ID de compte
        document.body.appendChild(element);
    
        // ✅ Attendre que la promesse soit résolue
        await flushPromises();
        await Promise.resolve(); // Force une mise à jour supplémentaire
    
    
        // ✅ Vérifier que la somme des commandes a bien été mise à jour
        expect(element.sumOrdersOfCurrentAccount).toBe(500);
        expect(element.error).toBeNull();
    });
    
    test('❌ Tester un appel Apex avec une somme de 0', async () => {
        getSumOrdersByAccount.mockResolvedValue(0);

        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        element.recordId = '001XXXXXXX';
        document.body.appendChild(element);

        await Promise.resolve();

        expect(element.sumOrdersOfCurrentAccount).toBe(0);
        expect(element.error).toBe('Erreur, pas de commandes rattachées à ce compte ou le montant des commandes est égal à 0');
    });

    test('⚠️ Tester le cas où l’appel Apex échoue', async () => {
        getSumOrdersByAccount.mockRejectedValue(new Error('Erreur API'));

        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        element.recordId = '001XXXXXXX';
        document.body.appendChild(element);
        
        await flushPromises();
        await new Promise(resolve => setTimeout(resolve, 0));

        expect(element.sumOrdersOfCurrentAccount).toBe(0);
        
        expect(element.error).toBeTruthy();
        if (element.error) {
            expect(element.error).toContain('Erreur lors de la récupération des données');
        }
        
    });
});

    








