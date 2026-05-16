-- =============================================
-- SAUTI CREATORS — Supabase Schema
-- Run this in Supabase Dashboard → SQL Editor
-- =============================================

-- Users table (extends Supabase auth.users)
create table public.users (
  id           uuid primary key references auth.users(id) on delete cascade,
  name         text not null,
  username     text not null unique,
  email        text not null,
  avatar_url   text,
  bio          text,
  followers_count  int default 0,
  following_count  int default 0,
  posts_count      int default 0,
  total_earnings   numeric(12,2) default 0.0,
  is_verified      boolean default false,
  created_at   timestamptz default now()
);

-- Posts table
create table public.posts (
  id             uuid primary key default gen_random_uuid(),
  creator_id     uuid not null references public.users(id) on delete cascade,
  caption        text,
  media_url      text,
  type           text not null check (type in ('image', 'video', 'text')),
  likes_count    int default 0,
  comments_count int default 0,
  shares_count   int default 0,
  created_at     timestamptz default now()
);

-- Post likes (many-to-many)
create table public.post_likes (
  post_id  uuid references public.posts(id) on delete cascade,
  user_id  uuid references public.users(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (post_id, user_id)
);

-- Follows (many-to-many)
create table public.follows (
  follower_id  uuid references public.users(id) on delete cascade,
  following_id uuid references public.users(id) on delete cascade,
  created_at   timestamptz default now(),
  primary key (follower_id, following_id)
);

-- Tips
create table public.tips (
  id           uuid primary key default gen_random_uuid(),
  from_user_id uuid references public.users(id) on delete set null,
  to_user_id   uuid not null references public.users(id) on delete cascade,
  amount       numeric(10,2) not null,
  currency     text default 'TZS',
  note         text,
  created_at   timestamptz default now()
);

-- Subscriptions
create table public.subscriptions (
  id           uuid primary key default gen_random_uuid(),
  subscriber_id uuid references public.users(id) on delete cascade,
  creator_id    uuid references public.users(id) on delete cascade,
  price         numeric(10,2) not null,
  currency      text default 'TZS',
  status        text default 'active' check (status in ('active', 'cancelled', 'expired')),
  started_at    timestamptz default now(),
  expires_at    timestamptz,
  primary key (subscriber_id, creator_id)
);

-- Notifications
create table public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references public.users(id) on delete cascade,
  type       text not null, -- 'like', 'follow', 'tip', 'comment', 'live'
  actor_id   uuid references public.users(id) on delete set null,
  post_id    uuid references public.posts(id) on delete cascade,
  message    text,
  is_read    boolean default false,
  created_at timestamptz default now()
);

-- =============================================
-- HELPER FUNCTIONS
-- =============================================

-- Increment posts count when a post is created
create or replace function increment_posts_count(user_id uuid)
returns void language sql as $$
  update public.users set posts_count = posts_count + 1 where id = user_id;
$$;

-- Update follower/following counts on follow
create or replace function handle_follow()
returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' then
    update public.users set followers_count = followers_count + 1 where id = new.following_id;
    update public.users set following_count = following_count + 1 where id = new.follower_id;
  elsif tg_op = 'DELETE' then
    update public.users set followers_count = followers_count - 1 where id = old.following_id;
    update public.users set following_count = following_count - 1 where id = old.follower_id;
  end if;
  return null;
end;
$$;

create trigger on_follow
after insert or delete on public.follows
for each row execute function handle_follow();

-- Update total earnings when tip is received
create or replace function handle_tip()
returns trigger language plpgsql as $$
begin
  update public.users set total_earnings = total_earnings + new.amount where id = new.to_user_id;
  return new;
end;
$$;

create trigger on_tip
after insert on public.tips
for each row execute function handle_tip();

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

alter table public.users         enable row level security;
alter table public.posts         enable row level security;
alter table public.post_likes    enable row level security;
alter table public.follows       enable row level security;
alter table public.tips          enable row level security;
alter table public.subscriptions enable row level security;
alter table public.notifications enable row level security;

-- Users: anyone logged in can read; only owner can update
create policy "users_read"   on public.users for select using (auth.role() = 'authenticated');
create policy "users_insert" on public.users for insert with check (auth.uid() = id);
create policy "users_update" on public.users for update using (auth.uid() = id);

-- Posts: anyone logged in can read; creator can insert/delete
create policy "posts_read"   on public.posts for select using (auth.role() = 'authenticated');
create policy "posts_insert" on public.posts for insert with check (auth.uid() = creator_id);
create policy "posts_delete" on public.posts for delete using (auth.uid() = creator_id);
create policy "posts_update" on public.posts for update using (auth.uid() = creator_id);

-- Likes: authenticated users
create policy "likes_all" on public.post_likes for all using (auth.role() = 'authenticated');

-- Follows: authenticated users
create policy "follows_all" on public.follows for all using (auth.role() = 'authenticated');

-- Tips: authenticated users
create policy "tips_read"   on public.tips for select using (auth.uid() = to_user_id or auth.uid() = from_user_id);
create policy "tips_insert" on public.tips for insert with check (auth.uid() = from_user_id);

-- Subscriptions: owner
create policy "subs_all" on public.subscriptions for all using (auth.uid() = subscriber_id or auth.uid() = creator_id);

-- Notifications: owner only
create policy "notif_all" on public.notifications for all using (auth.uid() = user_id);

-- =============================================
-- STORAGE BUCKETS
-- Run in Supabase Dashboard → Storage → New bucket
-- =============================================
-- Create two public buckets:
--   Name: "images"  | Public: true
--   Name: "videos"  | Public: true
