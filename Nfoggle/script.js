const playerText = document.getElementById("playerText");
const hintCountText = document.getElementById("hintCount");
const hintButton = document.getElementById("hint");
const guess = document.getElementById("guess")
const scoreText = document.getElementById("score")
let teamImage = document.getElementById("nflTeam");
let collegeTeamImage = document.getElementById("collegeTeam");
let headshot = document.getElementById("headshot")
let hintCount = 0;
let url;
let drafted;
let playerName;
let currentPrompt;
let teamUrl;
let teamName;
let teamLogoUrl;
let score = 0;

document.addEventListener("keydown", function (event) {
    if (event.key === "Enter" && document.activeElement !== hintButton) {
        guessPlayer();
    }
});

function showHint() {
    hintCount++;
    hint();
    hintButton.innerHTML = "Hint";
    hintCountText.innerHTML = "You have used " + hintCount + " hints";
    if (hintCount > 10) {
        hintButton.disabled = true
    }
}

async function loadData() {
    try {
        const response = await fetch("./athletes.json");

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        let playerIndex = Math.floor(Math.random() * 100);
        const data = await response.json();
        let player = data.items[playerIndex];
        console.log(player);

        url = httpsUrl(player.$ref);

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
                currentPrompt = currentPrompt + "<br>" + "Your player was born in " + data.birthPlace.city + ", " + data.birthPlace.state + ", " + data.birthPlace.country;
                playerText.innerHTML = currentPrompt;
            }
            if (hintCount === 5) {
                currentPrompt = currentPrompt + "<br>" + "Your player wears number " + data.jersey;
                playerText.innerHTML = currentPrompt
            }
            if (hintCount === 6) {
                fetch(httpsUrl(data.college.$ref))
                    .then(response => response.json())
                    .then(collegeData => {
                        console.log(collegeData.$ref);
                        currentPrompt = currentPrompt + "<br>" + "Your player went to " + collegeData.name;
                        playerText.innerHTML = currentPrompt;
                        collegeTeamImage.src = httpsUrl(collegeData.logos[0].href);
                        console.log(collegeData.logos);
                    })
                    .catch(error => {
                        console.error('Fetch failed:', error);
                    });
                playerText.innerHTML = currentPrompt;
            }
            if (hintCount === 7) {
                if (data.status.type === "free-agent") {
                    currentPrompt = currentPrompt + "<br>" + "Your player is a free agent";                
                    teamImage.src = "freeAgent.png";
                    playerText.innerHTML = currentPrompt;
                }
                else {
                    teamUrl = data.team.$ref;
                    teamName = await getTeamInfo(teamUrl, "name");
                    teamLogoUrl = await getTeamInfo(teamUrl, "logo");
                    currentPrompt = currentPrompt + "<br>" + "Your player plays for the " + teamName;
                    teamImage.src = teamLogoUrl;
                    console.log(teamLogoUrl);
                    playerText.innerHTML = currentPrompt;
                }
            }
            if (hintCount === 8) {
                console.log(data.headshot.href)
                currentPrompt = currentPrompt + "<br>" + "This is your players headshot"
                playerText.innerHTML = currentPrompt;
                headshot.src = httpsUrl(data.headshot.href);
            }
            if (hintCount === 9) {
                currentPrompt = currentPrompt + "<br>" + "Your player is " + inToFt(data.height) + " tall" + " and weighs " + data.weight + " pounds";
                playerText.innerHTML = currentPrompt
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
        score = score + 1000 - (hintCount * 75);
        window.alert('Correct! your score is ' + score);
        scoreText.innerHTML = 'Your score is ' + score;
        currentPrompt = "Click start to begin!";
        playerText.innerHTML = currentPrompt    
        hintCount = 0;  
        hintCountText.innerHTML = "You have used " + hintCount + " hints";  
        teamImage.src = "questionMark.png";
        collegeTeamImage.src = "questionMark.png";
        headshot.src = "emptyHeadshot.png";
        hintButton.disabled = false
        hintButton.innerHTML = "Start Game!";
        loadData();
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

async function getTeamInfo(teamUrl, type) {
    try {
        const response = await fetch(httpsUrl(teamUrl));

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const data = await response.json();

        console.log(data);
        console.log(data.displayName);

        if (type === "name") {
            return data.displayName;
        } else if (type === "logo") {
            return httpsUrl(data.logos[0].href);
        }
    }
    catch (error) {
        console.error('Fetch failed:', error);
    }
}

//prevent mixed content
function httpsUrl(url) {
    return url?.replace(/^http:/, "https:");
}
