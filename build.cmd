@echo off
setlocal

set PATH=%PATH%;%WIX%bin

set CONFIGURATION=%1
set RUNTIME=%2
set BUILDNUMBER=%3
set BRANCH=%4

if "%RUNTIME%" == "" set RUNTIME=win10-x64
if "%CONFIGURATION%" == "" set CONFIGURATION=Release
if "%BUILDNUMBER%" == "" set BUILDNUMBER=0
if "%VERSION%" == "" set VERSION=1.0.%BUILDNUMBER%

set VERSION=1.0.%BUILDNUMBER%

echo RUNTIME.........: %RUNTIME%
echo CONFIGURATION...: %CONFIGURATION%
echo BUILD...........: %BUILDNUMBER%
echo VERSION.........: %VERSION%

set PUBLISHDIR=%~dp0tmp\%RUNTIME%
set GENFILE=%~dp0tmp\HelloPortal.wxs

pushd %~dp0src
dotnet restore --runtime "%RUNTIME%"
dotnet publish --framework netcoreapp1.1 --runtime "%RUNTIME%" --output %PUBLISHDIR% -c %CONFIGURATION% --version-suffix %VERSION%
popd

heat dir %PUBLISHDIR% -ag -scom -sfrag -srd -sreg -nologo -dr HelloPortalDirRef -cg HelloPortalComponentGroup -var var.HelloPortalSourceDir -o %GENFILE%  

pushd %~dp0packaging\windows
candle.exe -out obj\Release\ -dVersion=%VERSION% -dHelloPortalSourceDir=%PUBLISHDIR% -arch x64 -ext "%WIX%\bin\WixUIExtension.dll" Product.wxs %GENFILE%
light.exe -out bin\Release\hello-%RUNTIME%.msi -pdbout bin\Release\hello.wixpdb -cultures:null -ext "%WIX%\bin\WixUIExtension.dll" obj\Release\Product.wixobj obj\Release\HelloPortal.wixobj

candle.exe -out obj\Release\ -dVersion=%VERSION% -arch x64 -ext "%WIX%\bin\WixBalExtension.dll" Bundle.wxs
light.exe -out bin\Release\hello_%VERSION%-%RUNTIME%.exe -pdbout bin\Release\Bootstrapper.wixpdb -ext "%WIX%\bin\WixBalExtension.dll" obj\Release\Bundle.wixobj
popd 

endlocal