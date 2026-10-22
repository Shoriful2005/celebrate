create table if not exists rooms (
  id text primary key,
  created_at timestamptz default now(),
  sender_name text,
  receiver_name text,
  occasion text check (occasion in ('birthday','achievement','wedding','graduation')),
  selected_modes jsonb default '[]',
  flow_sequence text,
  vault_type text check (vault_type in ('pin','date','name','quiz')),
  vault_question text,
  vault_answer text,
  secret_note text,
  envelope_style text,
  font_style text,
  photo_url text,
  voice_url text,
  is_candle_lit boolean default false,
  is_puzzle_solved boolean default false,
  is_vault_unlocked boolean default false,
  is_cake_cut boolean default false
);
alter table rooms enable row level security;
create policy "anon read" on rooms for select using (true);
create policy "anon insert" on rooms for insert with check (true);
create policy "anon update" on rooms for update using (true);
