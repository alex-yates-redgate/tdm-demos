subsetter.exe `
--database-engine sqlserver `
--source-connection-string "Server=localhost;Database=AdventureWorks;trusted_connection=yes;TrustServerCertificate=yes" `
--target-connection-string "Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes" `
--target-database-write-mode Overwrite `
--config-file="C:\git\tdm-demos\simple-demos\Subsetter\Filter.yaml"
