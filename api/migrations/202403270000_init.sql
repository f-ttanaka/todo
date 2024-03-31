create extension if not exists "uuid-ossp";

create table todos (
  uuid uuid not null default uuid_generate_v1(),
  title text not null,
  completed boolean not null
);