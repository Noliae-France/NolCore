# Contribuer à NolCore

NolCore est développé en **Nolc natif**. Les fonctionnalités backend ne doivent pas introduire Node.js. Respectez l’architecture MVC : accès PostgreSQL, contrôleurs/routes, vues `.nhtml` et CSS séparés.

## Vérifications

Exécutez `nolc check main.nol`, `docker compose config`, `docker build -t nolcore:local .` et `kubectl kustomize deploy/k8s/base` lorsque votre changement les concerne.

Les changements d’API doivent ajouter un test dans `.github/workflows/ci.yml`. Les changements de schéma doivent mettre à jour `schema.sql` et `deploy/k8s/base/schema.sql`.

## Pull requests

- décrivez le problème et le comportement attendu ;
- indiquez les routes et variables concernées ;
- gardez les commits ciblés ;
- confirmez que la CI passe ;
- ajoutez la documentation correspondante.

Un changement de sécurité doit suivre [SECURITY.md](SECURITY.md).
