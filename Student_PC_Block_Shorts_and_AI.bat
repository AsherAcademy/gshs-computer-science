@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ======================================================
echo Student PC browser restrictions
echo Blocks YouTube Shorts, Bing Chat, and selected AI sites
echo in Google Chrome and Microsoft Edge.
echo ======================================================
echo.

:: Require Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Run this file as Administrator.
    echo Right-click the file and choose "Run as administrator".
    echo.
    pause
    exit /b 1
)

set "CHROMEKEY=HKLM\SOFTWARE\Policies\Google\Chrome\URLBlocklist"
set "EDGEKEY=HKLM\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"

:: Keep the two original restrictions in entries 1 and 2.
reg add "%CHROMEKEY%" /v 1 /t REG_SZ /d "youtube.com/shorts" /f >nul || goto :failed
reg add "%CHROMEKEY%" /v 2 /t REG_SZ /d "bing.com/chat" /f >nul || goto :failed
reg add "%EDGEKEY%" /v 1 /t REG_SZ /d "youtube.com/shorts" /f >nul || goto :failed
reg add "%EDGEKEY%" /v 2 /t REG_SZ /d "bing.com/chat" /f >nul || goto :failed

:: Add AI website domains. A bare domain blocks that domain and its subdomains.
set /a N=10
for %%D in (
    chatgpt.com
    openai.com
    oaistatic.com
    oaiusercontent.com
    claude.ai
    anthropic.com
    gemini.google.com
    aistudio.google.com
    notebooklm.google.com
    generativelanguage.googleapis.com
    copilot.microsoft.com
    copilot.com
    perplexity.ai
    pplx.ai
    deepseek.com
    grok.com
    x.ai
    poe.com
    character.ai
    meta.ai
    mistral.ai
    you.com
    huggingchat.com
    phind.com
    blackbox.ai
    jasper.ai
    writesonic.com
    copy.ai
    gamma.app
    midjourney.com
    leonardo.ai
    ideogram.ai
    runwayml.com
    elevenlabs.io
    suno.com
    udio.com
    stability.ai
) do (
    reg add "%CHROMEKEY%" /v !N! /t REG_SZ /d "%%D" /f >nul || goto :failed
    reg add "%EDGEKEY%" /v !N! /t REG_SZ /d "%%D" /f >nul || goto :failed
    set /a N+=1
)

echo.
echo SUCCESS: Browser restrictions were added to Chrome and Edge.
echo Blocked: YouTube Shorts URL, Bing Chat, and the listed AI domains.
echo Close and reopen the browsers, or visit chrome://policy and edge://policy
 echo and select Reload policies.
echo.
echo IMPORTANT: Run this only on student PCs. This is browser-level blocking;
echo another browser or portable browser may not follow these policies.
echo This does not block every AI feature embedded in general-purpose websites.
echo.
pause
exit /b 0

:failed
echo.
echo ERROR: A registry command failed. Run this file as Administrator.
echo If the problem continues, check Windows policy permissions.
echo.
pause
exit /b 1
