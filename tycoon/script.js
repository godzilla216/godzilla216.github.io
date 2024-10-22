const names = ['Tom', 'Jerry', 'Peter', 'Alice', 'Bob', 'Eve', 'Charlie', 'Olivia', 'Max', 'Quandale', 'Luna'];

let day = 1;
let owner = "You";
let accountBalance = 10000;
let draftedPlayers = [];
let extraRationsActive = false;
let foremanActive = false;

const upgradeButton = document.getElementById('upgradeButton');
const dayDisplay = document.getElementById('day');
const accountDisplay = document.getElementById('account');
const draftButton = document.getElementById('draftButton');
const workButton = document.getElementById('workButton');
const breakButton = document.getElementById('breakButton');
const extraRationsButton = document.getElementById('extraRationsButton');
const foremanButton = document.getElementById('foremanButton');
const ironMikeButton = document.getElementById('ironMikeButton');
const sabrin = document.getElementById('sabrin');
const fireForemanButton = document.getElementById('fireForemanButton');
const draftedList = document.getElementById('draftedList');
const popup = document.getElementById('popup');
const slaveCountDisplay = document.getElementById('slaveCount');
const plantationUpgradeBar = document.getElementById('plantationUpgradeBar');

let slaveCount = 0;
let upgradeCount = 0;
const maxUpgrades = 4;
let maxSlaves = 15;

function updateSlaveCount() {
  slaveCountDisplay.textContent = `Slaves: ${slaveCount} out of ${maxSlaves}`;
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

function handleSlaveDeath(player, index) {
  accountBalance -= 2000; // Penalty for killing a slave
  accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
  draftedPlayers.splice(index, 1); // Remove the player from the drafted list
  slaveCount--; // Decrement slave count
  updateSlaveCount(); // Update the display for slave count

  const playerItem = draftedList.querySelectorAll('li')[index];
  playerItem.remove(); // Remove the player's display from the list
  showPopup(`${player.name} died from poor health. Penalty: $2000.`);
}

function checkMortality() {
  draftedPlayers.forEach((player, index) => {
    if (player.health > 100) {
      const healthOver100 = player.health - 100;
      player.moneyMultiplier = 1 + (healthOver100 * 0.15);
    } else {
      player.moneyMultiplier = 1;
    }

    player.health -= Math.floor(Math.random() * 10); // Decrease health randomly

    if (player.health <= 0) {
      handleSlaveDeath(player, index); // Call the new function for handling death
    } else {
      const playerItem = draftedList.querySelectorAll('li')[index];
      const healthBar = playerItem.querySelector('.health-bar');
      const healthPercentage = playerItem.querySelector('.health-percentage');
      healthBar.style.width = `${player.health}%`;
      healthPercentage.textContent = `${player.health}%`;
      
      if (player.health < 30) {
        healthBar.classList.remove('progress');
        healthBar.classList.add('danger');
      }
    }
  });
}

function restPlayers() {
  draftedPlayers.forEach((player) => {
    player.health += 5;
    if (player.health > 100) {
      player.health = 100;
    }
  });
}

function showPopup(message) {
  popup.textContent = message;
  popup.style.display = 'block';
  setTimeout(() => {
    popup.style.display = 'none';
  }, 4000);
}

function updatePlantationUpgradeBar() {
  const percentage = (upgradeCount / maxUpgrades) * 100; // Calculate percentage
  plantationUpgradeBar.style.width = `${percentage}%`; // Set width based on upgrades
}

function upgradePlantation() {
  if (upgradeCount < maxUpgrades) {
    if (deductCost(100000)) { // Deduct cost of the upgrade
      upgradeCount++; // Increment the upgrade count
      maxSlaves += 15; // Increase max slaves by 15
      updatePlantationUpgradeBar(); // Update the progress bar
      updateSlaveCount(); // Update the slave count display
      showPopup(`Plantation upgraded! You have upgraded ${upgradeCount} out of ${maxUpgrades} times. Max slaves: ${maxSlaves}`);
    } else {
      showPopup("You do not have enough funds to upgrade the plantation.");
    }
  } else {
    showPopup("You have reached the maximum number of upgrades.");
  }
}

// Event Listeners
draftButton.addEventListener('click', () => {
  if (draftedPlayers.length < maxSlaves) {
    const playerCost = Math.floor(Math.random() * 2000) + 1;
    if (deductCost(playerCost)) {
      const playerName = getRandomName();
      const playerHealth = 100; // Initial health
      draftedPlayers.push({ name: playerName, cost: playerCost, health: playerHealth, moneyMultiplier: 1 });
      slaveCount++; // Increment slave count when buying a slave
      updateSlaveCount(); // Call function to update slave count display
      const playerItem = document.createElement('li');
      const healthBar = document.createElement('div');
      healthBar.classList.add('health-bar', 'progress');
      healthBar.style.width = '100%';
      const healthPercentage = document.createElement('div');
      healthPercentage.classList.add('health-percentage');
      healthPercentage.textContent = '100%';
      const freeButton = document.createElement('button');
      freeButton.classList.add('free-button');
      freeButton.textContent = 'Free';
      freeButton.addEventListener('click', () => {
        accountBalance += 250;
        accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
        draftedPlayers = draftedPlayers.filter(player => player.name !== playerName);
        playerItem.remove();
        slaveCount--; // Decrement slave count when freeing a slave
        updateSlaveCount(); // Call function to update slave count display
        showPopup(`You freed ${playerName} and received $250.`);
      });
      playerItem.textContent = `${playerName} - $${playerCost} `;
      playerItem.appendChild(freeButton);
      playerItem.appendChild(healthBar);
      playerItem.appendChild(healthPercentage);
      draftedList.appendChild(playerItem);
      scrollToTop(); // Scroll to top after adding a slave
    } else {
      showPopup("You do not have enough funds.");
    }
  } else {
    showPopup("You have reached the maximum limit of slaves.");
  }
});

fireForemanButton.addEventListener('click', () => {
  if (foremanActive) {
    foremanActive = false;
    showPopup("Foreman fired. Total production decreased by 90% and no additional health deduction.");
  } else {
    showPopup("You do not have an active foreman to fire.");
  }
});

workButton.addEventListener('click', () => {
  showPopup("Working...");
  workButton.disabled = true;
  setTimeout(() => {
    let earningPerSlave = Math.floor(Math.random() * 1000) + 1;
    if (extraRationsActive) {
      earningPerSlave *= 1.5; // Increase earnings by 50%
      extraRationsActive = false;
    }
    
    if (foremanActive) {
      earningPerSlave *= 1.9; // Increase earnings by 90%
      draftedPlayers.forEach((player) => {
        player.health -= Math.floor(player.health * 0.05); // Deduct an additional 5% health
      });
    }

    draftedPlayers.forEach((player) => {
      accountBalance += earningPerSlave * player.moneyMultiplier;
    });

    accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
    checkMortality();
    workButton.disabled = false;
  }, 2000);
});

breakButton.addEventListener('click', () => {
  restPlayers();
  showPopup("Your slaves have earned a break and gained extra health.");
  day++;
  dayDisplay.textContent = `Day: ${day}`;
});

extraRationsButton.addEventListener('click', () => {
  if (deductCost(1500)) {
    extraRationsActive = true;
    showPopup("Extra rations provided. Slaves will work at increased rates for 1 day.");
  } else {
    showPopup("You do not have enough funds to provide extra rations.");
  }
});

foremanButton.addEventListener('click', () => {
  if (deductCost(3000)) {
    foremanActive = true;
    showPopup("Foreman hired. Total production increased by 90%, but an additional 5% health will be deducted.");
  } else {
    showPopup("You do not have enough funds to hire a foreman.");
  }
});

// Add the event listener for the upgrade button
upgradeButton.addEventListener('click', () => {
  upgradePlantation();
});
function updatePlantationUpgradeText() {
    const plantationUpgradeText = document.getElementById('plantationUpgradeText');
    plantationUpgradeText.textContent = `Upgrades: ${upgradeCount} out of ${maxUpgrades}`; // Update text display
}

function upgradePlantation() {
    if (upgradeCount < maxUpgrades) {
        if (deductCost(100000)) { // Deduct cost of the upgrade
            upgradeCount++; // Increment the upgrade count
            maxSlaves += 15; // Increase max slaves by 15
            updatePlantationUpgradeText(); // Update the text display
            updateSlaveCount(); // Update the slave count display
            showPopup(`Plantation upgraded! You have upgraded ${upgradeCount} out of ${maxUpgrades} times. Max slaves: ${maxSlaves}`);
        } else {
            showPopup("You do not have enough funds to upgrade the plantation.");
        }
    } else {
        showPopup("You have reached the maximum number of upgrades.");
    }
}
function checkRunAway() {
    const runawayChance = Math.random();
    if (runawayChance <= 0.02 && draftedPlayers.length > 0) { // 2% chance to run away
      const runawayIndex = Math.floor(Math.random() * draftedPlayers.length);
      const runawayPlayer = draftedPlayers[runawayIndex];
  
      // Remove the runaway player from the drafted list
      draftedPlayers.splice(runawayIndex, 1);
      slaveCount--; // Decrement slave count
      updateSlaveCount(); // Update the display for slave count
  
      // Remove the player's display from the list
      const playerItem = draftedList.querySelectorAll('li')[runawayIndex];
      playerItem.remove();
  
      // Show the popup notifying the player has run away
      showPopup(`${runawayPlayer.name} has run away!`);
    }
  }
  
  // Modify the workButton event listener to include the checkRunAway function
  workButton.addEventListener('click', () => {
    showPopup("Working...");
    workButton.disabled = true;
    setTimeout(() => {
      let earningPerSlave = Math.floor(Math.random() * 1000) + 1;
      if (extraRationsActive) {
        earningPerSlave *= 1.5; // Increase earnings by 50%
        extraRationsActive = false;
      }
      
      if (foremanActive) {
        earningPerSlave *= 1.9; // Increase earnings by 90%
        draftedPlayers.forEach((player) => {
          player.health -= Math.floor(player.health * 0.05); // Deduct an additional 5% health
        });
      }
  
      draftedPlayers.forEach((player) => {
        accountBalance += earningPerSlave * player.moneyMultiplier;
      });
  
      accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
      checkMortality();
      checkRunAway(); // Call the new checkRunAway function here
      workButton.disabled = false;
    }, 2000);
  });
  // Function to encode a string to Base64
function encodeBase64(str) {
    return btoa(unescape(encodeURIComponent(str)));
  }
  
  // Function to decode a Base64 string
  function decodeBase64(str) {
    return decodeURIComponent(escape(atob(str)));
  }
  
  // Function to save the game
  function saveGame() {
    const gameState = {
      slaveCount: slaveCount,
      accountBalance: accountBalance,
      draftedPlayers: draftedPlayers,
      day: day,
      upgradeCount: upgradeCount,
      maxSlaves: maxSlaves,
    };
  
    const gameStateString = JSON.stringify(gameState);
    document.cookie = gameState
    const encodedGameState = encodeBase64(gameStateString); // Encode to Base64
    const saveText = document.getElementById('saveText');
    saveText.value = encodedGameState; // Display the encoded game state
    showPopup("Game saved! You can copy the save code.");
  }
  
  // Function to rizz the game
  function loadGame() {
    const loadText = document.getElementById('loadText').value;
  
    try {
      const decodedState = decodeBase64(loadText); // Decode from Base64
      const loadedState = JSON.parse(decodedState); // Parse the decoded string
  
      // Restore the game state
      slaveCount = loadedState.slaveCount;
      accountBalance = loadedState.accountBalance;
      draftedPlayers = loadedState.draftedPlayers;
      day = loadedState.day;
      upgradeCount = loadedState.upgradeCount;
      maxSlaves = loadedState.maxSlaves;
  
      // Update the UI
      updateSlaveCount();
      accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
      dayDisplay.textContent = `Day: ${day}`;
      updatePlantationUpgradeText();
  
      // Recreate the list of drafted players in the UI
      draftedList.innerHTML = ''; // Clear the current list
      draftedPlayers.forEach((player) => {
        const playerItem = document.createElement('li');
        const healthBar = document.createElement('div');
        healthBar.classList.add('health-bar', 'progress');
        healthBar.style.width = `${player.health}%`;
        const healthPercentage = document.createElement('div');
        healthPercentage.classList.add('health-percentage');
        healthPercentage.textContent = `${player.health}%`;
        const freeButton = document.createElement('button');
        freeButton.classList.add('free-button');
        freeButton.textContent = 'Free';
        freeButton.addEventListener('click', () => {
          accountBalance += 250;
          accountDisplay.textContent = `Account Balance: $${Math.round(accountBalance)}`;
          draftedPlayers = draftedPlayers.filter(p => p.name !== player.name);
          playerItem.remove();
          slaveCount--; // Decrement slave count
          updateSlaveCount();
          showPopup(`You freed ${player.name} and received $250.`);
        });
        playerItem.textContent = `${player.name} - $${player.cost} `;
        playerItem.appendChild(freeButton);
        playerItem.appendChild(healthBar);
        playerItem.appendChild(healthPercentage);
        draftedList.appendChild(playerItem);
      });
  
      showPopup("Game loaded successfully!");
    } catch (error) {
      showPopup("Invalid save data. Please check and try again.");
    }
  }
  
  // Event listeners for the buttons
  document.getElementById('saveButton').addEventListener('click', saveGame);
  document.getElementById('loadButton').addEventListener('click', loadGame);
  // Toggle visibility of both save and load sections
document.getElementById('toggleAllSections').addEventListener('click', () => {
    const saveSection = document.getElementById('saveSection');
    const loadSection = document.getElementById('loadSection');
    
    // Check if either section is currently displayed
    if (saveSection.style.display === 'none' && loadSection.style.display === 'none') {
      saveSection.style.display = 'block';
      loadSection.style.display = 'block';
    } else {
      saveSection.style.display = 'none';
      loadSection.style.display = 'none';
    }
  });
