const openPackButton = document.getElementById("openPackButton");
const videoContainer = document.getElementById("videoContainer");
const packVideo = document.getElementById("packVideo");
const cardContainer = document.getElementById("cardContainer");
const cardImage = document.getElementById("cardImage");
const cardTitle = document.getElementById("cardTitle");
const cardDetails = document.getElementById("cardDetails");

// Card data
const cards = [
    {
        file: "87_ed_reed_gold.png",
        typeVideo: "Assets/gold.mp4"
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

openPackButton.addEventListener("click", () => {
    // Disable the button when opening a pack
    toggleButton(false);

    // Play the pack opening video
    playVideo("Assets/pack.mp4", () => {
        // Choose a random card
        const randomCard = parsedCards[Math.floor(Math.random() * parsedCards.length)];
        // Play the type video
        playVideo(randomCard.typeVideo, () => {
            // Display the card
            displayCard(randomCard);
            // Re-enable the button after everything is done
            toggleButton(true);
        });
    });
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
}
