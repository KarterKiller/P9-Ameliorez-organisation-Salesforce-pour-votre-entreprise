public class TestDataFactory {

    /**
     * Crée et retourne le Standard Price Book.
     * Cette méthode ne dépend pas des données existantes dans l'organisation.
     * @return L'instance du Standard Price Book créée pour le test.
     */
    public static Pricebook2 createStandardPricebook() {
        Pricebook2 standardPricebook = new Pricebook2(
            Name = 'Standard Test Pricebook',
            IsActive = true
        );
        insert standardPricebook;
        //System.debug('Standard Test Pricebook créé avec ID : ' + standardPricebook.Id);
        return standardPricebook;
    }

    /**
     * Crée une entrée dans le Standard Pricebook.
     * @param productId L'ID du produit.
     * @param unitPrice Le prix unitaire.
     * @return L'instance de l'entrée créée dans le Standard Pricebook.
     */
    public static PricebookEntry createStandardPricebookEntry(Id productId, Decimal unitPrice) {
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPbe = new PricebookEntry(
            Product2Id = productId,
            Pricebook2Id = standardPricebookId,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert standardPbe;
        //System.debug('Entrée dans le Standard Pricebook créée avec ID : ' + standardPbe.Id);
        return standardPbe;
    }

    /**
     * Crée un produit pour les tests.
     * @param name Nom du produit.
     * @param isActive Statut actif ou inactif du produit.
     * @return L'instance du produit inséré.
     */
    public static Product2 createProduct(String name, Boolean isActive) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Le nom du produit est requis.');
        }
        Product2 prod = new Product2(Name = name, IsActive = isActive);
        insert prod;
        //System.debug('Produit créé avec ID : ' + prod.Id);
        return prod;
    }

    /**
     * Crée une entrée de catalogue de prix dans un Price Book.
     * Cette méthode crée uniquement des données de test sans dépendre du Standard Pricebook global.
     * @param productId L'ID du produit.
     * @param pricebookId L'ID du Price Book.
     * @param unitPrice Le prix unitaire.
     * @param useStandardPrice Indique si l'entrée utilise le prix standard.
     * @return L'instance de l'entrée insérée.
     */
    public static PricebookEntry createPricebookEntry(Id productId, Id pricebookId, Decimal unitPrice, Boolean useStandardPrice) {
        if (productId == null || pricebookId == null) {
            throw new IllegalArgumentException('Product ID et Pricebook ID sont requis.');
        }

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = productId,
            Pricebook2Id = pricebookId,
            UnitPrice = unitPrice,
            UseStandardPrice = useStandardPrice,
            IsActive = true
        );
        insert pbe;
        //System.debug('Price Book Entry créé avec ID : ' + pbe.Id + ', UseStandardPrice : ' + useStandardPrice);
        return pbe;
    }

    /**
     * Crée un compte pour les tests.
     * @param name Nom du compte.
     * @return L'instance du compte inséré.
     */
    public static Account createAccount(String name) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Le nom du compte est requis.');
        }
        Account acc = new Account(Name = name);
        insert acc;
        //System.debug('Compte créé avec ID : ' + acc.Id);
        return acc;
    }

    /**
     * Crée une commande pour les tests.
     * @param accountId L'ID du compte associé.
     * @param pricebookId L'ID du Price Book associé.
     * @param status Le statut de la commande.
     * @return L'instance de la commande insérée.
     */
    public static Order createOrder(Id accountId, Id pricebookId, String status) {
        if (accountId == null || pricebookId == null) {
            throw new IllegalArgumentException('Account ID et Pricebook ID sont requis.');
        }
        if (String.isBlank(status)) {
            throw new IllegalArgumentException('Le statut de la commande est requis.');
        }
        Order ord = new Order(
            AccountId = accountId,
            Pricebook2Id = pricebookId,
            Status = status,
            EffectiveDate = Date.today()
        );
        insert ord;
        //System.debug('Commande créée avec ID : ' + ord.Id);
        return ord;
    }

    /**
     * Crée une ligne de commande pour les tests.
     * @param orderId L'ID de la commande associée.
     * @param pricebookEntryId L'ID du Price Book Entry associé.
     * @param quantity La quantité.
     * @param unitPrice Le prix unitaire.
     * @return L'instance de la ligne de commande insérée.
     */
    public static OrderItem createOrderItem(Id orderId, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        if (orderId == null || pricebookEntryId == null) {
            throw new IllegalArgumentException('Order ID et PricebookEntry ID sont requis.');
        }
        if (quantity == null || quantity <= 0) {
            throw new IllegalArgumentException('La quantité doit être supérieure à zéro.');
        }
        OrderItem oi = new OrderItem(
            OrderId = orderId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantity,
            UnitPrice = unitPrice
        );
        insert oi;
        //System.debug('OrderItem créé avec ID : ' + oi.Id);
        return oi;
    }

/**
 * Crée plusieurs commandes avec des lignes de commande associées.
 * @param accountId L'ID du compte associé.
 * @param pricebookId L'ID du Price Book associé.
 * @param pricebookEntryId L'ID du Price Book Entry associé.
 * @param numberOfOrders Le nombre de commandes à créer.
 * @param shipmentCost Le coût d'expédition pour chaque commande.
 * @return La liste des commandes créées.
 */
public static List<Order> createOrdersWithItems(Id accountId, Id pricebookId, Id pricebookEntryId, Integer numberOfOrders, Decimal shipmentCost) {
    if (accountId == null || pricebookId == null || pricebookEntryId == null) {
        throw new IllegalArgumentException('Account ID, Pricebook ID et PricebookEntry ID sont requis.');
    }
    if (numberOfOrders == null || numberOfOrders <= 0) {
        throw new IllegalArgumentException('Le nombre de commandes doit être supérieur à zéro.');
    }

    List<Order> orders = new List<Order>();
    List<OrderItem> orderItems = new List<OrderItem>();

    for (Integer i = 0; i < numberOfOrders; i++) {
        Decimal orderAmount = 100 + (i * 10); // Montants variés : 100, 110, 120, ...

        // Créer une commande
        Order order = new Order(
            AccountId = accountId,
            Pricebook2Id = pricebookId,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            ShipmentCost__c = shipmentCost
        );
        orders.add(order);
    }

    // Insérer les commandes
    insert orders;

    // Créer les lignes de commande pour chaque commande
    for (Integer i = 0; i < orders.size(); i++) {
        OrderItem orderItem = new OrderItem(
            OrderId = orders[i].Id,
            PricebookEntryId = pricebookEntryId,
            Quantity = 1, // Quantité fixée à 1 pour simplifier
            UnitPrice = 100 + (i * 10) // Montant variable par commande
        );
        orderItems.add(orderItem);
    }

    // Insérer les lignes de commande
    insert orderItems;

    //System.debug(numberOfOrders + ' commandes et ' + orderItems.size() + ' lignes de commande créées.');
    return orders;
}

public static void createMultipleOrderItems(Id orderId, Id pricebookEntryId, List<Decimal> unitPrices, List<Integer> quantities) {
    List<OrderItem> orderItems = new List<OrderItem>();
    for (Integer i = 0; i < unitPrices.size(); i++) {
        orderItems.add(new OrderItem(
            OrderId = orderId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantities[i],
            UnitPrice = unitPrices[i]
        ));
    }
    insert orderItems;
}

}
