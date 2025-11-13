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

```
         Entry           
           │             
           │             
        ┌──▼───┐         
        │ Main │         
        └──1───┘         
           │             
           │             
           │             
        execute          
           │             
           │             
         runCli          
           │             
           │             
      runCheckstyle      
           │             
           │             
           1             
           │             
      ┌────▼────┐        
      │ Checker │        
      └────1────┘        
           │             
           │             
           │             
        process          
           │             
           │             
      processFiles       
           │             
           │             
      processFile        
           │             
           │             
           N             
           │             
┌──────────▼────────────┐
│ AbstractFileSetCheck  │
└──────────1────────────┘
           │             
           │             
        process          
           │             
           │             
     processFiltered     
           │             
           │             
           1             
           │             
           ▼             
         EXIT
```

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
+ `AbstractAutomaticBean`:
    + Superclass of the majority of relavant classes
    + An `AbstractAutomaticBean` object is constructed dynamically with the use of `ModuleFactory`
    + After construction, its fields are populated by calling `AbstractAutomaticBean.contextualize()` for shared/inherited properties, and `AbstractAutomaticBean.configure()` for its own properties
    + `AbstractAutomaticBean.configure()` also make calls to `AbstractAutomaticBean.finishLocalSetup()` and `AbstractAutomaticBean.setupChild()`
    + `AbstractAutomaticBean.finishLocalSetup()` allows subclasses provide post-construction logic, such as validation, setting up internal states, initializing resources, etc.
    + `AbstractAutomaticBean.setupChild()` allows subclasses provide logic to process sub-modules, however, default behavior of this method is to forbid, common subclass override is to construct sub-modules using `ModuleFactory`, `contextualize()` and `configure()` it, and add further logic depending on the sub-modules' actual instaces' types 

# Relevant Components

## `DetailAST`
+ Represent an Abstract Syntax Tree - the source code of a file in the form of a logical tree-like structure
+ Obtained via `JavaParser`
+ Each `DetailAST` object is a node of a tree that contains:
  + Node Identity & Position
    + `getType()`: Returns token type (e.g., `CLASS_DEF`, `METHOD_DEF`)
    + `getText()`: The actual text/identifier of the node
    + `getLineNo()` / `getColumnNo()`: Source location for error reporting
  + Tree Navigation - Children
    + `getFirstChild()`: First direct child node
    + `getLastChild()`: Last direct child node
    + `getChildCount()`: Number of direct children
    + `getChildCount(type)`: Count of children with specific token type
    + `hasChildren()`: Whether node has any children
  + Tree Navigation - Siblings
    + `getNextSibling()`: Next node at same level
    + `getPreviousSibling()`: Previous node at same level
  + Tree Navigation - Parent
    + `getParent()`: Parent node in the tree
  + Search & Query
    + `findFirstToken(type)`: Find first child/descendant with specific type
    + `branchContains(type)`: Check if subtree contains token type (deprecated)
+ Example AST for `public class MyClass { private int field; }`:
```
COMPILATION_UNIT
├── CLASS_DEF "MyClass"
│   ├── MODIFIERS
│   │   └── LITERAL_PUBLIC
│   ├── LITERAL_CLASS
│   ├── IDENT "MyClass"
│   ├── OBJBLOCK
│   │   └── VARIABLE_DEF "field"
│   │       ├── MODIFIERS
│   │       │   └── LITERAL_PRIVATE
│   │       ├── TYPE
│   │       │   └── LITERAL_INT
│   │       └── IDENT "field"
```

## `TreeWalker`
+ Checkstyle's core AST processing engine that transforms Java source code into structured events and feed them into specific individual checks.
+ `TreeWalker` acts as the conductor that:
  + Parses Java files into ASTs
  + Traverses AST trees depth-first
  + Notifies registered checks at each node
  + Collects and filters violations
  + Manages check lifecycle
+ Extends `FileSetCheck`, therefore is a component that is responsible for checking a file, but can also have child checks that require AST
+ Extends `AbstractAutomaticBean` therefore can be configured according to XML config file at runtime
+ Post-construct - `finishLocalSetup()`: configure context with tab-with, severity, etc. to be passed to child modules
+ Child modules setup - `setupChild()`:
  + Constructs child module
  + `contextualize()` and `configure()` if child module is an instance of `AbstractAutomaticBean`
  + Inits child module and `registerCheck()` if it is an instance of `AbstractCheck`
  + Add child module to the list of filters if it is an instance of `TreeWalkerFilter`
  + Rejects all other types
+ Registers child check modules - `registerCheck(AbstractCheck check)`
  + Gets the types of tokens, or in other words, AST nodes, this check is interested in
  + Categorizes the check: does it need comment nodes or not
  + Store the check based on the above data
+ Process file - `processFiltered()`:
  + Generates AST
  + Traverses it twice, one with comments and one without
+ AST traversion - `processIter()`:
  + Traverses the AST depth-first non-recursively
  + Notifies specific individual checks at every node
  + Collects and returns all violations

## `Checker`
+ Implements `RootModule`, making it the main processing component of the application
+ Extends `AbstractAutomaticBean` therefore can be configured according to XML config file at runtime
+ Post-construct - `finishLocalSetup()`: configure context with tab-with, severity, etc. to be passed to child modules
+ Child modules setup - `setupChild()`:
  + Constructs child module
  + `contextualize()` and `configure()` if child module is an instance of `AbstractAutomaticBean`
  + Inits child module and `addFileSetCheck()` if it is an instance of `FileSetCheck`
  + Add child module to the list of filters if it is a filter
  + `addListener()` if child module is an instance of `AuditListener`
+ Main processing entry - `process()`
  + `process()` delegates to `processFiles()`
  + `processFiles()` delegates to `processFile()` for each individual file
  + `processFile()` invokes all checks
  + Collects all violations, lets listerners handle logging and returns
```
                                                                ┌────────────────┐       
                                                                │                N       
                                                                │                │       
┌────────────┐                   ┌───────────────────────┐      │        ┌───────▼──────┐
│ RootModule │                   │ AbstractAutomaticBean │      │        │ FileSetCheck │
└─────^──────┘                   └────────────^──────────┘      │        └───────^──────┘
      │                                       │                 │                │       
      ├───────────────────────────────────────┤                 │                │       
      │                                       │                 │                │       
 ┌────┴─────┐                                 │                 │                │       
 │ Checker  ├─1───────────────────────────────┼─────────────────┘                │       
 └──────────┘                                 │                                  │       
                                         ┌────┴───────┐                          │       
                                         │ TreeWalker ├─────────────────┬────────┘       
                                         └────────────┘                 N                
                                                                        │                
                                                                 ┌──────▼────────┐       
                                                                 │ AbstractCheck │       
                                                                 └───────────────┘
```
