@echo off

:: Sørg for at batch-filen kjører som administrator
:CheckPrivileges
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Administratorrettigheter kreves for å kjøre dette skriptet.
    PING localhost >NUL
    PowerShell Start-Process cmd -ArgumentList '/c, %0', '-Verb RunAs'
    EXIT /B
)

:: Stopp Credential Manager-tjenesten
sc stop VaultSvc

:: Gi tilgang til NGC-mappen og slett den
takeown /f C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /r /d y
icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /grant administrators:F /t
rmdir /s /q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC

:: Start Credential Manager-tjenesten igjen
sc start VaultSvc

:: Gi beskjed om å starte maskinen på nytt
echo Windows Hello-data er nullstilt. Vennligst start maskinen på nytt for å sette opp PIN-kode på nytt.
pause
