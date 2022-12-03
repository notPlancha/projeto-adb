Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop bucket add main
scoop bucket add extras
scoop install tectonic
scoop install pandoc
scoop install 7zip
#scoop install go
scoop install xidel
Invoke-WebRequest "https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.zip" -OutFile .\osmosis.zip
7z x .\osmosis.zip -o .\osmosis\
#cd osm2mongo\
#go build osm2mongo -o ../osm2mongo.exe
#cd ..
#Invoke-WebRequest https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.zip -OutFile "$env:TEMP\eisvogel.zip"
#7z x "$env:TEMP\eisvogel.zip" -o"$env:TEMP\eisvogel\"
#$pandocTemplatePath = "$env:APPDATA\pandoc\templates\eisvogel.latex"
#if (Test-Path $pandocTemplatePath) { Remove-Item $pandocTemplatePath }
#Move-Item "$env:TEMP\eisvogel\eisvogel.latex" $pandocTemplatePath