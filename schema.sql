-- Surprise Room v2 schema (Supabase SQL Editor). Safe to re-run on an existing project.
create table if not exists public.rooms (
  id text primary key,
  created_at timestamptz not null default now(),
  sender_name text not null,
  receiver_name text not null,
  occasion text not null check (occasion in ('birthday','achievement','wedding','graduation')),
  selected_modes jsonb not null default '[]'::jsonb
);
alter table public.rooms
  add column if not exists flow_sequence text default 'puzzle_then_cake' check (flow_sequence in ('puzzle_then_cake','puzzle_then_note','direct_cake','custom')),
  add column if not exists unlock_timestamp timestamptz,
  add column if not exists cake_text text,
  add column if not exists candle_numbers text,
  add column if not exists vault_type text default 'pin' check (vault_type in ('pin','date','name','quiz')),
  add column if not exists vault_question text,
  add column if not exists vault_answer text,
  add column if not exists secret_note text,
  add column if not exists envelope_style text default 'royal_gold' check (envelope_style in ('vintage','royal_gold','romantic','minimal_glass')),
  add column if not exists font_style text default 'modern_en' check (font_style in ('chakrabak','vector_bangla','kalpurush','cursive_en','serif_en','modern_en')),
  add column if not exists photo_url text,
  add column if not exists sender_photo_url text,
  add column if not exists voice_url text,
  add column if not exists is_candle_lit boolean not null default false,
  add column if not exists is_puzzle_solved boolean not null default false,
  add column if not exists is_vault_unlocked boolean not null default false,
  add column if not exists is_cake_cut boolean not null default false;

alter table public.rooms enable row level security;
drop policy if exists "anon read rooms" on public.rooms;
drop policy if exists "anon create rooms" on public.rooms;
drop policy if exists "anon update state" on public.rooms;
create policy "anon read rooms"   on public.rooms for select to anon using (true);
create policy "anon create rooms" on public.rooms for insert to anon with check (true);
create policy "anon update state" on public.rooms for update to anon using (true) with check (true);

revoke update on public.rooms from anon;
grant select, insert on public.rooms to anon;
grant update (is_candle_lit, is_puzzle_solved, is_vault_unlocked, is_cake_cut) on public.rooms to anon;

do $$ begin
  alter publication supabase_realtime add table public.rooms;
exception when duplicate_object then null; end $$;

-- Live sync (candle, cake cut, puzzle, vault, gift, confetti) uses Realtime Broadcast on
-- channel 'room_<id>' and needs no table. vault_answer is readable by anyone who can read the row.
