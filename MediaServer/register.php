<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

function register($username, $password, $email) {
    $mysqli = new mysqli("localhost", "root", "", "pandanda");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to the database: " . $mysqli->connect_error;
        return;
    }

    $eusername = $mysqli->real_escape_string($username);
    $eemail = $mysqli->real_escape_string($email);
    $epassword = md5($mysqli->real_escape_string($password)); // md5 encryption


    $query = "INSERT INTO users (username, email, password) VALUES ('$eusername', '$eemail', '$epassword')";
    if ($mysqli->query($query) === TRUE) {
        echo "Registration successful!";
    } else {
        echo "Registration failed: " . $mysqli->error;
    }

    $mysqli->close();
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!empty($_POST['username']) && !empty($_POST['password']) && !empty($_POST['email'])) {
        register($_POST['username'], $_POST['password'], $_POST['email']);
    } else {
        echo "All fields are required!";
    }
}
?>


<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    <form method="post" action="register.php">
        <p>Username: <input type="text" name="username"></p>
        <p>Password: <input type="password" name="password"></p>
        <p>Email: <input type="email" name="email"></p>
        <p><input type="submit" value="Register"></p>
    </form>
</body>
</html>