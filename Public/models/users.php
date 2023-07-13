<?php
require('/opt/lampp/htdocs/project/models/blood_groups.php');
require('/opt/lampp/htdocs/project/models/rhesus.php');
require_once('/opt/lampp/htdocs/project/models/usertype.php');



class Users {
    var BloodGroups $blood_group = BloodGroups::AB;
    var Rhesus $rhesus = Rhesus::positive;
    var UserType $userType;
    var string $first_name;
    var string $last_name;
    var string $username;
    var string $location;
    public string $email;
    public string $password;
    public string $conpassword;  
    
    public function decode(array $arr): Users {
        return $this;
    }
}



