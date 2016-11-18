" Vim syntax file
" Language: Fox Script
" Maintainer: Moritz "LittleFox" Grosch

if exists("b:current_syntax")
    finish
endif

" Keywords
syn keyword fssKeywords module function if else
syn keyword fssBasicTypes integer boolean string float map array

syn region fssBlock start="{" end="}" fold transparent

syn keyword fssTodo contained TODO FIXME XXX NOTE
syn match fssComment "#.*$" contains=cellTodo
syn region fssString start='"' end='"' skip='\\"'

let b:current_syntax = "foxscript"

hi def link fssTodo       Todo
hi def link fssComment    Comment
hi def link fssString     String
hi def link fssKeywords   Statement
hi def link fssBasicTypes Type
