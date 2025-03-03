// Elements
const openPackButton = document.getElementById("openPackButton");
const videoContainer = document.getElementById("videoContainer");
const packVideo = document.getElementById("packVideo");
const cardContainer = document.getElementById("cardContainer");
const cardImage = document.getElementById("cardImage");
const cardTitle = document.getElementById("cardTitle");
const cardDetails = document.getElementById("cardDetails");
const coinBalanceElement = document.getElementById("coinBalance");
const binderContainer = document.getElementById("binderContainer");

const openPackTab = document.getElementById("openPackTab");
const binderTab = document.getElementById("binderTab");
const openPackSection = document.getElementById("openPackSection");
const binderSection = document.getElementById("binderSection");

// Configuration
const packCost = 1000;
let coins = 10000;
let ownedCards = [];

// Exponential Quicksell Configuration
const baseValue = 100;
const multiplier = 1.05;
let cardPendingAction = false;

// Load card data from external JSON
fetch("list.json")
    .then(response => response.json())
    .then(cards => {
        const parsedCards = cards.map(file => {
            const fileName = file.replace(/-/g, "_").replace(".png", ""); 
            const [overall, firstName, lastName, type] = fileName.split("_");
            return {
                name: `${overall} ${firstName} ${lastName} ${type}`,
                overall: parseInt(overall),
                typeVideo: "Assets/gold.mp4",
                image: `Assets/cards/${file}`,
            };
        });
        window.parsedCards = parsedCards;
    })
    .catch(error => console.error("Error loading card data:", error));

// Utility Functions
function toggleButton(state) {
    openPackButton.disabled = !state;
    openPackButton.style.opacity = state ? "1" : "0.5";
    openPackButton.style.cursor = state ? "pointer" : "not-allowed";
}

function updateCoinDisplay() {
    coinBalanceElement.textContent = `Coins: ${coins}`;
}

function calculateQuicksellValue(overall) {
    return Math.floor(baseValue * Math.pow(multiplier, overall));
}

function getRandomCard() {
    const weights = window.parsedCards.map(card => 1 / card.overall);
    const totalWeight = weights.reduce((a, b) => a + b, 0);
    const cumulativeWeights = [];
    weights.reduce((acc, weight, index) => {
        cumulativeWeights[index] = acc + weight / totalWeight;
        return cumulativeWeights[index];
    }, 0);
    const random = Math.random();
    const selectedIndex = cumulativeWeights.findIndex(cumWeight => random < cumWeight);
    return window.parsedCards[selectedIndex];
}

// Pack Opening Logic
openPackButton.addEventListener("click", () => {
    if (coins >= packCost && !cardPendingAction) {
        coins -= packCost;
        updateCoinDisplay();
        toggleButton(false);
        playVideo("Assets/pack.mp4", () => {
            const randomCard = getRandomCard();
            if (randomCard.typeVideo.includes("gold.mp4")) {
                displayCard(randomCard);
            } else {
                playVideo(randomCard.typeVideo, () => {
                    displayCard(randomCard);
                });
            }
            cardPendingAction = true;
        });
    } else {
        alert(cardPendingAction ? "You must act on your current card before opening another pack!" : "You don't have enough coins to open a pack!");
    }
});

function playVideo(videoSrc, callback) {
    videoContainer.style.display = "block";
    packVideo.src = videoSrc;
    packVideo.onended = () => {
        videoContainer.style.display = "none";
        callback();
    };
    packVideo.play();
}

function displayCard(card) {
    const quicksellValue = calculateQuicksellValue(card.overall);
    cardImage.src = card.image;
    cardTitle.textContent = card.name;
    cardDetails.innerHTML = `You pulled a card: ${card.name}`;

    const actionButton = document.createElement("button");
    actionButton.textContent = "Add to Binder";
    actionButton.classList.add("add-to-binder-btn"); 
    actionButton.addEventListener("click", () => {
        addToBinder(card);
        cardContainer.style.display = "none";
        cardPendingAction = false;
        toggleButton(true);
    });

const quicksellButton = document.createElement("button");
quicksellButton.textContent = `Quick Sell (${quicksellValue} Coins)`;
quicksellButton.classList.add("quicksell-btn"); // Ensure class is added

console.log("Quicksell Button Classes:", quicksellButton.classList); // Debugging

quicksellButton.addEventListener("click", () => {
    quicksellCard(card, quicksellValue);
    cardContainer.style.display = "none";
    cardPendingAction = false;
    toggleButton(true);
});

    cardDetails.appendChild(actionButton);
    cardDetails.appendChild(quicksellButton);
    cardContainer.style.display = "block";
}

function quicksellCard(card, quicksellValue) {
    coins += quicksellValue;
    updateCoinDisplay();
    alert(`You quicksold ${card.name} for ${quicksellValue} coins!`);
    updateBinder();
}

function addToBinder(card) {
    ownedCards.push(card);
    updateBinder();
}

function updateBinder() {
    binderContainer.innerHTML = "";
    ownedCards.forEach((card, index) => {
        const cardDiv = document.createElement("div");
        cardDiv.classList.add("card");

        const img = document.createElement("img");
        img.src = card.image;

        const cardName = document.createElement("div");
        cardName.textContent = card.name;

        // Create Quicksell Button
        const quicksellValue = calculateQuicksellValue(card.overall);
        const quicksellButton = document.createElement("button");
        quicksellButton.textContent = `Quicksell (${quicksellValue} Coins)`;
        quicksellButton.addEventListener("click", () => {
            quicksellCard(card, quicksellValue);
            ownedCards.splice(index, 1); // Remove card from binder
            updateBinder(); // Refresh binder display
        });

        // Append elements
        cardDiv.appendChild(img);
        cardDiv.appendChild(cardName);
        cardDiv.appendChild(quicksellButton);
        binderContainer.appendChild(cardDiv);
    });
}


openPackTab.addEventListener("click", () => {
    openPackSection.style.display = "block";
    binderSection.style.display = "none";
    openPackTab.classList.add("active");
    binderTab.classList.remove("active");
});

binderTab.addEventListener("click", () => {
    openPackSection.style.display = "none";
    binderSection.style.display = "block";
    openPackTab.classList.remove("active");
    binderTab.classList.add("active");
});

updateCoinDisplay();
