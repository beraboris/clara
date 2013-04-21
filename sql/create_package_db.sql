-- Packages table
create table if not exists packages (
  id INTEGER,
  name TEXT,
  bunde TEXT,
  version TEXT,
  author TEXT,
  installed_on DATETIME
);

-- Files table
create table if not exists files (
  package_id INTEGER,
  file_path TEXT
);
