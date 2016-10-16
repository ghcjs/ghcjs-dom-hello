module Main (
    main
) where

import Control.Monad.IO.Class (MonadIO(..))
import Control.Concurrent.MVar (takeMVar, putMVar, newEmptyMVar)

import GHCJS.DOM (run, syncPoint, currentDocument)
import GHCJS.DOM.Types
       (HTMLParagraphElement(..), HTMLSpanElement(..), unsafeCastTo)
import GHCJS.DOM.Document (getBodyUnsafe, createElementUnsafe, createTextNode)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (on, mouseClientXY)
import qualified GHCJS.DOM.Document as D (click)
import qualified GHCJS.DOM.Element as E (click)

main = do
  putStrLn "<a href=\"http://localhost:3708/\">http://localhost:3708/</a>"
  run 3708 $ do
    Just doc <- currentDocument
    body <- getBodyUnsafe doc
    setInnerHTML body (Just "<h1>Kia ora (Hi)</h1>")
    on doc D.click $ do
        (x, y) <- mouseClientXY
        newParagraph <- createElementUnsafe doc (Just "p") >>= unsafeCastTo HTMLParagraphElement
        text <- createTextNode doc $ "Click " ++ show (x, y)
        appendChild newParagraph text
        appendChild body (Just newParagraph)
        return ()

    -- Make an exit button
    exitMVar <- liftIO newEmptyMVar
    exit <- createElementUnsafe doc (Just "span") >>= unsafeCastTo HTMLSpanElement
    text <- createTextNode doc "Click here to exit"
    appendChild exit text
    appendChild body (Just exit)
    on exit E.click $ liftIO $ putMVar exitMVar ()

    -- Force all all the lazy evaluation to be executed
    syncPoint

    -- In GHC compiled version the WebSocket connection will end when this
    -- thread ends.  So we will wait until the user clicks exit.
    liftIO $ takeMVar exitMVar
    setInnerHTML body (Just "<h1>Ka kite ano (See you later)</h1>")
    return ()
