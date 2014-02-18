import Text.Show.Pretty
import RuntimeSystem

-- We will only support transmission of Strings here; so channels
-- won't take any extra parameter.

data Connect = Connect Chan Chan


-- We're goint to use continuations.
type Cont f a = ...
type IO a = Cont Process a
  
-- Effects will be transformations of the state of the system.
type Process = ...

-- We can now translate the server code.

