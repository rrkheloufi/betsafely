# Checklist sécurité

À cocher dans la section Sécurité de chaque tâche, pour les points qui s'appliquent. Un point non applicable est marqué « n/a », jamais laissé vide.

- [ ] Aucun secret, clé, URL de projet réelle ni identifiant RevenueCat réel dans le diff (`git diff dev` relu).
- [ ] Aucune clé `service_role` dans l'app ; les clés publiques viennent de `env/<flavor>.json`.
- [ ] Toute nouvelle table a la RLS activée et ses policies testées en pgTAP.
- [ ] Aucun bucket Storage ajouté.
- [ ] Toute Edge Function vérifie l'authentification en premier et valide ses entrées.
- [ ] Le webhook reste authentifié et idempotent.
- [ ] Les droits Premium sont vérifiés par l'entitlement `premium` ; côté serveur par `entitlements`.
- [ ] Aucune donnée personnelle, image, contenu de pari ni e-mail dans les logs, Sentry ou les analytics.
- [ ] Aucune donnée de pari n'est envoyée hors de l'appareil sans compte Premium synchronisé.
- [ ] Les jetons et sessions sont gérés par les SDK ; aucun jeton stocké à la main. Si une valeur sensible doit être stockée hors SDK, elle passe par `flutter_secure_storage` (à justifier).
- [ ] Les entrées utilisateur sont validées (longueurs, bornes, formats) avant écriture locale.
- [ ] Les liens profonds entrants sont validés (schéma, hôte, paramètres) avant navigation.
- [ ] Les permissions système demandées sont celles de `docs/architecture.md` section 13, avec leur texte.
- [ ] Aucune dépendance ajoutée sans justification dans `docs/architecture.md` section 10.
- [ ] `make check` vert, `make test-db` et `make test-functions` verts si `supabase/` est touché.
