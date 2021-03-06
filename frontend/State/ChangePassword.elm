module State.ChangePassword exposing (..)


type Status
    = NotLoaded
    | Success
    | Failure
    | NetworkError


type alias Model =
    { oldPassword : String
    , newPassword : String
    , newPassword2 : String
    , status : Status
    }


init : Model
init =
    { oldPassword = ""
    , newPassword = ""
    , newPassword2 = ""
    , status = NotLoaded
    }
