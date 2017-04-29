module Main (
    main
) where

import Language.Javascript.JSaddle.WebKitGTK (run)
import HelloMain (helloMain)

main :: IO ()
main = run helloMain
