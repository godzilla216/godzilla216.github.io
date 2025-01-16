        function timeAgo(date) {
            const now = new Date();
            const seconds = Math.floor((now - new Date(date)) / 1000);
            const interval = Math.floor(seconds / 31536000);
            if (interval > 1) return interval + " years ago";
            const month = Math.floor(seconds / 2592000);
            if (month > 1) return month + " months ago";
            const week = Math.floor(seconds / 604800);
            if (week > 1) return week + " weeks ago";
            const day = Math.floor(seconds / 86400);
            if (day > 1) return day + " days ago";
            const hour = Math.floor(seconds / 3600);
            if (hour > 1) return hour + " hours ago";
            const minute = Math.floor(seconds / 60);
            if (minute > 1) return minute + " minutes ago";
            return Math.floor(seconds) + " seconds ago";
        }

// Function to censor cuss words in a comment or username
function censorCussWords(text) {
    const cussWords = ['fuck', 'bitch', 'nigger', 'nigga', 'dick', 'KKK', 'vagina', 'shit', 'pornhub', 'gay', 'retard', 'fag', 'faggot', 'NUT', 'sigma', 'dick', 'cum']; // Add more cuss words here
    let censoredText = text;

    cussWords.forEach(word => {
        // Regex to find bad words even when they are not separated by spaces or are attached to punctuation
        const regex = new RegExp(`${word}`, 'gi'); // Case insensitive
        censoredText = censoredText.replace(regex, '*'.repeat(word.length));
    });

    return censoredText;
}

async function fetchWebsiteContent(url) {
    try {
        const response = await fetch(url);
        const text = await response.text();

        // Create a DOM parser to parse the HTML content
        const parser = new DOMParser();
        const doc = parser.parseFromString(text, 'text/html');

        // Extract the table data from the parsed HTML
        const table = doc.querySelector('table');
        if (!table) {
            throw new Error('Table not found in the HTML');
        }

        const rows = table.querySelectorAll('tr');
        const comments = [];

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length < 3) return; // Ensure there are enough cells in the row

            const timestamp = cells[0].innerText;
            const username = cells[1].innerText;
            const commentText = cells[2] ? cells[2].innerText : '';

            if (isNaN(new Date(timestamp).getTime())) return; // Skip if timestamp is NaN

            comments.push({ timestamp, username, commentText });
        });

        // Sort comments by timestamp in descending order
        comments.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

        const contentDiv = document.getElementById('content');
        contentDiv.innerHTML = ''; // Clear loading text

        comments.forEach(comment => {
            const commentBox = document.createElement('div');
            commentBox.className = 'comment-box';

            const avatar = document.createElement('div');
            avatar.className = 'avatar';
            
            const content = document.createElement('div');
            content.className = 'content';

            const usernameDiv = document.createElement('div');
            usernameDiv.className = 'username';
            usernameDiv.textContent = censorCussWords(comment.username); // Censor username

            const textDiv = document.createElement('div');
            textDiv.className = 'text';
            textDiv.textContent = censorCussWords(comment.commentText); // Censor comment text

            const timestampDiv = document.createElement('div');
            timestampDiv.className = 'timestamp';
            timestampDiv.textContent = timeAgo(comment.timestamp);

            content.appendChild(usernameDiv);
            content.appendChild(textDiv);
            content.appendChild(timestampDiv);

            commentBox.appendChild(avatar);
            commentBox.appendChild(content);
            contentDiv.appendChild(commentBox);
        });
    } catch (error) {
        console.error('Error fetching or parsing the website content:', error);
        document.getElementById('content').innerText = 'Failed to load content.';
    }
}

// Replace with the URL of the website you want to fetch content from
fetchWebsiteContent('https://docs.google.com/spreadsheets/d/e/2PACX-1vT-1gJLSUM5PjuxdQ_1p9_PpOjo_LRT57pCpZBuZ6uzlFoGfmH63uQ7KOZ5WF7FBTyT7Le7zSfRas6K/pubhtml');
