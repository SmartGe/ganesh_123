@echo off
setlocal enabledelayedexpansion
 
cd /d "%~dp0"
 
set "collections=INT_Geo_Spider_Number_check_MRC_HCL.json INT_Numbercheck_contribution_Portfolio_Booked_All_RB_Copy.json INT_Numbercheck_contribution_Portfolio_HCC_MRN_ALL_Copy.json INT_Numbercheck_contribution_Portfolio_OM_2212_Fleet_Copy.json INT_Numbercheck_contribution_Portfolio_PURE_PA_FL_Copy.json INT_Portfolio_Geo_Spider_Number_check_23511_OM_2212_Fleet_Copy.json INT_Portfolio_Geo_Spider_Number_check_Booked_All_RB_Copy.json INT_Portfolio_Geo_Spider_Number_check_HCC_MRN_ALL_Copy.json INT_Portfolio_Geo_Spider_Number_check_MRC_HCI.json INT_Portfolio_Geo_Spider_Number_check_MRC_LDS.json INT_Portfolio_Geo_Spider_Number_check_PURE_PA_FL_Copy.json"
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