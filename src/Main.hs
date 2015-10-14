module Main (
    main
) where

import Control.Applicative ((<$>))
import GHCJS.DOM
       (enableInspector, webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (getBody, createElement, createTextNode, click)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.HTMLParagraphElement
       (castToHTMLParagraphElement)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (on, mouseClientXY)

main = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- getBody doc
    setInnerHTML body (Just "<h1>Hello World</h1>")
    on doc click $ do
        (x, y) <- mouseClientXY
        Just newParagraph <- fmap castToHTMLParagraphElement <$> createElement doc (Just "p")
        text <- createTextNode doc $ "Click " ++ show (x, y)
        appendChild newParagraph text
        appendChild body (Just newParagraph)
        return ()
    return ()
