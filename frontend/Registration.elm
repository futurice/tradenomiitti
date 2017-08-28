module Registration exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events exposing (onInput, onWithOptions)
import Http
import Json.Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode
import State.Registration exposing (..)
import Translation exposing (T)
import Util exposing (UpdateMessage(..))


type Msg
    = Email String
    | Submitted
    | SendResponse (Result Http.Error Response)


type alias Response =
    { status : String }


submit : Model -> Cmd Msg
submit model =
    let
        encoded =
            Json.Encode.object <|
                [ ( "email", Json.Encode.string model.email )
                ]
    in
    Http.post "/register" (Http.jsonBody encoded) decodeResponse
        |> Http.send SendResponse


decodeResponse : Json.Decode.Decoder Response
decodeResponse =
    decode Response
        |> required "status" Json.Decode.string


update : Msg -> Model -> ( Model, Cmd (UpdateMessage Msg) )
update msg model =
    case msg of
        Email email ->
            { model | email = email } ! []

        SendResponse (Err error) ->
            { model | status = Failure } ! []

        SendResponse (Ok response) ->
            { model | status = Success } ! []

        Submitted ->
            model ! [ Cmd.map LocalUpdateMessage <| submit model ]



-- Näytä success/failure -> message, jonka serveri lähettää?


view : T -> Model -> H.Html Msg
view t model =
    case model.status of
        NotLoaded ->
            H.div
                [ A.class "container last-row" ]
                [ H.div
                    [ A.class "row registration col-sm-6 col-sm-offset-3" ]
                    [ H.form
                        [ A.class "registration__container"
                        , onWithOptions "submit"
                            { preventDefault = True, stopPropagation = False }
                            (Json.Decode.succeed Submitted)
                        ]
                        [ H.h1
                            [ A.class "registration__heading" ]
                            [ H.text <| t "registration.title" ]
                        , H.h3
                            [ A.class "registration__input" ]
                            [ H.input [ A.name "email", A.type_ "email", A.autofocus True, A.placeholder <| t "registration.emailPlaceholder", onInput Email ] []
                            ]
                        , H.p
                            [ A.class "registration__submit-button" ]
                            [ H.button
                                [ A.type_ "submit"
                                , A.class "btn btn-primary"
                                , A.disabled (String.length model.email == 0)
                                ]
                                [ H.text <| t "registration.buttonText" ]
                            ]
                        ]
                    ]
                ]

        Success ->
            H.div
                [ A.class "container last-row" ]
                [ H.div
                    [ A.class "row registration col-sm-6 col-sm-offset-3" ]
                    [ H.div
                        [ A.class "registration__container"
                        ]
                        [ H.h1
                            [ A.class "registration__heading" ]
                            [ H.text <| t "registration.success" ]
                        ]
                    ]
                ]

        Failure ->
            H.div
                [ A.class "container last-row" ]
                [ H.div
                    [ A.class "row changepassword col-sm-6 col-sm-offset-3" ]
                    [ H.div
                        [ A.class "changepassword__container"
                        ]
                        [ H.h1
                            [ A.class "changepassword__heading" ]
                            [ H.text <| t "registration.failure" ]
                        ]
                    ]
                ]