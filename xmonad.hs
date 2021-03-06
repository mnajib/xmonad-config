import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, removeKeys)
import System.IO

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
-- import XMonad.Layout.Spiral
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
-- import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.Combo
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Renamed

import Graphics.X11.ExtraTypes.XF86

myTerminal      = "urxvt +sb -bg black -fg white -uc -bc"
-- myTerminal   = "termonad"
-- myTerminal = "alacritty"

myXmobarrc = "~/.xmonad/xmobarrc.hs"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 1
-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--myModMask       = mod1Mask
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
-- A tagging example:
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
-- override some of the default keybindings and add my own
-- myKeys =
--    [ ((mod4Mask .|. shiftMask, xK_w), spawn "feh --bg-fill --randomize ~/Wallpapers/*") -- change wallpaper
--    --, ((mod4Mask .|. shiftMask, xK_q), kill) -- close window with mod-shift-Q (default is mod-shift-C)
--    --, ((mod4Mask .|. shiftMask, xK_e), io (exitWith ExitSuccess)) -- close xmonad with mod-shift-E (default is mod-shift-Q)
--    , ((mod4Mask .|. shiftMask, xK_r), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Recompile and restart xmonad
--    , ((mod4Mask,               xK_x), spawn "scrot '%Y-%m-%d-%H%M%S.png' -b -u -e 'mv $f ~/Pictures/Screenshots/'" )
--    , ((mod4Mask .|. shiftMask, xK_x), spawn "scrot '%Y-%m-%d-%H%M%S-full.png' -b -e 'mv $f ~/Pictures/Screenshots/'" )
--    --, ((mod4Mask .|. shiftMask, xK_l), spawn "xlock -mode random" )
--    , ((mod4Mask .|. shiftMask, xK_l), spawn "xlock -mode forest" )
--    --, ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command --lock" )
--    ]
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modm, xK_p), spawn "dmenu_run")
    --, ((modm, xK_p), spawn "rofi -show run")
    , ((modm, xK_p), spawn "rofi -combi-modi window,drun,ssh -theme solarized -font \"hack 10\" -show combi")
    --, ((modm, xK_p), spawn "rofi -combi-modi window,drun,ssh -theme solarized -font \"hack 10\" -show combi -icon-theme \"Papirus\" -show-icons")
    --, ((modm, xK_f), spawn "rofi -show run -modi run -location 1 -width 100 -lines 2 -line-margin 0 -line-padding 1 -separator-style none -font \"mono 10\" -columns 9 -bw 0 -disable-history -hide-scrollbar -color-window \"#222222, #222222, #b1b4b3\" -color-normal \"#222222, #b1b4b3, #222222, #005577, #b1b4b3\" -color-active \"#222222, #b1b4b3, #222222, #007763, #b1b4b3\" -color-urgent \"#222222, #b1b4b3, #222222, #77003d, #b1b4b3\" -kb-row-select \"Tab\" -kb-row-tab \"\"")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p ), spawn "gmrun")
    -- , ((modm .|. shiftMask, xK_p ), spawn "")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --, ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((modm .|. controlMask .|. shiftMask, xK_Right), sendMessage $ Move R)
    , ((modm .|. controlMask .|. shiftMask, xK_Left ), sendMessage $ Move L)
    , ((modm .|. controlMask .|. shiftMask, xK_Up   ), sendMessage $ Move U)
    , ((modm .|. controlMask .|. shiftMask, xK_Down ), sendMessage $ Move D)

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout =
    renamed [Replace "Tab"] ( avoidStruts (tabbed shrinkText tabConfig) ) |||
    renamed [Replace "TallMaster"] ( avoidStruts ( Tall 1 (3/100) (1/2) )) |||
    -- Tall 1 (3/100) (1/2) |||
    renamed [Replace "WideMaster"] (avoidStruts ( Mirror (Tall 1 (3/100) (1/2)) )) |||
    -- Mirror (Tall 1 (3/100) (1/2)) |||
    -- avoidStruts ( ThreeColMid 1 (3/100) (1/2) ) |||
    renamed [Replace "TabTab"] ( avoidStruts ( windowNavigation (combineTwo (TwoPane (3/100) (1/2)) (tabbed shrinkText tabConfig) (tabbed shrinkText tabConfig) )) ) |||
    renamed [Replace "Grid"] (avoidStruts Grid) |||
    -- avoidStruts Full |||
    -- avoidStruts ( spiral (6/7)) ) |||
    -- avoidStruts noBorders (fullscreenFull Full) |||
    renamed [Replace "SuperFull"] (noBorders (fullscreenFull Full))
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll [
    className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()

{-
-- use xmobar as status bar, overriding the default config file path
myBar = "xmobar ~/.xmonad/xmobarrc.hs"

-- configuration of the status bar output generated by xmonad
myPP = xmobarPP { ppCurrent = xmobarColor "#181715" "#58C5F1" . wrap "[" "]"
                , ppTitle = xmobarColor "#14FF08" "" . shorten 120
                , ppVisible = xmobarColor "#58C5F1" "#181715" . wrap "(" ")"
                , ppUrgent = xmobarColor "#181715" "#D81816"
                , ppHidden = xmobarColor "#58C5F1" "#181715"
                , ppSep = " * "
                }

-- keybinding for toggling the gap for the statusbar (hiding the statusbar)
toggleGapsKey XConfig {XMonad.modMask = mod4Mask} = (mod4Mask, xK_b)
-}

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
-- main = xmonad =<< statusBar myBar myPP toggleGapsKey myConfig
-- main = xmonad defaults
main = do
    --xmonad $ defaults
    --xmproc <- spawnPipe "~/.xmonad/xmobarrc.hs"
    xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
    spawnPipe "xmobar ~/.xmonad/xmobarrc-top.hs"

    xmonad $ defaultConfig {
-- {-
    --xmonad $ defaults {
    --xmonad $ def {
        -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        layoutHook         = myLayout,
        --layoutHook = avoidStruts $ layoutHook defaultConfig,
        --layoutHook         = smartBorders $ myLayout,
        --layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
        -- The . thing combines several functions into one, in this case it will combine smartBorders with avoidStruts to give you the benefits of both.
        {-
        layoutHook = composeAll [
            myLayout--,
            --layoutHook defaultConfig
            ],
        -}

        -- handleEventHook    = myEventHook,
        --handleEventHook    = docksEventHook,
        handleEventHook    = myEventHook <+> docksEventHook,

        -- startupHook        = myStartupHook,
        --startupHook        = setWMName "LG3D",
        startupHook        = myStartupHook <+> setWMName "LG3D",

        -- The "manage hook" is the thing that decides how windows are supposed to appear.
        -- The <+> thing combines options for the manage hook.
        --
        --manageHook = myManageHook,
        --manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig,
        --manageHook = manageDocks <+> myManageHook,
        manageHook = composeAll [  --  composeAll will automatically combine every item in the list with the <+> operator.
            manageDocks,
            -- isFullscreen --> doFullFloat,
            -- className =? "Vlc" --> doFloat,
            myManageHook--,
            --manageHook defaultConfig
            ],
        -- NOTE: You can float your windows before fullscreening them. This is usually accomplished by holding down the modkey and left clicking on the window once. When you have floated the window, it can cover all other windows, including xmobar. So if you then try to fullscreen the window, it should cover the entire screen.

        --logHook            = myLogHook,
        logHook = dynamicLogWithPP  $ xmobarPP {
        --logHook = myLogHook <+> dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "#14FF08" "" . shorten 60,
            ppCurrent = xmobarColor "#181715" "#58C5F1" . wrap "[" "]",
            ppVisible = xmobarColor "#58C5F1" "#181715" . wrap "(" ")",
            ppUrgent = xmobarColor "#181715" "#D81816",
            ppHidden = xmobarColor "#58C5F1" "#181715",
            ppSep = " * "
            }

        -- } `additionalKeys` myKeys `removeKeys` [(mod4Mask, xK_q)]
        } `additionalKeys` [
            ((mod4Mask .|. shiftMask, xK_l), spawn "xlock -mode forest"),
            ((controlMask, xK_Print), spawn "sleep 0.2; scrot"),
            ((0, xK_Print), spawn "scrot")
            ]
-- -}

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
-- myConfig = def {
--defaults = def {
{-
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        --layoutHook         = smartBorders $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
-}

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
