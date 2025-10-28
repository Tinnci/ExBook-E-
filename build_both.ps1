# PowerShell Script: Auto-compile both versions of error notebook
# Strategy: Direct output with different jobname for each version
# Version 1: Show solutions
# Version 2: Hide solutions

# Set encoding to UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "[1/3] Generating version WITH solutions..." -ForegroundColor Green

# Create config for showing solutions
@"
% Show solutions version (for review and learning)
\setSolutionDisplay{\showSolution}
"@ | Out-File -Encoding UTF8 solution_config.tex

# Compile with solutions - PASS 1 (generate TOC)
Write-Host "    Compiling (pass 1/2)..." -ForegroundColor Cyan
lualatex -synctex=1 -interaction=nonstopmode -jobname=zhangyu_8_01_with_solutions zhangyu_8_01.tex 2>&1 | Out-Null

# Wait for file completion
Start-Sleep -Milliseconds 1000

# Compile with solutions - PASS 2 (generate TOC in PDF)
Write-Host "    Compiling (pass 2/2)..." -ForegroundColor Cyan
lualatex -synctex=1 -interaction=nonstopmode -jobname=zhangyu_8_01_with_solutions zhangyu_8_01.tex 2>&1 | Out-Null

# Wait for file completion
Start-Sleep -Milliseconds 1000

if (Test-Path zhangyu_8_01_with_solutions.pdf) {
    Write-Host "    [OK] Generated: zhangyu_8_01_with_solutions.pdf" -ForegroundColor Green
} else {
    Write-Host "    [ERROR] Could not generate PDF" -ForegroundColor Red
}

Write-Host ""
Write-Host "[2/3] Generating version WITHOUT solutions..." -ForegroundColor Green

# Create config for hiding solutions
@"
% Hide solutions version (for self-testing)
\setSolutionDisplay{\hideSolution}
"@ | Out-File -Encoding UTF8 solution_config.tex

# Compile without solutions - PASS 1 (generate TOC)
Write-Host "    Compiling (pass 1/2)..." -ForegroundColor Cyan
lualatex -synctex=1 -interaction=nonstopmode -jobname=zhangyu_8_01_no_solutions zhangyu_8_01.tex 2>&1 | Out-Null

# Wait for file completion
Start-Sleep -Milliseconds 1000

# Compile without solutions - PASS 2 (generate TOC in PDF)
Write-Host "    Compiling (pass 2/2)..." -ForegroundColor Cyan
lualatex -synctex=1 -interaction=nonstopmode -jobname=zhangyu_8_01_no_solutions zhangyu_8_01.tex 2>&1 | Out-Null

# Wait for file completion
Start-Sleep -Milliseconds 1000

if (Test-Path zhangyu_8_01_no_solutions.pdf) {
    Write-Host "    [OK] Generated: zhangyu_8_01_no_solutions.pdf" -ForegroundColor Green
} else {
    Write-Host "    [ERROR] Could not generate PDF" -ForegroundColor Red
}

# Cleanup temporary files
Write-Host ""
Write-Host "[3/3] Cleaning up temporary files..." -ForegroundColor Cyan
$tempPatterns = @(
    "zhangyu_8_01_with_solutions.aux",
    "zhangyu_8_01_with_solutions.log",
    "zhangyu_8_01_with_solutions.out",
    "zhangyu_8_01_with_solutions.toc",
    "zhangyu_8_01_with_solutions.fdb_latexmk",
    "zhangyu_8_01_with_solutions.fls",
    "zhangyu_8_01_no_solutions.aux",
    "zhangyu_8_01_no_solutions.log",
    "zhangyu_8_01_no_solutions.out",
    "zhangyu_8_01_no_solutions.toc",
    "zhangyu_8_01_no_solutions.fdb_latexmk",
    "zhangyu_8_01_no_solutions.fls",
    "zhangyu_8_01.pdf"
)
foreach ($pattern in $tempPatterns) {
    Remove-Item -Path $pattern -Force -ErrorAction SilentlyContinue
}
Write-Host "    [OK] Cleanup complete" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[+] Build Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[+] Successfully generated both versions:" -ForegroundColor Green
Write-Host "    1. zhangyu_8_01_with_solutions.pdf" -ForegroundColor Yellow
Write-Host "    2. zhangyu_8_01_no_solutions.pdf" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
