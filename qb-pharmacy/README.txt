# 🏥 qb-pharmacy

Un script **QBCore** développé par **LaPetiteVieDEV** permettant d’ajouter un **pharmacien PNJ** à l’hôpital, qui vend des fournitures médicales (bandages, trousses de soins).  
Inspiré par notre serveur **La Petite Vie RP**, ce script apporte une petite touche **RP** à votre ville !

---

## 👥 À propos de LaPetiteVieDEV

Nous sommes une petite équipe de développement passionnée, derrière le projet **La Petite Vie RP**, un serveur FiveM québécois qui mise sur :  
- Un **RP social et humoristique** inspiré de l’émission culte *La Petite Vie*.  
- Une ambiance **nostalgique et rétro**, avec une touche de réalisme.  
- Des scripts maison optimisés pour améliorer l’expérience de jeu.  

Notre objectif ? Créer un environnement immersif, drôle et accessible à toute la communauté francophone nord-américaine !

---

## ✨ Fonctionnalités

- 👨‍⚕️ **Ped Pharmacien** fixe et animé (invincible, ne bouge pas, avec animation RP).  
- 📍 **Blip** sur la map pour localiser le pharmacien.  
- 🛒 **Menu interactif** (qb-menu) pour acheter :
  - Bandages
  - First Aid Kits
  - antidouleur  
- 🎯 Compatible **qb-target** pour une interaction moderne.  
- 🔐 Système de gestion **occupé/disponible** :  
  - Si un joueur parle au pharmacien → il est occupé.  
  - Les autres reçoivent une notif "Pharmacien déjà occupé".  
  - Le pharmacien redevient dispo dès que le menu est fermé.  
- 🔔 Notifications immersives.  

---


👉 Si vous n’avez pas encore de dossier `[qb]`, créez-le dans `resources/` pour bien organiser vos scripts QBCore.

2. Vérifiez que vous avez ces dépendances installées et fonctionnelles :
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

3. Dans votre fichier **server.cfg**, ajoutez la ressource **après** les dépendances :
```cfg
ensure qb-core
ensure qb-menu
ensure qb-target
ensure qb-pharmacy
  
