module Main (
    main
) where

import Control.Applicative ((<$>))
import Control.Monad.Trans (liftIO)
import GHCJS.DOM
       (enableInspector, webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (getBody, createElement)
import GHCJS.DOM.HTMLElement (setInnerText)
import GHCJS.DOM.Element (setInnerHTML, click)
import GHCJS.DOM.HTMLParagraphElement
       (castToHTMLParagraphElement)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (on, mouseClientXY)

main = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- getBody doc
    setInnerHTML body (Just "<h1>Hello World</h1>")
    on body click $ do
        (x, y) <- mouseClientXY
        liftIO $ do
            Just newParagraph <- fmap castToHTMLParagraphElement <$> createElement doc (Just "p")
            setInnerText newParagraph $ Just $ "Click " ++ show (x, y)
            appendChild body (Just newParagraph)
            return ()
    return ()
