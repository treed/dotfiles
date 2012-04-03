import Data.IORef
import Control.OldException(catchDyn,try)
import Control.Category ((>>>))
import Control.Monad
import DBus
import DBus.Connection
import DBus.Message
import XMonad
import XMonad.Layout.Dishes
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.StackSet hiding (focus, workspaces)
import XMonad.Config.Gnome
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified System.IO.UTF8  as UTF8


myTerminal           = "gnome-terminal"
myBorderWidth        = 0
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#000000"
myModMask            = mod4Mask
myFocusFollowsMouse  = True

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
myNumlockMask   = mod2Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myStartupHook = setWMName "LG3D"

myScratchpads =
    [ NS "calc" "gnome-calculator" (title =? "Calculator") defaultFloating
    ]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_c     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modm,               xK_l     ), spawn "gnome-screensaver-command -l")
    , ((0,                  xK_Print ), spawn "scrot")
    , ((controlMask,        xK_Print ), spawn "scrot -u")
    , ((shiftMask,          xK_Print ), spawn "sleep 0.2; scrot -s")
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm,               xK_b     ), sendMessage ToggleStruts)
    , ((modm,               xK_r     ), spawn "xrefresh")

    -- Window Motion
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_n     ), windows W.focusDown)
    , ((modm,               xK_p     ), windows W.focusUp  )
    , ((modm .|. shiftMask, xK_n     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_p     ), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_comma ), sendMessage Shrink)
    , ((modm .|. shiftMask, xK_period), sendMessage Expand)

    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), restart "xmonad" True)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)


    -- Cycling Workspaces
    , ((modm,               xK_Right),  moveTo Next viewableWS)
    , ((modm,               xK_Left),   moveTo Prev viewableWS)
    , ((modm .|. shiftMask, xK_Right),  (shiftTo Next viewableWS) >> (moveTo Next viewableWS))
    , ((modm .|. shiftMask, xK_Left),   (shiftTo Prev viewableWS) >> (moveTo Prev viewableWS))
    , ((modm,               xK_Down),   nextScreen)
    , ((modm,               xK_Up),     prevScreen)
    , ((modm .|. shiftMask, xK_Down),   shiftNextScreen >> nextScreen)
    , ((modm .|. shiftMask, xK_Up),     shiftPrevScreen >> prevScreen)

    -- Scratchpads
    , ((modm .|. mod1Mask,   xK_c),      namedScratchpadAction myScratchpads "calc")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (liftM2 (.) W.greedyView W.shift, shiftMask)]]

viewableWS = WSIs $ return (("NSP" /=) . tag)

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full ||| dishes
    where
        tiled = Tall nmaster delta tiled_ratio
        dishes = Dishes nmaster dishes_ratio
        nmaster = 1
        delta = 1/100
        tiled_ratio = 1/2
        dishes_ratio = 1/5

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Dia"            --> doFloat
    , className =? "vncviewer"      --> doFloat
    , className =? "Vmplayer"       --> doFloat
    , className =? "Virt-viewer"    --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , title     =? "Save File"      --> (doRectFloat $ RationalRect 0.25 0.25 0.5 0.5)
    , namedScratchpadManageHook myScratchpads
    , manageDocks ]

logPrinter :: Connection -> PP
logPrinter dbus       = defaultPP {
    ppOutput          = outputThroughDBus dbus
  , ppTitle           = pangoSanitize >>> pangoColor "#00DDFF"
  , ppCurrent         = pangoSanitize >>> wrap "[" "]" >>> pangoColor "#00EEEE"
  , ppVisible         = pangoSanitize >>> pangoColor "#00EEEE"
  , ppHidden          = hiddenFilter
  , ppLayout          = layoutFilter
  , ppHiddenNoWindows = const ""
  , ppUrgent          = pangoColor "red"
  , ppSep             = " • "
  , ppOrder           = (\ (ws:l:t:_) -> [l, ws, t])
  }

hiddenFilter :: WorkspaceId -> String
hiddenFilter "NSP" = ""
hiddenFilter a = a

layoutFilter :: String -> String
layoutFilter a = [head a]

-- This retry is really awkward, but sometimes DBus won't let us get our
-- name unless we retry a couple times.
getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\ (DBus.Error _ _) ->
                                                getWellKnownName dbus)
 where
  tryGetName = do
    namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
    addArgs namereq [String "org.xmonad.Log", Word32 5]
    sendWithReplyAndBlock dbus namereq 0
    return ()

outputThroughDBus :: Connection -> String -> IO ()
outputThroughDBus dbus str = do
  let str' = "<span font=\"Terminus 9 Bold\">" ++ str ++ "</span>"
  msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
  addArgs msg [String str']
  send dbus msg 0 `catchDyn` (\ (DBus.Error _ _ ) -> return 0)
  return ()

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
 where
  left  = "<span foreground=\"" ++ fg ++ "\">"
  right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
 where
  sanitize '>'  acc = "&gt;"   ++ acc
  sanitize '<'  acc = "&lt;"   ++ acc
  sanitize '\"' acc = "&quot;" ++ acc
  sanitize '&'  acc = "&amp;"  ++ acc
  sanitize x    acc = x:acc

main = withConnection Session $ \ dbus -> do
    getWellKnownName dbus
    floatNextWindows <- newIORef 0
    xmonad $ gnomeConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = dynamicLogWithPP (logPrinter dbus),
        startupHook        = myStartupHook
    }
