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
        System.debug('Standard Test Pricebook créé avec ID : ' + standardPricebook.Id);
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
        System.debug('Entrée dans le Standard Pricebook créée avec ID : ' + standardPbe.Id);
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
        System.debug('Produit créé avec ID : ' + prod.Id);
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
        System.debug('Price Book Entry créé avec ID : ' + pbe.Id + ', UseStandardPrice : ' + useStandardPrice);
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
        System.debug('Compte créé avec ID : ' + acc.Id);
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
        System.debug('Commande créée avec ID : ' + ord.Id);
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
        System.debug('OrderItem créé avec ID : ' + oi.Id);
        return oi;
    }

    /**
 * Génère des commandes et des lignes de commande en masse pour les tests.
 * @param recordCount Le nombre de commandes à créer.
 * @param itemsPerOrder Le nombre de lignes de commande par commande.
 * @return Une liste des commandes créées.
 */
    public static List<Order> generateLargeOrderData(Integer recordCount, Integer itemsPerOrder) {
    if (recordCount == null || recordCount <= 0) {
        throw new IllegalArgumentException('Le nombre de commandes doit être supérieur à zéro.');
    }

    if (itemsPerOrder == null || itemsPerOrder <= 0) {
        throw new IllegalArgumentException('Le nombre de lignes de commande par commande doit être supérieur à zéro.');
    }

    // Créer un Pricebook standard
    Id standardPricebookId = Test.getStandardPricebookId();

    // Créer un produit standard
    Product2 testProduct = createProduct('Test Product', true);

    // Créer une entrée dans le Pricebook standard
    PricebookEntry testPricebookEntry = createStandardPricebookEntry(testProduct.Id, 100.00);

    // Créer un compte de test
    Account testAccount = createAccount('Test Account');

    // Listes pour stocker les commandes et les lignes de commande
    List<Order> orders = new List<Order>();
    List<OrderItem> orderItems = new List<OrderItem>();

    // Créer les commandes
    for (Integer i = 0; i < recordCount; i++) {
        Order ord = new Order(
            AccountId = testAccount.Id,
            Pricebook2Id = standardPricebookId,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        orders.add(ord);
    }

    // Insérer les commandes en masse
    insert orders;

    // Créer les lignes de commande pour chaque commande
    for (Order ord : orders) {
        for (Integer j = 0; j < itemsPerOrder; j++) {
            OrderItem oi = new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = testPricebookEntry.Id,
                Quantity = 1,
                UnitPrice = 100.00
            );
            orderItems.add(oi);
        }
    }

    // Insérer les lignes de commande en masse
    insert orderItems;

    System.debug(recordCount + ' commandes et ' + (recordCount * itemsPerOrder) + ' lignes de commande créées.');

    // Retourner la liste des commandes créées
    return orders;
}
}
