module ListAds exposing (..)

import Common
import Ad
import Html as H
import Html.Attributes as A
import Http
import Json.Decode exposing (list)
import State.Ad
import State.ListAds exposing (..)

type Msg = NoOp | GetAds | UpdateAds (Result Http.Error (List State.Ad.Ad))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    UpdateAds (Ok ads) ->
      ({ model | ads = ads }, Cmd.none )
    --TODO: show error
    UpdateAds (Err _) ->
      (model, Cmd.none)
    GetAds ->
      (model, getAds)


getAds : Cmd Msg
getAds =
  let
    url = "/api/ads/"
    request = Http.get url (list Ad.adDecoder)
  in
    Http.send UpdateAds request


view : Model -> H.Html Msg
view model =
  let
    adsHtml = List.map adListView model.ads
    rows = List.reverse (List.foldl folder [] adsHtml)
    rowsHtml = List.map row rows
  in
    H.div []
    [ H.div
      []
      [ H.h3 [ A.class "list-ads__header" ] [ H.text "Selaa hakuilmoituksia" ] ]
      , H.div [A.class "list-ads__list-background"]
      [ H.div
        [ A.class "row list-ads__ad-container" ]
        rowsHtml
        ]
    ]

row : List (H.Html Msg) -> H.Html Msg
row ads =
  H.div
    [ A.class "row" ]
    ads

adListView : State.Ad.Ad -> H.Html Msg
adListView ad =
  H.div
    [ A.class "col-xs-12 col-sm-6"]
    [ H.div
      [ A.class "list-ads__ad-preview" ]
      [ H.h3 []
        [ H.a 
          [ A.class "list-ads__ad-preview-heading"
          , A.href ("/ads/" ++ (toString ad.id)) ]
          [ H.text ad.heading ] 
        ]
      , H.p [ A.class "list-ads__ad-preview-content" ] [ H.text (truncateContent ad.content 200) ]
      , H.hr [] []
      , Common.authorInfo ad.createdBy
      ]
    ]

-- transforms a list to a list of lists of two elements: [1, 2, 3, 4, 5] => [[5], [3, 4], [1, 2]]
-- note: reverse the results if you need the elements to be in original order
folder : a -> List (List a) -> List (List a)
folder x acc =
  case acc of
    [] -> [[x]]
    row :: rows ->
      case row of
        el1 :: el2 :: els -> [x] :: row :: rows
        el :: els -> [el, x] :: rows
        els -> (x :: els) :: rows

-- truncates content so that the result includes at most numChars characters, taking full words. "…" is added if the content is truncated 
truncateContent : String -> Int -> String
truncateContent content numChars =
  if (String.length content) < numChars
    then content
    else
      let
        truncated = List.foldl (takeNChars numChars) "" (String.words content)
      in
        -- drop extra whitespace created by takeNChars and add three dots
        (String.dropRight 1 truncated) ++ "…"

-- takes first x words where sum of the characters is less than n
takeNChars : Int -> String -> String -> String
takeNChars n word accumulator =
  let
    totalLength = (String.length accumulator) + (String.length word)
  in
    if totalLength < n
      then accumulator ++ word ++ " "
      else accumulator
