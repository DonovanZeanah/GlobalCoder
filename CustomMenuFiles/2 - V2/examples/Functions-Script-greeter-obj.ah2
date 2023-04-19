make_greeter(f)
{
    greet(subject)  ; This will be a closure due to f.
    {
        MsgBox Format(f, subject)
    }
    return greet  ; Return the closure.
}

g := make_greeter("Hello, {}!")
g(A_UserName)
g("World")
