mongoimport `
    --db atp `
    --collection games `
    --file  ".\data\atpplayers.json"
mongoimport `
    --db atp `
    --collection countryAliases `
    --type csv `
    --headerline `
    --file ".\data\countryAlias.csv"
mongoimport `
    --db atp `
    --collection countryCodes `
    --type csv `
    --headerline `
    --file ".\data\countryCodes.csv"