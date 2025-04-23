create extension if not exists "uuid-ossp";

create table users (
	uuid uuid not null DEFAULT uuid_generate_v1(),
	name text not null unique,
	password text not null,
	created_at TIMESTAMP DEFAULT now(),
	primary key (uuid)
);

create table todos (
  uuid uuid not null default uuid_generate_v1(),
	user_uuid uuid not null, 
  title text not null,
  completed boolean not null,
	primary key (uuid),
	constraint todo_user_uuid_fk foreign key (user_uuid) references users (uuid)
);
