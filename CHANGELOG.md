# Journal des changements

## [Unreleased]

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
