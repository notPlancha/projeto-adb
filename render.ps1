pandoc projetoAdb.md -o projetoAdb.latex -s -V lang=pt-pt
if ($LastExitCode -eq 0) {
 tectonic projetoAdb.latex
}