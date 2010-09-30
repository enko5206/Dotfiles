--------------------------------------------------------------------------------
--                                                                            --
-- ~/.xmonad/xmonad.hs                                                        --
-- author: enko (based on original file by pbrisbin)                          --
-- last modified: 26/06/2010                                                  --
--                                                                            --
--------------------------------------------------------------------------------
--
-- /*IMPORTS*/ -- {{{
--
-- actions
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows (rotFocusedUp, rotFocusedDown)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WithAll (killAll,withAll,withAll')

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook

-- layout
import XMonad.Layout.IM
import XMonad.Layout.LayoutHints (layoutHintsWithPlacement)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane

-- util
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers (maildirNew,dzenColorL,wrapL)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.WindowProperties (getProp32s)

-- other
import Data.List
import Data.Monoid
import Data.Ratio
 
import System.IO
import System.Exit
 
import qualified Data.Map as M
import qualified XMonad.StackSet as W
--
-- }}}
--
-- /*STUFF*/ -- {{{
--
-- variables
myTerminal              = "urxvt"
myWorkspaces            = ["1:main","2:web","3:im","4:text"] ++ map show [6..9]
myModMask               = mod4Mask
myBorderWidth           = 0
-- myFont                  = "-*-fixed-*-*-*-*-12-*-*-*-*-*-iso10646-*"
myFont                  = "Consolas-8"

-- tab theme
myTabConfig             = defaultTheme {activeColor         = colorBG
                                       ,inactiveColor 	    = colorBG
                                       ,activeBorderColor   = colorFG
                                       ,inactiveTextColor   = colorFG
                                       ,inactiveBorderColor = colorFG2
                                       ,activeTextColor	    = colorFG3
                                       ,fontName            = " ++ myFont ++ "
                                       }

-- colors
myNormalBorderColor     = colorBG
myFocusedBorderColor    = colorFG3
colorBG                 = "#303030" -- gray
colorFG                 = "#606060" -- light gray
colorFG2                = "#909090" -- more light gray
colorFG3                = "#C4DF90" -- yellow/green
colorUrg                = "#FFA500" -- orange 
--
-- }}}
--
-- /*KEYBINDINGS*/ -- {{{
--
myKeys = [("M-<Return>", spawn  myTerminal                     ) 
        , ("M-S-m"     , spawn  myMail                         )
        , ("M-S-a"     , spawn  myVolmixer                     )
        , ("M-S-i"     , spawn  myChat                         )
        , ("M-w"       , spawn  myWallpapers                   )
        , ("M-S-l"     , spawn  myLock                         )
        , ("M-p"       , spawn  myDmenu                        )
        , ("<Print>"   , spawn  myShot                         )

        , ("M-S-p"     , spawn "gmrun"                         )
        , ("M-f"       , spawn "firefox"                       )
        , ("M-d"       , spawn "nautilus --no-desktop"         )
        , ("M-g"       , spawn "gedit"                          )
        , ("M-`"       , spawn "eject -T /dev/sr0"             )

        , ("M-v"       , spawn "mpc toggle"                    )  
        , ("M-b"       , spawn "mpc prev"                      ) 
        , ("M-n"       , spawn "mpc next"                      ) 
        
        , ("M-<U>"     , spawn "amixer -q set Master 2+ unmute")
		, ("M-<D>"     , spawn "amixer -q set Master 2- unmute")
        
        , ("M-S-c"     , kill                                  )  
        , ("M-<Space>" , sendMessage NextLayout                ) 
        , ("M-<Tab>"   , windows W.focusDown                   ) 
        , ("M-j"       , windows W.focusDown                   ) 
        , ("M-k"       , windows W.focusUp                     ) 
        , ("M-m"       , windows W.focusMaster                 ) 
        , ("M-S-j"     , windows W.swapDown                    ) 
        , ("M-S-k"     , windows W.swapUp                      ) 
        , ("M-h"       , sendMessage Shrink                    ) 
        , ("M-l"       , sendMessage Expand                    )
        , ("M-t"       , withFocused $ windows . W.sink        )
        , ("M-S-<R>"   , shiftToNext >> nextWS                 )
        , ("M-S-<L>"   , shiftToPrev >> prevWS                 )
        , ("M-c"       , moveTo Next (WSIs (return $ not . (=="SP") . W.tag))) 
        , ("M-x"       , moveTo Prev (WSIs (return $ not . (=="SP") . W.tag))) 

        , ("M-q"       , spawn myRestart                       )         
        , ("M-S-q"     , spawn myReboot                        ) 
        , ("M-C-x"     , spawn myShutdown                      ) 
        ]
        where
          myVolmixer   =  myTerminal ++ " -e alsamixer"
          myChat       =  myTerminal ++ " -e mcabber"
          myMail       =  myTerminal ++ " -e mutt"
          myDmenu      = "dmenu_run -fn '" ++ myFont ++ "' -nb '" ++ colorBG ++ "' -nf '" ++ colorFG ++ "' -sb '" ++ colorFG2 ++ "' -sf '" ++ colorBG ++ "'"
          myLock       = "xscreensaver-command -l"
          myShot       = "scrot -c -d -m '%d-%m-%Y_%H%M%S.png' -e 'mv $f /home/enko/Pictures/screenshots/'"
          myWallpapers = "feh -r -F -V -d -Z /home/enko/Pictures/wallpapers"
          myRestart    = "for pid in `pgrep conky`; do kill -9 $pid; done && " ++
                         "for pid in `pgrep dzen2`; do kill -9 $pid; done && " ++
                         "xmonad --recompile && xmonad --restart "
          myReboot     = "sudo shutdown -r now"
          myShutdown   = "sudo shutdown -h now"
--
-- }}}
--                       
-- /*LAYOUTS*/ -- {{{
--
-- > xprop | grep WM_CLASS
--
myLayout = avoidStruts $ smartBorders$ onWorkspace "3:im" imLayout
                       $ standardLayouts
  where
    
    standardLayouts = tiled ||| Mirror tiled ||| full ||| tabs

    -- im roster on left tenth, standardLayouts in other nine tenths
    imLayout        = withIM (1/10) imProp standardLayouts

    -- WMROLE = "roster" is Gajim.py's buddy list
    imProp          = Role "roster"

    tiled           = hinted $ ResizableTall nmaster delta ratio []
    full            = hinted $ noBorders Full

    -- like hintedTile but for any layout
    hinted l        = layoutHintsWithPlacement (0,0) l

    nmaster         = 1
    delta           = 3/100
    ratio           = toRational $ 2/(1 + sqrt 5 :: Double) -- golden ratio
    tabs            = hinted (tabbedBottom shrinkText myTabConfig) 
--
-- }}}
--
-- /*MANAGEHOOK*/ -- {{{
--
myManageHook = (composeAll . concat $
  [ [resource  =? r                 --> doIgnore         |  r    <- myIgnores] -- ignore desktop
  , [className =? c                 --> doShift "2:web"  |  c    <- myWebs   ] -- move webs to web
  , [className =? c                 --> doShift "4:text" |  c    <- myText   ] -- move to text
  , [title     =? t                 --> doShift "3:im"   |  t    <- myChats  ] -- move chats to chat
  , [className =? c                 --> doShift "3:im"   | (c,_) <- myIMs    ] -- move chats to chat
  , [className =? c <&&> role /=? r --> doFloat          | (c,r) <- myIMs    ] -- float all ims but roster
  , [className =? c                 --> doFloat          |  c    <- myFloats ] -- float my floats
  , [className =? c                 --> doCenterFloat    |  c    <- myCFloats] -- float my floats
  , [name      =? n                 --> doFloat          |  n    <- myNames  ] -- float my names
  , [name      =? n                 --> doCenterFloat    |  n    <- myCNames ] -- float my names
  , [isFullscreen                   --> myDoFullFloat                        ]
  ]) <+> manageTypes <+> manageDocks

  where

    role      = stringProperty "WM_WINDOW_ROLE"
    name      = stringProperty "WM_NAME"

    -- [ ("class1","role1"), ("class2","role2"), ... ]
    myIMs     = [("Gajim.py","roster")]

    -- titles
    myChats   = ["mcabber","mutt"]

    -- classnames
    myFloats  = ["MPlayer","Zenity","VirtualBox","rdesktop"]
    myCFloats = ["Xmessage","Save As...","XFontSel"]

    myWebs    = ["Navigator","Shiretoko","Firefox"]     ++
                ["Uzbl","uzbl","Uzbl-core","uzbl-core"] ++
                ["Google-chrome","Chromium-browser"]
                
    myText    = ["Gvim"]
    
    -- resources
    myIgnores = ["desktop","desktop_window"]

    -- names
    myNames   = ["Google Chrome Options","Chromium Options"]
    myCNames  = ["bashrun"]

-- a trick for fullscreen but stil allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat

-- modified version of manageDocks
manageTypes :: ManageHook
manageTypes = checkType --> doCenterFloat

checkType :: Query Bool
checkType = ask >>= \w -> liftX $ do
  m   <- getAtom    "_NET_WM_WINDOW_TYPE_MENU"
  d   <- getAtom    "_NET_WM_WINDOW_TYPE_DIALOG"
  u   <- getAtom    "_NET_WM_WINDOW_TYPE_UTILITY"
  mbr <- getProp32s "_NET_WM_WINDOW_TYPE" w

  case mbr of
    Just [r] -> return $ elem (fromIntegral r) [m,d,u]
    _        -> return False
--
-- }}}
--
-- /*DZEN2 STATUSBAR*/ -- {{{
--
makeDzen :: Int -> Int -> Int -> Int -> String -> String
makeDzen x y w h a = "dzen2 -p" ++
                     " -ta " ++ a ++
                     " -x " ++ show x ++
                     " -y " ++ show y ++
                     " -w " ++ show w ++
                     " -h " ++ show h ++
                     " -fn '" ++ myFont ++ "'" ++
                     " -fg '" ++ colorFG ++ "'" ++
                     " -bg '" ++ colorBG ++ "' -e 'onstart=lower'"

myDzenGenOpts           = "-fg '" ++ colorFG ++ "' -bg '" ++ colorBG ++ "' -fn '" ++ myFont ++ "' -h '15'"
myStatusBar             = "dzen2 -x 0 -y 0 -w 970 -ta l " ++ myDzenGenOpts
myConkyBar              = "conky -c .dzenconkyrc | dzen2 -p -ta r -x 970 -y 0 -w 1366 " ++ myDzenGenOpts
myMPDBar                = "conky -c .dzenmpdrc | dzen2 -p -ta l -y 785 -w 1366 " ++ myDzenGenOpts
 
myLogHook :: Handle -> X ()
myLogHook h   = (dynamicLogWithPP $ defaultPP
  { ppCurrent = dzenColor colorBG colorFG2 . pad
  , ppUrgent  = dzenColor colorBG colorUrg . dzenStrip
  , ppLayout  = dzenFG colorFG2 . myRename
  , ppHidden  = dzenFG colorFG2 . noScratchPad
  , ppTitle   = shorten 100
  , ppHiddenNoWindows = namedOnly
  , ppSep     = " "
  , ppWsSep   = ""
  , ppOutput  = hPutStrLn h
  }) >> updatePointer (Relative 0.95 0.95) >> myFadeInactive 0.75
  where
    -- thanks byorgey (this filters out NSP too)
    namedOnly ws = if any (`elem` ws) ['a'..'z'] then pad ws else ""
 
    -- my own filter out scratchpad function
    noScratchPad ws = if all (`elem` ws) "NSP" then "" else pad ws
 
    -- L needed for loggers
    dzenFG c  = dzenColor c ""
    dzenFGL c = dzenColorL c ""
    
    myRename  = (\x -> case x of
               "Hinted ResizableTall" -> "/ /-/ "
               "Mirror Hinted ResizableTall" -> "/-,-/ "
               "Hinted Tabbed Bottom Simplest" -> "/.../ "
               "Hinted TwoPane" -> "/ / / "
               "Hinted Full" -> "/  / "
               
               _ -> x ++ " "
               ) . stripIM
 
    stripIM s = if "IM " `isPrefixOf` s then drop (length "IM ") s else s
--
-- }}}
--
-- /*OTHER*/ -- {{{
-- 
-- FadeInactive *HACK* --
--
-- you can probably just use the standard:
--
-- >> fadeInactiveLogHook (Ratio)
--
-- i use this rewrite that checks layout, because xcompmgr is
-- epic fail for me on some layouts
--
 
-- sets the opacity of inactive windows to the specified amount
-- *unless* the current layout is full or tabbed
myFadeInactive :: Rational -> X ()
myFadeInactive = fadeOutLogHook . fadeIf (isUnfocused <&&> isGoodLayout)
 
-- returns True if the layout description does not contain words
-- "Full" or "Tabbed"
isGoodLayout:: Query Bool
isGoodLayout = liftX $ do
  l <- gets (description . W.layout . W.workspace . W.current . windowset)
  return $ not $ any (`isInfixOf` l) ["Full","Tabbed"]

-- MySpawnHook *HACK* --
--
-- spawn an arbitrary command on urgent
--
data MySpawnHook = MySpawnHook String deriving (Read, Show)
 
instance UrgencyHook MySpawnHook where
    urgencyHook (MySpawnHook s) w = spawn $ s
 
-- 'ding!' on urgent (gajim has fairly unnannoying sounds thankfully)
myUrgencyHook = MySpawnHook "aplay /usr/share/gajim/data/sounds/bounce.wav"
--
-- }}}
--
-- /*MAIN*/ -- {{{
--
main = do
  d <- spawnPipe myStatusBar
  spawn myConkyBar
  spawn myMPDBar
  spawn "xcompmgr"
  -- and finally start xmonad:
  xmonad $ withUrgencyHook myUrgencyHook $ defaultConfig
    { terminal           = myTerminal
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , layoutHook         = myLayout
    , manageHook         = myManageHook
    , logHook            = myLogHook d
    } `additionalKeysP` myKeys
--
-- }}}

