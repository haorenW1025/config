-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad hiding(config)
import Data.Monoid
import System.Exit

import Data.Tree
import System.Exit (exitSuccess)
import qualified Data.Map as M
import qualified XMonad.StackSet as W
-- layout

import XMonad.Layout.Decoration
import XMonad.Layout.LayoutModifier
import XMonad.Layout.WindowArranger
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows(boringWindows, focusUp, focusDown, focusMaster)

import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.ResizableThreeColumns

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Shell
import XMonad.Prompt.Zsh
import XMonad.Prompt.XMonad
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Window
import XMonad.Prompt.Man

-- hooks
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.ServerMode

-- Actions
-- import XMonad.Actions.Submap
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects
import XMonad.Actions.CopyWindow
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.TagWindows
import qualified XMonad.Actions.Search as S

-- util
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.DynamicScratchpads

import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified DBus as D
import qualified DBus.Client as D



-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal      = "alacritty"
myBrowser :: String
myBrowser       = "firefox"
myEditor :: String
myEditor        = "neovim"
myFont :: String
myFont          = "Monofur Nerd Font Mono"

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
myWorkspaces    = ["home","dev1","config1","web","remote","reading","dev2","config2","music","virtual"]


projects :: [Project]
projects =

    [ Project   { projectName       = "remote"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    sshPrompt myXPConfig
                }
    , Project   { projectName       = "dev1"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn "~/script/rofi/tmux_session.sh"
                }
    , Project   { projectName       = "dev2"
                , projectDirectory  = "~/workplace"
                , projectStartHook  = Just $ do
                    spawn "~/script/rofi/tmux_session.sh"
                }
    , Project   { projectName       = "web"
                , projectDirectory  = "~"
                , projectStartHook  = Just $ do
                    spawn "firefox"
                }
    , Project   { projectName       = "config1"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "~/script/rofi/edit_configs.sh"
                }
    , Project   { projectName       = "config2"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "~/script/rofi/edit_configs.sh"
                }
    , Project   { projectName       = "music"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do
                    spawn "spotify"
                }
    ]

myNormalBorderColor :: String
myNormalBorderColor  = "#81A1C1"
myFocusedBorderColor :: String
myFocusedBorderColor = "#BF616A"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myXPConfig :: XPConfig
myXPConfig = def
      { font                = "xft:Monofurbold Nerd Font:size=18:bold:antialias=true"
      , bgColor             = "#3B4252"
      , fgColor             = "#D8DEE9"
      , bgHLight            = "#8FBCBB"
      , fgHLight            = "#292929"
      , borderColor         = "#81A1C1"
      , promptBorderWidth   = 2
      , promptKeymap        = defaultXPKeymap
      , completionKey       = (controlMask, xK_n)
      , changeModeKey       = xK_Tab
      -- , position            = Top
      , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.5 }
      , height              = 50
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , showCompletionOnTab = False
      , alwaysHighlight     = False
      , maxComplRows        = Just 20
      , searchPredicate     = fuzzyMatch
      , sorter              = fuzzySort
      }


-- self defined prompt
spawnPrompt :: String -> XPConfig -> X ()
spawnPrompt c config =  do
    cmds <- io getCommands
    mkXPrompt Shell config (getShellCompl cmds $ searchPredicate config) run
    where run a = unsafeSpawn $ c ++ " " ++ a

activateCurrentProject :: X ()
activateCurrentProject = do
    project <- currentProject
    activateProject project




-- trigger current project hook

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myEZKeys :: [([Char], X ())]
myEZKeys =
        -- Prompt
        [ ("M-r x", xmonadPrompt myXPConfig)
        , ("M-r h", sshPrompt myXPConfig)
        , ("M-r w", windowPrompt myXPConfig Goto allWindows)
        , ("M-r S-w", windowPrompt myXPConfig Bring allWindows)
        , ("M-r C-w", windowPrompt myXPConfig BringCopy allWindows)
        , ("M-r c", spawn "~/script/rofi/edit_configs.sh")
        , ("M-r s", spawn "~/script/rofi/surfraw.sh")
        , ("M-r r", spawn "rofi -show drun -modi drun")
        , ("M-r e", spawn "rofi -show emoji -modi emoji")
        , ("M-r b", spawn "~/script/rofi/browser_bookmark.sh")
        , ("M-r m", manPrompt myXPConfig)
        , ("M-r t", spawn "~/script/rofi/tmux_session.sh")
        , ("M-r p", switchProjectPrompt myXPConfig)
        , ("M-r C-p", shiftToProjectPrompt myXPConfig)
        , ("M-r d", changeProjectDirPrompt myXPConfig)
        , ("M-r z", spawnPrompt ("alacritty" ++ " -e") myXPConfig)
        -- , ("M-r z", zshPrompt myXPConfig "$HOME/packages/zsh-capture-completion/capture.zsh")

        -- xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad
        , ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        -- applications
        , ("M-<Return>", spawn myTerminal)
        , ("M-b", spawn "firefox")
        , ("M-S-b", runOrCopy "firefox" (className =? "Firefox"))
        , ("M-a m", spawn "/snap/bin/spotify")
        -- emacs
        , ("M-e e", spawn "emacs") -- this is not illegal!
        , ("M-e o", spawn "emacs --funcall org-agenda-list")

        -- window
        , ("M-q", kill1)
        , ("M-l", windows W.focusDown)
        , ("M-h", windows W.focusUp)
        , ("M-m", focusMaster)
        , ("M-S-m", windows W.swapMaster)
        , ("M-S-l", windows W.swapDown)
        , ("M-S-h", windows W.swapUp)
        , ("M-j", sendMessage Shrink)
        , ("M-k", sendMessage Expand)
        , ("M-C-j", sendMessage MirrorShrink)
        , ("M-C-k", sendMessage MirrorExpand)
        , ("M-f", sendMessage $ Toggle FULL)

        -- workspace
        -- , ("M-S-w", TS.treeselectWorkspace myTSConfig myWorkspaces (\i -> W.greedyView i . W.shift i))
        , ("M-w h", windows $ W.greedyView "home")
        , ("M-w d", windows $ W.greedyView "dev1")
        , ("M-w c", windows $ W.greedyView "config1")
        , ("M-w r", windows $ W.greedyView "remote")
        , ("M-w w", windows $ W.greedyView "web")
        , ("M-w m", windows $ W.greedyView "music")
        , ("M-x", toggleWS)
        -- run project startup hook
        , ("M-S-<Return>",  activateCurrentProject)

        -- , ("M-w", TS.treeselectWorkspace myTSConfig myWorkspaces W.greedyView)


        , ("M-<Backspace>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-v", windows copyToAll)
        , ("M-S-v", killAllOtherCopies)
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
        , ("M-s l", namedScratchpadAction myScratchPads "file_manager")
        , ("M-s c", namedScratchpadAction myScratchPads "ytop")
        , ("M-s g", namedScratchpadAction myScratchPads "nvtop")
        , ("M-s p", withFocused $ makeDynamicSP "dyn1")
        , ("M-s S-p", spawnDynamicSP "dyn1")

        -- sublayout
        , ("M-'" , onGroup W.focusDown')
        , ("M-;" , onGroup W.focusUp')
        , ("M-t h" , sendMessage $ pullGroup L)
        , ("M-t l" , sendMessage $ pullGroup R)
        , ("M-t k" , sendMessage $ pullGroup U)
        , ("M-t j" , sendMessage $ pullGroup D)
        , ("M-t m" , withFocused (sendMessage . MergeAll))
        , ("M-t u" , withFocused (sendMessage . UnMerge))
        , ("<XF86AudioMute>",   spawn "amixer set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")

        -- utility
        , ("M-u 4", spawn "sleep 0.2; scrot -s -f")
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
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

myTabConfig::Theme
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
           $ windowNavigation
           $ boringWindows
           $ subLayout [] (tabs)
           $ addTabs shrinkText myTabConfig
           $ limitWindows 8
           $ mySpacing 4
           $ ResizableTall 1 (3/100) (1/2) []
mirrorTall = renamed [Replace "mirrorTall"]
           $ windowNavigation
           $ boringWindows
           $ subLayout [] (tabs)
           $ addTabs shrinkText myTabConfig
           $ limitWindows 8
           $ mySpacing 4
           $ Mirror
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20
           $ Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20
           $ simplestFloat
threeCol = renamed [Replace "threeCol"]
           $ windowNavigation
           $ boringWindows
           $ subLayout [] (tabs)
           $ addTabs shrinkText myTabConfig
           $ limitWindows 7
           $ mySpacing' 4
           $ ResizableThreeColMid 1 (1/10) (1/2) []
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig

-- combo    = tmsCombineTwoDefault (Tall 0 (3/100) 0) simpleTabbed         

-- The layout hook
myLayoutHook = avoidStruts $ mkToggle (MIRROR ?? FULL ?? EOT) $ T.toggleLayouts floats $ T.toggleLayouts monocle
               $ T.toggleLayouts tabs $ windowArrange
               $ myDefaultLayout
             where
               myDefaultLayout =     tall
                                 ||| mirrorTall 
                                 ||| threeCol
                                 ||| noBorders monocle

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
myManageHook :: Query(Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Peek"           --> doFloat
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
myEventHook = ewmhDesktopsEventHook
              <+> swallowEventHook (className =? "Alacritty" <||> className =? "Termite") (return True)

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
                , NS "ytop" spawnTop findTop manageTop
                , NS "spt" spawnSpt findSpt manageSpt
                , NS "file_manager" spawnlf findlf managelf
                , NS "nvtop" spawnNvtop findNvtop manageNvtop
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
    spawnNvtop  = myTerminal ++ " --class nvtop -e nvtop"
    findNvtop   = resource =? "nvtop"
    manageNvtop = customFloating $ W.RationalRect l t w h
                 where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnTop  = myTerminal ++ " --class ytop -e ytop"
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

-- myLogHook :: D.Client -> PP
-- myLogHook dbus = def
--     { ppOutput  = dbusOutput dbus
--     , ppCurrent = wrap ("%{F" ++ color4 ++ "} ") "%{F-}"
--     , ppVisible = \( _ ) -> ""
--     , ppUrgent  = \( _ ) -> ""
--     , ppHidden  = \( _ ) -> ""
--     , ppHiddenNoWindows= \( _ ) -> ""
--     , ppTitle   = wrap ("%{F" ++ color2 ++ "}")"%{F-}" . shorten 60
--     -- , ppTitle   = \( _ ) -> ""
--     , ppLayout = wrap ("%{F" ++ color1 ++ "} ") "%{F-}"
--     , ppSep     = "  |  "
--     }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main::IO()
main = do
    -- xmproc0 <- spawnPipe "xmobar -x 0 /home/whz861025/.config/xmobar/xmobarrc0"

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    -- -- Emit a DBus signal on log updates
-- dbusOutput :: D.Client -> String -> IO ()
-- dbusOutput dbus str = do
    --     let signal = (D.signal objectPath interfaceName memberName) {
    --             D.signalBody = [D.toVariant $ UTF8.decodeString str]
    --         }
    --     D.emit dbus signal
    -- where
    --     objectPath = D.objectPath_ "/org/xmonad/Log"
    --     interfaceName = D.interfaceName_ "org.xmonad.Log"
    --     memberName = D.memberName_ "Update"

    xmonad $ ewmh $ dynamicProjects projects $ docks $ def {
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
            mouseBindings      = myMouseBindings,

        -- hooks, layouts
            layoutHook         = myLayoutHook,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            startupHook        = myStartupHook
        } `additionalKeysP` myEZKeys
