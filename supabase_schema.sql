-- MAF-CITY: Supabase Schema
-- Виконай цей SQL у Supabase → SQL Editor

-- 1. Таблиця профілів гравців
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  avatar_url text,
  club_id uuid,
  created_at timestamptz default now()
);

-- 2. Таблиця клубів
create table if not exists clubs (
  id uuid default gen_random_uuid() primary key,
  name text unique not null,
  logo_url text,
  admin_id uuid references profiles(id) on delete set null,
  created_at timestamptz default now()
);

-- Додаємо зовнішній ключ клубу до профілів
alter table profiles
  add constraint profiles_club_id_fkey
  foreign key (club_id) references clubs(id) on delete set null;

-- 3. Заявки на вступ до клубу
create table if not exists club_requests (
  id uuid default gen_random_uuid() primary key,
  club_id uuid references clubs(id) on delete cascade not null,
  player_id uuid references profiles(id) on delete cascade not null,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz default now(),
  unique(club_id, player_id)
);

-- 4. Storage bucket для логотипів клубів
insert into storage.buckets (id, name, public)
values ('club-logos', 'club-logos', true)
on conflict do nothing;

-- 5. RLS Policies

alter table profiles enable row level security;
alter table clubs enable row level security;
alter table club_requests enable row level security;

-- Profiles: читають усі, редагує тільки власник
create policy "profiles_select" on profiles for select using (true);
create policy "profiles_insert" on profiles for insert with check (auth.uid() = id);
create policy "profiles_update" on profiles for update using (auth.uid() = id);

-- Clubs: читають усі, створює авторизований
create policy "clubs_select" on clubs for select using (true);
create policy "clubs_insert" on clubs for insert with check (auth.uid() is not null);
create policy "clubs_update" on clubs for update using (auth.uid() = admin_id);

-- Club requests: гравець бачить свої, адмін бачить заявки до свого клубу
create policy "requests_select_player" on club_requests for select using (auth.uid() = player_id);
create policy "requests_select_admin" on club_requests for select using (
  exists (select 1 from clubs where clubs.id = club_id and clubs.admin_id = auth.uid())
);
create policy "requests_insert" on club_requests for insert with check (auth.uid() = player_id);
create policy "requests_update_admin" on club_requests for update using (
  exists (select 1 from clubs where clubs.id = club_id and clubs.admin_id = auth.uid())
);

-- Storage policy для club-logos
create policy "logos_select" on storage.objects for select using (bucket_id = 'club-logos');
create policy "logos_insert" on storage.objects for insert with check (
  bucket_id = 'club-logos' and auth.uid() is not null
);
