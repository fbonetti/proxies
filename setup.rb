require 'pg'

conn = PG.connect(dbname: 'proxies')

sql = <<-SQL
  DROP TABLE proxies;

  CREATE TABLE proxies (
    host cidr,
    port int,
    http boolean DEFAULT FALSE,
    https boolean DEFAULT FALSE,
    country varchar(255),
    last_live_at timestamp
  );

  CREATE UNIQUE INDEX proxies_host_port
  ON proxies (host, port);
SQL

conn.exec(sql)