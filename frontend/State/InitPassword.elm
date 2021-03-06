module State.InitPassword exposing (..)


type Status
    = NotLoaded
    | Success
    | Failure
    | NetworkError


type alias Model =
    { password : String
    , password2 : String
    , status : Status
    }


init : Model
init =
    { password = ""
    , password2 = ""
    , status = NotLoaded
    }
