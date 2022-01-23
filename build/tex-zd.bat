@ECHO OFF
set "base_path=%cd%"
SET base_path=%base_path:\build=%
SET delete_path=%base_path%\zdoom\filter\textures

FOR /f %%a IN ('WMIC OS GET LocalDateTime ^| FIND "."') DO ( SET DTS=%%a )
SET datestamp=%DTS:~0,8%

if exist "%base_path%\zdoom" (RD /S /Q "%base_path%\zdoom")

::mkdir %base_path%\built
mkdir "%base_path%\zdoom"

echo ---------starting to create the dhtp for the zdoom engine and compatible engines---------
mkdir "%base_path%\zdoom\filter\doom\hires"
mkdir "%base_path%\zdoom\filter\doom.doom2\hires"
mkdir "%base_path%\zdoom\filter\doom.doom2.plutonia\hires"
mkdir "%base_path%\zdoom\filter\doom.doom2.tnt\hires"

echo ---------copying textures---------
xcopy "%base_path%\textures\*.png" "%base_path%\zdoom\filter\textures\" /E
move "%base_path%\zdoom\filter\textures\doom1\*" "%base_path%\zdoom\filter\doom\hires\"
move "%base_path%\zdoom\filter\textures\doom2\*" "%base_path%\zdoom\filter\doom.doom2\hires\"
move "%base_path%\zdoom\filter\textures\doom2-plut\*" "%base_path%\zdoom\filter\doom.doom2.plutonia\hires\"
move "%base_path%\zdoom\filter\textures\doom2-tnt\*" "%base_path%\zdoom\filter\doom.doom2.tnt\hires\"
RD /S /Q "%delete_path%\doom1" "%delete_path%\doom2" "%delete_path%\doom2-plut" "%delete_path%\doom2-tnt"
move "%base_path%\zdoom\filter\textures\*" "%base_path%\zdoom\filter\doom\hires\"
echo ---------copying flats---------
xcopy "%base_path%\flats\*.png" "%base_path%\zdoom\filter\doom\hires\" /Y
RD /S /Q "%delete_path%"


echo ---------copying readmes---------
FOR %%b IN ("%base_path%\docs\*") DO (
copy "%base_path%\README.md"+"%%b"+"%base_path%\credits.txt" "%base_path%\zdoom\README_%%~nb%%~xb"
)


echo ---------ziping pack---------
powershell Compress-Archive -LiteralPath '%base_path%\zdoom\filter' -DestinationPath '%base_path%\zdoom-dhtp-%datestamp%.zip'
REN "%base_path%\zdoom-dhtp-%datestamp%.zip" "zdoom-dhtp-%datestamp%.pk3"
echo ---------Complete---------
