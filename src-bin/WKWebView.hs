module Main (
    main
) where

import Language.Javascript.JSaddle.WKWebView (run)
import HelloMain (helloMain)

main :: IO ()
main = run helloMain
