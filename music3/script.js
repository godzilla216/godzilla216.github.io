const audio = document.getElementById("audio");
const songs = ["Audio/song1.m4a", "Audio/song2.m4a"];
let currentSongIndex = 0;

function loadSong(index) {
  audio.src = songs[index];
  audio.play();
}

document.getElementById("next").addEventListener("click", () => {
  currentSongIndex = (currentSongIndex + 1) % songs.length;
  loadSong(currentSongIndex);
});

document.getElementById("prev").addEventListener("click", () => {
  currentSongIndex = (currentSongIndex - 1 + songs.length) % songs.length;
  loadSong(currentSongIndex);
});

window.addEventListener('load', () => {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('sw.js').then(() => {
      console.log('Service Worker Registered');
    });
  }
  loadSong(currentSongIndex);
});
