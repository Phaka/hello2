@echo off

set CONFIGURATION=%1
set RUNTIME=%2
set BUILDNUMBER=%3
set BRANCH=%4

REM if [%RUNTIME%]==[] set RUNTIME=win10-x64
REM if [%CONFIGURATION%]==[] set CONFIGURATION=Release
REM if [%BUILDNUMBER%]==[] set BUILDNUMBER=0
REM if [%VERSION%]==[] set VERSION=1.0.%BUILDNUMBER%

set VERSION=1.0.%BUILDNUMBER%

echo RUNTIME.........: %RUNTIME%
echo CONFIGURATION...: %CONFIGURATION%
echo BUILD...........: %BUILDNUMBER%
echo VERSION.........: %VERSION%


pushd %~dp0src
dotnet restore --runtime "%RUNTIME%"
dotnet publish --framework netcoreapp1.1 --runtime "%RUNTIME%" --output %~dp0packaging\%RUNTIME% -c %CONFIGURATION% --version-suffix %VERSION%
popd
