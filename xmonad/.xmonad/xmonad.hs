import XMonad
import Data.Monoid
import Control.Monad
import System.Exit
import System.IO

import Control.Monad.Writer
import Graphics.X11.ExtraTypes.XorgDefault

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.Run
import XMonad.Util.EZConfig           -- "M-S-x" style keybindings

import XMonad.Hooks.UrgencyHook       -- For Urgency hint management

import XMonad.Hooks.DynamicLog        -- Allows for xmobar integration
import XMonad.Hooks.ManageDocks       -- For leaving space for xmobar

import XMonad.Hooks.ManageHelpers     -- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageHelpers.html

import Graphics.X11.Xinerama          -- For getting screen info

import XMonad.Actions.TopicSpace      -- For topic centered workspaces
import XMonad.Actions.CycleWS         -- For nextScreen
import XMonad.Actions.CycleRecentWS
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO

import XMonad.Actions.DynamicWorkspaceGroups

import XMonad.Actions.GridSelect

import XMonad.Util.WindowProperties

-- Layouts ---------------------------------------------------
import XMonad.Layout.LayoutHints
import XMonad.Layout.Tabbed
import XMonad.Layout.Renamed

-- Prompts ---------------------------------------------------
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.AppendFile       -- append stuff to my todo file

-- Local libs ------------------------------------------------
import LibNotifyUrgencyHook

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal  = "urxvt"
myShell     = "zsh"
browserCmd  = "firefox"
keepassCmd  = "keepass2"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#00ff00"


------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout =     avoidStrutsOn [U] $
    renamed [CutWordsLeft 1] . layoutHints $ tiled ||| Mirror tiled ||| renamed [Replace "Full"] simpleTabbed
        where
            tiled   = renamed [Replace "Tiled"] $ Tall nmaster delta ratio
            nmaster = 1
            delta   = 3/100
            ratio   = 2/3

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
    [
        isDialog                      --> doShift =<< currentWs,
        className =? "MPlayer"        --> doFloat,
        className =? "Pidgin"         --> doShift "talk",
        className =? "Icedove"        --> doShift "mail",
        className =? "Conkeror"       --> doShift "web",
        resource  =? "desktop_window" --> doIgnore,
        resource  =? "kdesktop"       --> doIgnore,
        manageDocks
    ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook h = dynamicLogWithPP $ xmobarPP {
        ppOutput = hPutStrLn h,
        ppCurrent = pad . xmobarColor "green" "" . wrap "λx." "",
        ppVisible = pad,
        ppHidden = const "",
        ppUrgent = xmobarColor "darkgreen" "green" . pad,
        ppTitle = xmobarColor "green" "" . shorten 256
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
myStartupHook = return ()


------------------------------------------------------------------------
-- Topic workspaces setup

-- The list of all topics/workspaces of your xmonad configuration.
-- The order is important, new topics must be inserted
-- at the end of the list if you want hot-restarting
-- to work.
myTopics :: [Topic]
myTopics =
  [ "dashboard" -- the first one
  , "dev"
  , "web", "mail", "talk", "music", "dokumente"
  , "keepass"
  ]

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
  { topicDirs = M.fromList $
      [ ("dashboard", "")
      , ("dev", "")
      , ("dokumente", "Dokumente")
      ]
  , defaultTopicAction = const (return ())
  , defaultTopic = "dashboard"
  , topicActions = M.fromList $
      [ ("dashboard",  spawnShell)
      , ("dev",        spawnShell >> spawn "gvim")
      , ("web",        spawn browserCmd)
      , ("keepass",    spawn keepassCmd)
      ]
  }

-- extend your keybindings
myKeymap conf =
    -- mod-[1..],       Switch to workspace N
    -- mod-shift-[1..], Move client to workspace N
    -- mod-ctrl-[1..],  Switch to workspace N on other screen
    [ (m ++ "M-" ++ [k], f i)
        | (i, k) <- zip (XMonad.workspaces conf) "1234567890-"
        , (f, m) <- [ (goto, "")
                    , (windows . W.shift, "S-")
                    , (\ws -> nextScreen >> (goto $ ws) >> prevScreen, "C-")
                    ]
    ]
    ++
    [
      ("M-a", currentTopicAction myTopicConfig)
    , ("M-g", promptedGoto)
    , ("M-C-g", promptedGotoOtherScreen)
    , ("M-S-g", promptedShift)
    , ("M-S-u", focusUrgent)
    ]
    ++
    -- rotate workspaces.
    [ ("M-C-<R>",   DO.swapWith Next NonEmptyWS)
    , ("M-C-<L>",   DO.swapWith Prev NonEmptyWS)
    , ("M-c", cycleRecentWS' [xK_Super_L] xK_c xK_x)
    ]
    ++
    -- workspace groups.
    [ ("M-y n", promptWSGroupAdd myXPConfig "Name this group: ")
    , ("M-y g", promptWSGroupView myXPConfig "Go to group: ")
    , ("M-y d", promptWSGroupForget myXPConfig "Forget group: ")
    ]
    ++
    -- prompts.
    [
      -- add single lines to my todo file from a prompt.
      ("M-w t", appendFilePrompt myXPConfig "/home/markus/todo")
      -- add single lines to my wiki Notes file from a prompt.
    , ("M-w n", appendFilePrompt myXPConfig "/home/markus/Notizen.mdwn")
    , ("M-p", runOrRaisePrompt myXPConfig)
    ]
    ++
    [ ( mask ++ [key], screenWorkspace s >>= flip whenJust (windows . action) )
           | (key, s) <- zip "xv" [0..]
           , (mask, action) <- [ ("M-", W.view)
                             , ("M-S-", W.shift) ]
    ]
    ++
    -- utilities.
    [
      ("<Print>", spawn "scrot")
    , ("C-<Print>", spawn "sleep 0.2; scrot -s")
    , ("M-S-z", spawn "xscreensaver-command -lock")
    ]
    ++
    [
      ("M-u", spawn "setxkbmap de")
    , ("M-a", spawn "setxkbmap de neo")
    ]


spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
spawnShellIn dir = spawn $ myTerminal ++ " -title urxvt -e sh -c 'cd ''" ++ dir ++ "'' && " ++ myShell ++ "'"

goto :: Topic -> X ()
goto = switchTopic myTopicConfig

promptedGotoOtherScreen :: X ()
promptedGotoOtherScreen = workspacePrompt myXPConfig $ \ws -> do
    nextScreen
    goto ws
    prevScreen

wsgrid = gridselect gsConfig <=< asks $ map (\x -> (x,x)) . workspaces . config

promptedGoto :: X ()
-- promptedGoto = workspacePrompt myXPConfig goto
promptedGoto = wsgrid >>= flip whenJust (switchTopic myTopicConfig)

promptedShift :: X ()
-- promptedShift = workspacePrompt myXPConfig $ windows . W.shift
promptedShift = wsgrid >>= \x -> whenJust x $ \y -> windows (W.greedyView y . W.shift y)

cycleRecentWS' = cycleWindowSets options
    where options w = map (W.view `flip` w) (recentTags w)
          recentTags w = map W.tag $ W.hidden w ++ [W.workspace (W.current w)]

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    h <- spawnPipe "xmobar"
    r <- getScreenRes ":0" 0
    checkTopicConfig myTopics myTopicConfig
    xmonad $ defaults h r

-- A structure representing screen info
--

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- defaults h r = myUrgencyHook (xRes r) (yRes r) $ defaultConfig {
defaults h r = withUrgencyHook LibNotifyUrgencyHook defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myTopics,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageHook defaultConfig,
        handleEventHook    = myEventHook,
        logHook            = myLogHook h,
        startupHook        = myStartupHook
    } `additionalKeysP` ( myKeymap $ defaults h r )

-- Gets the current resolution given a display and a screen
getScreenRes :: String -> Int -> IO Res
getScreenRes d n = do
    dpy <- openDisplay d
    r <- liftIO $ getScreenInfo dpy
    closeDisplay dpy
    return $ Res
        { xRes = fromIntegral $ rect_width $ r !! n
        , yRes = fromIntegral $ rect_height $ r !! n
        }

-- Screen Resolution
data Res = Res
    { xRes :: Int
    , yRes :: Int
    }

-- some nice colors for the prompt windows to match the dzen status bar.
myXPConfig = defaultXPConfig
    { fgColor = "#00ff00"
    , bgColor = "#003300"
    , borderColor = "#00ff00"
    }

gsConfig = defaultGSConfig { gs_navigate = fix $ \self ->
    let navKeyMap = M.fromList $
                [((0, xK_Escape), cancel)
                ,((0, xK_Return), select)
                ,((0, xK_slash ), substringSearch self)]
           ++
            map (\(k,a) -> (k,a >> self))
                [((0, xK_Left)         , move (-1,  0))
                ,((mod3Mask , xK_Left) , move (-1,  0))
                ,((0, xK_Right)        , move ( 1,  0))
                ,((mod3Mask, xK_Right) , move ( 1,  0))
                ,((0, xK_Down)         , move ( 0,  1))
                ,((mod3Mask, xK_Down)  , move ( 0,  1))
                ,((0, xK_Up)           , move ( 0, -1))
                ,((mod3Mask, xK_Up)    , move ( 0, -1))
                ,((0, xK_space)        , setPos (0,0))
                ]
    in makeXEventhandler $ shadowWithKeymap navKeyMap (const self)
    , gs_cellpadding = 10 }
