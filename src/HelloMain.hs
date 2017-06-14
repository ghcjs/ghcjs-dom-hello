module HelloMain (
    helloMain
) where

import Control.Monad.IO.Class (MonadIO(..))
import Control.Concurrent.MVar (takeMVar, putMVar, newEmptyMVar)

import GHCJS.DOM
import GHCJS.DOM.Types
import GHCJS.DOM.Document
import GHCJS.DOM.Element
import GHCJS.DOM.Node
import GHCJS.DOM.EventM
import GHCJS.DOM.GlobalEventHandlers
import GHCJS.DOM.HTMLHyperlinkElementUtils

-- | This is the main function of this application it is shared by all the different executable
-- types included in this package.  Its type JSM () is like IO () but for anything that needs
-- a JavaScript context to run.
--
-- One way to work on this application is to use ghci and jsaddle-warp.  Start ghci with
-- your favourite tool, for instance from the command line you can run:
-- > cabal new-repl
--
-- Make sure break-on-exception is off (otherwise it will break when we restart the warp server)
-- > :set -fno-break-on-exception
--
-- There is a `.ghci` file in the ghcjs-dom-hello directory that redefines the :reload command so
-- that each time :reload is used it will also run:
-- > Language.Javascript.JSaddle.Warp.debug 3708 HelloMain.helloMain
-- This will start a warp server on port 3708. If it was already running it will stop the
-- old one first, but before it does it will send a signal to each of the connected browsers to
-- refresh.  That way after the :reload they should all be refreshed automaticaly.
-- (It also waits up to 10 seconds for the browsers to reconnect. If one is closed or in the
-- or in the background you may have to wait for the ghci prompt to return).
--
-- Use `runOnAll` to run JavaScript on all the connected browsers.  For instance the following
-- will print the HTML from the body of each connected browser:
-- > Language.Javascript.JSaddle.Debug.runOnAll_ $ currentDocumentUnchecked >>= getBodyUnchecked >>= getInnerHTML >>= liftIO . putStrLn
helloMain :: JSM ()
helloMain = do
    doc <- currentDocumentUnchecked
    body <- getBodyUnchecked doc
    setInnerHTML body "<h1>Kia ora (Hi)</h1>"

    -- Add a mouse click event handler to the document
    _ <- on doc click $ do
        (x, y) <- mouseClientXY
        newParagraph <- uncheckedCastTo HTMLParagraphElement <$> createElement doc "p"
        text <- createTextNode doc $ "Click " ++ show (x, y)
        appendChild_ newParagraph text
        appendChild_ body newParagraph

    -- Make an exit link
    exitMVar <- liftIO newEmptyMVar
    exit <- uncheckedCastTo HTMLAnchorElement <$> createElement doc "a"
    text <- createTextNode doc "Click here to exit"
    appendChild_ exit text
    appendChild_ body exit

    -- Set an href for the link, but use preventDefault to stop it working
    -- (demonstraights synchronous callbacks into haskell, as preventDefault
    -- must be called inside the JavaScript event handler function).
    setHref exit "https://github.com/ghcjs/ghcjs-dom-hello"
    _ <- on exit click $ preventDefault >> liftIO (putMVar exitMVar ())

    -- Force all all the lazy JSaddle evaluation to be executed
    syncPoint

    -- Wait until the user clicks exit.
    liftIO $ takeMVar exitMVar
    setInnerHTML body "<h1>Ka kite ano (See you later)</h1>"
