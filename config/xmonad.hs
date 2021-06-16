import XMonad
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, ppOutput, ppCurrent, wrap
                               ,xmobarColor)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, docksEventHook)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe, hPutStrLn)

import Graphics.X11.ExtraTypes.XF86

main = do
  xmobar <- spawnPipe "xmobar /home/sballert/.config/xmobar/xmobarrc"
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
  `additionalKeysP`
  [ ("M-<Return>", spawn "rofi -show drun")
  , ("M-s", spawn "session-menu")
  , ("M-p", spawn "toggle-touchpad")
  , ("M-c", spawn "toggle-screenlocker")
  , ("M-b", spawn "bluetoothctl-menu")
  , ("<XF86AudioRaiseVolume>", spawn "pulseaudio-ctl up")
  , ("<XF86AudioLowerVolume>", spawn "pulseaudio-ctl down")
  , ("<XF86AudioMute>", spawn "pulseaudio-ctl mute")
  , ("<Print>", spawn "flameshot gui")
  , ("<XF86MonBrightnessUp>", spawn "brightnessctl set 10%+")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 10%-")
  ]

myLogHook xmobar = def
  { ppOutput = hPutStrLn xmobar
  , ppCurrent = xmobarColor "#d79921" "" . wrap "[" "]"
  }
