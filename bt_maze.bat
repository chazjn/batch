@echo off
cls
setlocal EnableDelayedExpansion

echo [Binary Tree Algorithm Maze Creator] @chazjn 26/06/2014. ver 1.1.
echo Based on code here: http://weblog.jamisbuck.org/2011/2/7/maze-generation-algorithm-recap
echo bt_maze /? for more options
echo/

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
			
			IF !go!==0 (SET go=Ёо)
			IF !go!==1 (SET go=Ё )
			IF !go!==2 (SET go=оо)
			
			SET MAZE=!MAZE!!go!
		)

	::draw current row then clear it 
	echo !MAZE!
	SET MAZE=

	::pause screen
	IF %pause% GTR 0 (ping 1.1.1.1 -n 1 -w %pause% > nul)
)

echo Width=%width% height=%height% 
GOTO EOF

:HELP
echo Options:
echo bt_maze [width] [height] [pauseTime]
echo If no height specified, value of width will be used.
echo pauseTime set the (approximate) time in milliseconds to pause between drawing rows.
echo All flags are optional.
echo e.g.: bt_maze 50 75 900
echo/

:EOF