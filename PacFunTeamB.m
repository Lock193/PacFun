function PacFunTeamB
clc
clearvars
clear global
close all

global score xBoarder yBoarder gameField game_scene showLevelFlag
global pacmanX pacmanY pacmanDirection foodX foodY
global enemyObjects %X,Y

showLevelFlag = 1;
gameField = 1;
game_scene = simpleGameEngine('game_cover.png', 1399, 1399);
drawField();
keyPress(getKeyboardInput(game_scene));

score = 0;
xBoarder = 20;
yBoarder = 20;
enemyObjects = zeros(5, 2);
gameProcessRun();
if score > 4
    win();
else
    gameOver();
end

function gameProcessRun()
while (1)
    if score > 4
        break;
    end
    if showLevelFlag == 1
        showLevel();
        close all
        drawField();
        keyPress(getKeyboardInput(game_scene));
     
        showLevelFlag = 0;
        initializeLevel();
    end
    drawField();
 
    keyPress(getKeyboardInput(game_scene));
    movePacman();
    drawField();
    if (foodX == pacmanX) && (foodY == pacmanY)
        score = score + 1;
        showLevelFlag = 1;
        continue;
    end
    for i = 1:score + 1
        if ((pacmanX == enemyObjects(i, 1)) && (pacmanY == enemyObjects(i, 2)))
            return;
        end
        [enemyObjects(i, 1), enemyObjects(i, 2)] = moveEnemy(enemyObjects(i, 1), enemyObjects(i, 2));
        drawField();
        if ((pacmanX == enemyObjects(i, 1)) && (pacmanY == enemyObjects(i, 2)))
            return;
        end
    end
end
end

function initializeLevel()
try
    close all
    game_scene = simpleGameEngine('pacman.png', 69, 69);
    %General
    gameField = zeros(xBoarder, yBoarder);
    gameField = gameField + 2;
    pacmanDirection = '';
 
    % Initialize Pacman
    pacmanX = xBoarder / 2;
    pacmanY = yBoarder / 2;
    gameField(pacmanX, pacmanY) = 1;
 
    %Walls
    initializeWalls();
 
    foodX = 1;
    foodY = 1;
    generateFruits();
 
    for i = 1:score + 1
        [enemyObjects(i, 1), enemyObjects(i, 2)] = initializeEnemy();
    end
catch
end
end

function showLevel()
try
    % LEVEL 1
    if score == 0
        gameField = 1;
        game_scene = simpleGameEngine('level1.png', 1399, 1399);
        % LEVEL 2
    elseif score == 1
        gameField = 1;
        game_scene = simpleGameEngine('level2.png', 1399, 1399);
        % LEVEL 3
    elseif score == 2
        gameField = 1;
        game_scene = simpleGameEngine('level3.png', 1399, 1399);
        % LEVEL 4
    elseif score == 3
        gameField = 1;
        game_scene = simpleGameEngine('level4.png', 1399, 1399);
        % LEVEL 5
    elseif score == 4
        gameField = 1;
        game_scene = simpleGameEngine('level5.png', 1399, 1399);
    end
catch
end
end

function drawField()
try
    drawScene(game_scene, gameField, gameField);
catch
end
end

% When a key is pressed
function keyPress (key)
try
    if showLevelFlag == 0
        pacmanDirection = key;
    end
catch
end
end

function movePacman()
oldPacmanX = pacmanX;
oldPacmanY = pacmanY;
try
    gameField(pacmanX, pacmanY) = 2;
    if isequal(pacmanDirection, 'downarrow')
        if (pacmanX == xBoarder) || (gameField(pacmanX + 1, pacmanY) == 5)
            pacmanX = pacmanX - 1;
        else
            pacmanX = pacmanX + 1;
        end
    elseif isequal(pacmanDirection, 'uparrow')
        if (pacmanX == 1) || (gameField(pacmanX - 1, pacmanY) == 5)
            pacmanX = pacmanX + 1;
        else
            pacmanX = pacmanX - 1;
        end
    elseif isequal(pacmanDirection, 'rightarrow')
        if (pacmanY == yBoarder) || (gameField(pacmanX, pacmanY + 1) == 5)
            pacmanY = pacmanY - 1;
        else
            pacmanY = pacmanY + 1;
        end
    elseif isequal(pacmanDirection, 'leftarrow')
        if (pacmanY == 1) || (gameField(pacmanX, pacmanY - 1) == 5)
            pacmanY = pacmanY + 1;
        else
            pacmanY = pacmanY - 1;
        end
    end
 
    gameField(pacmanX, pacmanY) = 1;
catch
    gameField(oldPacmanX, oldPacmanY) = 1;
end
end

%Creates new fruits
function generateFruits()
try
    while (1)
        foodX = randi(xBoarder);
        foodY = randi(yBoarder);
        [distance, ~] = findShortestPath(foodX, foodY);
        if (gameField(foodX, foodY) == 2 && distance > 4)
            gameField(foodX, foodY) = 3;
            break;
        end
    end
catch
end
end

function [enemyX, enemyY] = initializeEnemy()
try
    while (1)
        enemyX = randi(xBoarder);
        enemyY = randi(yBoarder);
        [distance, ~] = findShortestPath(enemyX, enemyY);
        if (gameField(enemyX, enemyY) == 2) && (distance > 4)
            gameField(enemyX, enemyY) = 4;
            break;
        end
    end
catch
end
end

function [distance, enemyDirection] = findShortestPath(enemyX, enemyY)
try
    % Enemy AI: calculating which direction to choose
    distanceIfDirectionUp = sqrt((enemyX - 1 - pacmanX) ^ 2 + (enemyY - pacmanY) ^ 2);
    distanceIfDirectionDown = sqrt((enemyX + 1 - pacmanX) ^ 2 + (enemyY - pacmanY) ^ 2);
    distanceIfDirectionRight = sqrt((enemyX - pacmanX) ^ 2 + (enemyY + 1 - pacmanY) ^ 2);
    distanceIfDirectionLeft = sqrt((enemyX - pacmanX) ^ 2 + (enemyY - 1 - pacmanY) ^ 2);
 
    distance = min(min(distanceIfDirectionUp, distanceIfDirectionDown), min(distanceIfDirectionRight, distanceIfDirectionLeft));
 
    if distanceIfDirectionUp == distance
        enemyDirection = 'uparrow';
    elseif distanceIfDirectionDown == distance
        enemyDirection = 'downarrow';
    elseif distanceIfDirectionRight == distance
        enemyDirection = 'rightarrow';
    elseif distanceIfDirectionLeft == distance
        enemyDirection = 'leftarrow';
    end
catch
end
end

function [enemyX, enemyY] = moveEnemy(enemyX, enemyY)
oldEnemyX = enemyX;
oldEnemyY = enemyY;
try
    [~, enemyDirection] = findShortestPath(enemyX, enemyY);
    %Moving the enemy
    gameField(enemyX, enemyY) = 2;
    if isequal(enemyDirection, 'downarrow')
        if (enemyX == xBoarder)
            enemyX = enemyX - 1;
        elseif (gameField(enemyX + 1, enemyY) ~= 2) && (gameField(enemyX + 1, enemyY) ~= 1)
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX, tempEnemyY + 1) == 2
                while gameField(tempEnemyX + 1, tempEnemyY) ~= 2 && gameField(tempEnemyX + 1, tempEnemyY) ~= 1 && gameField(tempEnemyX, tempEnemyY + 1) == 2
                    %Moving right
                    tempEnemyY = tempEnemyY + 1;
                end
                [distanceRight, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceRight = 500;
            end
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX, tempEnemyY - 1) == 2
                while gameField(tempEnemyX + 1, tempEnemyY) ~= 2 && gameField(tempEnemyX + 1, tempEnemyY) ~= 1 && gameField(tempEnemyX, tempEnemyY + 1) == 2
                    %Moving left
                    tempEnemyY = tempEnemyY - 1;
                end
                [distanceLeft, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceLeft = 500;
            end
            if (distanceRight < distanceLeft)
                enemyY = enemyY + 1;
            else
                enemyY = enemyY - 1;
            end
         
        else
            enemyX = enemyX + 1;
        end
    elseif isequal(enemyDirection, 'uparrow')
        if (enemyX == 1)
            enemyX = enemyX + 1;
        elseif (gameField(enemyX - 1, enemyY) ~= 2) && (gameField(enemyX - 1, enemyY) ~= 1)
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX, tempEnemyY + 1) == 2
                while gameField(tempEnemyX - 1, tempEnemyY) ~= 2 && gameField(tempEnemyX - 1, tempEnemyY) ~= 1 && gameField(tempEnemyX, tempEnemyY + 1) == 2
                    %Moving right
                    tempEnemyY = tempEnemyY + 1;
                end
                [distanceRight, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceRight = 500;
            end
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX, tempEnemyY - 1) == 2
                while gameField(tempEnemyX - 1, tempEnemyY) ~= 2 && gameField(tempEnemyX - 1, tempEnemyY) ~= 1 && gameField(tempEnemyX, tempEnemyY - 1) == 2
                    %Moving left
                    tempEnemyY = tempEnemyY - 1;
                end
                [distanceLeft, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceLeft = 500;
            end
            if (distanceRight < distanceLeft)
                enemyY = enemyY + 1;
            else
                enemyY = enemyY - 1;
            end
        else
            enemyX = enemyX - 1;
        end
    elseif isequal(enemyDirection, 'rightarrow')
        if (enemyY == yBoarder)
            enemyY = enemyY - 1;
        elseif gameField(enemyX, enemyY + 1) ~= 2 && gameField(enemyX, enemyY + 1) ~= 1
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX - 1, tempEnemyY) == 2
                while gameField(tempEnemyX, tempEnemyY + 1) ~= 2 && gameField(tempEnemyX, tempEnemyY + 1) ~= 1 && gameField(tempEnemyX - 1, tempEnemyY) == 2
                    %Moving up
                    tempEnemyX = tempEnemyX - 1;
                end
                [distanceUp, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceUp = 500;
            end
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX + 1, tempEnemyY) == 2
                while gameField(tempEnemyX, tempEnemyY + 1) ~= 2 && gameField(tempEnemyX, tempEnemyY + 1) ~= 1 && gameField(tempEnemyX + 1, tempEnemyY) == 2
                    %Moving down
                    tempEnemyX = tempEnemyX + 1;
                end
                [distanceDown, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceDown = 500;
            end
            if (distanceDown < distanceUp)
                enemyX = enemyX + 1;
            else
                enemyX = enemyX - 1;
            end
        else
            enemyY = enemyY + 1;
        end
    elseif isequal(enemyDirection, 'leftarrow')
        if (enemyY == 1)
            enemyY = enemyY + 1;
        elseif gameField(enemyX, enemyY - 1) ~= 2 && gameField(enemyX, enemyY - 1) ~= 1
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX - 1, tempEnemyY) == 2
                while gameField(tempEnemyX, tempEnemyY - 1) ~= 2 && gameField(tempEnemyX, tempEnemyY - 1) ~= 1 && gameField(tempEnemyX - 1, tempEnemyY) == 2
                    %Moving up
                    tempEnemyX = tempEnemyX - 1;
                end
                [distanceUp, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceUp = 500;
            end
            tempEnemyX = enemyX;
            tempEnemyY = enemyY;
            if gameField(tempEnemyX + 1, tempEnemyY) == 2
                while gameField(tempEnemyX, tempEnemyY - 1) ~= 2 && gameField(enemyX, enemyY - 1) ~= 1 && gameField(tempEnemyX + 1, tempEnemyY) == 2
                 
                    %Moving down
                    tempEnemyX = tempEnemyX + 1;
                end
                [distanceDown, ~] = findShortestPath(tempEnemyX, tempEnemyY);
            else
                distanceDown = 500;
            end
            if (distanceDown < distanceUp)
                enemyX = enemyX + 1;
            else
                enemyX = enemyX - 1;
            end
        else
            enemyY = enemyY - 1;
        end
    end
 
    gameField(enemyX, enemyY) = 4;
catch
    gameField(oldEnemyX, oldEnemyY) = 4;
end
end

function initializeWalls()
try
    % LEVEL 1
    if score == 0
        for i = 1:19
            if 1 ~= mod(i, 2) && i ~= 10
                gameField(i, i) = 5;
                gameField(i + 1, i) = 5;
            end
        end
        for i = 1:19
            if 1 ~= mod(i, 2) && i ~= 10
                gameField(20 - i, i) = 5;
                gameField(20 - i + 1, i) = 5;
            end
        end
     
        % LEVEL 2
    elseif score == 1
     
        for i = 3:17
            if i ~= 10
                gameField(i, i) = 5;
                gameField(i + 1, i) = 5;
            end
            for i = 3:10
                gameField(13 - i, 21 - i) = 5;
                gameField(13 - i, 20 - i) = 5;
                gameField(20 - i, 13 - i) = 5;
                gameField(20 - i, 12 - i) = 5;
            end
            gameField(1, 2) = 5;
            gameField(2, 1) = 5;
            gameField(1, 19) = 5;
            gameField(2, 20) = 5;
            gameField(19, 1) = 5;
            gameField(20, 2) = 5;
            gameField(19, 20) = 5;
            gameField(20, 19) = 5;
            gameField(4, 17) = 5;
            gameField(17, 4) = 5;
        end
     
        % LEVEL 3
    elseif score == 2
        gameField(18, 18) = 5;
        gameField(2, 2) = 5;
        gameField(18, 2) = 5;
        gameField(2, 18) = 5;
        for i = 5:15
            if i ~= 10
                gameField(i, 10) = 5;
                gameField(i, 5) = 5;
                gameField(i, 15) = 5;
                gameField(i - 3, 3) = 5;
                gameField(i - 3, 7) = 5;
                gameField(i - 3, 12) = 5;
                gameField(i - 3, 17) = 5;
                gameField(18, i) = 5;
            end
        end
        gameField(16, 5) = 5;
        gameField(16, 6) = 5;
        gameField(16, 7) = 5;
        gameField(16, 15) = 5;
        gameField(16, 14) = 5;
        gameField(16, 13) = 5;
     
        % LEVEL 4
    elseif score == 3
        for i = 2:19
            if i ~= 6 && i ~= 15
                gameField(i, 19) = 5;
                gameField(i, 2) = 5;
            end
        end
        for i = 4:17
            if i ~= 10 && i ~= 11
                gameField(3, i) = 5;
                gameField(18, i) = 5;
            end
            for i = 4:17
                if i ~= 9 && i ~= 12
                    gameField(5, i) = 5;
                    gameField(16, i) = 5;
                end
            end
            for i = 7:14
                if i ~= 10 && i ~= 11
                    gameField(7, i) = 5;
                    gameField(14, i) = 5;
                end
            end
            for i = 8:12
                gameField(i, 4) = 5;
                gameField(i, 17) = 5;
            end
            for i = 7:11
                gameField(i, 6) = 5;
                gameField(i, 15) = 5;
            end
            for i = 9:12
                gameField(i, 8) = 5;
                gameField(i, 13) = 5;
                gameField(9, i) = 5;
            end
        end
     
        % LEVEL 5
    elseif score == 4
        for i = 2:20
            if i ~= 1 && i ~= 6 && i ~= 10 && i ~= 17
                gameField(i, 2) = 5;
                gameField(i, 19) = 5;
            end
         
            for i = 1:19
                if i ~= 11 && i ~= 13 && i ~= 15 && i ~= 17
                    gameField(i, 4) = 5;
                    gameField(i, 17) = 5;
                end
            end
         
            for i = 10:14
                if i ~= 11 && i ~= 13
                    gameField(i, 5) = 5;
                    gameField(i, 16) = 5;
                end
            end
         
            for i = 2:19
                if i ~= 9 && i ~= 10 && i ~= 11 && i ~= 12 && i ~= 13 && i ~= 15 && i ~= 16 && i ~= 18
                    gameField(i, 6) = 5;
                    gameField(i, 15) = 5;
                end
            end
            for i = 8
                gameField(i, 7) = 5;
                gameField(i, 14) = 5;
                gameField(12, i) = 5;
                gameField(12, i + 5) = 5;
                gameField(11, i) = 5;
                gameField(11, i + 5) = 5;
                gameField(10, i) = 5;
                gameField(10, i + 5) = 5;
            end
            for i = 14:15
                gameField(i, 7) = 5;
                gameField(i, 14) = 5;
            end
            for i = 9:12
                gameField(1, i) = 5;
                gameField(3, i) = 5;
                gameField(6, i) = 5;
                gameField(12, i) = 5;
                gameField(16, i) = 5;
                gameField(18, i) = 5;
            end
            for i = 8:13
                gameField(8, i) = 5;
            end
            gameField(14, 10) = 5;
            gameField(14, 11) = 5;
            gameField(20, 8) = 5;
            gameField(20, 9) = 5;
            gameField(20, 12) = 5;
            gameField(20, 13) = 5;
        end
    end
catch
end
end

function gameOver()
try
    close all
    gameField = 1;
    game_scene = simpleGameEngine('you_lose.png', 1399, 1399);
    drawScene(game_scene, gameField, gameField);
    showLevel = 1;
    keyPress(getKeyboardInput(game_scene));
    close all
catch
end
end

function win()
try
    close all
    gameField = 1;
    game_scene = simpleGameEngine('you_win.png', 1399, 1399);
    drawScene(game_scene, gameField, gameField);
    showLevel = 1;
    keyPress(getKeyboardInput(game_scene));
    close all
catch
end
end
end