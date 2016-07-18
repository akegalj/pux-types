module Main where

import Prelude (Unit, bind, const, show, (-), (+), pure, ($))

import Control.Apply ((*>))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, throw)
import Signal.Channel (CHANNEL)

import Pux (renderToDOM, start, EffModel, onlyEffects, noEffects)
import Pux.Html (Html, text, button, span, div)
import Pux.Html.Events (onClick)

data Action
    = Button
    | Nop

type State = Int

-- NOTE: here I tried to do some action with effect and I picked `throw`
-- update :: forall eff. Action -> State -> EffModel State Action (err' :: CHANNEL | eff)
update Button state = onlyEffects state [ liftEff $ throw "bla" *> pure Nop ]
update Nop state = noEffects state

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
