subsetter.exe `
--database-engine sqlserver `
--source-connection-string "Server=localhost;Database=AdventureWorks_Prod;trusted_connection=yes;TrustServerCertificate=yes" `
--target-connection-string "Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes" `
--target-database-write-mode Overwrite `
--config-file="./Filter.yaml"