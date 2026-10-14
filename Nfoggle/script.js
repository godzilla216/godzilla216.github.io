const playerText = document.getElementById("playerText");
const hintCountText = document.getElementById("hintCount");
const hintButton = document.getElementById("hint");
const guess = document.getElementById("guess")
const scoreText = document.getElementById("score")
// suggestions container for custom autocomplete
const suggestionsBox = document.getElementById("suggestions");
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
let names = []; 

// Image reveal helper: add 'reveal' class and remove after animation
function animateReveal(el) {
    if (!el) return;
    // remove any fadeout class
    el.classList.remove('fadeout');
    // force reflow to restart animation
    void el.offsetWidth;
    el.classList.add('reveal');
    function cleanup() {
        el.classList.remove('reveal');
        el.removeEventListener('animationend', cleanup);
    }
    el.addEventListener('animationend', cleanup);
}

// Parallax background movement
(function setupParallax() {
    const layers = document.querySelectorAll('.bg-3d .bg-layer');
    if (!layers || layers.length === 0) return;
    let mouseX = 0, mouseY = 0;
    let rx = 0, ry = 0;
    function onMove(e) {
        const w = window.innerWidth;
        const h = window.innerHeight;
        mouseX = (e.clientX - w/2) / (w/2);
        mouseY = (e.clientY - h/2) / (h/2);
    }
    window.addEventListener('mousemove', onMove);
    function frame() {
        // subtle smoothing
        rx += (mouseX - rx) * 0.08;
        ry += (mouseY - ry) * 0.08;
        // apply transforms with different intensities
        layers.forEach((layer, i) => {
            const depth = (i + 1) / layers.length; // 0..1
            const tx = rx * 18 * depth;
            const ty = ry * 12 * depth;
            layer.style.transform = `translate3d(${tx}px, ${ty}px, ${-120 + i*60}px) scale(${1 + 0.02*(1-depth)})`;
        });
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
})();


document.addEventListener("keydown", function (event) {
    if (event.key === "Enter" && document.activeElement !== hintButton) {
        guessPlayer();
    }
});

// Removed the old click handler that copied select -> input; using datalist lets the input receive selected value automatically.

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
        const data = await response.json();
        let playerIndex = Math.floor(Math.random() * data.items.length);
        let player = data.items[playerIndex];
        console.log(player);
        url = httpsUrl(player.$ref);
    } catch (error) {
        console.error("Failed to load JSON:", error);
    }

    fetch("./names.json")
        .then(response => response.json())
        .then(data => {
            names = data;
            console.log(names);
            // names array will be used by the custom autocomplete below
        })
        .catch(error => {
            console.error("Failed to load names:", error);
        });
}

loadData();

// Autocomplete behavior: show filtered suggestions under the guess input
guess.addEventListener('input', updateSuggestions);
guess.addEventListener('keydown', handleSuggestionKeys);
guess.addEventListener('blur', () => setTimeout(hideSuggestions, 150));

defaultMaxSuggestions = 8;

function updateSuggestions() {
    const q = guess.value.trim().toLowerCase();
    if (!q) { hideSuggestions(); return; }
    const matches = names.filter(n => n.toLowerCase().includes(q)).slice(0, defaultMaxSuggestions);
    renderSuggestions(matches);
}

function renderSuggestions(list) {
    suggestionsBox.innerHTML = '';
    if (!list || list.length === 0) { hideSuggestions(); return; }
    suggestionsBox.style.display = 'block';
    list.forEach(item => {
        const li = document.createElement('li');
        li.className = 'suggestion-item';
        li.setAttribute('role','option');
        li.textContent = item;
        li.addEventListener('mousedown', function (e) { // mousedown to select before blur
            e.preventDefault();
            guess.value = item;
            hideSuggestions();
        });
        suggestionsBox.appendChild(li);
    });
}

function hideSuggestions() {
    suggestionsBox.innerHTML = '';
    suggestionsBox.style.display = 'none';
}

function handleSuggestionKeys(e) {
    if (e.key === 'Enter') {
        // If there are suggestions, pick the first and let the Enter press submit the guess
        const first = suggestionsBox.querySelector('.suggestion-item');
        if (first) {
            guess.value = first.textContent;
            hideSuggestions();
            // allow existing keydown handler to call guessPlayer()
        }
    }
    // Basic arrow support: move focus into list items
    else if (e.key === 'ArrowDown') {
        const first = suggestionsBox.querySelector('.suggestion-item');
        if (first) { first.focus(); }
    }
}

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
                        // set image then animate reveal
                        collegeTeamImage.src = httpsUrl(collegeData.logos[0].href);
                        animateReveal(collegeTeamImage);
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
                animateReveal(teamImage);
                playerText.innerHTML = currentPrompt;
                }
                else {
                    teamUrl = data.team.$ref;
                    teamName = await getTeamInfo(teamUrl, "name");
                    teamLogoUrl = await getTeamInfo(teamUrl, "logo");
                    currentPrompt = currentPrompt + "<br>" + "Your player plays for the " + teamName;
                    teamImage.src = teamLogoUrl;
                    animateReveal(teamImage);
                    console.log(teamLogoUrl);
                    playerText.innerHTML = currentPrompt;
                }
            }
            if (hintCount === 8) {
                console.log(data.headshot.href)
                currentPrompt = currentPrompt + "<br>" + "This is your players headshot"
                playerText.innerHTML = currentPrompt;
                headshot.src = httpsUrl(data.headshot.href);
                animateReveal(headshot);
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
        // fade out current images before resetting to placeholders
        teamImage.classList.add('fadeout');
        collegeTeamImage.classList.add('fadeout');
        headshot.classList.add('fadeout');
        setTimeout(() => {
            teamImage.src = "questionMark.png";
            collegeTeamImage.src = "questionMark.png";
            headshot.src = "emptyHeadshot.png";
        }, 220);
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