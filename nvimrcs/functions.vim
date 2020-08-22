"+-----------------------------------------------------------------------+
"¦ Maintainer:     aloha                                                 ¦
"¦                                                                       ¦
"¦ License:        MIT                                                   ¦
"+-----------------------------------------------------------------------+

""======================== Preset helper functions =======================
""Get a random int number.
function! GetRandomInt()
    if has('nvim')
        ""How to get random int in nvim?
        "return RandomInt()
    else
        let b:seed = srand()
        return rand(b:seed)
    endif
endfunction

""========================= Airline random theme =========================
let b:airline_themes_list=[
            \    "alduin", "angr", "atomic", "ayu_dark", "ayu_light", "ayu_mirage", "badwolf", "base16_3024", "base16_adwaita", "base16_apathy",
            \    "base16_ashes", "base16_atelierdune", "base16_atelierforest", "base16_atelierheath", "base16_atelierlakeside", "base16_atelierseaside", "base16_bespin", "base16_brewer", "base16_bright", "base16_chalk",
            \    "base16_classic", "base16_codeschool", "base16_colors", "base16color", "base16_default", "base16_eighties", "base16_embers", "base16_flat", "base16_google", "base16_grayscale",
            \    "base16_greenscreen", "base16_gruvbox_dark_hard", "base16_harmonic16", "base16_hopscotch", "base16_isotope", "base16_londontube", "base16_marrakesh", "base16_mocha", "base16_monokai", "base16_nord",
            \    "base16_oceanicnext", "base16_ocean", "base16_paraiso", "base16_pop", "base16_railscasts", "base16_seti", "base16_shapeshifter", "base16_shell", "base16_snazzy", "base16_solarized",
            \    "base16_spacemacs", "base16_summerfruit", "base16_tomorrow", "base16_twilight", "base16", "base16_vim", "behelit", "biogoo", "bubblegum", "cobalt2",
            \    "cool", "dark_minimal", "desertink", "deus", "distinguished", "durant", "fairyfloss", "fruit_punch", "hybridline", "hybrid",
            \    "jellybeans", "jet", "kalisi", "kolor", "laederon", "light", "lucius", "luna", "minimalist", "molokai",
            \    "monochrome", "murmur", "night_owl", "onedark", "ouo", "owo", "papercolor", "peaksea", "powerlineish", "qwq",
            \    "ravenpower", "raven", "seagull", "seoul256", "serene", "sierra", "silver", "simple", "soda", "solarized_flood",
            \    "solarized", "sol", "term_light", "term", "themes", "tomorrow", "ubaryd", "understated", "violet", "wombat",
            \    "xtermlight", "zenburn", "airlineish",
            \]

" function! AirlineSelectTheme(num)
"     if a:num < 0
"         let b:airline_theme_selected = GetRandomInt() % 113
"         let g:airline_theme = b:airline_themes_list[b:airline_theme_selected]
"         echo 'random theme ' b:airline_theme_selected ' :' g:airline_theme 'selected.'
"     elseif a:num >= 113
"         echo 'Number too big! Select a number smaller than 114.'
"     else
"         let g:airline_theme = b:airline_themes_list[a:num]
"     endif
"     source $HOME/.vim/plugins/vim-airline/autoload/airline.vim
" endfunction

function! AirlineRandomTheme()
    if g:airline_random_theme == 1
        let b:airline_theme_selected = GetRandomInt() % 114
        let g:airline_theme = b:airline_themes_list[b:airline_theme_selected]
        "":mes[sages] 以查看当前主题信息
        au VimEnter * echomsg 'airline theme '.b:airline_theme_selected.':'.b:airline_themes_list[b:airline_theme_selected].' selected.'
    endif
endfunction
au VimEnter * call AirlineRandomTheme()


""======================= Open a terminal smartly ========================
function! g:OpenTerminalSmartly()
    if winwidth(0)*1.0/winheight(0) > 3
        vsplit | terminal
    else
        split  | terminal
    endif
endfunction


""============= Get the .backColor to set backgroud color ================
""pass 0 to use transparent background and store current bg color in a file.
""pass 1 to use color specified by the file.
function! g:TransparentBg(option)
    ""检查输入
    execute a:option != 0 && a:option != 1 ?
                \ 'echoerr "Argument error in function TransparentBg" | return -1'
                \ : ''
    ""备份文件路径
    let l:hi_normal_backup_file = g:main_runtimepath.'.cache/backColor'
    ""检查备份文件是否存在
    if !glob(g:main_runtimepath.'.cache/backColor')
        call system('touch '.l:hi_normal_backup_file)
    endif
    ""防止重复执行
    if !exists('s:back_color')
        let s:back_color = -1
    endif
    ""根据选项设置背景
    if a:option == 1
        if s:back_color != 1
            ""将Vim原来的背景色等信息存储到备份文件, 以便用户调用
            let l:hi_normal_backup = split(execute('silent hi Normal', ''))
            call remove(l:hi_normal_backup, 1)
            call writefile(['hi '.join(l:hi_normal_backup, ' ')], l:hi_normal_backup_file)
        endif
        ""设置透明背景
        hi Normal ctermbg=NONE guibg=NONE
        let s:back_color = 1
    elseif a:option ==0 && s:back_color != 0
        execute(readfile(l:hi_normal_backup_file)[0])
        let s:back_color =0
    endif
endfunction
" function! g:BackgroudColor(option)
"     execute a:option != 1 && a:option != 2 ? "return" : ""
"     if !file_readable(expand('$HOME/.config/nvim/.backColor'))
"         call system('touch '.expand('$HOME/.config/nvim/.backColor'))
"         call writefile([ '1' ], expand('$HOME/.config/nvim/.backColor'))
"     endif
"     if a:option == 2
"         if readfile(expand('$HOME/.config/nvim/.backColor'))[0] == '1'
"             hi Normal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#2C323B
"         else
"             hi Normal ctermfg=223 ctermbg=None guifg=#ebdbb2 guibg=None
"         endif
"     else
"         let l:currentColor = str2nr(readfile(expand('$HOME/.config/nvim/.backColor'))[0])
"         execute l:currentColor == 1 ?
"                     \ "hi Normal ctermfg=223 ctermbg=None guifg=#ebdbb2 guibg=None"
"                     \ : l:currentColor == 0 ?
"                     \ "hi Normal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#2C323B" : ""
"         call writefile(
"                     \ l:currentColor == 0 ? [ '1' ] : [ '0' ],
"                     \ expand('$HOME/.config/nvim/.backColor'))
"         unlet l:currentColor
"     endif
" endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

"==== Delete trailing white space on save, useful for some filetypes =====
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

"============= Don't close window, when deleting a buffer ================
function! BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

""Delete all buffers except the one in current window.
fun! DeleteAllBuffersInWindow(option)
    let s:curWinNr = winnr()
    if winbufnr(s:curWinNr) == 1
        ret
    endif
    let s:curBufNr = bufnr("%")
    exe "bn"
    let s:nextBufNr = bufnr("%")
    while s:nextBufNr != s:curBufNr
        exe "bn"
        if a:option == 'force'
            exe "bdel! ".s:nextBufNr
        else
            exe "bdel ".s:nextBufNr
        endif
        let s:nextBufNr = bufnr("%")
    endwhile
endfun

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"================================ 窗口操作 ===============================
func! FullScreen()
     " GUI is running or is about to start.
    if (has("win16") || has("win32")) && has("gui_running")
        simalt ~x
    elseif has('linux')
        "if exists("+lines")
        "    set lines=9999
        "endif
        "if exists("+columns")
        "    set columns=9999
        "endif
    endif
    let g:Full_Screen = 1
endfunc

func! ShrinkScreen()
    if has("win32") && has("gui_running")
        set lines=35 columns=100
    elseif has('linux')
        "set lines=25 columns=75
    endif
    let g:Full_Screen = 0
endfunc

func! ToggleFullScreen()
    if g:Full_Screen == 0
        call FullScreen()
    else
        call ShrinkScreen()
    endif
endfunc

function! BigWindow()
    call FullScreen()
    NERDTree
    TagbarOpen
endfunction

function! SmallWindow()
    call ShrinkScreen()
    " vim-plug 中设置 NERDTree 不会自动启动
    if exists("g:NERDTree")
        NERDTreeClose
    endif
    TagbarClose
endfunction

" " Compile function
" nnoremap <leader>r :call <SID>CompileRunGcc()<CR>
" func! CompileRunGcc()
"     exec "w"
"     if &filetype == 'c'
"         exec "!g++ % -o %<"
"         exec "!time ./%<"
"     elseif &filetype == 'cpp'
"         set splitbelow
"         exec "!g++ -std=c++11 % -Wall -o %<"
"         :sp
"         :res -15
"         :term ./%<
"     elseif &filetype == 'java'
"         exec "!javac %"
"         exec "!time java %<"
"     elseif &filetype == 'sh'
"         :!time bash %
"     elseif &filetype == 'python'
"         set splitbelow
"         :sp
"         :term python3 %
"     elseif &filetype == 'html'
"         silent! exec "!".g:mkdp_browser." % &"
"     elseif &filetype == 'markdown'
"         exec "MarkdownPreview"
"     elseif &filetype == 'tex'
"         silent! exec "VimtexStop"
"         silent! exec "VimtexCompile"
"     elseif &filetype == 'dart'
"         exec "CocCommand flutter.run -d ".g:flutter_default_device
"         CocCommand flutter.dev.openDevLog
"     elseif &filetype == 'javascript'
"         set splitbelow
"         :sp
"         :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
"     elseif &filetype == 'go'
"         set splitbelow
"         :sp
"         :term go run .
"     endif
" endfunc

""找到较低的目录层级，然后删除之
function RToc()
    exe "/-toc .* -->"
    let lstart=line('.')
    exe "/-toc -->"
    let lnum=line('.')
    execute lstart.",".lnum."g/           /d"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"Author : 路永磊
"plugin : awheel_fcitx.vim
"Date   : 2020-05-29
"Usage  : 解决vim使用中文输入法时的干扰问题
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:chinese_enable = 2                                     "若当前系统为中文输入法,则获取的输入法状态值为 2
let s:english_enable = 1                                     "若当前系统为英文输入法,则获取的输入法状态值为 1
let s:get_fcitx_language_status = "fcitx-remote"             "获取当前输入法的状态值
let s:set_fcitx_chinese         = "fcitx-remote -o"          "把输入法设置为 中文
let s:set_fcitx_english         = "fcitx-remote -c"          "把输入法设置为 英文

let s:start_language_status = system(s:set_fcitx_english)    "vim启动时,默认把输入法设置为英文



"此处可以根据编辑的文件后缀名来做更改
let g:saved_insert_mode_language_status = s:english_enable                     "初始设置 插入模式 输入法为英文
autocmd BufNewFile,BufRead *.txt,*.text,[Rr][Ee][Aa][Dd][Mm][Ee] 
            \let g:saved_insert_mode_language_status = s:chinese_enable        "在编辑*.txt,*.text文件格式的时候



"当退出 插入模式 时,会把输入法设置为英文 
function! s:fcitx_2_english()
    let s:exit_insert_status = system(s:get_fcitx_language_status)      "检查退出 插入模式 时,输入法的状态
    if s:exit_insert_status != s:english_enable                         "如果退出 插入模式 时,输入法不是英文
        let l:temp = system(s:set_fcitx_english)                        "将输入法设置为英文
    endif
    let g:saved_insert_mode_language_status = s:exit_insert_status      "保存退出 插入模式 时的输入法状态 
endfunction

"当进入 插入模式 时,输入法会自动选择语言为上一次插入模式使用的语言
function! s:fcitx_enter_insert_mode()
    let s:enter_insert_status = system(s:get_fcitx_language_status)     "获取进入 插入模式 时,输入法的状态
    if s:enter_insert_status != g:saved_insert_mode_language_status     "如果当前输入法语言和上一次退出插入模式时的语言不一样
        if g:saved_insert_mode_language_status == s:chinese_enable      "改变输入法当前语言为上一次退出插入模式时的语言
            let l:temp = system(s:set_fcitx_chinese)
        else
            let l:temp = system(s:set_fcitx_english)
        endif
    endif
endfunction



"退出插入模式调用的函数
autocmd InsertLeave * call s:fcitx_2_english()

"进入插入模式调用的函数
autocmd InsertEnter * call s:fcitx_enter_insert_mode()


"================================ 移动模式 ===============================
function! g:SwitchMotionMod()
    if !exists("g:motionMod") || g:motionMod == 1
        noremap <S-M-j> 5<C-e>
        noremap <S-M-k> 5<C-y>
        if exists('g:motionMod')
            echo 'Changed to Free mod.'
        endif
        let g:motionMod = 0
    elseif g:motionMod == 0
        echo 'Changed to Fixed mod.'
        noremap <S-M-j> 5jzz
        noremap <S-M-k> 5kzz
        let g:motionMod = 1
    endif
endfunction

