<?php
// Database connection
$servername = "localhost";
$username = "root"; // Replace with your MySQL username
$password = "";     // Replace with your MySQL password
$dbname = "feedback_system"; // Replace with your database name

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_ip = $_SERVER['REMOTE_ADDR'];

// Check if feedback type is provided
if (isset($_POST['type'])) {
    $feedback_type = $_POST['type'];

    // Check if user has already voted
    $result = $conn->query("SELECT * FROM user_feedback WHERE user_ip = '$user_ip'");
    if ($result->num_rows == 0) {
        if ($feedback_type == 'like') {
            $conn->query("UPDATE feedback_counts SET likes = likes + 1 WHERE id = 1");
        } elseif ($feedback_type == 'dislike') {
            $conn->query("UPDATE feedback_counts SET dislikes = dislikes + 1 WHERE id = 1");
        }

        // Record the user's vote
        $conn->query("INSERT INTO user_feedback (user_ip, feedback_type) VALUES ('$user_ip', '$feedback_type')");
    } else {
        echo "You have already voted!";
    }
}

// Fetch current feedback counts
$result = $conn->query("SELECT likes, dislikes FROM feedback_counts WHERE id = 1");
$row = $result->fetch_assoc();

echo "Likes: " . $row['likes'] . "<br>";
echo "Dislikes: " . $row['dislikes'] . "<br>";

$conn->close();
?>
