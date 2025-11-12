# Flow

+ Entry point: `Main.main`: parses CLI arguments, handles version & usage help requests, delegates to `Main.execute` for further logic
+ `Main.execute`: finds target files (files to be checked), delegates to `Main.runCli`
+ `Main.runCli`: handles CLI options regarding the target files, delegates to `Main.runCheckstyle`
+ `Main.runCheckstyle`: loads XML config file (represented by a `Configuration` object) and runs `RootModule.process`
  + Loads properties (`Properties` object) from a properties file, or from system properties
  + Determines if ignored modules should be run or omitted
  + Determines multi-threading/parallelism configurations
  + Loads configurations (`Configuration` object) from config file
  + Delegates to `Main.getRootModule` to get a `RootModule` object that will control and run the main Checkstyle logic
  + Creates an `AuditListener` object (an observer if the observer pattern) based on the input options, which will log running information to specified output path (stdout or a file on disk)
  + Configures the newly created `RootModule`, populating it with checks (each represented by a `FileSetCheck`) specified in the config file, adds listener and begins processing files by calling `RootModule.process` 
+ `Checker.process`: implements `RootModule.process`: filters files by extention, delegates to every `FileSetCheck.process` to process each file, collects and returns violations
+ `AbstractFileSetCheck.process`: implements `FileSetCheck.process`: sets up environment and parameters, filters target file extension and delegates to sub-class implementations of `AbstractFileSetCheck.processFiltered` for specific checks


# Framework
Checkstyle implements a framework that enables declarative XML-based configurations, using reflection and runtime object construction.

+ `Configuration`: 
    + Implements *Composite pattern*
    + A `Configuration` represent a `<module>`, which can have:
        + A `name`
        + A list of properties, with each `property` a key-value string-string pair
        + A list of sub-modules
    + Make up a nested tree-like structure that determines what objects are created at runtime, their attributes, and how they are composed

+ `ModuleFactory`:
    + Constructs objects based on XML config module name, which is `Configuration.getName()`
    + Searches classpath in addtion to built-in classes, which allows users add custom 3rd-party checks
    + Only handles object construction, doesn't populate those objects' fields, as that is handled by a different component
