# Base de données BetSafely (Supabase)

Source de vérité du schéma. Toute migration dans `supabase/migrations/` dérive de ce document ; un écart met d'abord ce document à jour. Les règles d'écriture sont dans `.claude/rules/supabase.md`.

## 1. Schéma

Identifiants : les lignes utilisateur sont créées hors ligne, leur `uuid` v4 est donc généré par l'appareil (CSPRNG, 122 bits) ; les lignes créées par le serveur utilisent `gen_random_uuid()`. Les référentiels ont des identifiants texte stables et lisibles (`winamax`, `football`).

```sql
-- ===== Extensions et types =====
create extension if not exists pg_cron;

create type bet_type as enum ('single', 'multi', 'system');
create type bet_status as enum ('open', 'won', 'lost', 'void', 'cashout', 'custom');
create type bet_source as enum ('manual', 'scan');
create type budget_scope as enum ('global', 'bookmaker', 'sport');
create type pause_end_reason as enum ('expired', 'bet_recorded', 'manual');
create type alert_type as enum ('budget_50', 'budget_80', 'budget_100', 'chase_d1', 'chase_d2', 'chase_d3', 'projection');
create type odds_format as enum ('decimal', 'american');
create type bookmaker_category as enum ('sportsbook', 'prediction');
create type help_kind as enum ('helpline', 'self_exclusion', 'international');
create type app_role as enum ('admin');

-- ===== Référentiels (lecture publique) =====
create table reference_version (
  id boolean primary key default true check (id),
  version bigint not null default 1,
  updated_at timestamptz not null default now()
);

create table countries (
  code char(2) primary key,
  default_currency char(3) not null,
  default_odds_format odds_format not null default 'decimal',
  has_full_reference boolean not null default false,
  position smallint not null,
  updated_at timestamptz not null default now()
);

create table sports (
  id text primary key check (id ~ '^[a-z_]{2,32}$'),
  labels jsonb not null check (labels ? 'fr' and labels ? 'en'),
  icon text not null,
  position smallint not null,
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table country_sports (
  country_code char(2) not null references countries,
  sport_id text not null references sports,
  position smallint not null,
  primary key (country_code, sport_id)
);

create table markets (
  id text primary key check (id ~ '^[a-z0-9_]{2,48}$'),
  sport_id text references sports,           -- null : marchés génériques (« autres sports »)
  labels jsonb not null check (labels ? 'fr' and labels ? 'en'),
  position smallint not null,
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);
create index markets_sport_idx on markets (sport_id);

create table bookmakers (
  id text primary key check (id ~ '^[a-z0-9_]{2,48}$'),
  name text not null check (length(name) between 1 and 60),
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table country_bookmakers (
  country_code char(2) not null references countries,
  bookmaker_id text not null references bookmakers,
  category bookmaker_category not null default 'sportsbook',
  position smallint not null,
  primary key (country_code, bookmaker_id)
);

create table help_resources (
  id uuid primary key default gen_random_uuid(),
  country_code char(2) references countries, -- null : ressource internationale
  kind help_kind not null,
  name text not null,
  phone text,
  url text check (url ~ '^https://'),
  hours jsonb,                                -- libellés localisés
  position smallint not null,
  verified_at date not null,
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table market_facts (
  id uuid primary key default gen_random_uuid(),
  country_code char(2) unique references countries, -- null : phrase générique
  texts jsonb not null check (texts ? 'fr' and texts ? 'en'),
  source_label text not null,
  source_url text,
  updated_at timestamptz not null default now()
);

create table equivalents (
  id uuid primary key default gen_random_uuid(),
  locale text not null check (locale ~ '^[a-z]{2}(-[A-Z0-9]{2,3})?$'),
  label_one text not null,
  label_other text not null,
  unit_price_minor integer not null check (unit_price_minor > 0),
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);
create index equivalents_locale_idx on equivalents (locale) where is_active;

create table notification_durations (
  sport_id text primary key references sports,
  duration_minutes smallint not null check (duration_minutes between 30 and 600),
  updated_at timestamptz not null default now()
);

create table app_config (
  id boolean primary key default true check (id),
  min_version_ios text not null default '1.0.0',
  min_version_android text not null default '1.0.0',
  roles_enabled boolean not null default false,  -- rôles futurs désactivés
  updated_at timestamptz not null default now()
);

create table user_roles (                        -- vide en V1
  user_id uuid not null references auth.users on delete cascade,
  role app_role not null,
  primary key (user_id, role)
);

-- ===== Tables utilisateur (miroir Premium) =====
-- Colonnes communes : user_id, created_at, updated_at (horloge client, arbitre LWW),
-- deleted_at (suppression logique), server_updated_at (horloge serveur, curseur de récupération).

create table user_preferences (
  user_id uuid primary key references auth.users on delete cascade,
  country_code char(2) not null,
  currency char(3) not null,
  odds_format odds_format not null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now()
);

create table user_bookmakers (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  bookmaker_id text references bookmakers,
  custom_name text check (length(custom_name) between 1 and 60),
  is_favorite boolean not null default false,
  is_hidden boolean not null default false,
  position smallint not null default 0,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  check ((bookmaker_id is null) <> (custom_name is null))
);
create unique index user_bookmakers_ref_uq on user_bookmakers (user_id, bookmaker_id) where bookmaker_id is not null and deleted_at is null;

create table user_sports (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  sport_id text not null references sports,
  is_favorite boolean not null default false,
  position smallint not null default 0,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now()
);
create unique index user_sports_uq on user_sports (user_id, sport_id) where deleted_at is null;

create table bets (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  bookmaker_id text references bookmakers,
  bookmaker_custom text check (length(bookmaker_custom) between 1 and 60),
  sport_id text references sports,
  sport_custom text check (length(sport_custom) between 1 and 40),
  market_id text references markets,
  market_custom text check (length(market_custom) between 1 and 60),
  description text not null default '' check (length(description) <= 80),
  bet_type bet_type not null,
  same_event boolean not null default false,
  selections_count smallint not null default 1 check (selections_count between 1 and 50),
  is_live boolean not null default false,
  is_free_bet boolean not null default false,
  stake_minor bigint not null check (stake_minor > 0),
  odds_decimal numeric(8,4) check (odds_decimal >= 1.01),
  placed_at timestamptz not null,
  event_at timestamptz,
  event_time_known boolean not null default false,
  status bet_status not null default 'open',
  return_minor bigint check (return_minor >= 0),
  settled_at timestamptz,
  source bet_source not null default 'manual',
  scan_confidence jsonb,
  note text not null default '' check (length(note) <= 200),
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  check (bookmaker_id is not null or bookmaker_custom is not null),
  check (bet_type = 'system' or odds_decimal is not null),                          -- [18]
  check ((status = 'open') = (return_minor is null and settled_at is null)),
  check (bet_type = 'single' or selections_count >= 2)
);
create index bets_user_sync_idx on bets (user_id, server_updated_at);

create table selections (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  bet_id uuid not null references bets on delete cascade,
  position smallint not null default 0,
  sport_id text references sports,
  description text not null default '' check (length(description) <= 80),
  market_id text references markets,
  market_custom text check (length(market_custom) between 1 and 60),
  odds_decimal numeric(8,4) check (odds_decimal >= 1.01),
  event_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now()
);
create index selections_user_sync_idx on selections (user_id, server_updated_at);
create index selections_bet_idx on selections (bet_id);

create table retro_balances (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  bookmaker_id text references bookmakers,
  bookmaker_custom text check (length(bookmaker_custom) between 1 and 60),
  deposits_minor bigint not null check (deposits_minor >= 0),
  withdrawals_minor bigint not null check (withdrawals_minor >= 0),
  balance_minor bigint not null check (balance_minor >= 0),
  since_month date check (since_month = date_trunc('month', since_month)::date),
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  check ((bookmaker_id is null) <> (bookmaker_custom is null))
);
create index retro_balances_user_sync_idx on retro_balances (user_id, server_updated_at);

create table budgets (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  scope budget_scope not null,
  scope_ref text,
  month date not null check (month = date_trunc('month', month)::date),
  amount_minor bigint not null check (amount_minor > 0),
  thresholds smallint[] not null default '{100}' check (thresholds <@ '{50,80,100}'),
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  check ((scope = 'global') = (scope_ref is null))
);
create unique index budgets_uq on budgets (user_id, scope, coalesce(scope_ref, ''), month) where deleted_at is null;
create index budgets_user_sync_idx on budgets (user_id, server_updated_at);

create table pauses (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  started_at timestamptz not null,
  planned_end_at timestamptz,                      -- null : sans fin
  ended_at timestamptz,
  end_reason pause_end_reason,
  notify_milestones boolean not null default false,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  check ((ended_at is null) = (end_reason is null)),
  check (planned_end_at is null or planned_end_at > started_at)
);
create index pauses_user_sync_idx on pauses (user_id, server_updated_at);

create table alerts_log (
  id uuid primary key,
  user_id uuid not null references auth.users on delete cascade,
  type alert_type not null,
  triggered_at timestamptz not null,
  bet_id uuid references bets on delete set null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now()
);
create index alerts_log_user_sync_idx on alerts_log (user_id, server_updated_at);

-- ===== Tables serveur uniquement =====
create table entitlements (
  user_id uuid primary key references auth.users on delete cascade,
  is_active boolean not null,
  expires_at timestamptz,
  period_type text check (period_type in ('normal', 'trial', 'intro')),
  product_id text,
  store text,
  billing_issue_at timestamptz,
  purge_after date,                                -- expiration + 90 jours
  last_event_at timestamptz not null,
  updated_at timestamptz not null default now()
);

create table revenuecat_events (
  event_id text primary key,
  type text not null,
  app_user_id text not null,
  received_at timestamptz not null default now()
);

create table scan_counters (
  user_id uuid primary key references auth.users on delete cascade,
  free_used smallint not null default 0 check (free_used between 0 and 3),
  month date not null default date_trunc('month', now() at time zone 'utc')::date,
  month_count integer not null default 0 check (month_count between 0 and 150),
  updated_at timestamptz not null default now()
);

-- ===== Fonctions =====
create function is_registered() returns boolean language sql stable as $$
  select coalesce((auth.jwt() ->> 'is_anonymous')::boolean, true) = false
$$;

create function has_active_premium(uid uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from entitlements e
    where e.user_id = uid and e.is_active
      and (e.expires_at is null or e.expires_at > now())
  )
$$;

create function is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select (select roles_enabled from app_config)
     and exists (select 1 from user_roles where user_id = auth.uid() and role = 'admin')
$$;

-- Quota : réservation atomique, remboursement si échec (appelées par scan-ticket en service_role)
create function reserve_scan(uid uuid, premium boolean) returns table (allowed boolean, remaining integer)
language plpgsql security definer set search_path = public as $$
declare
  c scan_counters;
  cur_month date := date_trunc('month', now() at time zone 'utc')::date;
begin
  insert into scan_counters (user_id) values (uid) on conflict do nothing;
  select * into c from scan_counters where user_id = uid for update;
  if c.month <> cur_month then
    update scan_counters set month = cur_month, month_count = 0 where user_id = uid returning * into c;
  end if;
  if premium and c.month_count < 150 then
    update scan_counters set month_count = month_count + 1, updated_at = now() where user_id = uid;
    return query select true, 150 - c.month_count - 1;
  elsif not premium and c.free_used < 3 then
    update scan_counters set free_used = free_used + 1, updated_at = now() where user_id = uid;
    return query select true, 3 - c.free_used - 1;
  else
    return query select false, 0;
  end if;
end $$;

create function refund_scan(uid uuid, premium boolean) returns void
language sql security definer set search_path = public as $$
  update scan_counters set
    month_count = case when premium then greatest(month_count - 1, 0) else month_count end,
    free_used   = case when premium then free_used else greatest(free_used - 1, 0) end,
    updated_at = now()
  where user_id = uid
$$;

create function scan_quota() returns table (premium boolean, remaining integer, total integer)
language sql stable security definer set search_path = public as $$
  select p.premium,
         case when p.premium then 150 - coalesce(case when c.month = date_trunc('month', now() at time zone 'utc')::date then c.month_count end, 0)
              else 3 - coalesce(c.free_used, 0) end,
         case when p.premium then 150 else 3 end
  from (select has_active_premium(auth.uid()) as premium) p
  left join scan_counters c on c.user_id = auth.uid()
$$;

revoke execute on function reserve_scan, refund_scan from public, anon, authenticated;

-- ===== Triggers =====
create function sync_before_write() returns trigger language plpgsql as $$
begin
  if tg_op = 'UPDATE' then
    if new.user_id <> old.user_id then raise exception 'user_id immuable'; end if;
    if new.updated_at < old.updated_at then return old; end if;  -- la dernière écriture gagne
    new.created_at := old.created_at;
  end if;
  new.server_updated_at := now();
  return new;
end $$;
-- attaché en BEFORE INSERT OR UPDATE à : user_preferences, user_bookmakers, user_sports,
-- bets, selections, retro_balances, budgets, pauses, alerts_log

create function bump_reference_version() returns trigger language plpgsql as $$
begin
  update reference_version set version = version + 1, updated_at = now();
  return null;
end $$;
-- attaché en AFTER INSERT OR UPDATE OR DELETE FOR EACH STATEMENT aux 10 tables de référence

create function touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;
-- attaché en BEFORE UPDATE aux tables de référence, à entitlements et à scan_counters

-- ===== Vues =====
-- Aucune : tous les agrégats sont calculés localement (P-08).

-- ===== Jobs planifiés (pg_cron, UTC) =====
select cron.schedule('purge-expired-sync', '0 3 * * *', $$
  delete from bets b using entitlements e where b.user_id = e.user_id and e.purge_after < current_date;
  -- idem pour les 8 autres tables utilisateur, puis :
  update entitlements set purge_after = null where purge_after < current_date;
$$);
select cron.schedule('purge-tombstones', '15 3 * * *', $$
  delete from bets where deleted_at < now() - interval '90 days';
  -- idem pour les 8 autres tables utilisateur
$$);
select cron.schedule('purge-inactive-anonymous', '30 3 * * 0', $$
  delete from auth.users u where u.is_anonymous
    and coalesce(u.last_sign_in_at, u.created_at) < now() - interval '12 months'
    and not exists (select 1 from entitlements e where e.user_id = u.id and e.is_active);
$$);
select cron.schedule('purge-revenuecat-events', '45 3 * * 0', $$
  delete from revenuecat_events where received_at < now() - interval '90 days';
$$);
```

**Seed (`supabase/seed.sql`) :** 7 pays, 17 sports avec libellés FR et EN (les 4 autres langues ajoutées dans la tâche de traduction [33]), ordre par pays (9.3), marchés (9.4), bookmakers par pays (9.5), ressources d'aide (F-16, sans FEJAR tant qu'il n'est pas confirmé), phrases de contexte (F-14), durées (N-01), `app_config`, `reference_version`. Prix unitaires des équivalents déduits des maquettes (« 118 € ≈ 11 mois de streaming », « 1 240 € ≈ 4 mois de courses ») et à valider dans la tâche de seed.

## 2. Policies RLS

RLS activée sur toutes les tables. Aucune policy `delete` côté client : la suppression est logique, la purge passe par `pg_cron` ou `delete-account`.

| Table | Policy | Opération | Rôle | Condition |
|---|---|---|---|---|
| 10 tables de référence | `ref_read` | select | anon, authenticated | `true` |
| 10 tables de référence | `ref_admin_write` | insert, update, delete | authenticated | `is_admin()` (faux en V1) |
| `user_roles` | aucune | | | service_role seul |
| 9 tables utilisateur | `own_read` | select | authenticated | `user_id = auth.uid() and is_registered()` |
| 9 tables utilisateur | `own_insert` | insert | authenticated | check `user_id = auth.uid() and is_registered() and has_active_premium(auth.uid())` |
| 9 tables utilisateur | `own_update` | update | authenticated | using et check identiques à `own_insert` |
| `entitlements` | `own_read` | select | authenticated | `user_id = auth.uid()` |
| `scan_counters` | aucune | | | lecture par la RPC `scan_quota()` |
| `revenuecat_events` | aucune | | | service_role seul |

Tests pgTAP : pour chaque table utilisateur, accès refusé à un autre utilisateur, à l'anonyme Supabase et à un compte sans entitlement en écriture ; lecture permise au propriétaire après expiration.


## 3. Edge Functions



| Fonction | Responsabilité | Pourquoi une fonction |
|---|---|---|
| `scan-ticket` | Session exigée (anonyme ou compte), réservation du quota, appel au modèle de vision avec sortie JSON stricte, validation du JSON, remboursement du quota en cas d'échec ou d'image sans ticket, aucune image ni contenu dans les logs, délai de 20 s | Détient la clé du modèle [38] et fait foi pour le quota |
| `revenuecat-webhook` | Authentification par en-tête secret, idempotence par `event.id`, mise à jour de `entitlements`, `purge_after` à l'expiration, effacé au réabonnement | Appelée par RevenueCat, écrit des tables serveur |
| `delete-account` | Suppression des données en ligne, du client RevenueCat par l'API REST, de l'utilisateur Auth [14, 15] | Nécessite la clé service_role et la clé secrète RevenueCat |

En secours, si `entitlements` n'a pas encore reçu le webhook, `scan-ticket` interroge l'API RevenueCat avec l'uid [8].

