function timeAgo(date) {
    const now = new Date();
    const seconds = Math.floor((now - new Date(date)) / 1000);
    
    const intervals = [
        { label: 'years', seconds: 31536000 },
        { label: 'months', seconds: 2592000 },
        { label: 'weeks', seconds: 604800 },
        { label: 'days', seconds: 86400 },
        { label: 'hours', seconds: 3600 },
        { label: 'minutes', seconds: 60 },
        { label: 'seconds', seconds: 1 },
    ];
    
    for (const { label, seconds: interval } of intervals) {
        const count = Math.floor(seconds / interval);
        if (count > 1) return `${count} ${label} ago`;
    }
    
    return 'just now';
}

async function fetchWebsiteContent(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        
        const text = await response.text();
        const parser = new DOMParser();
        const doc = parser.parseFromString(text, 'text/html');

        const table = doc.querySelector('table');
        if (!table) throw new Error('Table not found in the HTML');

        const rows = table.querySelectorAll('tr');
        const comments = [];

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length < 3) return;

            const timestamp = cells[0].innerText;
            const username = cells[1].innerText;
            const commentText = cells[2].innerText || '';

            const parsedDate = new Date(timestamp);
            if (isNaN(parsedDate.getTime())) return;

            comments.push({ timestamp: parsedDate, username, commentText });
        });

        comments.sort((a, b) => b.timestamp - a.timestamp);

        const contentDiv = document.getElementById('content');
        contentDiv.innerHTML = ''; // Clear loading text

        comments.forEach(({ timestamp, username, commentText }) => {
            const commentBox = document.createElement('div');
            commentBox.className = 'comment-box';

            const avatar = document.createElement('div');
            avatar.className = 'avatar';
            
            const content = document.createElement('div');
            content.className = 'content';

            const usernameDiv = document.createElement('div');
            usernameDiv.className = 'username';
            usernameDiv.textContent = username;

            const textDiv = document.createElement('div');
            textDiv.className = 'text';
            textDiv.textContent = commentText;

            const timestampDiv = document.createElement('div');
            timestampDiv.className = 'timestamp';
            timestampDiv.textContent = timeAgo(timestamp);

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
fetchWebsiteContent('https://docs.google.com/spreadsheets/d/e/2PACX-1vRy9_TWZFC-zUaDmi0E2SMEjgXz_n9u7ljJnUvlBnwmzyNWLA5-h3iGutSeKOtD7jvG5UAykLNumbMy/pubhtml');
