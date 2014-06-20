" Vim syntax file
" Language: Todo list
" Maintainer: Jeff Wang
" Latest Revision: 31 May 2014

if exists("b:current_syntax")
  finish
endif

syn region todoComplete start="\(^\[x\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoInProgress start="\(^\[-\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoPending start="\(^\[|\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoIncomplete start="\(^\[ \]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoComment start="^" end="\(^\[.\]\)\@=" skipnl fold contained
