<div align="center">

# ◈ NolCore

### Le socle open source de Noliae

Gateway API natif écrit en **Nolc**, avec PostgreSQL, identité, permissions,
recherche, administration et intégration des services IA et crawler.

[![CI](https://github.com/Noliae-France/NolCore/actions/workflows/ci.yml/badge.svg)](https://github.com/Noliae-France/NolCore/actions/workflows/ci.yml)
[![Service integration](https://github.com/Noliae-France/NolCore/actions/workflows/services-integration.yml/badge.svg)](https://github.com/Noliae-France/NolCore/actions/workflows/services-integration.yml)
[![Runtime](https://img.shields.io/badge/runtime-Nolc-ff4d2e)](https://github.com/Noliae-France/nolc)
[![PostgreSQL](https://img.shields.io/badge/database-PostgreSQL-336791)](https://www.postgresql.org/)
[![Licence MIT](https://img.shields.io/badge/licence-MIT-2ea44f)](LICENSE)

</div>

## Une architecture claire

NolCore est le point d’entrée public : il authentifie, applique les droits,
stocke les données et expose l’API. Les tâches spécialisées restent isolées :

```text
Client → NolCore API → PostgreSQL
                     ├→ NolCore IA       (réseau interne)
                     └→ NolCore Crawler  (réseau interne)
```

| Dépôt | Responsabilité |
|---|---|
| [NolCore](https://github.com/Noliae-France/NolCore) | Orchestration Docker/Kubernetes et intégration complète |
| [NolCore-API](https://github.com/Noliae-France/NolCore-API) | Gateway, comptes, sessions, droits, recherche et administration |
| [NolCore-IA](https://github.com/Noliae-France/NolCore-IA) | Agrégateur Claude, ChatGPT, Mistral et Gemini |
| [NolCore-Crawler](https://github.com/Noliae-France/NolCore-Crawler) | Crawl HTTP contrôlé avec respect de `robots.txt` |

Ce choix permet de déployer, mettre à l’échelle et mettre à jour chaque
composant indépendamment. Le code source est public afin que les garanties de
sécurité et de fonctionnement de Noliae restent auditables.

## Fonctionnalités

- Authentification : inscription, vérification e-mail, connexion, sessions
  signées de 24 h, profil et changement d’identifiants.
- PostgreSQL : requêtes paramétrées, recherche plein texte, conversations,
  documents, permissions, audit et profils SMTP.
- IA : routes protégées qui délèguent au service interne `NOLCORE_IA_URL`.
- Recherche : texte, image et recherche assistée par IA, avec limite de débit.
- Crawler : routage protégé vers `NOLCORE_CRAWLER_URL` ; le service dédié
  applique lui-même `robots.txt`.
- Administration : utilisateurs, SMTP, IA, crawler, Discord et permissions.
- Sécurité : Argon2id/libsodium, cookies `HttpOnly`, SQL paramétré et secrets
  uniquement par environnement.

## Démarrage avec Docker

Prérequis : Docker Engine et Compose v2.

```sh
git clone https://github.com/Noliae-France/NolCore.git
cd NolCore
export NOLIAE_SESSION_SECRET="change-me-with-at-least-32-characters"
docker compose up --build
```

Le gateway écoute sur `http://localhost:8080`. Compose démarre aussi PostgreSQL,
NolCore-IA et NolCore-Crawler. Les images des deux services sont récupérées
depuis GHCR.

Contrôles utiles :

```sh
curl http://localhost:8080/api/health
curl http://localhost:8080/api/ready
curl http://localhost:8080/api/dependencies
```

Les fichiers `.nhtml` de `examples/mvc` sont uniquement des exemples MVC : ils
ne sont pas compilés ni servis par le core.

## Configuration

| Variable | Usage |
|---|---|
| `NOLIAE_SESSION_SECRET` | Secret de signature, 32 caractères minimum |
| `NOLIAE_COOKIE_DOMAIN` | `.noliae.com` pour partager la session entre sous-domaines de production |
| `NOLCORE_DATABASE_URL` | URL PostgreSQL du gateway |
| `NOLCORE_IA_URL` | URL interne de NolCore-IA (`http://ia:8092` en Compose) |
| `NOLCORE_CRAWLER_URL` | URL interne de NolCore-Crawler (`http://crawler:8091`) |
| `NOLCORE_DEFAULT_PROVIDER` / `NOLCORE_DEFAULT_MODEL` | Choix par défaut pour les conversations |
| `NOLCORE_VERIFICATION_SMTP_ID` | Profil SMTP de vérification e-mail |
| `NOLCORE_DISCORD_*` | Configuration bot et webhook Discord |

Les tokens des fournisseurs IA (`NOLCORE_CLAUDE_TOKEN`,
`NOLCORE_CHATGPT_TOKEN`, `NOLCORE_MISTRAL_TOKEN`, `NOLCORE_GEMINI_TOKEN`) sont
destinés au service IA, jamais au dépôt ni à l’image du gateway.

## API principale

| Groupe | Routes |
|---|---|
| Santé | `GET /api/health`, `GET /api/ready`, `GET /api/dependencies` |
| Users | `POST /v1/user/register`, `/login`, `GET /me`, vérification et modifications du compte |
| IA | `POST /v1/ia`, `POST /v1/ia/:nameid/:modelia/:text` |
| Recherche | `GET /v1/search/text/:keyword`, `/img/:keyword`, `/ia/:keyword` |
| Crawler | `POST /v1/crawler/visite/:url`, `GET /v1/crawler/result/:url` |
| Admin | `/v1/admin/user/`, `/ia/`, `/smtp/`, `/crawler/`, `/discord/` |
| SMTP | `POST /v1/smtp/:idsmtp/send`, `GET /pool`, `DELETE /remove` |

Les routes sensibles exigent une session Bearer/cookie valide. Les ports SMTP
autorisés sont exclusivement 465 (SMTPS) et 587 (STARTTLS).

## Kubernetes / K3s

Le manifeste Kustomize complet est dans `deploy/k8s/base` : API, PostgreSQL,
services IA/crawler, probes, service et ingress.

```sh
kubectl create namespace nolcore
kubectl -n nolcore create secret generic nolcore-secrets \
  --from-literal=postgres-password='mot-de-passe-fort' \
  --from-literal=session-secret="$(openssl rand -hex 32)"
kubectl apply -k deploy/k8s/base
kubectl -n nolcore rollout status deployment/nolcore-api
```

Ajoutez les tokens IA et les secrets SMTP à un Secret externe ou à votre coffre
de secrets. Ne les versionnez jamais.

## Développement et CI/CD

```sh
nolc check main.nol
```

À chaque push sur `main`, GitHub Actions construit l’image GHCR, teste le
gateway, exécute les scénarios PostgreSQL/SMTP et reconstruit l’intégration avec
les dépôts IA et Crawler publics.

## Documentation et contribution

- [Sécurité](SECURITY.md)
- [Contribution](CONTRIBUTING.md)
- [Code de conduite](CODE_OF_CONDUCT.md)
- [Changements](CHANGELOG.md)
- [Licence MIT](LICENSE)
