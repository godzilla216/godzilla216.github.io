let x = 0;
let y = 0;
const slider1 = document.getElementById('slider1');

let z = slider1.ariaValueMax;

slider1.addEventListener('input', function () {
   z = this.value; // update z whenever the slider moves
   console.log('Slider value:', z); // optional: see it update
});

document.addEventListener('keydown', function (event) {
   const text1 = document.getElementById("text1");
   const click = document.getElementById('click');
   const clone1 = click.cloneNode();
   if (event.key === ' ' && x === 0) {
      x++
      text1.innerHTML = `you have clicked space ${x} time.`;
      if (y === 0) {
         clone1.volume = z;
         clone1.play(); 
      }
   }

   else if (event.key === ' ') {

      x++;
      document.cookie = 'clickCount=' + x + "; expires=Thu, 18 Dec 2025 12:00:00 UTC";

      console.log("AFTER SET COOKIE:  " + document.cookie);
      text1.innerHTML = `you have clicked space ${x} times.`;
      if (y === 0) {
         clone1.volume = z;
         clone1.play();        
      }

   }
});

function panel_toggle() {
   const panel1 = document.getElementById('storebg');
   if (getComputedStyle(panel1).display === 'none') {
      panel1.style.display = 'block';
   } else {
      panel1.style.display = 'none';
   }
}
 


function getCookie(cname) {
   let name = cname + "=";
   let decodedCookie = decodeURIComponent(document.cookie);
   let ca = decodedCookie.split(';');
   for (let i = 0; i < ca.length; i++) {
       let c = ca[i];
       while (c.charAt(0) == ' ') {
           c = c.substring(1);
       }
       if (c.indexOf(name) == 0) {
           return c.substring(name.length, c.length);
       }
   }
   return "";
}
function onPageLoad() {
   x = getCookie("clickCount");
   console.log("onPageLoad, x=" + x);
}

function mute() {
   const mute_img = document.getElementById('icon');
   if (y === 0) {
      mute_img.src = '/assets/mute.svg'
      y++
   }
   else {
      mute_img.src = '/assets/audio.svg'
      y--
   }




}