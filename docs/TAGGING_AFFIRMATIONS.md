# Tagger les affirmations (tone + themes)

Après avoir exécuté le SQL qui ajoute les colonnes, tu renseignes `tone`
(obligatoire) et `themes` (optionnel) sur chaque affirmation.

## Valeurs autorisées

- **`tone`** : `direct` · `doux` · `poetique` · `percutant`
- **`themes`** (0, 1 ou plusieurs) : `travail` · `famille` · `relations` · `sante` · `argent`
  Laisse vide (`{}`) pour une affirmation universelle (la majorité).

## Option A — Table Editor (visuel, simple)

Supabase → Table Editor → `affirmations` → édite `tone` (et `themes`) ligne par ligne.
Pour `themes`, saisis un tableau Postgres : `{travail}` ou `{travail,relations}`.

## Option B — SQL par lots (rapide)

Tout mettre en « doux » par défaut est déjà fait (valeur par défaut). Ensuite tu
ajustes par lots, par exemple :

```sql
-- passer certaines catégories en direct/percutant
update affirmations set tone = 'direct'    where category = 'action';
update affirmations set tone = 'percutant' where category = 'focus';
update affirmations set tone = 'poetique'  where category = 'vision';

-- taguer un domaine de vie sur des affirmations précises
update affirmations set themes = '{travail}'
  where content ilike '%travail%' or content ilike '%carrière%';

update affirmations set themes = '{relations}'
  where content ilike '%relation%' or content ilike '%autre%';
```

## Option C — au cas par cas

```sql
update affirmations
set tone = 'poetique', themes = '{sante}'
where content = 'Chaque respiration me recentre.';
```

## Vérifier la répartition

```sql
select tone, count(*) from affirmations group by tone;
select category, count(*) from affirmations group by category;
```

## Comment ça influence l'app

- L'app pondère le tirage : +poids si le `tone` de l'affirmation = le ton choisi
  à l'onboarding, +poids si un `themes` correspond à « ce qui pèse ».
- Rien n'est jamais totalement exclu — c'est une pondération, pas un filtre dur.
- Non taggé = neutre (ton « doux », aucun thème) : l'app marche quand même.
