Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop bucket add main
scoop bucket add extras
scoop install tectonic
scoop install pandoc
#scoop install 7zip
#Invoke-WebRequest https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.zip -OutFile "$env:TEMP\eisvogel.zip"
#7z x "$env:TEMP\eisvogel.zip" -o"$env:TEMP\eisvogel\"
#$pandocTemplatePath = "$env:APPDATA\pandoc\templates\eisvogel.latex"
#if (Test-Path $pandocTemplatePath) { Remove-Item $pandocTemplatePath }
#Move-Item "$env:TEMP\eisvogel\eisvogel.latex" $pandocTemplatePath