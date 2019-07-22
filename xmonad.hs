import XMonad
import XMonad.Hooks.DynamicLog (xmobar)

main = do
  xmonad =<< xmobar myConfig

myConfig = def
  { modMask = mod4Mask
  , terminal = "st"
  , borderWidth = 1
  }
