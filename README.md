# NolCore

Core applicatif Noliae écrit en Nolc natif : Users & Auth, interface IA,
recherche PostgreSQL, API/services, permissions et administration.

```sh
docker compose up --build
```

Ouvrir http://localhost:8080. Les secrets sont fournis par l'environnement ;
aucun secret réel ne doit être commité.

## API v1

- `POST /v1/user/register`, `POST /v1/user/login`, `GET /v1/user/me`
- `POST /v1/user/resetpassword`, `/v1/user/me/changepassword`, `/changemail`, `/changename`
- `POST /v1/ia/:nameid/:modelia/:text` ou `POST /v1/ia` avec JSON
- `GET /v1/search/text/:keyword`, `/img/:keyword`, `/ia/:keyword`
- `POST /v1/crawler/visite/:url`, `GET /v1/crawler/result/:url`
- `GET /v1/perms`, `GET /v1/admin/`

Les fournisseurs IA sont branchés par `NOLCORE_CHATGPT_URL`,
`NOLCORE_CLAUDE_URL`, `NOLCORE_MISTRAL_URL` et `NOLCORE_GEMENI_URL`.
