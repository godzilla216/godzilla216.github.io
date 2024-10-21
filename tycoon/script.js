const names = ['Tom', 'Jerry', 'Peter', 'Alice', 'Bob', 'Eve', 'Charlie', 'Olivia', 'Max', 'Quandale', 'Luna'];

let day = 1;
let owner = "You";
let accountBalance = 10000;
let draftedPlayers = [];
let extraRationsActive = false;
let foremanActive = false;

const dayDisplay = document.getElementById('day');
const ownerDisplay = document.getElementById('owner');
const accountDisplay = document.getElementById('account');
const draftButton = document.getElementById('draftButton');
const workButton = document.getElementById('workButton');
const breakButton = document.getElementById('breakButton');
const extraRationsButton = document.getElementById('extraRationsButton');
const foremanButton = document.getElementById('foremanButton');
const ironMikeButton = document.getElementById('ironMikeButton');
const sabrinButton = document.getElementById('sabrin');
const fireForemanButton = document.getElementById('fireForemanButton');
const draftedList = document.getElementById('draftedList');
const popup = document.getElementById('popup');
const slaveCountDisplay = document.getElementById('slaveCount');

let slaveCount = 0;

function updateSlaveCount() {
  slaveCountDisplay.textContent = `Slaves: ${slaveCount} out of 15`;
}

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function getRandomName() {
  return names[Math.floor(Math.random() * names.length)];
}

function deductCost(cost) {
  if (accountBalance >= cost) {
    accountBalance -= cost;
    accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
    return true;
  } else {
    return false;
  }
}

function checkMortality() {
  draftedPlayers.forEach((player, index) => {
    player.health -= Math.floor(Math.random() * 10);
    if (player.health <= 0) {
      accountBalance -= 2000; // Penalty for death
      draftedPlayers.splice(index, 1);
      const playerItem = draftedList.querySelectorAll('li')[index];
      playerItem.remove();
      showPopup(`${player.name} died from poor health. Penalty: $2000.`);
      updateSlaveCount();
    } else {
      const playerItem = draftedList.querySelectorAll('li')[index];
      const healthBar = playerItem.querySelector('.health-bar');
      healthBar.style.width = `${player.health}%`;
    }
  });
}

function restPlayers() {
  draftedPlayers.forEach((player) => {
    player.health = Math.min(player.health + 5, 100);
  });
}

function showPopup(message) {
  popup.textContent = message;
  popup.style.display = 'block';
  setTimeout(() => { popup.style.display = 'none'; }, 2000);
}

function saveGame() {
  const gameState = { day, owner, accountBalance, draftedPlayers, extraRationsActive, foremanActive, slaveCount };
  localStorage.setItem('gameState', JSON.stringify(gameState));
}

function loadGame() {
  const savedState = localStorage.getItem('gameState');
  if (savedState) {
    const gameState = JSON.parse(savedState);
    day = gameState.day;
    owner = gameState.owner;
    accountBalance = gameState.accountBalance;
    draftedPlayers = gameState.draftedPlayers;
    extraRationsActive = gameState.extraRationsActive;
    foremanActive = gameState.foremanActive;
    slaveCount = gameState.slaveCount;
    updateDisplays();
  }
}

function updateDisplays() {
  dayDisplay.textContent = `Day: ${day}`;
  ownerDisplay.textContent = `Owner: ${owner}`;
  accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
  draftedList.innerHTML = ''; // Clear the list
  draftedPlayers.forEach(player => {
    const playerItem = document.createElement('li');
    playerItem.textContent = `${player.name} - Health: ${player.health} `;
    const healthBar = document.createElement('div');
    healthBar.classList.add('health-bar', 'progress');
    healthBar.style.width = `${player.health}%`;
    playerItem.appendChild(healthBar);
    const freeButton = document.createElement('button');
    freeButton.classList.add('free-button');
    freeButton.textContent = 'Free';
    playerItem.appendChild(freeButton);
    draftedList.appendChild(playerItem);
    
    freeButton.addEventListener('click', () => {
      accountBalance += 250; // Gain $250 for freeing a slave
      accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
      draftedPlayers = draftedPlayers.filter(p => p.name !== player.name);
      playerItem.remove();
      slaveCount--;
      updateSlaveCount(); // Update slave count display
      showPopup(`You freed ${player.name} and received $250.`);
      saveGame(); // Save after freeing a slave
    });
  });
  updateSlaveCount();
}

// Load game when the page is opened
loadGame();

draftButton.addEventListener('click', () => {
  if (draftedPlayers.length < 15) {
    const playerCost = Math.floor(Math.random() * 2000) + 1;
    if (deductCost(playerCost)) {
      const playerName = getRandomName();
      draftedPlayers.push({ name: playerName, health: 100 });
      slaveCount++;
      updateDisplays();
      scrollToTop();
      saveGame(); // Save after drafting
    } else {
      showPopup("You do not have enough funds.");
    }
  } else {
    showPopup("You have reached the maximum limit of 15 slaves.");
  }
});

workButton.addEventListener('click', () => {
  showPopup("Working...");
  workButton.disabled = true;
  setTimeout(() => {
    let earningPerSlave = Math.floor(Math.random() * 1000) + 1;
    if (extraRationsActive) {
      earningPerSlave *= 1.5; // Increase earnings by 50%
      extraRationsActive = false; // Reset after use
    }

    if (foremanActive) {
      earningPerSlave *= 1.9; // Increase earnings by 90%
      draftedPlayers.forEach((player) => {
        player.health -= Math.floor(player.health * 0.05); // Deduct health
      });
    }

    draftedPlayers.forEach((player) => {
      accountBalance += earningPerSlave;
    });

    accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
    checkMortality();
    workButton.disabled = false;
    saveGame(); // Save after work
  }, 2000);
});

breakButton.addEventListener('click', () => {
  restPlayers();
  showPopup("Your slaves have earned a break and gained extra health.");
  day++;
  updateDisplays();
  saveGame(); // Save after break
});

extraRationsButton.addEventListener('click', () => {
  if (deductCost(1500)) {
    extraRationsActive = true;
    showPopup("Extra rations provided. Slaves will work at increased rates for 1 day.");
    saveGame(); // Save after using extra rations
  } else {
    showPopup("You do not have enough funds to provide extra rations.");
  }
});

foremanButton.addEventListener('click', () => {
  if (deductCost(3000)) {
    foremanActive = true;
    showPopup("Foreman hired. Total production increased by 90%.");
    saveGame(); // Save after hiring foreman
  } else {
    showPopup("You do not have enough funds to hire a foreman.");
  }
});

ironMikeButton.addEventListener('click', () => {
  if (deductCost(500000)) {
    draftedPlayers.push({ name: 'Mike Tyson', health: 7000 });
    showPopup("You now have Mike Tyson on your team!");
    updateDisplays();
    saveGame(); // Save after hiring Iron Mike
  } else {
    showPopup("You do not have enough funds to get Iron Mike.");
  }
});

sabrinButton.addEventListener('click', () => {
  if (deductCost(600000)) {
    draftedPlayers.push({ name: 'sabrin', health: 9000 });
    showPopup("You now have sabrin on your team!");
    updateDisplays();
    saveGame(); // Save after hiring sabrin
  } else {
    showPopup("You do not have enough funds to get sabrin.");
  }
});
