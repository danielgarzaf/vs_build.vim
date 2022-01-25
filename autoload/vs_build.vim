function! EndsWith(string, sub) abort
    let idx = stridx(a:string, a:sub)
    while idx > 0 
        if len(a:sub) == (len(a:string) - idx)
            return 1
        endif
        let idx = stridx(a:string, a:sub, idx+1)
    endwhile
    return 0
endfunction

function! ListFilesFromDir(path, list_files) abort
    let slash = ""
    if has("win32")
        let slash = "\\"
    elseif has("unix")
        let slash = "/"
    endif

    for elem in split(globpath(a:path, "*"))
        " If it's a file, add it to list_files
        if filereadable(elem)
            call add(a:list_files, elem)
        " Else, repeat process with current path
        else 
            call ListFilesFromDir(elem, a:list_files)
        endif
    endfor
    return a:list_files
endfunction

function! GetFiletypes(files, filetype) abort
    return filter(a:files, {idx, val -> EndsWith(val, a:filetype)})
endfunction

function! GetFirstFiletype(files, filetype) abort
    let files = GetFiletypes(a:files, a:filetype)
    if len(files) > 0
        return files[0]
    endif
endfunction

function! vs_build#add_build_mode(mode) abort
    let g:vs_modes[tolower(a:mode)] = 1
endfunction

function! vs_build#remove_build_mode(mode) abort
    unlet g:vs_modes[tolower(a:mode)]
endfunction

function! vs_build#build_mode(mode) abort
    if get(g:vs_modes, a:mode)
        let g:vs_mode = a:mode
    else
        echom "Build mode doesn't exist in solution"
    endif
endfunction

function! vs_build#build() abort
    let files = ListFilesFromDir('.', [])
    let sln_file = GetFirstFiletype(files, '.sln')
    execute "!devenv ".sln_file." /Build ".g:vs_mode
endfunction

function! vs_build#run() abort
    let files = ListFilesFromDir('.', [])
    let exe_file = GetFirstFiletype(files, '.exe')
    echo "Running: ".exe_file
    execute "!".exe_file
endfunction

function! Startup() abort
    let g:vs_modes = {
                \ "debug": 1,
                \ "release": 1
                \ }
    let g:vs_mode = "release"
endfunction

call Startup()
