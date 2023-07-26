" Vim syntax file
" Language: UEFI IFR
" Maintainer: Mara Sophie Grosch <littlefox@lf-net.org>
" Latest Revision: 2021-05-03

if exists("b:current_syntax")
  finish
endif

syn keyword basicKeywords Form Set Guid VarStore Size Name

syn match   binarySource '{\([0-9a-fA-F]\{2\} \)\+\\}'
syn match   guid         '[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}'


hi def link binarySource  Comment
hi def link guid          Constant
hi def link basicKeywords Statement
