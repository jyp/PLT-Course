
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
  let input =  "../Exercises/All.tex"
  need input
  _pdflatex input

html x = do
  let html = x ++ ".html"
      org = x ++ ".org"
  produce html $ do
    need org
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(setq org-export-headline-levels 2)",
                "--visit=" ++ org,
                "--funcall", "org-export-as-html-batch"]

tex = do
  produce "Lectures.pdf" $ do
    need "Lectures.org"
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(setq org-export-headline-levels 2)",
                "--visit=Lectures.org",
                "--funcall", "org-export-as-pdf"]
  

pub = system ["rsync", "-r", ".",
          "bernardy@remote11.chalmers.se:/chalmers/users/bernardy/www/www.cse.chalmers.se/pp/" -- Correct url.
          -- I don't use the "official" thing; see e-mail correspondence (Edu2009)
          -- bernardy@remote12.chalmers.se:/chalmers/groups/edu2009/www/www.cse.chalmers.se/course/DAT121
  ]

action = do
  exercises
  html "index"
  html "Schedule"
  html "Lectures"
  pub
  


