//board 67
let board;
let columnCount = 19;
let rowCount = 21;
const tileSize = 32;
const boardWidth = columnCount * tileSize;
const boardHeight = rowCount * tileSize;
const scoreboard = document.getElementById('score')
let context;
let lastTime = 0;
lives = 3;
points = 0;
speed = 16;
poweredUp = false;
let powerUpLength;
moving = false;
started = false;

const directions = ['U', 'D', 'L', 'R'];


//X = wall p = pac man L = power pellet ' ' = dot

//Sprites
let blueGhostImage;
let orangeGhostImage;
let pinkGhostImage;
let redGhostImage;
let pacmanLeftImage;
let pacmanRightImage;
let pacmanUpImage;
let pacmanDownImage;
let wallImage;
let scaredGhostImage;

const tileMap = [
    "XXXXXXXXXXXXXXXXXXX",
    "X    L   X        X",
    "X XX XXX X XXX XX X",
    "X       L         X",
    "X XX X XX XX X XX X",
    "X    X       X    X",
    "XXXX XXXX XXXX XXXX",
    "OOOX X       X XOOO",
    "XXXX X XXrXX X XXXX",
    "O       bpo       O",
    "XXXX X XXXXX X XXXX",
    "OOOX X       X XOOO",
    "XXXX X XXXXX X XXXX",
    "X  L     X   L    X",
    "X XX XXX X XXX XX X",
    "X  X     P     X  X",
    "XX X X XXXXX X X XX",
    "X    X   X   X    X",
    "X XXXXXX X XXXXXX X",
    "X                 X",
    "XXXXXXXXXXXXXXXXXXX"
]

const walls = new Set();
const foods = new Set();
const powerPellets = new Set();
const ghosts = new Set();
let pacman;

window.onload = function () {
    board = document.getElementById('board');
    board.height = boardHeight;
    board.width = boardWidth;
    context = board.getContext('2d')

    for (let ghost of ghosts.values()) {
        const newDirection = directions[Math.floor(Math.random() * 4)];
        ghost.updateDirection(newDirection);

    }
    requestAnimationFrame(gameLoop);
    loadImages();
    loadMap();
    update();

    document.addEventListener('keydown', movePacman)
    console.log(ghosts.size);
    console.log(walls.size);
    console.log(foods.size);
}

function updateScoreBoard() {
    scoreboard.innerText = `Score: ${points}   Lives: ${lives}`;
}

function loadImages() {
    wallImage = new Image();
    wallImage.src = 'Assets/wall.png';

    orangeGhostImage = new Image();
    orangeGhostImage.src = 'Assets/orangeGhost.png';
    blueGhostImage = new Image();
    blueGhostImage.src = 'Assets/blueGhost.png';
    redGhostImage = new Image();
    redGhostImage.src = 'Assets/redGhost.png';
    pinkGhostImage = new Image();
    pinkGhostImage.src = 'Assets/pinkGhost.png';
    scaredGhostImage = new Image();
    scaredGhostImage.src = 'Assets/scaredGhost.png'


    pacmanDownImage = new Image();
    pacmanDownImage.src = 'Assets/pacmanDown.png';
    pacmanUpImage = new Image();
    pacmanUpImage.src = 'Assets/pacmanUp.png';
    pacmanRightImage = new Image();
    pacmanRightImage.src = 'Assets/pacmanRight.png';
    pacmanLeftImage = new Image();
    pacmanLeftImage.src = 'Assets/pacmanLeft.png';

}

function loadMap() {
    walls.clear();
    foods.clear();
    ghosts.clear();

    for (let r = 0; r < rowCount; r++) {
        for (let c = 0; c < columnCount; c++) {
            const row = tileMap[r];
            const tileMapChar = row[c];

            const x = c * tileSize;
            const y = r * tileSize;

            if (tileMapChar == 'X') {
                const wall = new Block(wallImage, x, y, tileSize, tileSize);
                walls.add(wall);
            }
            else if (tileMapChar == 'b') {
                const ghost = new Block(blueGhostImage, x, y, tileSize, tileSize);
                ghosts.add(ghost);
            }
            else if (tileMapChar == 'o') {
                const ghost = new Block(orangeGhostImage, x, y, tileSize, tileSize);
                ghosts.add(ghost);
            }
            else if (tileMapChar == 'p') {
                const ghost = new Block(pinkGhostImage, x, y, tileSize, tileSize);
                ghosts.add(ghost);
            }
            else if (tileMapChar == 'r') {
                const ghost = new Block(redGhostImage, x, y, tileSize, tileSize);
                ghosts.add(ghost);
            }
            else if (tileMapChar == 'P') {
                pacman = new Block(pacmanRightImage, x, y, tileSize, tileSize);
            }
            else if (tileMapChar == 'L') {
                const powerPellet = new Block(null, x + 8, y + 8, 16, 16);
                powerPellets.add(powerPellet);

            }
            else if (tileMapChar == ' ') {
                const food = new Block(null, x + 14, y + 14, 4, 4);
                foods.add(food);
            }

        }
    }
}

let isPlaying = false;

function playSound(url) {
    const audio = new Audio(url);

    return audio.play()
        .then(() => audio)
        .catch(err => {
            console.error("Audio error", err);
            throw err;
        });
}

function gameLoop(timestamp) {
    const delta = timestamp - lastTime;
    lastTime = timestamp;

    update(delta);
    requestAnimationFrame(gameLoop);
}

function update(delta) {
    move(delta);
    draw();
    removeObjects();
    updateScoreBoard();
}

/*
function update() {
    move();
    draw();
    removeObjects();
    updateScoreBoard();
    setTimeout(update, 50);

}
*/

function draw() {
    context.clearRect(0, 0, board.width, board.height);
    context.drawImage(pacman.image, pacman.x, pacman.y, pacman.width, pacman.height);
    for (let ghost of ghosts.values()) {
        if (poweredUp == false) {
            context.drawImage(ghost.image, ghost.x, ghost.y, ghost.width, ghost.height);
        }
        else {
            context.drawImage(scaredGhostImage, ghost.x, ghost.y, ghost.width, ghost.height);
        }
    }
    for (let wall of walls.values()) {
        context.drawImage(wall.image, wall.x, wall.y, wall.width, wall.height);
    }
    context.fillStyle = 'white'
    for (let food of foods.values()) {
        context.fillRect(food.x, food.y, food.width, food.height)
    }
    context.fillStyle = 'yellow'
    for (let powerPellet of powerPellets.values()) {
        context.fillRect(powerPellet.x, powerPellet.y, powerPellet.width, powerPellet.height)
    }
}

//looks nicer than before but still works
function movePacman(e) {
    started = true;
    if (e.code === "ArrowUp"   || e.code === "KeyW") pacman.nextDirection = 'U';
    if (e.code === "ArrowDown" || e.code === "KeyS") pacman.nextDirection = 'D';
    if (e.code === "ArrowLeft" || e.code === "KeyA") pacman.nextDirection = 'L';
    if (e.code === "ArrowRight"|| e.code === "KeyD") pacman.nextDirection = 'R';
}

function collisionDetection(a, b) {
    return a.x < b.x + b.width &&
        a.x + a.width > b.x &&
        a.y < b.y + b.height &&
        a.y + a.height > b.y;
}


function isCenteredOnGrid(entity) {
    return (
        Math.round(entity.x) % tileSize === 0 &&
        Math.round(entity.y) % tileSize === 0
    );
}

function willHitWallNextTurn(entity, direction) {
    let testVelX = 0;
    let testVelY = 0;
    if (direction === 'U') testVelY = -tileSize / speed;
    if (direction === 'D') testVelY = tileSize / speed;
    if (direction === 'L') testVelX = -tileSize / speed;
    if (direction === 'R') testVelX = tileSize / speed;
    entity.x += testVelX;
    entity.y += testVelY;
    let hitWall = false;
    for (let wall of walls.values()) {
        if (collisionDetection(entity, wall)) {
            hitWall = true;
            break;
        }
    }

    entity.x -= testVelX;
    entity.y -= testVelY;

    return hitWall;
}


function move() {
    if (isCenteredOnGrid(pacman) && moving ===  true && started === true) {
            playSound("Assets/back.mp3");        
    }
    
    
    if (!willHitWallNextTurn (pacman, pacman.nextDirection) && pacman.x > 0) { 
            pacman.updateDirection(pacman.nextDirection);
        }
    pacman.x += pacman.velocityX;
    pacman.y += pacman.velocityY;
    for (wall of walls) {
    }    
    
    
    let collided = false;

    for (let wall of walls.values()) {
        if (collisionDetection(pacman, wall)) {
            pacman.x -= pacman.velocityX;
            pacman.y -= pacman.velocityY;
            collided = true;
            break;
        }
    }
    
    

    moving = !collided;
    
    if (pacman.x < -32) {
        pacman.x = 608
    }
    if (pacman.x > 608) {
        pacman.x = -32
    }
    if (pacman.direction == 'U') {
        pacman.image = pacmanUpImage;
    }
    if (pacman.direction == 'D') {
        pacman.image = pacmanDownImage;
    }
    if (pacman.direction == 'L') {
        pacman.image = pacmanLeftImage;
    }
    if (pacman.direction == 'R') {
        pacman.image = pacmanRightImage;
    }
}

function removeObjects() {
    for (let food of foods) {
        if (collisionDetection(food, pacman)) {
            foods.delete(food)
            points += 10;
            playSound("Assets/dot.mp3");
        }
    }

    for (let powerPellet of powerPellets) {
        if (collisionDetection(powerPellet, pacman)) {
            powerPellets.delete(powerPellet)
            points += 50;
            playSound("Assets/frightened.mp3");
            poweredUp = true;
            powerUpLength = 6000;
            playSound("Assets/bonus.mp3");
            setTimeout(function(){
            poweredUp = false;
            }, powerUpLength)
        }
    }
    for (let ghost of ghosts) {
        if (collisionDetection(ghost, pacman) && poweredUp == true) {
            ghosts.delete(ghost)
            points += 200;
        }
        else if (collisionDetection(ghost, pacman) && poweredUp == false) {
            playSound("Assets/dead.mp3");
            pacman.x = pacman.startX;
            pacman.y = 480;
            lives -= 1;
            if (lives == 0) {
                alert("Game Over! Your final score is: " + points);
                points = 0;
                lives = 3;
                loadMap();
                started = false;
            }
        }
    }
    
}



class Block {
    constructor(image, x, y, width, height) {
        this.image = image;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;

        this.startX = x;
        this.startY = x;

        this.direction = '';
        this.nextDirection = '';
        this.velocityX = 0;
        this.velocityY = 0;
    }
    
    updateDirection(direction) {
        this.direction = direction;
        this.updateVelocity();
        for (let wall of walls.values()) {
            if (collisionDetection(this, wall)) {
                this.x -= this.velocityX;
                this.y -= this.velocityY;

            }
        }
    }

    

    updateVelocity() {
        if (this.direction == 'U') {
            this.velocityX = 0;
            this.velocityY = -tileSize / speed;
        }
        else if (this.direction == 'D') {
            this.velocityX = 0;
            this.velocityY = tileSize / speed;
        }
        else if (this.direction == 'L') {
            this.velocityX = -tileSize / speed;
            this.velocityY = 0;

        }
        else if (this.direction == 'R') {
            this.velocityX = tileSize / speed;
            this.velocityY = 0;
        }
    }
}
