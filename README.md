<div align="center">

# ◈ NolCore

### Le cœur open source de Noliae

Un backend MVC natif en **Nolc** pour construire les services de [noliae.com](https://noliae.com) : identité, IA, recherche, crawling et intégrations.

[![CI](https://github.com/Noliae-France/NolCore/actions/workflows/ci.yml/badge.svg)](https://github.com/Noliae-France/NolCore/actions/workflows/ci.yml)
[![Runtime](https://img.shields.io/badge/runtime-Nolc%20native-ff4d2e)](https://github.com/Noliae-France/nolc)
[![Database](https://img.shields.io/badge/database-PostgreSQL-336791)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-2ea44f)](LICENSE)

</div>

## Pourquoi NolCore ?

NolCore est le socle partagé des applications Noliae. Il regroupe dans un seul
service natif les briques qui doivent rester cohérentes partout : sécurité,
comptes, permissions, IA, moteur de recherche, crawler et administration.

Nous avons décidé de montrer le code source de nos apps et de notre cœur :
la transparence permet aux utilisateurs, développeurs et auditeurs de comprendre
les garanties du produit, de proposer des améliorations et de construire avec
Noliae plutôt que de dépendre d’une boîte noire.

## Fonctionnalités

| Domaine | Ce que fournit NolCore |
|---|---|
| MVC | Routeur Nolc, contrôleurs, vues `.nhtml` et CSS séparés |
| Users & Auth | Inscription, connexion, profil, changement de compte, sessions 24 h |
| Sessions | Cookie signé lié à l’utilisateur, l’email, l’IP, l’horodatage et un nonce aléatoire |
| IA | Agrégation Claude, ChatGPT, Mistral et Gemini par fournisseur/modèle |
| Recherche | Index PostgreSQL plein texte, recherche textuelle, IA et base pour images |
| Crawler | Visite HTTP, lecture de `robots.txt`, refus des chemins interdits et indexation |
| Permissions | Permissions par utilisateur, rôles et audit des actions |
| Administration | Gestion des utilisateurs et supervision du cœur |
| Intégrations | Bot Discord et webhook Discord configurables |

## Architecture

```text
NolCore
├── main.nol                 # routeur + boucle HTTP
├── *.nhtml                  # Views MVC compilées en Nolc
├── static/                  # CSS public
├── schema.sql               # PostgreSQL et migrations initiales
├── crawler.nol              # HTTP + politique robots.txt
├── vendor/nolc/lib/         # stdlib Nolc compatible avec le binaire public
├── Dockerfile
└── docker-compose.yml
```

Le serveur est un binaire natif Nolc. PostgreSQL est le seul service de
persistance ; les requêtes venant de l’extérieur passent par des paramètres
libpq et ne sont pas concaténées au SQL.

## Démarrage rapide

```sh
git clone https://github.com/Noliae-France/NolCore.git
cd NolCore
docker compose up --build
```

Ouvrir ensuite :

- [http://localhost:8080](http://localhost:8080) — accueil ;
- [http://localhost:8080/inscription](http://localhost:8080/inscription) — créer un compte ;
- [http://localhost:8080/connexion](http://localhost:8080/connexion) — se connecter ;
- [http://localhost:8080/recherche](http://localhost:8080/recherche) — recherche.

Les valeurs par défaut de Compose sont destinées au développement local. En
production, fournir les secrets par l’environnement ou le gestionnaire de
secrets de la plateforme : ne jamais les commiter.

## API v1

### Utilisateur

```text
POST /v1/user/register
POST /v1/user/login
GET  /v1/user/me
POST /v1/user/resetpassword
POST /v1/user/me/changepassword
POST /v1/user/me/changemail
POST /v1/user/me/changename
```

La connexion renvoie un Bearer token et pose le cookie `nol_session`. Le cookie
est valable 24 heures et est invalidé en cas de changement d’IP ou d’email.

### IA multi-fournisseurs

```text
POST /v1/ia/:nameid/:modelia/:text
POST /v1/ia
```

Variables de configuration :

```env
NOLCORE_CLAUDE_URL=https://...
NOLCORE_CHATGPT_URL=https://...
NOLCORE_MISTRAL_URL=https://...
NOLCORE_GEMINI_URL=https://...
```

### Recherche et crawler

```text
GET  /v1/search/text/:keyword
GET  /v1/search/img/:keyword
GET  /v1/search/ia/:keyword
POST /v1/crawler/visite/:url
GET  /v1/crawler/result/:url
```

Le crawler ne visite une URL qu’après lecture de son `robots.txt`. Les pages
acceptées sont indexées dans PostgreSQL et deviennent disponibles dans la
recherche de l’utilisateur.

### Permissions, administration et Discord

```text
GET  /v1/perms
GET  /v1/admin/
GET  /v1/discord/bot
POST /v1/discord/webhook
```

Configuration Discord : `NOLCORE_DISCORD_BOT_TOKEN`,
`NOLCORE_DISCORD_GUILD_ID` et `NOLCORE_DISCORD_WEBHOOK_URL`.

## Développement

Le workflow GitHub Actions compile l’image Docker avec le binaire Nolc public,
exécute un smoke test HTTP, démarre PostgreSQL, vérifie le schéma, puis teste
l’inscription, la connexion Bearer et la session cookie.

```sh
# Avec le compilateur Nolc installé
nolc nhtml accueil.nhtml login.nhtml inscription.nhtml recherche.nhtml tableau.nhtml
nolc check main.nol
```

## Sécurité

- Les secrets sont lus depuis l’environnement.
- Les mots de passe sont hachés avec Argon2id via libsodium.
- Les requêtes SQL sont paramétrées.
- Les cookies de session sont `HttpOnly`, `SameSite=Lax` et peuvent être `Secure`.
- Les recherches sont limitées et auditées.
- Les robots sont respectés avant toute visite.

NolCore est une base open source en évolution. Les règles de déploiement,
rotation de secrets, sauvegardes PostgreSQL, TLS, MFA et observabilité doivent
être définies pour chaque environnement de production.

## Licence

Voir [LICENSE](LICENSE).
