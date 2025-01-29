---
title: "Projet 9 Salesforce: Améliorez une organisation Salesforce pour votre entreprise"
description: "Optimisation et modernisation d'une instance Salesforce pour améliorer la qualité du code, les performances et la mise en place du CI/CD."
author: "Karim Tayassi"
date: "2025-01-29"
version: "1.0"
---

# 📌 Projet 9 Salesforce: Améliorez une organisation Salesforce pour votre entreprise

## 📖 Description du projet
Ce projet a pour objectif d’optimiser une instance Salesforce utilisée par **Fasha**, un distributeur de vêtements de renommée. L’objectif est d’améliorer les performances, la maintenabilité et la qualité du code en mettant en place :

- Des **tests unitaires et fonctionnels** pour garantir la robustesse des développements.
- Un **refactoring du code** afin d’éliminer les requêtes SOQL dans les boucles et améliorer la lisibilité.
- Une **automatisation des tests et des déploiements** avec un pipeline CI/CD sous **GitHub Actions**.
- Une **optimisation des performances**, notamment sur la gestion des mises à jour massives.

---

## 🎯 Objectifs principaux
✅ **Amélioration de la qualité du code** (suppression des mauvaises pratiques, meilleure maintenabilité).  
✅ **Augmentation de la couverture de code** via des tests unitaires et d’intégration robustes.  
✅ **Optimisation des performances** (réduction des temps d'exécution et meilleure gestion des transactions).  
✅ **Mise en place d’un pipeline CI/CD** pour automatiser le déploiement et les tests continus.  
✅ **Documentation technique et rapports de tests** pour assurer la traçabilité des améliorations.  

---

## 🛠 Technologies utilisées
- **Salesforce Apex** (Triggers, Classes, Tests)  
- **Lightning Web Components (LWC)**  
- **Salesforce DX (SFDX)**  
- **GitHub Actions** (CI/CD)  
- **Data Loader** (Tests et imports de données)  

---

## 📂 Structure du projet
📁 `force-app/main/default` → Code source Salesforce (Apex, Triggers, LWC)  
📁 `tests` → Classes de test pour assurer la couverture de code  
📁 `.github/workflows` → Fichiers YAML pour automatiser le CI/CD  
📁 `docs` → Documentation technique et rapports de test  

---

## 🧪 Tests et couverture de code
🔹 **Tests unitaires et fonctionnels** couvrant les principales fonctionnalités.  
🔹 **Mesure de la couverture de code** pour assurer la fiabilité des nouvelles implémentations.  
🔹 **Scénarios de tests complexes avec Data Loader** pour simuler des mises à jour massives.  
🔹 **Tests de performance** afin de valider l’optimisation des requêtes et des traitements.  

---

## 🚀 Pipeline CI/CD (GitHub Actions)
📌 **Automatisation des tests** pour garantir la stabilité du code.  
📌 **Déploiement conditionnel** uniquement après validation des tests.  
📌 **Sécurisation des déploiements** grâce à l'utilisation des secrets GitHub.  

---

## 📄 Documentation disponible
📝 **Rapports de test et de couverture de code** avec résultats détaillés.  
📚 **Guide sur la mise en place du CI/CD avec GitHub Actions**.  
📖 **Explication des refactorisations et des optimisations de performance**.  

---

## 🤝 Contributions
Les contributions sont **les bienvenues** ! 🎉  
Si vous souhaitez améliorer le projet, merci de **créer une pull request** ou **ouvrir une issue** sur GitHub.  

📧 Contact : `karter.t@gmail.com`  

---
