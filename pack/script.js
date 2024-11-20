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

const packCost = 1000;
let coins = 10000; // Starting coins
let ownedCards = [];

// Card data
const cards = [
    {
        file: "87_ed_reed_gold.png",
        file: "84_Boogie_Basham_genki_force.png"
    }
];

// Parse card details from file names
const parsedCards = cards.map(card => {
    const [overall, firstName, lastName, type] = card.file.replace(".png", "").split("_");
    return {
        name: `${overall} ${firstName} ${lastName} ${type}`,
        typeVideo: card.typeVideo,
        image: `Assets/cards/${card.file}`
    };
});

// Function to disable the button
function toggleButton(state) {
    openPackButton.disabled = !state;
    openPackButton.style.opacity = state ? "1" : "0.5";
    openPackButton.style.cursor = state ? "pointer" : "not-allowed";
}

function updateCoinDisplay() {
    coinBalanceElement.textContent = `Coins: ${coins}`;
}

openPackButton.addEventListener("click", () => {
    // Check if the user has enough coins
    if (coins >= packCost) {
        // Deduct the cost of the pack
        coins -= packCost;
        updateCoinDisplay();

        // Disable the button while the pack is opening
        toggleButton(false);

        // Play the pack opening video
        playVideo("Assets/pack.mp4", () => {
            // Choose a random card
            const randomCard = parsedCards[Math.floor(Math.random() * parsedCards.length)];
            
            // Check if the card's type video is "gold.mp4" and skip if true
            if (randomCard.typeVideo.includes("gold.mp4")) {
                console.log("Skipped playing gold.mp4");
                displayCard(randomCard); // Directly display the card
                toggleButton(true); // Re-enable the button
            } else {
                // Play the type video
                playVideo(randomCard.typeVideo, () => {
                    // Display the card
                    displayCard(randomCard);
                    // Re-enable the button after everything is done
                    toggleButton(true);
                });
            }
        });
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

function displayCard(card) {
    cardImage.src = card.image;
    cardTitle.textContent = card.name;
    cardDetails.textContent = `You pulled a card: ${card.name}`;
    cardContainer.style.display = "block";
    cardContainer.classList.add("show");

    // Show the quicksell or add to binder options
    const actionButton = document.createElement("button");
    actionButton.textContent = "Add to Binder";
    actionButton.addEventListener("click", () => {
        addToBinder(card);
        cardContainer.style.display = "none"; // Hide card after adding it
    });

    const quicksellButton = document.createElement("button");
    quicksellButton.classList.add("quicksell");
    quicksellButton.textContent = "Quick Sell (3000 Coins)";
    quicksellButton.addEventListener("click", () => {
        quicksellCard(card);
        cardContainer.style.display = "none"; // Hide card after quicksell
    });

    cardDetails.appendChild(actionButton);
    cardDetails.appendChild(quicksellButton);
}

function addToBinder(card) {
    ownedCards.push(card);
    updateBinder();
}

function quicksellCard(card) {
    // Remove the card from ownedCards
    const cardIndex = ownedCards.indexOf(card);
    if (cardIndex !== -1) {
        ownedCards.splice(cardIndex, 1); // Remove the card from the array
    }
    coins += 3000;
    updateCoinDisplay();
    alert(`You quicksold ${card.name} for 3000 coins!`);
    updateBinder(); // Update the binder display
}

function updateBinder() {
    binderContainer.innerHTML = ''; // Clear current binder

    ownedCards.forEach((card, index) => {
        const cardDiv = document.createElement("div");
        cardDiv.classList.add("card");

        const img = document.createElement("img");
        img.src = card.image;

        const cardName = document.createElement("div");
        cardName.textContent = card.name;

        const quicksellButton = document.createElement("button");
        quicksellButton.classList.add("quicksell");
        quicksellButton.textContent = "Quick Sell (3000 Coins)";
        quicksellButton.addEventListener("click", () => {
            quicksellCard(card); // Remove card and update binder
        });

        cardDiv.appendChild(img);
        cardDiv.appendChild(cardName);
        cardDiv.appendChild(quicksellButton);

        binderContainer.appendChild(cardDiv);
    });
}

openPackTab.addEventListener("click", () => {
    openPackSection.style.display = "block";
    binderSection.style.display = "none";
});

binderTab.addEventListener("click", () => {
    openPackSection.style.display = "none";
    binderSection.style.display = "block";
});
