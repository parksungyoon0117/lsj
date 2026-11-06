-- 방명록 메시지 테이블
create table public.messages (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (char_length(name) between 1 and 30),
  content    text not null check (char_length(content) between 1 and 300),
  created_at timestamptz not null default now()
);

comment on table public.messages is '방명록 메시지';

-- 최신순 조회용 인덱스
create index messages_created_at_idx on public.messages (created_at desc);

-- Row Level Security 켜기: 켜는 순간 정책이 허용한 동작 외에는 모두 막힙니다.
alter table public.messages enable row level security;

-- 정책 1: 누구나(로그인 안 한 방문자 포함) 메시지를 읽을 수 있음
create policy "Anyone can read messages"
  on public.messages
  for select
  to anon, authenticated
  using (true);

-- 정책 2: 누구나 메시지를 작성할 수 있음 (길이 제한은 위 check 제약조건이 담당)
create policy "Anyone can write messages"
  on public.messages
  for insert
  to anon, authenticated
  with check (true);

-- 수정(update)·삭제(delete) 정책은 만들지 않았으므로, 브라우저에서는 수정·삭제가 불가능합니다.

-- API 역할에 필요한 권한만 명시적으로 부여
grant select, insert on public.messages to anon, authenticated;
