# 📋 TODO - Application PDV Baaf

## 🎯 Fonctionnalités principales à implémenter

### 1. **Commandes UV (Unités de Vente)**
- [ ] Bouton rapide "Commande UV" sur l'écran d'accueil
- [ ] Écran de création de commande UV
- [ ] Écran de liste des commandes UV
- [ ] Écran de détails d'une commande UV
- [ ] Actions : Créer, Valider, Rejeter, Consulter

### 2. **Paiements d'électricité**
- [ ] Améliorer l'écran de paiement prépayé
- [ ] Améliorer l'écran de paiement postpayé
- [ ] Intégration avec les APIs de paiement EDG
- [ ] Gestion des méthodes de paiement (Mobile Money, Carte, Espèces)

### 3. **Gestion des comptes**
- [ ] Écran de transfert commission → principal
- [ ] Affichage du solde principal
- [ ] Affichage du solde commission
- [ ] Historique des transferts

### 4. **Dashboard avec statistiques**

#### **Stats UV :**
- [ ] Total des commandes UV
- [ ] Commandes en attente
- [ ] Commandes validées
- [ ] Commandes rejetées
- [ ] Montant total des commandes

#### **Stats Paiements :**
- [ ] Total des paiements
- [ ] Paiements complétés
- [ ] Paiements réussis
- [ ] Paiements échoués
- [ ] Montant total des paiements

#### **Tableau des paiements récents :**
- [ ] Liste des 5 derniers paiements
- [ ] Détails : Date, Client, Montant, Statut, Méthode

### 5. **Contrôleurs Flutter (vides avec TODO)**

#### **Contrôleurs à créer :**
- [ ] `uv_order_controller.dart` - Gestion commandes UV (TODO: intégrer APIs)
- [ ] `account_controller.dart` - Gestion comptes (TODO: intégrer APIs)
- [ ] `payment_controller.dart` - Gestion paiements (TODO: intégrer APIs)
- [ ] `dashboard_controller.dart` - Gestion dashboard (TODO: intégrer APIs)

### 6. **Écrans à créer/modifier**

#### **Nouveaux écrans :**
- [ ] `uv_orders_screen.dart` - Gestion commandes UV
- [ ] `uv_order_create_screen.dart` - Création commande UV
- [ ] `uv_order_details_screen.dart` - Détails commande UV
- [ ] `account_transfer_screen.dart` - Transfert entre comptes
- [ ] `dashboard_screen.dart` - Dashboard avec stats
- [ ] `recent_payments_screen.dart` - Paiements récents

#### **Écrans à modifier :**
- [ ] `home_screen.dart` - Ajouter bouton UV, stats dashboard
- [ ] `payment_type_screen.dart` - Améliorer interface
- [ ] `prepaid_payment_screen.dart` - Intégrer APIs
- [ ] `postpaid_payment_screen.dart` - Intégrer APIs

### 7. **Widgets à créer**

- [ ] `uv_stats_card.dart` - Carte stats UV
- [ ] `payment_stats_card.dart` - Carte stats paiements
- [ ] `recent_payments_table.dart` - Tableau paiements récents
- [ ] `account_balance_card.dart` - Carte solde compte
- [ ] `uv_order_card.dart` - Carte commande UV

### 8. **Services à créer/modifier**

- [ ] `uv_order_service.dart` - Service commandes UV
- [ ] `account_service.dart` - Service comptes
- [ ] `payment_service.dart` - Service paiements (améliorer)
- [ ] `stats_service.dart` - Service statistiques

### 9. **Modèles de données**

- [ ] `UvOrder` - Modèle commande UV
- [ ] `Account` - Modèle compte
- [ ] `Payment` - Modèle paiement (améliorer)
- [ ] `Stats` - Modèle statistiques

### 10. **Navigation**

- [ ] Ajouter "Commandes UV" dans le menu principal
- [ ] Ajouter "Comptes" dans le menu principal
- [ ] Ajouter "Dashboard" dans le menu principal
- [ ] Navigation entre les écrans UV

---

## 🚀 Priorités de développement

1. **Phase 1** : Dashboard avec stats (affichage)
2. **Phase 2** : Commandes UV (création, liste)
3. **Phase 3** : Paiements améliorés
4. **Phase 4** : Gestion des comptes
5. **Phase 5** : Intégration complète des APIs

---

## 📝 Notes

- Utiliser les vraies APIs du backend
- Design moderne inspiré de l'image fournie
- Interface adaptée aux rôles et permissions
- Pas de données fictives
- Focus sur l'expérience utilisateur PDV
