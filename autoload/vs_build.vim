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

function! FindFiles(files, filetype) abort
    let res = []
    for file in a:files
        if EndsWith(file, a:filetype)
            call add(res, file)
        endif
    endfor
    return res
endfunction

function! ListFilesFromDir(path, list_files) abort
    let path = a:path
    if a:path[:1] == "./" && len(a:path) > 2
        let path = a:path[2:]
    endif
    for elem in split(globpath(path, "*"))
        if filereadable(elem)
            call add(a:list_files, elem)
        else 
            call ListFilesFromDir(path."/".elem, a:list_files)
        endif
    endfor
    return a:list_files
endfunction

function! FindFirstFiletype(files, filetype) abort
    for file in a:files
        if EndsWith(file, a:filetype)
            return file
        endif
    endfor
    return ""
endfunction

function! vs_build#build() abort
    let files = ListFilesFromDir('.', [])
    let sol_file = FindFirstFiletype(files, '.sln')
    execute "!devenv ".sol_file." /Build Debug"
endfunction

function! vs_build#run() abort
    let files = ListFilesFromDir('.', [])
    let sol_file = FindFirstFiletype(files, '.sln')
    let proj_name = sol_file[:-5]
    let exe_file = FindFirstFiletype(files, proj_name.'.exe')
    execute "!.\\".exe_file
endfunction
