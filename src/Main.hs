{-# LANGUAGE CPP #-}
module Main (
    main
) where

import HelloMain (helloMain)
#if defined(ghcjs_HOST_OS)
run :: a -> a
run = id
#elif defined(MIN_VERSION_jsaddle_wkwebview)
import Language.Javascript.JSaddle.WKWebView (run)
#else
import Language.Javascript.JSaddle.WebKitGTK (run)
#endif

main :: IO ()
main = run helloMain

