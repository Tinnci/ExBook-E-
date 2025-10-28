# Latexmk configuration for LuaLaTeX
$pdf_mode = 4;  # Use LuaLaTeX
$lualatex = 'lualatex -synctex=1 -interaction=nonstopmode %O %S';
$out_dir = './';

# Enable shell escape for some packages
$lualatex = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode %O %S';
