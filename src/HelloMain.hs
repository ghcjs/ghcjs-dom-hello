module HelloMain (
    helloMain
) where

import Control.Monad.IO.Class (MonadIO(..))
import Control.Concurrent.MVar (takeMVar, putMVar, newEmptyMVar)

import GHCJS.DOM (syncPoint, currentDocumentUnchecked)
import GHCJS.DOM.Types
       (Element(..), HTMLParagraphElement(..),
        HTMLSpanElement(..), uncheckedCastTo, JSM)
import GHCJS.DOM.Document (getBodyUnsafe, createElement, createTextNode)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (on, mouseClientXY)
import GHCJS.DOM.GlobalEventHandlers (click)

helloMain :: JSM ()
helloMain = do
    doc <- currentDocumentUnchecked
    body <- getBodyUnsafe doc
    setInnerHTML body (Just "<h1>Kia ora (Hi)</h1>")
    _ <- on doc click $ do
        (x, y) <- mouseClientXY
        newParagraph <- uncheckedCastTo HTMLParagraphElement <$> createElement doc "p"
        text <- createTextNode doc $ "Click " ++ show (x, y)
        _ <- appendChild newParagraph text
        _ <- appendChild body newParagraph
        return ()

    -- Make an exit button
    exitMVar <- liftIO newEmptyMVar
    exit <- uncheckedCastTo HTMLSpanElement <$> createElement doc "span"
    text <- createTextNode doc "Click here to exit"
    _ <- appendChild exit text
    _ <- appendChild body exit
    _ <- on exit click $ liftIO $ putMVar exitMVar ()

    -- Force all all the lazy JSaddle evaluation to be executed
    syncPoint

    -- In GHC compiled version the WebSocket connection will end when this
    -- thread ends.  So we will wait until the user clicks exit.
    liftIO $ takeMVar exitMVar
    setInnerHTML body (Just "<h1>Ka kite ano (See you later)</h1>")
    return ()
