public class TriggerHelper {
    public static Boolean isTriggerExecuted = false;
}
// empêcher les triggers de s’exécuter plusieurs fois lors d'une transaction unique, 
//ce qui peut arriver dans des scénarios complexes impliquant des appels récursifs ou des mises à jour en cascade.