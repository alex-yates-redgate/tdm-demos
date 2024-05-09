subsetter.exe ^
--database-engine PostgreSQL ^
--source-connection-string "Server=localhost;Port=5432;Database=paglia;User Id=postgres;Password=Redg@te1" ^
--target-connection-string "Server=localhost;Port=5432;Database=paglia_shadow;User Id=postgres;Password=Redg@te1" ^
--filter-table "rental" ^
--filter-clause "1=1 order by random() fetch first 10 rows only" ^
--target-database-write-mode Overwrite