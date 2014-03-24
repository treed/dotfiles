if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax match Number /\d\+/
syntax match Identifier /\<\h\w*/
syntax match Constant "/[-/a-zA-Z0-9_\.]\+"
syntax keyword Label classes control shellcommands copy
syntax keyword Function FileExists IsDir
syntax keyword Keyword domain access cfserver cfrunCommand schedule maxage editfilesize Syslog SyslogFacility AddInstallable actionsequence mode owner group backup server type define dest directories files tidy editfiles links processes
syntax match Operator /(\|)\|!\|-\||\|\.\|=\|\$\|{\|}/
syntax match Operator /:/ fold
syntax match String /"[^"]*"/hs=s+1,he=e-1
syntax match String /'[^']*'/hs=s+1,he=e-1
syntax match String /`[^`]*`/hs=s+1,he=e-1
syntax match Comment "#.*"

let b:current_syntax = "cfagent"
