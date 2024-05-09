-- Drop subset database if exists
use master 
go
alter database AdventureWorks_TDM set single_user with rollback immediate
drop database if exists AdventureWorks_TDM

-- Clone the database
DBCC CLONEDATABASE ('AdventureWorks', 'AdventureWorks_TDM') with VERIFY_CLONEDB;
go
-- Switch to the new database and set it to read/write
USE master;
ALTER DATABASE AdventureWorks_TDM SET read_write with rollback IMMEDIATE;
