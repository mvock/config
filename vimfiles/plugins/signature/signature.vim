if !exists("*DateTime") 
    func DateTime()
        return strftime("%Y-%m-%dT%H:%M:%S")
    endfunc
endif
if !exists("*Signature") 
    func Signature()
        return "\-- " . g:author_name . " <" . g:author_email . "> " . DateTime()
    endfunc
endif

iabbr <expr> ~~~~ Signature()
