<?php
require_once('./controller/mailer.php');
require_once("./controller/config.php");

function send_mail($to_email, $email): bool
{
    $mailer = new Mailer($to_email, $email);
    return $mailer->send_mail();
}

