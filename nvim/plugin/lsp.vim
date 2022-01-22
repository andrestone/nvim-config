set completeopt=menuone,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <C-b> :lua vim.lsp.buf.definition()<CR>
nnoremap <leader><F7> :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>H :lua vim.lsp.buf.signature_help()<CR>
nnoremap <F7> :lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>h :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>l :lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader><F2> :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <F2> :lua vim.lsp.diagnostic.goto_next()<CR>

" let g:compe = {}
" let g:compe.enabled = v:true
" let g:compe.autocomplete = v:true
" let g:compe.debug = v:false
" let g:compe.min_length = 1
" let g:compe.preselect = 'enable'
" let g:compe.throttle_time = 80
" let g:compe.source_timeout = 200
" let g:compe.incomplete_delay = 400
" let g:compe.max_abbr_width = 100
" let g:compe.max_kind_width = 100
" let g:compe.max_menu_width = 100
" let g:compe.documentation = v:true
" let g:compe.source = {}
" let g:compe.source.path = v:true
" let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.vsnip = v:true
" let g:compe.source.nvim_lua = v:true
" let g:compe.source.nvim_lsp = v:true

" inoremap <silent><expr> <C-y>      compe#confirm('<C-y>')
" inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <C-y>     compe#confirm('<C-y>')
