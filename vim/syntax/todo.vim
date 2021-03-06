" Vim syntax file
" Language: Todo list
" Maintainer: Jeff Wang
" Latest Revision: 31 May 2014

if exists("b:current_syntax")
  finish
endif

syn region todoComplete start="\(^\s*\[x\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoInProgress start="\(^\s*\[-\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoPending start="\(^\s*\[\.\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoIncomplete start="\(^\s*\[ \]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
syn region todoComment start="^" end="\(^\s*\[.\]\)\@=" skipnl fold contained
syn region todoHash start="\(^\s*\[s\]\)\@<=.*" end="$" skipnl skipwhite nextgroup=todoComment
