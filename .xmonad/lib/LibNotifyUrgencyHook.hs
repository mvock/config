module LibNotifyUrgencyHook ( LibNotifyUrgencyHook(..) ) where

import XMonad
import XMonad.StackSet
import XMonad.Hooks.UrgencyHook       -- For Urgency hint management
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name <- getName w
        ws <- gets windowset
        whenJust (findTag w ws) (flash name)
      where flash name index =
                safeSpawn "notify-send" [(show name ++ " requests your attention on workspace " ++ index)]

