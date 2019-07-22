import XMonad
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, ppOutput)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, docksEventHook)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe, hPutStrLn)

main = do
  xmobar <- spawnPipe "xmobar"
  xmonad $ myConfig xmobar

myConfig xmobar = def
  { modMask = mod4Mask
  , terminal = "st"
  , borderWidth = 1
  , normalBorderColor = "#3c3836"
  , focusedBorderColor = "#665c54"
  , logHook = dynamicLogWithPP $ myLogHook xmobar
  , layoutHook = avoidStruts $ layoutHook defaultConfig
  , manageHook = manageDocks <+> manageHook defaultConfig
  , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
  }
  `additionalKeys`
  [ ((mod4Mask, xK_Return), spawn "rofi -show drun")
  , ((mod4Mask, xK_s), spawn "loginctl lock-session")
  , ((0, 0x1008ff13), spawn "pulseaudio-ctl up")
  , ((0, 0x1008ff11), spawn "pulseaudio-ctl down")
  , ((0, 0x1008ff12), spawn "pulseaudio-ctl mute")
  ]

myLogHook xmobar = def
  { ppOutput = hPutStrLn xmobar
  }
