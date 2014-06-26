@echo off
cls
setlocal EnableDelayedExpansion

:: Get command flags or use defaults
:: %1 = Width
:: %2 = Height
:: %3 = Pause time
IF "%1"=="/?" GOTO HELP
IF "%1"=="" (Set width=15) ELSE (Set width=%1)
IF "%2"=="" (Set height=%width%) ELSE (Set height=%2)
IF "%3"=="" (set pause=0) ELSE (set pause=%3) 

::Increase by 1 to accommodate right/bottom row
set /a maxwidth = %width% + 1
set /a maxheight = %height% + 1

::Make maze, cycle height and widths
For /L %%h IN (1, 1, %maxheight%) DO (

		For /L %%w IN (1, 1, %maxwidth%) DO (
			
			IF %%h GTR 1 (set north=Y) ELSE (SET north=)
			IF %%w GTR 1 (set west=Y) ELSE (SET west=)
			IF %%w EQU %maxwidth% (set north=Y & set west=)
			IF %%h EQU %maxheight% (set west=Y & set north=)
			
			IF NOT DEFINED north IF NOT DEFINED west (SET go=0)
			IF DEFINED north IF NOT DEFINED west (SET go=1)
			IF DEFINED west IF NOT DEFINED north (SET go=2)
			IF DEFINED north IF DEFINED west (SET /a go=!random! %% 2 + 1)
			
			IF !go!==0 (SET go=¦¯)
			IF !go!==1 (SET go=¦ )
			IF !go!==2 (SET go=¯¯)
			
			SET MAZE=!MAZE!!go!
		)

	::draw current row then clear it 
	echo !MAZE!
	SET MAZE=

	::pause screen
	IF %pause% GTR 0 (timeout /t %pause% > nul)
)

echo Width=%width% height=%height% 
echo bt_maze /? for more options
GOTO EOF

:HELP
echo [Binary Tree Algorithm Maze Creator] @chazjn 26/06/2014. ver 1.0.
echo Based on code here: http://weblog.jamisbuck.org/2011/2/7/maze-generation-algorithm-recap
echo/
echo Options:
echo bt_maze [width] [height] [pauseTime]
echo If no height specified, value of width will be used
echo pauseTime set the time in seconds to pause between drawing rows
echo/

:EOF
