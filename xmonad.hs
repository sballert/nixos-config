import XMonad
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Util.EZConfig (additionalKeys)

main = do
  xmonad =<< xmobar myConfig

myConfig = def
  { modMask = mod4Mask
  , terminal = "st"
  , borderWidth = 1
  }
  `additionalKeys`
  [ ((mod4Mask, xK_Return), spawn "rofi -show drun")
  , ((mod4Mask, xK_s), spawn "loginctl lock-session")
  ]
