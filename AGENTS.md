# AGENTS.md — Citation Tracker

## Cos'è questo progetto
Tool che misura quanto un dominio viene citato dalle AI (ChatGPT, Perplexity, ecc.)
su domande long-tail generate a partire dal suo contenuto.

## Stack
- Pipeline dati: Python 3.11, Supabase come DB (Postgres)
- Web: Next.js + Vercel
- Nessun ORM pesante: query dirette via supabase-py / supabase-js

## Schema database (fonte di verità — non inventare campi)
- domains(id, url, name, created_at)
- topics(id, domain_id, label, description)
- queries(id, topic_id, question_text, intent)
- runs(id, query_id, engine, timestamp, raw_response, cited bool,
       sentiment, position, cited_url bool, competitors_mentioned jsonb)

## Convenzioni di codice
- Tutti i prompt LLM vivono in pipeline/prompts/*.txt, MAI hardcoded nel codice
- Ogni chiamata a un modello AI deve salvare la raw_response prima di parsarla
- Funzioni piccole, un file = una responsabilità
- Ogni modulo pipeline ha un blocco `if __name__ == "__main__"` per testarlo da solo

## Come testare
- pipeline: `python -m pipeline.crawler --domain example.com`
- web: `npm run dev` dentro /web

## Definition of done per una feature
1. Funziona su un caso reale, non solo sull'esempio banale
2. Gli errori (rete, parsing, rate limit) sono gestiti, non fanno crashare tutto
3. Il risultato è salvato su Supabase, non solo stampato a schermo
