module Main where

import Prelude (Unit, bind, const, show, (-), (+))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Signal.Channel (CHANNEL)

import Pux (renderToDOM, start, EffModel, noEffects)
import Pux.Html (Html, text, button, span, div)
import Pux.Html.Events (onClick)

data Action = Button

type State = Int

update :: forall eff. Action -> State -> EffModel State Action (eff)
update Button state = noEffects state

view :: State -> Html Action
view count =
  div
    []
    [ button [ onClick (const Button) ] [ text "Button" ]
    ]

main :: forall e. Eff (err :: EXCEPTION, channel :: CHANNEL | e) Unit
main = do
  app <- start
    { initialState: 0
    , update: update
    , view: view
    , inputs: []
    }

  renderToDOM "#app" app.html
