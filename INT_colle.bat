setlocal enabledelayedexpansion
 
cd /d "%~dp0"
 
set "collections=SIMPLICI_ALL.json"
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
        set /a failed+=1
    ) else (
        echo %%c passed >> "%reportFile%"
    )
    :: Append collection results to the report file
    type temp_output.html >> "%reportFile%"
)
 

 
:: Clean up temporary file
del temp_output.html
 
exit 0