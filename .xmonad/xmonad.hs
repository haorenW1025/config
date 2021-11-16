-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad hiding(config)
import qualified XMonad.StackSet as SS
import Data.Monoid
import System.Exit

import Data.Tree
import System.Exit (exitSuccess)
-- import qualified Data.Map as M
import qualified Data.Map.Strict as M
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.StackSet as W
import XMonad.Config.Desktop
-- layout

import XMonad.Layout.Decoration
import XMonad.Layout.WindowArranger
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
-- import XMonad.Layout.SubLayouts (pushGroup, pullGroup, pushWindow, pullWindow, onGroup, toSubl, mergeDir, GroupMsg(..), Broadcast(..), defaultSublMap)
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows(boringWindows, focusUp, focusDown, focusMaster)
import XMonad.Layout.Gaps
import XMonad.Layout.Accordion
import XMonad.Layout.Simplest
import XMonad.Layout.Hidden
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.Decoration(Decoration, DefaultShrinker)
import XMonad.Layout.LayoutModifier(LayoutModifier(handleMess, modifyLayout,
                                    redoLayout),
                                    ModifiedLayout(..))
import XMonad.Util.Invisible(Invisible(..))
import qualified XMonad.Util.ExtensibleConf as XC




import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
-- import XMonad.Layout.Simplest
import XMonad.Layout.Simplest(Simplest(..))
import XMonad.Layout.NoFrillsDecoration

-- Prompt
import XMonad.Prompt
-- import XMonad.Prompt.Unicode
import XMonad.Prompt.Ssh
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Window
import XMonad.Prompt.Man

-- hooks
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ServerMode
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.RefocusLast

-- Actions
-- import XMonad.Actions.Submap
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects
import XMonad.Actions.CopyWindow
import XMonad.Actions.PerWorkspaceKeys
import qualified XMonad.Actions.WindowBringer as WB
import qualified XMonad.Actions.Search as S

-- util
import XMonad.Util.WorkspaceCompare
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Themes
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.Dmenu
import qualified XMonad.Util.Hacks as Hacks




-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "alacritty"
myBrowser :: String
myBrowser  = "firefox"
myEditor :: String
myEditor   = "neovim"
myFont :: String
myFont     = "Monofur Nerd Font Mono"
myBaseConfig = desktopConfig

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
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
myWorkspaces :: [[Char]]
myWorkspaces    = ["\61461", "\62601","\59286","\61612","\63114","\58923","\61822","\63215","\61441"]
--myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
-- myWorkspaces    = ["home","dev1","config1","web","remote","reading","dev2","config2","music","virtual"]


projects :: [Project]
projects =

    [ Project   { projectName       = "\62601"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn myTerminal
                }
    , Project   { projectName       = "\59286"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn myTerminal
                }
    , Project   { projectName       = "\63114"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn myBrowser
                }
    , Project   { projectName       = "\61612"
                , projectDirectory  = "~"
                , projectStartHook  = Just $ do
                    spawn myBrowser
                }
    , Project   { projectName       = "\61822"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "skypeforlinux"
                }
    , Project   { projectName       = "\63215"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "thunderbird"
                }
    , Project   { projectName       = "\61441"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "spotify"
                }
    ]

myNormalBorderColor :: String
myNormalBorderColor  = "#BD93F9"
myFocusedBorderColor :: String
myFocusedBorderColor = "#FF5555"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myTabConfig = def { fontName            =  "xft:Monofurbold Nerd Font Mono:size=10:bold:antialias=true"
                 , activeColor         = "#8be9fd"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#8be9fd"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- define a custom function which activate the project startup event
activateCurrentProject :: X ()
activateCurrentProject = do
    project <- currentProject
    activateProject project

-- Make a windowBringer variant of bring & copy
bringCopyWindow :: Window -> WindowSet -> WindowSet
bringCopyWindow w ws = copyWindow w (W.currentTag ws) ws

bringCopyMenuConfig :: WB.WindowBringerConfig -> X ()
bringCopyMenuConfig wbConfig = WB.actionMenu wbConfig bringCopyWindow

bringCopyMenuArgs :: [String] -> X ()
bringCopyMenuArgs args = bringCopyMenuConfig def { WB.menuArgs = args }

-- Key bindings. Add, modify or remove key bindings here.
--
myEZKeys :: [([Char], X ())]
myEZKeys =
        -- Prompt
        [("M-r w", WB.gotoMenuArgs ["-l", "20", "-z", "1200", "-p", "Goto:"])
        , ("M-r S-w", WB.bringMenuArgs ["-l", "20", "-z", "1200", "-p", "Bring:"])
        , ("M-r C-w", bringCopyMenuArgs ["-l", "20", "-z", "1200", "-p", "Bring Copy:"])
        , ("M-r r", spawn "rofi -show drun")
        , ("M-r c", spawn "~/script/rofi/edit_configs.sh")
        , ("M-r s", spawn "~/script/rofi/sshmenu")

        -- xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad
        , ("M-C-r", spawn "xmonad --recompile && xmonad --restart")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        -- applications
        , ("M-<Return>", spawn myTerminal)
        , ("M-b", spawn myBrowser)
        , ("M-S-b", runOrCopy  myBrowser(className =? myBrowser))
        -- , ("M-a m", spawn "/snap/bin/spotify")
        -- emacs
        , ("M-e e", spawn "emacs") -- this is not illegal!
        , ("M-e o", spawn "emacs --funcall org-agenda-list")

        -- window
        , ("M-q", kill1)
        , ("M-l", focusDown)
        , ("M-h", focusUp)
        , ("M-m", focusMaster)
        , ("M-S-m", windows W.swapMaster)
        , ("M-S-l", windows W.swapDown)
        , ("M-S-h", windows W.swapUp)
        , ("M-j", sendMessage Shrink)
        , ("M-k", sendMessage Expand)
        , ("M-x", toggleFocus)
        , ("M-C-j", sendMessage MirrorShrink)
        , ("M-C-k", sendMessage MirrorExpand)
        , ("M-S-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-f", sendMessage (MT.Toggle NBFULL) )
        , ("M-d", decWindowSpacing 4)           -- Decrease window spacing
        , ("M-i", incWindowSpacing 4)           -- Increase window spacing
        , ("M-g", sendMessage $ ToggleGaps) -- Toggles noborder/full

        , ("M-n", withFocused hideWindow)
        , ("M-S-n", popOldestHiddenWindow)
        , ("M-S-x", toggleWS' ["NSP"])
        -- run project startup hook
        , ("M-S-<Return>",  activateCurrentProject)


        , ("M-<Backspace>", withFocused $ windows . W.sink) -- Push floating window back to tile
        -- layout
        , ("M-<Space>", sendMessage NextLayout)
        -- screen
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-C-.", shiftNextScreen >> nextScreen)
        , ("M-C-,", shiftPrevScreen >> prevScreen)
        , ("M-S-,", swapNextScreen >> nextScreen)
        , ("M-C-,", swapPrevScreen >> prevScreen)

        --scratchpads
        , ("M-s t", namedScratchpadAction myScratchPads "terminal")
        , ("M-s s", namedScratchpadAction myScratchPads "spt")
        , ("M-s f", namedScratchpadAction myScratchPads "file_manager")
        , ("M-s c", namedScratchpadAction myScratchPads "ytop")
        , ("M-s g", namedScratchpadAction myScratchPads "nvtop")
        , ("M-s p", namedScratchpadAction myScratchPads "pulsemixer")

        -- sublayout
        , ("M-'" , onGroup W.focusDown')
        , ("M-;" , onGroup W.focusUp')
        , ("M-S-<Space>" , toSubl NextLayout)
        , ("M-t h" , sendMessage $ pullGroup L)
        , ("M-t l" , sendMessage $ pullGroup R)
        , ("M-t k" , sendMessage $ pullGroup U)
        , ("M-t j" , sendMessage $ pullGroup D)
        , ("M-t m" , withFocused (sendMessage . MergeAll))
        , ("M-t u" , withFocused (sendMessage . UnMerge))
        , ("<XF86AudioMute>",   spawn "amixer -q set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 2%-")
        , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 2%+")
        , ("<XF86AudioPlay>", spawn $ "playerctl play-pause")
        , ("<XF86AudioNext>", spawn $ "playerctl next")
        , ("<XF86AudioPrev>", spawn $ "playerctl previous")
        , ("<XF86AudioStop>", spawn $ "playerctl stop")

        -- utility
        , ("M-u 4", spawn "sleep 0.2; scrot -s -f -e 'mv $f ~/Pictures/'")
        , ("M-u 3", spawn "peek")
        ]
        ++
        [ (otherModMasks ++ "M-" ++ key, action tag)
            | (tag, key)  <- zip myWorkspaces (map (\x -> "<F" ++ show x ++ ">") [1..12])
            , (otherModMasks, action) <- [ ("", windows . W.greedyView) -- or W.view
                                     , ("S-", windows . W.shift)]
        ]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:
mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           -- $ addTabs shrinkText myTabConfig $ subLayout [] Simplest
           -- $ boringWindows
           $ hiddenWindows
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
mag  = renamed [Replace "magnify"]
           $ smartBorders
           $ windowNavigation
           $ hiddenWindows
           $ magnifier
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           -- $ addTabs shrinkText myTabConfig $ subLayout [] Simplest
           -- $ boringWindows
           $ windowNavigation
           $ hiddenWindows
           $ mySpacing 8
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)

-- The layout hook
myLayoutHook = avoidStruts $ windowArrange $ T.toggleLayouts floats
               $ addTabs shrinkText myTabConfig $ subLayout [] Simplest
               $ boringWindows
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout = tall
                                 ||| Mirror tall
                                 ||| mag
                                 ||| threeCol

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
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     -- , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     -- , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     -- , className =? "brave-browser"   --> doShift ( myWorkspaces !! 1 )
     -- , className =? "qutebrowser"     --> doShift ( myWorkspaces !! 1 )
     -- , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     -- , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
     -- , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Even The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = ewmhDesktopsEventHook <+> swallowEventHook (className =? "Alacritty" <||> className =? "Termite") (return True)
-- refocusLastEventHook prevent xmonad from changing focus to the first tab when closing a floating window
myEventHook = refocusLastEventHook <+> swallowEventHook (className =? "Alacritty") (return True)
    where
        refocusLastEventHook = refocusLastWhen isFloat
-- myEventHook = refocusLastEventHook <+> ewmhDesktopsEventHook <+> swallowEventHook (className =? "Alacritty") (return True)
--     where
--         refocusLastEventHook = refocusLastWhen isFloat

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
myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"


-- scratchpads
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "ytop" spawnTop findTop manageTop
                , NS "spt" spawnSpt findSpt manageSpt
                , NS "file_manager" spawnlf findlf managelf
                , NS "nvtop" spawnNvtop findNvtop manageNvtop
                , NS "pulsemixer" spawnpulse findpulse managepulse
                ]
    where
    spawnTerm  = myTerminal ++ " --class scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.8
                 w = 0.8
                 t = 0.95 -h
                 l = 0.95 -w
    spawnNvtop  = myTerminal ++ " --class nvtop -e nvtop"
    findNvtop   = resource =? "nvtop"
    manageNvtop = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnTop  = myTerminal ++ " --class ytop -e bpytop"
    findTop   = resource =? "ytop"
    manageTop = customFloating $ W.RationalRect l t w h
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
    spawnlf  = "kitty --class=file_manager --listen-on=unix:\"$TMPDIR/kitty\" nnn"
    findlf   = resource =? "file_manager"
    managelf = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnpulse  = myTerminal ++ " --class pulsemixer -e pulsemixer"
    findpulse   = resource =? "pulsemixer"
    managepulse = customFloating $ W.RationalRect l t w h
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

-- Run xmonad with the settings you specify. No need to modify this.
--
myFilter = filterOutWs [scratchpadWorkspaceTag]
main::IO()
main = do

    xmonad $ addEwmhWorkspaceSort (pure myFilter) $ ewmh $ Hacks.javaHack $ dynamicProjects projects $ docks $ def {
        -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            clickJustFocuses   = myClickJustFocuses,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
            mouseBindings      = myMouseBindings,
            -- hooks, layouts
            layoutHook         =  myLayoutHook,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            startupHook        = myStartupHook,
            logHook = refocusLastLogHook >> nsHideOnFocusLoss myScratchPads
        } `additionalKeysP` myEZKeys
