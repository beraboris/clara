-- Packages table
create table if not exists packages (
  id integer not null primary key AUTOINCREMENT,
  name text not null,
  bundle text,
  version text not null,
  author text,
  installed_on datetime not null default CURRENT_TIMESTAMP
);
create index packages_name_index on packages(name);

-- Files table
create table if not exists files (
  package_id integer,
  file_path text primary key,

  foreign key (package_id) references packages(id)
);
