if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax match Identifier /\<\h\w*\>/
syntax match Number /\<\d\+\>/
syntax match Number /\<0x\x\+\>/
syntax match Number /\<0b[01]\+\>/
syntax match String /"[^"]*"/hs=s+1,he=e-1
syntax match String /'[^']*'/hs=s+1,he=e-1
syntax keyword Statement var let def begin end return call
syntax keyword Repeat while until do repeat
syntax keyword Structure enum
syntax keyword Include include embed
syntax keyword Type byte word
syntax keyword Statement get put add addc sub subc or and xor cmp bit push pull not neg shl shr rol ror inc dec set unset 
syntax keyword Keyword goto when carry zero overflow negative decimal interrupt local resume
syntax keyword Conditional if then else elseif
syntax keyword PreProc ines bank in
syntax keyword Keyword ram chr prg mapper mirroring battery fourscreen
syntax match Special /#\|@/
syntax match Operator /+\|-\|\*\|\/\|%\|\^\|<<\|>>\|<\|>\|<=\|>=\|=\|<>\|&&\|(\|)\|!\|||\||\|,\|\[\|\]\|:\|\./
syntax match Comment "//.*"

let b:current_syntax = "nel"
