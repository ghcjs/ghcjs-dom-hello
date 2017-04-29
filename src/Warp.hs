module Main (
    main
) where

import System.IO (stdout, hFlush)
import Language.Javascript.JSaddle.Warp (run)
import HelloMain (helloMain)

main :: IO ()
main = do
  putStrLn "<a href=\"http://localhost:3708/\">http://localhost:3708/</a>"
  hFlush stdout
  run 3708 helloMain
