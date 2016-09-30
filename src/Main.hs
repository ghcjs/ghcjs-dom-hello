module Main (
    main
) where

import GHCJS.DOM (run, currentDocument)
import GHCJS.DOM.Document (getBody, createElement, createTextNode, click)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (on, mouseClientXY)
import Control.Monad.IO.Class (MonadIO(..))
import Control.Monad (forever)
import Control.Concurrent (threadDelay)

main = run 3708 $ do
    Just doc <- currentDocument
    Just body <- getBody doc
    setInnerHTML body (Just "<h1>Hello World</h1>")
    on doc click $ do
        (x, y) <- mouseClientXY
        Just newParagraph <- createElement doc (Just "p")
        text <- createTextNode doc $ "Click " ++ show (x, y)
        appendChild newParagraph text
        appendChild body (Just newParagraph)
        return ()
    liftIO . forever $ threadDelay 10000000
    return ()
