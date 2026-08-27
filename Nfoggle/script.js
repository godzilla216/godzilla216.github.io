const playerText = document.getElementById("playerText");
const hintCountText = document.getElementById("hintCount");
const hintButton = document.getElementById("hint");
const guess = document.getElementById("guess")
let hintCount = 0;
let url;
let drafted;
let playerName;
let currentPrompt;
let teamUrl;
let teamName;

function showHint() {
    hintCount++;
    hint();
    hintButton.innerHTML = "Hint";
    hintCountText.innerHTML = "You have used " + hintCount + " hints";
}

async function loadData() {
    try {
        const response = await fetch("./athletes.json");

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        let playerIndex = Math.floor(Math.random() * 1001);
        const data = await response.json();
        let player = data.items[playerIndex];
        console.log(player);

        url = player.$ref;

    } catch (error) {
        console.error("Failed to load JSON:", error);
    }
}

loadData();

function hint() {
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(async data => {
            playerName = data.fullName.toUpperCase()
            if (hintCount === 1) {
                console.log(data);
                console.log(hintCount)
                if (data.experience.years === 0) {
                    ;
                    currentPrompt = "Your player is " + data.age + " years old" + " and is a rookie";
                    playerText.innerHTML = currentPrompt;
                }
                else {
                    currentPrompt = "Your player is " + data.age + " years old" + " and has played in the league for " + data.experience.years + " years";
                    playerText.innerHTML = currentPrompt;
                }
            }
            if (hintCount === 2) {
                console.log(data);
                console.log(hintCount);
                //have to keep as == for some reason or it breaks
                if (data.draft == null) {
                    currentPrompt = currentPrompt + "<br>" + "Your player was undrafted";
                    playerText.innerHTML = currentPrompt;
                    drafted = false;
                }
                else {
                    currentPrompt = currentPrompt + "<br>" + "Your player was drafted in " + data.draft.displayText;
                    playerText.innerHTML = currentPrompt;
                    drafted = true;
                }
            }
            if (hintCount === 3) {
                currentPrompt = currentPrompt + "<br>" + "Your player is a " + data.position.name;
                playerText.innerHTML = currentPrompt
            }
            if (hintCount === 4) {
                currentPrompt = currentPrompt + "<br>" + "Your player was born in " + data.birthPlace.city + ", " + data.birthPlace.country;
                playerText.innerHTML = currentPrompt;
            }
            if (hintCount === 5) {
                currentPrompt = currentPrompt + "<br>" + "Your player wears number " + data.jersey;
                playerText.innerHTML = currentPrompt
            }
            if (hintCount === 6) {
                currentPrompt = currentPrompt + "<br>" + "Your player is " + inToFt(data.height) + " tall" + " and weighs " + data.weight + " pounds";
                playerText.innerHTML = currentPrompt
            }
            if (hintCount === 7) {
                if (data.status.type === "free-agent") {
                    currentPrompt = currentPrompt + "<br>" + "Your player is a free agent";
                    playerText.innerHTML = currentPrompt;
                }
                else {
                    teamUrl = data.team.$ref;
                    getTeamInfo(teamUrl)
                    teamName = await getTeamInfo(teamUrl);
                    currentPrompt = currentPrompt + "<br>" + "Your player plays for the " + teamName;

                    playerText.innerHTML = currentPrompt;
                }
            }
        })
        .catch(error => {
            console.error('Fetch failed:', error);
        });
}

function guessPlayer() {
    console.log(playerName)
    console.log(guess.value)
    if (guess.value.toUpperCase() == playerName) {
        window.alert('Correct!')
    }
    else {
        window.alert('Incorrect')
    }
}

function inToFt(inches) {
    let feet = Math.floor(inches / 12);
    let remainingInches = inches % 12;
    return `${feet}'${remainingInches}"`;
}

async function getTeamInfo(teamUrl) {
    try {
        const response = await fetch(teamUrl);

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const data = await response.json();

        console.log(data);
        console.log(data.displayName);

        return data.displayName;
    }
    catch (error) {
        console.error('Fetch failed:', error);
    }
}
