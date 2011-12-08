
import Data.Monoid
import Cake

rules :: Rule
rules = empty

action = do
  produce "Lectures.html" $ do
    need "Lectures.org"
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(setq org-export-headline-levels 2)",
                "--visit=Lectures.org",
                "--funcall", "org-export-as-html-batch"]

  system ["rsync", "-r", ".",
          "bernardy@remote11.chalmers.se:/chalmers/users/bernardy/www/www.cse.chalmers.se/pp/"]


