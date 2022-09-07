import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = xmonad $ defaultConfig
	{ borderWidth					= 1
	, terminal						= "kitty"
	, normalBorderColor		= "#cccccc"
	, focusedBorderColor	= "#cd8b00"
	, manageHook = manageDocks <+> manageHook defaultConfig
	, layoutHook = avoidStruts  $  layoutHook defaultConfig
	} `additionalKeys`
	[ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
	, ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	, ((0, xK_Print), spawn "scrot")
	]
