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
let coins = 10000; // Starting coins
let ownedCards = [];

// Exponential Quicksell Configuration
const baseValue = 100; // Base quicksell value
const multiplier = 1.05; // Exponential growth rate per OVR
let cardPendingAction = false; // Tracks if there's a card awaiting action

// Card data
const cards = [
    {
        file: "87_ed_reed_gold.png",
        typeVideo: "Assets/gold.mp4",
    },
    {
        file: "84_Boogie_Basham_genki_force.png",
        typeVideo: "Assets/gold.mp4",
    },
    {
        file: "94_Harold_landryIII_rare.png",
        typeVideo: "Assets/gold.mp4",
    },
    {
        file: "99-Patrick-Manomes-Rare.png",
        typeVideo: "Assets/gold.mp4",
    },
];

// Parse card details from file names
const parsedCards = cards.map(card => {
    // Replace hyphens with underscores for consistency
    const fileName = card.file.replace(/-/g, "_").replace(".png", "");
    const [overall, firstName, lastName, type] = fileName.split("_");

    return {
        name: `${overall} ${firstName} ${lastName} ${type}`,
        overall: parseInt(overall), // Extract the OVR as a number
        typeVideo: card.typeVideo,
        image: `Assets/cards/${card.file}`,
    };
});

// Utility Functions
function toggleButton(state) {
    openPackButton.disabled = !state;
    openPackButton.style.opacity = state ? "1" : "0.5";
    openPackButton.style.cursor = state ? "pointer" : "not-allowed";
}

function updateCoinDisplay() {
    coinBalanceElement.textContent = `Coins: ${coins}`;
}

// Calculate quicksell value exponentially
function calculateQuicksellValue(overall) {
    return Math.floor(baseValue * Math.pow(multiplier, overall));
}

// Weighted Random Card Selection
function getRandomCard() {
    // Calculate weights (higher weight for lower OVR)
    const weights = parsedCards.map(card => 1 / card.overall);
    const totalWeight = weights.reduce((a, b) => a + b, 0);

    // Create cumulative distribution
    const cumulativeWeights = [];
    weights.reduce((acc, weight, index) => {
        cumulativeWeights[index] = acc + weight / totalWeight;
        return cumulativeWeights[index];
    }, 0);

    // Generate a random number and find the corresponding card
    const random = Math.random();
    const selectedIndex = cumulativeWeights.findIndex(cumWeight => random < cumWeight);

    return parsedCards[selectedIndex];
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
            cardPendingAction = true; // Mark that the user must act on this card
        });
    } else if (cardPendingAction) {
        alert("You must act on your current card before opening another pack!");
    } else {
        alert("You don't have enough coins to open a pack!");
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

// Card Display and Actions
function displayCard(card) {
    const overall = card.overall;
    const quicksellValue = calculateQuicksellValue(overall);

    cardImage.src = card.image;
    cardTitle.textContent = card.name;
    cardDetails.textContent = `You pulled a card: ${card.name}`;

    const actionButton = document.createElement("button");
    actionButton.textContent = "Add to Binder";
    actionButton.addEventListener("click", () => {
        addToBinder(card);
        cardContainer.style.display = "none";
        cardPendingAction = false; // User has acted on the card
        toggleButton(true);
    });

    const quicksellButton = document.createElement("button");
    quicksellButton.classList.add("quicksell");
    quicksellButton.textContent = `Quick Sell (${quicksellValue} Coins)`;
    quicksellButton.addEventListener("click", () => {
        quicksellCard(card, quicksellValue);
        cardContainer.style.display = "none";
        cardPendingAction = false; // User has acted on the card
        toggleButton(true);
    });

    cardDetails.innerHTML = ""; // Clear previous content
    cardDetails.appendChild(actionButton);
    cardDetails.appendChild(quicksellButton);

    cardContainer.style.display = "block";
    cardContainer.classList.add("show");
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

// Binder Management
function updateBinder() {
    binderContainer.innerHTML = "";

    ownedCards.forEach(card => {
        const overall = card.overall;
        const quicksellValue = calculateQuicksellValue(overall);

        const cardDiv = document.createElement("div");
        cardDiv.classList.add("card");

        const img = document.createElement("img");
        img.src = card.image;

        const cardName = document.createElement("div");
        cardName.textContent = card.name;

        const quicksellButton = document.createElement("button");
        quicksellButton.classList.add("quicksell");
        quicksellButton.textContent = `Quick Sell (${quicksellValue} Coins)`;
        quicksellButton.addEventListener("click", () => {
            quicksellCard(card, quicksellValue);
        });

        cardDiv.appendChild(img);
        cardDiv.appendChild(cardName);
        cardDiv.appendChild(quicksellButton);

        binderContainer.appendChild(cardDiv);
    });
}

// Tab Switching
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

// Initial Setup
updateCoinDisplay();
