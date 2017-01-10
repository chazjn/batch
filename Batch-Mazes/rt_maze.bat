@echo off
cls
setlocal EnableDelayedExpansion

echo [Recursive Backtracker Maze Creator] @chazjn 28/06/2014. ver 0.1.
echo Based on code here: http://weblog.jamisbuck.org/2011/2/7/maze-generation-algorithm-recap
echo rt_maze /? for more options
echo/

:: Get command flags or use defaults
:: %1 = Width
:: %2 = Height
IF "%1"=="/?" GOTO HELP
IF "%1"=="" (Set width=15) ELSE (Set width=%1)
IF "%2"=="" (Set height=%width%) ELSE (Set height=%2)

::Generate an empty maze
::represent each cell and as a double zero
For /L %%h IN (1, 1, %height%) DO (
		For /L %%w IN (1, 1, %width%) DO (
			SET MROW%%h=00!MROW%%h!
		)	
)

::display empty maze
For /L %%h IN (1, 1, %height%) DO (

	IF %%h EQU 1 (For /L %%w IN (1, 1, %width%) DO (SET TOP=_!TOP!))
	IF %%h EQU 1 ECHO .!TOP!!TOP!.
	
	ECHO ^|!MROW%%h!^|
		
	IF %%h EQU %height% (For /L %%w IN (1, 1, %width%) DO (SET BOT=~!BOT!))
	IF %%h EQU %height% ECHO `!BOT!!BOT!'	
)

:: Now we create a real maze
:: bitfields describe valid directions
:: 00 = not visited
:: 01 = north
:: 02 = east
:: 04 = south
:: 08 = west
:: therefore 01+02+04 = 07 (north, east & south are valid)
:: and 02+08 = 10 (east and west are valid) etc etc.


::choose random starting point
SET /A X=!random! %% %width% + 1
SET /A Y=!random! %% %height% + 1

SET MHISTORY=!X! across by !Y! down
ECHO !MHISTORY!

::Choose a random direction
:: 0 = 01 (north)
:: 1 = 02 (east)
:: 2 = 04 (south)
:: 3 = 05 (west)

SET /A GO=!random! %% 4
IF !GO! EQU 0 (SET GO=N)
IF !GO! EQU 1 (SET GO=E) 
IF !GO! EQU 2 (SET GO=S) 
IF !GO! EQU 3 (SET GO=W) 
ECHO Go = !GO!


::check if that direction is valid, if not choose again
CALL :IsDirectionValid !GO!
IF NOT !GO!==X (ECHO Direction is OK!) ELSE (ECHO Direction is not valid!)


echo Width=%width% height=%height% 

GOTO END

:::::::::::::::
:: FUNCTIONS ::
:::::::::::::::



::Check if direction is valid
::Send 3 arguments: %1= Returned Go value
::returns go as X is not a valid direction
:IsDirectionValid
::check north
IF !GO! EQU N IF !Y! EQU 1 (ECHO Cannot go north! & SET GO=X)
::check east
IF !GO! EQU E IF !X! EQU %width% (ECHO Cannot go east! & SET GO=X)
::check south
IF !GO! EQU S IF !Y! EQU %height% (ECHO Cannot go south! & SET GO=X)
::check west
IF !GO! EQU W IF !X! EQU 1 (ECHO Cannot go west! & SET GO=X)
::check if we've visited the cell before
CALL :GetValueOfXY V
IF NOT !V!==00 (ECHO Cell already visited! & SET GO=X)

GOTO :EOF


::Get the value of X/Y cell 
::Send 1 arguments: %1=returned value
:GetValueOfXY

:: get actual column value which is X minus 1 times 2
SET /A XX=(!X! - 1) * 2

:: get the value of the row/column and assign to %3
SET %1=!MROW%Y%:~%XX%,2!

:: show the value of the row/column
echo V = !%1!

GOTO :EOF


:HELP
echo Options:
echo rt_maze [width] [height] [pauseTime]
echo If no height specified, value of width will be used.
echo Both flags are optional.
echo e.g.: rt_maze 50 75
echo/
:END
