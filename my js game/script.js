//board
let board;
let columnCount = 19;
let rowCount = 21;
const tileSize = 32;
const boardWidth = columnCount*tileSize;
const boardHeight = rowCount*tileSize;
let context;

//X = wal p = pac man

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

const tileMap = [
    "XXXXXXXXXXXXXXXXXXX",
    "X        X        X",
    "X XX XXX X XXX XX X",
    "X                 X",
    "X XX X XXXXX X XX X",
    "X    X       X    X",
    "XXXX XXXX XXXX XXXX",
    "OOOX X       X XOOO",
    "XXXX X XXrXX X XXXX",
    "O       bpo       O",
    "XXXX X XXXXX X XXXX",
    "OOOX X       X XOOO",
    "XXXX X XXXXX X XXXX",
    "X        X        X",
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
const ghosts = new Set();
let pacman;

window.onload = function() {
    board = document.getElementById('board');
    board.height = boardHeight;
    board.width = boardWidth;
    context = board.getContext('2d')

    loadImages();
    loadMap();
    update();
    document.addEventListener('keyup', movePacman)
    console.log(ghosts.size);
    console.log(walls.size);
    console.log(foods.size);
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

    pacmanDownImage = new Image();
    pacmanDownImage.src = 'Assets/pacmanDown.png'; 
    pacmanUpImage = new Image();
    pacmanUpImage.src = 'Assets/pacmanUp.png';
    pacmanRightImage = new Image();
    pacmanRightImage.src = 'Assets/pacmanRight.png';
}

function loadMap() {
    walls.clear();
    foods.clear();
    ghosts.clear();

    for (let r = 0; r < rowCount; r++) {
        for(let c = 0; c < columnCount; c++) {
            const row = tileMap[r];
            const tileMapChar = row[c];

            const x = c*tileSize;
            const y = r*tileSize;

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
            else if(tileMapChar == ' ') {
                const food = new Block(null, x + 14, y + 14, 4, 4);
                foods.add(food);
            }
            
        }
    }
}

function update() {
    move();
    draw();
    setTimeout(update, 50);
    
}

function draw() {
    context.clearRect(0, 0, board.width, board.height);
    context.drawImage(pacman.image, pacman.x, pacman.y, pacman.width, pacman.height);
    for(let ghost of ghosts.values()) {
    context.drawImage(ghost.image, ghost.x, ghost.y, ghost.width, ghost.height);
    }
    for(let wall of walls.values()) {
    context.drawImage(wall.image, wall.x, wall.y, wall.width, wall.height);
    }
    context.fillStyle = 'white'
    for(let food of foods.values()) {
    context.fillRect(food.x, food.y, food.width, food.height)
    }
}

function movePacman(e) {
    if (e.code == "ArrowUp" || e.code == 'KeyW' ) {
        pacman.updateDirection('U')
    }
    else if (e.code == "ArrowDown" || e.code == 'KeyS' ) {
        pacman.updateDirection('D')
    }
    else if (e.code == "ArrowLeft" || e.code == 'KeyA' ) {
        pacman.updateDirection('L')
    }
    else if (e.code == "ArrowRight" || e.code == 'KeyD' ) {
        pacman.updateDirection('R')
    }
}

function move() {
    pacman.x += pacman.velocityX;
    pacman.y += pacman.velocityY;
}

class Block {
    constructor(image, x, y, width, height) {
        this.image = image;
        this.x = x;
        this.y = y;
        this. width = width;
        this.height = height;

        this.startX = x;
        this.startY = x;

        this.direction = 'R';
        this.velocityX = 0;
        this.velocityY = 0;
    }
    updateDirection(direction) {
        this.direction = direction;
        this.updateVelocity();
    }


    updateVelocity() {
        if (this.direction == 'U') {
            this.velocityX = 0;
            this.velocityY = -tileSize/4;
        }
        else if (this.direction == 'D') {
            this.velocityX = 0;
            this.velocityY = tileSize/4;
        }
            else if (this.direction == 'L') {
            this.velocityX = -tileSize/4;
            this.velocityY = 0;
        }
            else if (this.direction == 'R') {
            this.velocityX = tileSize/4;
            this.velocityY = 0;
        }
    }
}
