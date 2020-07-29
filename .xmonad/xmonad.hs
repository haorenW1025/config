-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import System.Exit (exitSuccess)

import Data.Tree
import qualified Data.Map as M
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import qualified XMonad.StackSet as W
-- layout
import XMonad.Layout.Decoration
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Hidden
import XMonad.Layout.NoBorders
import XMonad.Layout.BoringWindows(boringWindows, focusUp, focusDown, focusMaster)

import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns

-- hooks
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize

-- Actions
-- import XMonad.Actions.Submap
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects

-- util
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"
myBrowser       = "firefox"
myEditor        = "neovim"
myFont          = "Monofur Nerd Font Mono"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 5

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
-- myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myWorkspaces :: Forest String
myWorkspaces = [ Node "Home" []
               , Node "Dev"
                [
                  -- a plugin that I'm constantly working on
                  Node "completion"[],
                  -- learning some haskell
                  Node "Haskell" [],
                  -- learning some rust
                  Node "Rust" []
                ]
               , Node "Web"
                [
                  Node "1"[],
                  Node "2"[]
                ]
               , Node "ssh" 
                [
                  Node "122"[],
                  Node "123"[],
                  Node "124"[],
                  Node "126"[],
                  Node "126 -p 1234"[],
                  Node "126 -p 9487"[]
                ]
               , Node "Reading" [] -- for all your programming needs
               , Node "Config" 
                [
                  Node "neovim"[],
                  Node "xmonad"[],
                  Node "polybar"[]
                ]
               ]

projects :: [Project]
projects =

    [ Project   { projectName       = "ssh.122"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e mosh --server=\'$HOME/.local/bin/mosh-server\' whz861025@140.112.175.122"
                }
    , Project   { projectName       = "ssh.123"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e mosh --server=\'$HOME/.local/bin/mosh-server\' whz861025@140.112.175.123"
                }
    , Project   { projectName       = "ssh.124"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e mosh --server=\'$HOME/.local/bin/mosh-server\' whz861025@140.112.175.124"
                }
    , Project   { projectName       = "ssh.126"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e ssh whz861025@140.112.175.126"
                }
    , Project   { projectName       = "ssh.126 -p 1234"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e ssh -p 1234 whz861025@140.112.175.126"
                }
    , Project   { projectName       = "ssh.126 -p 9487"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e ssh -p 9487 whz861025@140.112.175.126"
                }
    , Project   { projectName       = "Config.neovim"
                , projectDirectory  = "~/.config/nvim"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e nvim -c \"SLoad config\""
                }
    , Project   { projectName       = "Config.xmonad"
                , projectDirectory  = "~/.xmonad"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e nvim xmonad.hs"
                }
    , Project   { projectName       = "Dev"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn myTerminal
                }
    , Project   { projectName       = "Config.polybar"
                , projectDirectory  = "~/.config/polybar"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e nvim config"
                }
    , Project   { projectName       = "Dev.completion"
                , projectDirectory  = "~/.local/share/nvim/site/pack/packer/opt/completion-nvim/"
                , projectStartHook  = Just $ do
                    spawn "alacritty -e nvim -c \"SLoad completion\""
                }
    , Project   { projectName       = "Web"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn myBrowser
                }
    ]

myNormalBorderColor  = "#81A1C1"
myFocusedBorderColor = "#BF616A"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myTSConfig = TS.tsDefaultConfig { 
      TS.ts_hidechildren = True
    , TS.ts_font         = "xft:Monofurbold Nerd Font Mono:size=18:bold:antialias=true"
    , TS.ts_background   = 0xdd292d3e
    , TS.ts_node         = (0xffd0d0d0, 0xff202331)
    , TS.ts_nodealt      = (0xffd0d0d0, 0xff292d3e)
    , TS.ts_highlight    = (0xffffffff, 0xff755999)
    , TS.ts_extra        = 0xffd0d0d0
    , TS.ts_indent       = 80
    , TS.ts_navigate     = myTreeNavigation
}

myTreeNavigation = M.fromList
    [ ((0, xK_q),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    , ((mod4Mask, xK_h),        TS.moveTo ["Home"])
    , ((mod4Mask, xK_c),        TS.moveTo ["Config"])
    , ((mod4Mask, xK_w),        TS.moveTo ["Web"])
    , ((mod4Mask, xK_s),        TS.moveTo ["ssh"])
    , ((mod4Mask, xK_d),        TS.moveTo ["Dev"])
    , ((mod4Mask, xK_r),        TS.moveTo ["Reading"])
    ]


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myEZKeys :: [([Char], X ())]
myEZKeys =
        -- Rofi
        [ ("M-r r", spawn "rofi -show run -modi run")
        , ("M-r h", spawn "rofi -show ssh -modi ssh")
        , ("M-r w", spawn "rofi -show window -modi window")
        , ("M-r c", spawn "~/script/rofi/edit_configs.sh")
        , ("M-r s", spawn "~/script/rofi/surfraw.sh")
        , ("M-r d", spawn "rofi -show drun -modi drun")
        , ("M-r e", spawn "rofi -show emoji -modi emoji")
        , ("M-r b", spawn "~/script/rofi/browser_bookmark.sh")
        , ("M-r m", spawn "~/script/rofi/open_man.sh")
        -- xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad
        , ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        -- applications
        , ("M-<Return>", spawn myTerminal)
        , ("M-b", spawn "firefox")
        -- window
        , ("M-q", kill)
        , ("M-l", focusDown)
        , ("M-h", focusUp)
        -- , ("M-m", focusMaster)
        -- , ("M-S-m", windows W.swapMaster)
        , ("M-m", withFocused hideWindow)
        , ("M-S-m", popOldestHiddenWindow)
        , ("M-S-l", windows W.swapDown)
        , ("M-S-h", windows W.swapUp)
        , ("M-j", sendMessage Shrink)
        , ("M-k", sendMessage Expand)
        , ("M-w", withFocused $ windows . W.sink)
        , ("M-f", sendMessage $ Toggle FULL)
        -- workspace
        , ("M-C-l", nextWS)
        , ("M-C-h", prevWS)
        -- screen
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-C-.", shiftNextScreen >> nextScreen)
        , ("M-C-,", shiftPrevScreen >> prevScreen)
        , ("M-S-,", swapNextScreen >> nextScreen)
        , ("M-C-,", swapPrevScreen >> prevScreen)

        , ("M-S-t", TS.treeselectWorkspace myTSConfig myWorkspaces W.shift )
        , ("M-t", TS.treeselectWorkspace myTSConfig myWorkspaces W.greedyView)

        --scratchpads
        , ("M-s t", namedScratchpadAction myScratchPads "terminal")
        , ("M-s s", namedScratchpadAction myScratchPads "spt")
        , ("M-s l", namedScratchpadAction myScratchPads "file_manager")
        ]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- close focused window
    [
    -- , ((modm            ,   xK_q     ), kill)
     -- Rotate through the available layout algorithms
    ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- submap
    , ((modm .|. mod1Mask, xK_h), sendMessage $ pullGroup L)
    , ((modm .|. mod1Mask, xK_l), sendMessage $ pullGroup R)
    , ((modm .|. mod1Mask, xK_k), sendMessage $ pullGroup U)
    , ((modm .|. mod1Mask, xK_j), sendMessage $ pullGroup D)

    , ((modm .|. mod1Mask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. mod1Mask, xK_u), withFocused (sendMessage . UnMerge))

    , ((modm .|. shiftMask, xK_F4), spawn "sleep 0.2; scrot -s -f")
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    , ((modm .|. mod1Mask, xK_period), onGroup W.focusUp')
    , ((modm .|. mod1Mask, xK_comma), onGroup W.focusDown')
    -- Swap the focused window with the next window

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
    , ((modm, button3), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

myTabConfig = def { fontName            = "xft:Monofurbold Nerd Font Mono:bold:pixelsize=14"
                    , activeColor         = "#292d3e"
                    , inactiveColor       = "#3e445e"
                    , activeBorderColor   = "#292d3e"
                    , inactiveBorderColor = "#292d3e"
                    , activeTextColor     = "#ffffff"
                    , inactiveTextColor   = "#d0d0d0"
                    }

-- sublayout is nice
tall     = renamed [Replace "tall"]
           -- $ noBorders
           $ hiddenWindows
           $ windowNavigation
           $ boringWindows
           $ subLayout [] (tabs)
           $ addTabs shrinkText myTabConfig
           $ limitWindows 12
           $ mySpacing 10
           $ ResizableTall 1 (3/100) (1/2) []
mirrorTall = renamed [Replace "mirrorTall"]
           $ hiddenWindows
           $ windowNavigation
           -- $ noBorders
           $ boringWindows
           $ subLayout [] (tabs)
           $ addTabs shrinkText myTabConfig
           $ limitWindows 12
           $ mySpacing 10
           $ Mirror
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ noBorders
           $ limitWindows 20
           $ Full
floats   = renamed [Replace "floats"]
           $ noBorders
           $ limitWindows 20
           $ simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeColMid 1 (1/10) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
          
-- The layout hook
myLayoutHook = avoidStruts $ mkToggle (MIRROR ?? FULL ?? EOT)
               $ T.toggleLayouts floats
               $ myDefaultLayout
             where
               myDefaultLayout =     tall
                                 ||| mirrorTall 
                                 ||| noBorders monocle
                                 -- ||| threeCol

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
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Even The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = minimizeEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
          spawnOnce "~/script/autorun.sh" 


-- scratchpads
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "spt" spawnSpt findSpt manageSpt
                , NS "file_manager" spawnlf findlf managelf
                ]
    where
    spawnTerm  = myTerminal ++ " --class scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnSpt  = myTerminal ++ " --class spt -e spt"
    findSpt   = resource =? "spt"
    manageSpt = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnlf  = myTerminal ++ " --class file_manager -e lf"
    findlf   = resource =? "file_manager"
    managelf = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

color1, color2, color3, color4 :: String
color1 = "#B48EAD"
color2 = "#81A1C1"
color3 = "#900000"
color4 = "#EBCB8B"

myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput  = dbusOutput dbus
    , ppCurrent = wrap ("%{F" ++ color4 ++ "} ") "%{F-}"
    , ppVisible = \( _ ) -> ""
    , ppUrgent  = \( _ ) -> ""
    , ppHidden  = \( _ ) -> ""
    , ppHiddenNoWindows= \( _ ) -> ""
    , ppTitle   = wrap ("%{F" ++ color2 ++ "}")"%{F-}" . shorten 30
    -- , ppTitle   = \( _ ) -> ""
    , ppLayout = wrap ("%{F" ++ color1 ++ "} ") "%{F-}"
    , ppSep     = "  |  "
    }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main::IO()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad $ dynamicProjects projects $ docks $ defaults { logHook = workspaceHistoryHook <+> dynamicLogWithPP (myLogHook dbus) }

    -- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
        let signal = (D.signal objectPath interfaceName memberName) {
                D.signalBody = [D.toVariant $ UTF8.decodeString str]
            }
        D.emit dbus signal
    where
        objectPath = D.objectPath_ "/org/xmonad/Log"
        interfaceName = D.interfaceName_ "org.xmonad.Log"
        memberName = D.memberName_ "Update"

defaults = def {
        -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            clickJustFocuses   = myClickJustFocuses,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = TS.toWorkspaces myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,

        -- key bindings
            keys               = myKeys,
            mouseBindings      = myMouseBindings,

        -- hooks, layouts
            layoutHook         = myLayoutHook,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            startupHook        = myStartupHook
        } `additionalKeysP` myEZKeys

