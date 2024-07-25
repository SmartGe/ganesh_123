@echo off
setlocal enabledelayedexpansion
 
cd /d "%~dp0"
 
set "collections=SIMPLICIALLpostmancollectionNewman.json SIMPLICIALLpostmancollectionNewman.json"
set "failed=0"
 
:: Create/empty the report file
set "reportFile=-Collection_report.html"
echo > "%reportFile%"
 
:: Loop through each collection
for %%c in (%collections%) do (
    echo Running %%c...
    newman run "%%c" -r htmlextra --reporter-htmlextra-export temp_output.html
    set "exitCode=!errorlevel!"
    if !exitCode! neq 0 (
        echo %%c failed >> "%reportFile%"
        set /a failed+=1
    ) else (
        echo %%c passed >> "%reportFile%"
    )
    :: Append collection results to the report file
    echo --- Results for %%c --- >> "%reportFile%"
    type temp_output.html >> "%reportFile%"
    echo. >> "%reportFile%"
)
 
:: Check for any failures
if %failed% gtr 0 (
    echo Some collections failed
    echo Some collections failed >> "%reportFile%"
) else (
    echo All collections passed
    echo All collections passed >> "%reportFile%"
)
 
:: Clean up temporary file
del temp_output.html
 
exit 0