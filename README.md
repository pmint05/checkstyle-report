# Flow

+ Entry point: `Main.main`: parses CLI arguments, handles version & usage help requests, delegates to `Main.execute` for further logic
+ `Main.execute`: finds target files (files to be checked), delegates to `Main.runCli`
+ `Main.runCli`: handles CLI options regarding the target files, delegates to `Main.runCheckstyle`
+ `Main.runCheckstyle`: loads XML config file (represented by a `Configuration` object) and runs `RootModule.process`
+ `RootModule.process`: implemented by `Checker.process`: filters files by extention, delegates to `FileSetCheck,process` to process each file, collects and returns violations
