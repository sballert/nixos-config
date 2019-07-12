import XMonad

main = do
  xmonad myConfig

myConfig = def
  { modMask = mod4Mask
  , terminal = "st"
  , borderWidth = 1
  }
