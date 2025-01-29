import { createElement } from 'lwc';
import SumOrdersComponent from 'c/sumOrdersComponent';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

// Simuler un appel Apex
jest.mock('@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount', () => ({
    default: jest.fn()
}));

describe('c-sum-orders-component', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should render component and call Apex method', async () => {
        const element = createElement('c-sum-orders-component', {
            is: SumOrdersComponent
        });
        document.body.appendChild(element);

        // Simule la réponse Apex
        getSumOrdersByAccount.mockResolvedValue(500);

        await Promise.resolve(); // Laisser LWC réagir aux changements
        const div = element.shadowRoot.querySelector('div');
        expect(div.textContent).toContain('500');
    });
});
