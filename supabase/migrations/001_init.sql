-- Tabella domini tracciati
create table domains (
  id uuid primary key default gen_random_uuid(),
  url text not null unique,
  name text not null,
  created_at timestamptz not null default now()
);

-- Topic/cluster individuati dal contenuto di ogni dominio
create table topics (
  id uuid primary key default gen_random_uuid(),
  domain_id uuid not null references domains(id) on delete cascade,
  label text not null,
  description text,
  created_at timestamptz not null default now()
);

-- Domande long-tail generate per ogni topic
create table queries (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references topics(id) on delete cascade,
  question_text text not null,
  intent text check (intent in ('informativa', 'comparativa', 'transazionale')),
  created_at timestamptz not null default now()
);

-- Risultati di ogni esecuzione di una domanda su un motore AI
create table runs (
  id uuid primary key default gen_random_uuid(),
  query_id uuid not null references queries(id) on delete cascade,
  engine text not null,
  timestamp timestamptz not null default now(),
  raw_response text,
  cited boolean default false,
  sentiment text check (sentiment in ('positivo', 'neutro', 'negativo')),
  position int,
  cited_url boolean default false,
  competitors_mentioned jsonb default '[]'::jsonb
);

-- Indici per le query più frequenti della dashboard
create index idx_topics_domain_id on topics(domain_id);
create index idx_queries_topic_id on queries(topic_id);
create index idx_runs_query_id on runs(query_id);
create index idx_runs_engine on runs(engine);
