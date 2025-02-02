create extension if not exists "uuid-ossp";

create table users (
	uuid uuid not primary key,
	name text,
	created_at TIMESTAMP DEFAULT now()	
);

create table todos (
  uuid uuid not null default uuid_generate_v1(),
  title text not null,
  completed boolean not null
);