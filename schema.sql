-- Surprise Room: Supabase schema (run in Supabase Dashboard > SQL Editor)

create table if not exists public.rooms (
  id                 text primary key,                 -- e.g. bd-9876
  created_at         timestamptz not null default now(),
  sender_name        text not null,
  receiver_name      text not null,
  occasion           text not null check (occasion in ('birthday','achievement','wedding','graduation')),
  selected_modes     jsonb not null default '[]'::jsonb, -- e.g. ["cake","puzzle","vault","pin:1234"]
  secret_note        text,
  photo_url          text,                              -- data URL or storage URL
  voice_url          text,
  is_candle_lit      boolean not null default true,
  is_puzzle_solved   boolean not null default false,
  is_vault_unlocked  boolean not null default false
);

-- No-login access: anonymous visitors may create, read and update rooms.
alter table public.rooms enable row level security;

drop policy if exists "anon read rooms"   on public.rooms;
drop policy if exists "anon create rooms" on public.rooms;
drop policy if exists "anon update state" on public.rooms;

create policy "anon read rooms"   on public.rooms for select to anon using (true);
create policy "anon create rooms" on public.rooms for insert to anon with check (true);
create policy "anon update state" on public.rooms for update to anon using (true) with check (true);

-- Limit what anon can change after creation: only the three game-state flags.
revoke update on public.rooms from anon;
grant  update (is_candle_lit, is_puzzle_solved, is_vault_unlocked) on public.rooms to anon;
grant  select, insert on public.rooms to anon;

-- Optional: let database changes stream over Realtime too.
alter publication supabase_realtime add table public.rooms;

-- Note: live sync (candle, puzzle, vault, confetti) uses Realtime Broadcast on
-- channel 'room_<id>', which needs no table. Public channels work with the anon key.
-- Tip: the vault code is stored in selected_modes as "pin:XXXX" and is readable by
-- anyone who can read the row. Fine for a fun surprise, not for real secrets.
