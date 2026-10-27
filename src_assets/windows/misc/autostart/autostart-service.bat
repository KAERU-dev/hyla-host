@echo off

rem Set the service to auto-start
sc config ApolloService start= auto
exit /b %ERRORLEVEL%
