# Journal des changements

## [Unreleased]

- Conversations IA identifiées par un UUID public (`public_id`), indépendant
  de l'id interne, pour des URL `/chat/:id` partageables sans exposer le PK.
- Partage public en lecture seule d'une conversation (`is_public` +
  endpoints share/unshare/lecture publique), sans authentification requise.
- Cache Redis sur la liste des conversations et les messages d'une
  conversation, invalidé à chaque nouveau message ou suppression.
- Support des fournisseurs IA Grok (xAI) et DeepSeek, au même titre que
  ChatGPT/Claude/Mistral/Gemini (catalogue, chat, streaming).
- Upload d'images vers S3 (OVH) via URL présignées SigV4 (`s3.nol`) —
  aucune donnée binaire ne transite par ce serveur, aucun identifiant en dur.
- Algorithme de classement de recherche maison façon PageRank (`pagerank.nol`) :
  graphe de liens (`search_links`) alimenté par le crawler, autorité calculée
  par power-iteration en SQL pur, classement pondéré pertinence × autorité.
- Découverte automatique de liens par le crawler (au lieu de dépendre
  uniquement d'une liste d'URLs semées manuellement) + reprise des jobs de
  crawl bloqués après un crash du worker.
- Documentation sécurité, contribution et déploiement communautaire.
- Compatibilité Kubernetes/K3s via Kustomize.
- Vérification de compte par e-mail avec Postfix/Dovecot dans la CI.
- Réinitialisation de mot de passe testée de bout en bout dans la CI.
- Sessions cookie et bearer enregistrées dans PostgreSQL, révocables après
  changement/reset de mot de passe et gérables par appareil.
- Image Docker corrigée pour les imports relatifs de la bibliothèque Nolc.

## [0.1.0] - 2026-07-29

- Core backend natif Nolc et architecture MVC.
- API v1 users, auth, sessions, permissions, IA, recherche, crawler, SMTP, Discord et administration.
- PostgreSQL, Docker Compose, image Docker et workflows GitHub Actions.

[Unreleased]: https://github.com/Noliae-France/NolCore/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Noliae-France/NolCore/releases/tag/v0.1.0
