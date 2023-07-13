<?php
enum BloodGroups {
    case A;
    case B;
    case AB;
    case O;
    public function __to_str()
    {
        switch ($this) {
            case BloodGroups::A :
                return "A";
                break;
            case BloodGroups::AB :
                return "AB";
                break;
            case BloodGroups::B :
                return "B";
                break;
            case BloodGroups::O :
                return "O";
        }
    }
}



