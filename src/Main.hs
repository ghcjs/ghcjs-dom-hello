module Main (
    main
) where

import Control.Applicative ((<$>))
import Control.Monad.Trans (liftIO)
import GHCJS.DOM
       (enableInspector, webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (documentGetBody, documentCreateElement)
import GHCJS.DOM.HTMLElement (htmlElementSetInnerHTML, htmlElementSetInnerText)
import GHCJS.DOM.Element (elementOnclick)
import GHCJS.DOM.HTMLParagraphElement
       (castToHTMLParagraphElement)
import GHCJS.DOM.Node (nodeAppendChild)
import GHCJS.DOM.EventM (mouseClientXY)

main = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- documentGetBody doc
    htmlElementSetInnerHTML body "<h1>Hello World</h1>"
    elementOnclick body $ do
        (x, y) <- mouseClientXY
        liftIO $ do
            Just newParagraph <- fmap castToHTMLParagraphElement <$> documentCreateElement doc "p"
            htmlElementSetInnerText newParagraph $ "Click " ++ show (x, y)
            nodeAppendChild body (Just newParagraph)
            return ()
    return ()
