
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
        
cp a b = system ["cp",a,b]        
        
exercises = produce "All.pdf" $ do    
  let input =  "../New/Exercises/All.tex"
  need input
  _pdflatex input

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

pub = system ["rsync", "-r", ".",
          "bernardy@remote13.chalmers.se:/chalmers/users/bernardy/www/www.cse.chalmers.se/pp/"]

action = do
  exercises
  html
  pub
  


