
        function updateCountdown() {
            const now = new Date().getTime();
            const christmas = new Date("December 25, 2024 00:00:00").getTime();
            const timeLeft = christmas - now;

            const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

            document.getElementById("days").innerText = days;
            document.getElementById("hours").innerText = hours;
            document.getElementById("minutes").innerText = minutes;
            document.getElementById("seconds").innerText = seconds;

            if (timeLeft < 0) {
                document.getElementById("countdown").innerHTML = "The Beta is live!";
            }
        }

        setInterval(updateCountdown, 1000);
