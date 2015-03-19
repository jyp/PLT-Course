
import Data.Monoid
import Cake
import System.Directory
import Control.Monad.IO.Class

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
        
prep = do 
  need p
  produce "../Exercises/Preprocessor" $ do
    cut $ system ["ghc","--make",p]
  where p = "../Exercises/Preprocessor.hs"
  
exercises withAnswers target = produce target $ do
  prep
  let input =  "../Exercises/All.tex"
  let intermediate = "../Exercises/P.tex"
  need input
  cut $ do
    system ["../Exercises/Preprocessor", show withAnswers, input, intermediate]
    liftIO $ setCurrentDirectory "../Exercises"   -- So that pdflatex sees includes, etc.
    system ["pdflatex", "-shell-escape", intermediate]
    liftIO $ setCurrentDirectory "../Pub"
    cp "../Exercises/P.pdf" target

html x = do
  let html = x ++ ".html"
      org = x ++ ".org"
  produce html $ do
    need org
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(progn (require 'org) (require 'org-exp) (setq org-export-headline-levels 2))",
                "--visit=" ++ org,
                "--funcall", "org-html-export-to-html"]

tex = do
  produce "Lectures.pdf" $ do
    need "Lectures.org"
    -- todo: chase includes
    cut $ 
        system ["emacs", 
                "--batch", 
                "--eval", "(setq org-export-headline-levels 2)",
                "--visit=Lectures.org",
                "--funcall", "org-latex-export-to-pdf"]

pub = system ["rsync", "--chmod=a+r", "-r", ".",
          "bernardy@remote11.chalmers.se:/chalmers/users/bernardy/www/www.cse.chalmers.se/pp/" -- Correct url.
          -- I don't use the "official" thing; see e-mail correspondence (Edu2009)
          -- bernardy@remote12.chalmers.se:/chalmers/groups/edu2009/www/www.cse.chalmers.se/course/DAT121
  ]
      
htmlAll = do
  html "index"
  html "Schedule"
  html "admin"
  html "Lectures"
  html "Final/Summary"
  html "Templates/Summary"

action = do
  exercises True "All.pdf"
  exercises False "OnlyQuestions.pdf"
  htmlAll
  pub
  


