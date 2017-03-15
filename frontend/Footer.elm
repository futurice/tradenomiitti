module Footer exposing (..)

import Html as H
import Html.Attributes as A

view : H.Html msg
view =
  H.div
    [ A.class "footer" ]
    [ H.div
      [ A.class "container footer__content"]
      [ H.div [ A.class "row" ]
        [ H.div
          [ A.class "col-xs-12 col-sm-3" ]
          [ H.img
              [ A.src "/static/tral-logo_white.png"
              , A.class "footer__tral-logo"
              ] []
          ]
        , H.div
          [ A.class "col-xs-12 col-sm-3" ]
          [ H.p [] [ H.a [ A.href "/kayttoehdot" ] [ H.text "Palvelun käyttöehdot" ]]
          , H.p [] [ H.a [ A.href "/rekisteriseloste" ] [ H.text "Rekisteriseloste" ]]
          , H.p [] [ H.a [ A.href "http://tral.fi" ] [ H.text "tral.fi" ]]
          , H.p [] [ H.a [ A.href "http://liity.tral.fi/#liity" ] [ H.text "Liity jäseneksi" ]]
          ]
        , H.div
          [ A.class "col-xs-12 col-sm-4 footer__social-icons" ]
          [ H.a [ A.href "https://www.facebook.com/tradenomiliitto" ] [ H.i [ A.class "fa fa-facebook"] [] ]
          , H.a [ A.href "https://twitter.com/Tradenomiliitto" ] [ H.i [ A.class "fa fa-twitter"] [] ]
          , H.a [ A.href "https://www.instagram.com/tradenomiliitto/" ] [ H.i [ A.class "fa fa-instagram"] [] ]
          , H.a [ A.href "http://www.linkedin.com/groups/Tradenomiliitto-TRAL-ry-2854058/about" ] [ H.i [ A.class "fa fa-linkedin"] [] ]
          ]
        ]
      ]
    ]
