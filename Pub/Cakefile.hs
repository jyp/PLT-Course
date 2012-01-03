
import Data.Monoid
import Cake

rules :: Rule
rules = empty

agenda = do
  produce "Agenda.html" $ do
    need "Schedule.org"
    cut $ do
      system ["emacs",
--              "--batch",
              "--eval",  "(org-batch-store-agenda-views " ++             
                          "org-agenda-span month "++                   
                          "org-agenda-start-day \"2011-11-01\" "++
                          "org-agenda-include-diary nil "++ 
                          "org-agenda-files (quote (\"Schedule.org\")))"
      --              "--kill"
              ]
        

html = do
  produce "Lectures.html" $ do
    need "Lectures.org"
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(setq org-export-headline-levels 2)",
                "--visit=Lectures.org",
                "--funcall", "org-export-as-html-batch"]

action = do
  html
  system ["rsync", "-r", ".",
          "bernardy@remote11.chalmers.se:/chalmers/users/bernardy/www/www.cse.chalmers.se/pp/"]


