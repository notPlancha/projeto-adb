#Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop bucket add main
scoop bucket add extras
scoop install tectonic
scoop install pandoc
scoop install 7zip
scoop install mongosh
scoop install mongodb-database-tools
7z x .\data\atpplayers.7z