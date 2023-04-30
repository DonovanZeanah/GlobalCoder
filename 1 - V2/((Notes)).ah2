

/*FileFolder Loop
    "FDR" : "R"ecurse  "F"iles "D" irectory "FDR"
*/

/* Objects & Classes
    ;//========= class definition:
        class ClassName extends BaseClassName
        {
            InstanceVar := Expression
            
            static ClassVar := Expression

            class NestedClass
            {
                ...
            }

            Method()
            {
                ...
            }
            
            static Method()
            {
                ...
            }

            Property[Parameters]  ; Use brackets only when parameters are present.
            {
                get {
                    return value of property
                }
                set {
                    Store or otherwise handle value
                }
            }
            
            ShortProperty
            {
                get => Expression which calculates property value
                set => Expression which stores or otherwise handles value
            }
            
            ShorterProperty => Expression which calculates property value
        }
    ;//======== Enumerator Object
        
        An enumerator is a type of function object which is called repeatedly to enumerate a sequence of values.

        Enumerators exist primarily to support For-loops, and are not usually called directly. The for-loop documentation details the process by which an enumerator is called. The script may implement an enumerator to control which values are assigned to the for-loop's variables on each iteration of the loop.

        Built-in enumerators are instances of the Enumerator class (which is derived from Func), but any function object can potentially be used with a for-loop.

        Table of Contents
        Methods:
        Call: Retrieves the next item or items in an enumeration.
        Related
        Methods
        Call
        Retrieves the next item or items in an enumeration.

        Enum.Call(&OutputVar1 , &OutputVar2)
        EnumFunction(&OutputVar1 , &OutputVar2)
        &OutputVar1, &OutputVar2
        Type: VarRef

        One or more references to output variables for the enumerator to assign values.

        Returns a non-zero integer if successful or zero if there were no items remaining.

        A simple function definition can be used to create an enumerator; in that case, the Call method is implied.

        When defining your own enumerator, the number of parameters should match the number of variables expected to be passed to the for-loop (before the "in" keyword). This is usually either 1 or 2, but a for-loop can accept up to 19 variables. To allow the method to accept a varying number of variables, declare optional parameters.

        An exception is thrown when the for-loop attempts to call the method if there are more variables than parameters (too many parameters passed, too few defined) or fewer variables than mandatory parameters.
    ;//======== Prototype objec
        Since Objects are dynamic and prototype-based, each class consists of two parts:

        The class has a  Prototype object, on which all instances of the class are based. 
        All methods and dynamic properties that apply to instances of the class are contained by the prototype object. 
        This includes all properties and methods which lack the static keyword.
        The class itself is an object, containing only static methods and properties. 
        This includes all properties and methods with the static keyword, and all nested classes. 
        These do not apply to a specific instance, and can be used by referring to the class itself by name.

        ;//========= delegation
        Objects are prototype-based. That is, any properties not defined in the object itself can instead be defined in the object's base. 
        This is known as inheritance by delegation or differential inheritance, 
        because an object can implement only the parts that make it different, while delegating the rest to its base.

        Although a base object is also generally known as a prototype, 
        we use "a class's Prototype" to mean the object upon which every instance of the class is based, 
        and "base" to mean the object upon which an instance is based.

        AutoHotkey's object design was influenced primarily by JavaScript and Lua, 
        with a little C#. We use obj.base in place of JavaScript's obj.__proto__ and cls.Prototype in place of 
        JavaScript's func.prototype. (Class objects are used in place of constructor functions.)

        An object's base is also used to identify its type or class. 
        For example, x := [] creates an object based on Array.Prototype,
         which means that the expressions x is Array and x.HasBase(Array.Prototype) are true, 
         and type(x) returns "Array". Each class's Prototype is based on the Prototype of its base class, 
         so x.HasBase(Object.Prototype) is also true.

        Any instance of Object or a derived class can be a base object, but an object can only be assigned as the base of an object 
        with the same native type. This is to ensure that built-in methods can always identify the native type of an object, 
        and operate only on objects that have the correct binary structure.

        Base objects can be defined two different ways:

        By creating a normal object.
        By defining a class. Each class has a Prototype property containing an object which all instances of that class are based on, 
        while the class itself becomes the base object of any direct subclasses.
        A base object can be assigned to the base property of another object,
         but typically an object's base is set implicitly when it is created.
    ;\\==========\\ End 

        Objects are prototype-based. That is, any properties not defined in the object itself can instead be defined in the object's base. 
        This is known as inheritance by delegation or differential inheritance, 
        because an object can implement only the parts that make it different, while delegating the rest to its base.*/

/* Operators 

    Variables and Expressions
    Table of Contents
    Variables
    Expressions
    Operators in Expressions
    Built-in Variables
    Variable Capacity and Memory
    Variables
    See Variables for general explanation and details about how variables work.

    Storing values in variables: To store a string or number in a variable, use the colon-equal operator (:=) followed by a number, quoted string or any other type of expression. For example:

    MyNumber := 123
    MyString := "This is a literal string."
    CopyOfVar := Var
    A variable cannot be explicitly deleted, but its previous value can be released by assigning a new value, such as an empty string:

    MyVar := ""
    A variable can also be assigned a value indirectly, by taking its reference and using a double-deref or passing it to a function. For example:

    MouseGetPos &x, &y
    Reading the value of a variable which has not been assigned a value is considered an error. IsSet can be used to detect this condition.

    Retrieving the contents of variables: To include the contents of a variable in a string, use concatenation or Format. For example:

    MsgBox "The value of Var is " . Var . "."
    MsgBox "The value in the variable named Var is " Var "."
    MsgBox Format("Var has the value {1}.", Var)
    Sub-expressions can be combined with strings in the same way. For example:

    MsgBox("The sum of X and Y is " . (X + Y))
    Comparing variables: Please read the expressions section below for important notes about the different kinds of comparisons.

    Expressions
    See Expressions for a structured overview and further explanation.

    Expressions are used to perform one or more operations upon a series of variables, literal strings, and/or literal numbers.

    Plain words in expressions are interpreted as variable names. Consequently, literal strings must be enclosed in double quotes to distinguish them from variables. For example:

    if (CurrentSetting > 100 or FoundColor != "Blue")
        MsgBox "The setting is too high or the wrong color is present."
    In the example above, "Blue" appears in quotes because it is a literal string. Single-quote marks (') and double-quote marks (") function identically, except that a string enclosed in single-quote marks can contain literal double-quote marks and vice versa. Therefore, to include an actual quote mark inside a literal string, escape the quote mark or enclose the string in the opposite type of quote mark. For example:

    MsgBox "She said, `"An apple a day.`""
    MsgBox 'She said, "An apple a day."'
    Empty strings: To specify an empty string in an expression, use an empty pair of quotes. For example, the statement if (MyVar != "") would be true if MyVar is not blank.

    Storing the result of an expression: To assign a result to a variable, use the := operator. For example:

    NetPrice := Price * (1 - Discount/100)
    Boolean values: When an expression is required to evaluate to true or false (such as an IF-statement), a blank or zero result is considered false and all other results are considered true. For example, the statement if ItemCount would be false only if ItemCount is blank or 0. Similarly, the expression if not ItemCount would yield the opposite result.

    Operators such as NOT/>/=/< automatically produce a true or false value: they yield 1 for true and 0 for false. However, the AND/OR operators always produce one of the input values. For example, in the following expression, the variable Done is assigned 1 if A_Index is greater than 5 or the value of FoundIt in all other cases:

    Done := A_Index > 5 or FoundIt
    As hinted above, a variable can be used to hold a false value simply by making it blank or assigning 0 to it. To take advantage of this, the shorthand statement if Done can be used to check whether the variable Done is true or false.

    In an expression, the keywords true and false resolve to 1 and 0. They can be used to make a script more readable as in these examples:

    CaseSensitive := false
    ContinueSearch := true
    Integers and floating point: Within an expression, numbers are considered to be floating point if they contain a decimal point or scientific notation; otherwise, they are integers. For most operators -- such as addition and multiplication -- if either of the inputs is a floating point number, the result will also be a floating point number.

    Within expressions and non-expressions alike, integers may be written in either hexadecimal or decimal format. Hexadecimal numbers all start with the prefix 0x. For example, Sleep 0xFF is equivalent to Sleep 255. Floating point numbers can optionally be written in scientific notation, with or without a decimal point (e.g. 1e4 or -2.1E-4).

    Within expressions, unquoted literal numbers such as 128, 0x7F and 1.0 are converted to pure numbers before the script begins executing, so converting the number to a string may produce a value different to the original literal value. For example:

    MsgBox(0x7F)  ; Shows 128
    MsgBox(1.00)  ; Shows 1.0
    Operators in Expressions
    See Operators for general information about operators.

    Except where noted below, any blank value (empty string) or non-numeric value involved in a math operation is not assumed to be zero. Instead, a TypeError is thrown. If Try is not used, the unhandled exception causes an error dialog by default.

    Expression Operators (in descending precedence order)
    Operator    Description
    %Expr%  
    Dereference or name substitution.

    When Expr evaluates to a VarRef, %Expr% accesses the corresponding variable. For example, x := &y takes a reference to y and assigns it to x, then %x% := 1 assigns to the variable y and %x% reads its value.

    Otherwise, the value of the sub-expression Expr is used as the name or partial name of a variable or property. This allows the script to refer to a variable or property whose name is determined by evaluating Expr, which is typically another variable. Variables cannot be created dynamically, but a variable can be assigned dynamically if it has been declared or referenced non-dynamically somewhere in the script.

    Note: The result of the sub-expression Expr must be the name or partial name of the variable or property to be accessed.

    Percent signs cannot be used directly within Expr due to ambiguity, but can be nested within parentheses. Otherwise, Expr can be any expression.

    If there are any adjoining %Expr% sequences and partial names (without any spaces or other characters between them), they are combined to form a single name.

    An Error is typically thrown if the variable does not already exist, or if it is uninitialized and its value is being read. The or-maybe operator (??) can be used to avoid that case by providing a default value. For example: %'novar'% ?? 42.

    Although this is historically known as a "double-deref", this term is inaccurate when Expr does not contain a variable (first deref), and also when the resulting variable is the target of an assignment, not being dereferenced (second deref).

    x.y
    x.%z%   Member access. Get or set a value or call a method of object x, where y is a literal name and z is an expression which evaluates to a name. See object syntax.
    var?    
    Maybe. Permits the variable to be unset. This is valid only when passing a variable to an optional parameter, array element or object literal; or on the right-hand side of a direct assignment. The question mark must be followed by one of the following symbols (ignoring whitespace): )]},:. The variable may be passed conditionally via the ternary operator or on the right-hand side of AND/OR.

    The variable is typically an optional parameter, but can be any variable. For variables that are not function parameters, a VarUnset warning may still be shown at load-time if there are other references to the variable but no assignments.

    This operator is currently supported only for variables. To explicitly or conditionally omit a parameter in more general cases, use the unset keyword.

    See also: unset (Optional Parameters)

    ++
    --  
    Pre- and post-increment/decrement. Adds or subtracts 1 from a variable. The operator may appear either before or after the variable's name. If it appears before the name, the operation is performed and its result is used by the next operation (the result is a variable reference in this case). For example, Var := ++X increments X and then assigns its value to Var. Conversely, if the operator appears after the variable's name, the result is the value of X prior to performing the operation. For example, Var := X++ increments X but Var receives the value X had before it was incremented.

    These operators can also be used with a property of an object, such as myArray.Length++ or --myArray[i]. In these cases, the result of the sub-expression is always a number, not a variable reference.

    **  
    Power. Example usage: base**exponent. Both base and exponent may contain a decimal point. If exponent is negative, the result will be formatted as a floating point number even if base and exponent are both integers. Since ** is of higher precedence than unary minus, -2**2 is evaluated like -(2**2) and so yields -4. Thus, to raise a literal negative number to a power, enclose it in parentheses such as (-2)**2.

    The power operator is right-associative. For example, x ** y ** z is evaluated as x ** (y ** z).

    Note: A negative base combined with a fractional exponent such as (-2)**0.5 is not supported; attempting it will cause an exception to be thrown. But both (-2)**2 and (-2)**2.0 are supported. If both base and exponent are 0, the result is undefined and an exception is thrown.

    -
    !
    ~
    &   
    Unary minus (-): Inverts the sign of its operand.

    Unary plus (+): +N is equivalent to -(-N). This has no effect when applied to a pure number, but can be used to convert numeric strings to pure numbers.

    Logical-not (!): If the operand is blank or 0, the result of applying logical-not is 1, which means "true". Otherwise, the result is 0 (false). For example: !x or !(y and z). Note: The word NOT is synonymous with ! except that ! has a higher precedence. Consecutive unary operators such as !!Var are allowed because they are evaluated in right-to-left order.

    Bitwise-not (~): This inverts each bit of its operand. As 64-bit signed integers are used, a positive input value will always give a negative result and vice versa. For example, ~0xf0f evaluates to -0xf10 (-3856), which is binary equivalent to 0xfffffffffffff0f0. If an unsigned 32-bit value is intended, the result can be truncated with result & 0xffffffff. If the operand is a floating point value, a TypeError is thrown.

    Reference (&): Creates a VarRef, which is a value representing a reference to a variable. A VarRef can then be used to indirectly access the target variable. For example, ref := &target followed by %ref% := 1 would assign the value 1 to target. The VarRef would typically be passed to a function, but could be stored in an array or property. See also: Dereference, ByRef.

    Taking a reference to a built-in variable such as A_Clipboard is currently not supported, except when being passed directly to an OutputVar parameter of a built-in function.

    *
    /
    //  
    Multiply (*): The result is an integer if both inputs are integers; otherwise, it is a floating point number.

    Other uses: The asterisk (*) symbol is also used in variadic function calls.

    True divide (/): True division yields a floating point result even when both inputs are integers. For example, 3/2 yields 1.5 rather than 1, and 4/2 yields 2.0 rather than 2.

    Integer divide (//): The double-slash operator uses high-performance integer division. For example, 5//3 is 1 and 5//-3 is -1. If either of the inputs is in floating point format, a TypeError is thrown. For modulo, see Mod.

    The *= and /= operators are a shorthand way to multiply or divide the value in a variable by another value. For example, Var*=2 produces the same result as Var:=Var*2 (though the former performs better).

    Division by zero causes a ZeroDivisionError to be thrown.

    +
    -   
    Add (+) and subtract (-). On a related note, the += and -= operators are a shorthand way to increment or decrement a variable. For example, Var+=2 produces the same result as Var:=Var+2 (though the former performs better). Similarly, a variable can be increased or decreased by 1 by using Var++, Var--, ++Var, or --Var.

    Other uses: If the + or - symbol is not preceded by a value (or a sub-expression which yields a value), it is interpreted as a unary operator instead.

    <<
    >>
    >>> 
    Bit shift left (<<). Example usage: Value1 << Value2. This is equivalent to multiplying Value1 by "2 to the Value2th power".

    Arithmetic bit shift right (>>). Example usage: Value1 >> Value2. This is equivalent to dividing Value1 by "2 to the Value2th power" and rounding the result to the nearest integer leftward on the number line; for example, -3>>1 is -2.

    Logical bit shift right (>>>). Example usage: Value1 >>> Value2. Unlike arithmetic bit shift right, this does not preserve the sign of the number. For example, -1 has the same bit representation as the unsigned 64-bit integer 0xffffffffffffffff, therefore -1 >>> 1 is 0x7fffffffffffffff.

    The following applies to all three operators:

    If either of the inputs is a floating-point number, a TypeError is thrown.
    If Value2 is less than 0 or greater than 63, an exception is thrown.
    &
    ^
    |   
    Bitwise-and (&), bitwise-exclusive-or (^), and bitwise-or (|). Of the three, & has the highest precedence and | has the lowest.

    If either of the inputs is a floating-point number, a TypeError is thrown.

    Related: Bitwise-not (~)

    .   
    Concatenate. A period (dot) with at least one space or tab on each side is used to combine two items into a single string. You may also omit the period to achieve the same result (except where ambiguous such as x -y, or when the item on the right side has a leading ++ or --). When the dot is omitted, there must be at least one space or tab between the items to be merged.

    Var := "The color is " . FoundColor  ; Explicit concat
    Var := "The color is " FoundColor    ; Auto-concat
    Sub-expressions can also be concatenated. For example: Var := "The net price is " .  Price * (1 - Discount/100).

    A line that begins with a period (or any other operator) is automatically appended to the line above it.

    The entire length of each input is used, even if it includes binary zero. For example, Chr(0x2010) Chr(0x0000) Chr(0x4030) produces the following string of bytes (due to UTF-16-LE encoding): 0x10, 0x20, 0, 0, 0x30, 0x40. The result has an additional null-terminator (binary zero) which is not included in the length.

    Other uses: If there is no space or tab to the right of a period (dot), it is interpreted as either a literal floating-point number or member access. For example, 1.1 and (.5) are numbers, A_Args.Has(3) is a method call and A_Args.Length is a property access.

    ~=  Shorthand for RegExMatch. For example, the result of "abc123" ~= "\d" is 4 (the position of the first numeric character).
    >   <
    >= <=   
    Greater (>), less (<), greater-or-equal (>=), and less-or-equal (<=). The inputs are compared numerically. A TypeError is thrown if either of the inputs is not a number or a numeric string.

    =
    ==
    !=
    !== 
    Case-insensitive equal (=) / not-equal (!=) and case-sensitive equal (==) / not-equal (!==). The == operator behaves identically to = except when either of the inputs is not numeric (or both are strings), in which case == is always case sensitive and = is always case insensitive. The != and !== behave identically to their counterparts without !, except that the result is inverted.

    The == and !== operators can be used to compare strings which contain binary zero. All other comparison operators except ~= compare only up to the first binary zero.

    For case insensitive comparisons, only the ASCII letters A-Z are considered equivalent to their lowercase counterparts. To instead compare according to the rules of the current user's locale, use StrCompare and specify "Locale" for the CaseSense parameter.

    IS
    IN
    CONTAINS    
    Value is Class yields true (1) if Value is an instance of Class or false (0) otherwise. Class must be an Object with a Prototype own property, but typically the property is defined implicitly by a class definition. This operation is generally equivalent to HasBase(Value, Class.Prototype).

    in and contains are reserved for future use.

    NOT Logical-NOT. Except for its lower precedence, this is the same as the ! operator. For example, not (x = 3 or y = 3) is the same as !(x = 3 or y = 3).
    AND
    &&  
    Both of these are logical-AND. For example: x > 3 and x < 10.

    In an expression where all operands resolve to True, the last operand that resolved to True is returned. Otherwise, the first operand that resolves to False is returned. Effectively, only when all operands are true, will the result be true. Boolean expressions are subject to short-circuit evaluation (left to right) in order to enhance performance.

    A := 1, B := {}, C := 20, D := True, E := "String" ; All operands are truthy and will be evaluated
    MsgBox(A && B && C && D && E) ; The last truthy operand is returned ("String")
    A := 1, B := "", C := 0, D := False, E := "String" ; B is falsey, C and D are false
    MsgBox(A && B && ++C && D && E) ; The first falsey operand is returned (""). C, D and E are not evaluated and C is never incremented
    A line that begins with AND or && (or any other operator) is automatically appended to the line above it.

    OR
    ||  
    Both of these are logical-OR. For example: x <= 3 or x >= 10.

    In an expression where at least one operand resolves to True, the first operand that resolved to True is returned. Otherwise, the last operand that resolves to False is returned. Effectively, provided at least one operand is true, the result will be true. Boolean expressions are subject to short-circuit evaluation (left to right) in order to enhance performance.

    A := "", B := False, C := 0, D := "String", E := 20 ; At least one operand is truthy. All operands up until D (including) will be evaluated
    MsgBox(A || B || C || D || ++E) ; The first truthy operand is returned ("String"). E is not evaluated and is never incremented
    A := "", B := False, C := 0 ; All operands are falsey and will be evaluated
    MsgBox(A || B || C) ; The last falsey operand is returned (0)
    A line that begins with OR or || (or any other operator) is automatically appended to the line above it.

    ??  
    Or maybe, otherwise known as the coalescing operator. If the left operand (which must be a variable) has a value, it becomes the result and the right branch is skipped. Otherwise, the right operand becomes the result. In other words, A ?? B behaves like A || B (logical-OR) except that the condition is IsSet(A).

    This is typically used to provide a default value when it is known that a variable or optional parameter might not already have a value. For example:

    MsgBox MyVar ?? "Default value"
    Since the variable is expected to sometimes be uninitialized, no error is thrown in that case. Unlike IsSet(A) ? A : B, a VarUnset warning may still be shown at load-time if there are other references to the variable but no assignments.

    ?:  
    Ternary operator. This operator is a shorthand replacement for the if-else statement. It evaluates the condition on its left side to determine which of its two branches should become its final result. For example, var := x>y ? 2 : 3 stores 2 in Var if x is greater than y; otherwise it stores 3. To enhance performance, only the winning branch is evaluated (see short-circuit evaluation).

    See also: maybe (var?), or-maybe (??)

    Note: When used at the beginning of a line, the ternary condition should usually be enclosed in parentheses to reduce ambiguity with other types of statements. For details, see Expression Statements.

    :=
    +=
    -=
    *=
    /=
    //=
    .=
    |=
    &=
    ^=
    >>=
    <<=
    >>>=    
    Assign. Performs an operation on the contents of a variable and stores the result back in the same variable. The simplest assignment operator is colon-equals (:=), which stores the result of an expression in a variable. For a description of what the other operators do, see their related entries in this table. For example, Var //= 2 performs integer division to divide Var by 2, then stores the result back in Var. Similarly, Var .= "abc" is a shorthand way of writing Var := Var . "abc".

    Unlike most other operators, assignments are evaluated from right to left. Consequently, a line such as Var1 := Var2 := 0 first assigns 0 to Var2 then assigns Var2 to Var1.

    If an assignment is used as the input for some other operator, its value is the variable itself. For example, the expression (Var+=2) > 50 is true if the newly-increased value in Var is greater than 50. It is also valid to combine an assignment with the reference operator, as in &(Var := "initial value").

    The precedence of the assignment operators is automatically raised when it would avoid a syntax error or provide more intuitive behavior. For example: not x:=y is evaluated as not (x:=y). Similarly, ++Var := X is evaluated as ++(Var := X); and Z>0 ? X:=2 : Y:=2 is evaluated as Z>0 ? (X:=2) : (Y:=2).

    The target variable can be un-set by combining a direct assignment (:=) with the unset keyword or the maybe (var?) operator. For example: Var := unset, Var1 := (Var2?).

    An assignment can also target a property of an object, such as myArray.Length += n or myArray[i] .= t. When assigning to a property, the result of the sub-expression is the value being assigned, not a variable reference.

    () => expr  
    Fat arrow function. Defines a simple function and returns a Func or Closure object. Write the function's parameter list (optionally preceded by a function name) to the left of the operator. When the function is called (via the returned reference), it evaluates the sub-expression expr and returns the result.

    The following two examples are equivalent:

    sumfn := Sum(a, b) => a + b
    Sum(a, b) {
        return a + b
    }
    sumfn := Sum
    In both cases, the function is defined unconditionally at the moment the script launches, but the function reference is stored in sumfn only if and when the assignment is evaluated.

    If the function name is omitted and the parameter list consists of only a single parameter name, the parentheses can be omitted. The example below defines an anonymous function with one parameter a and stores its reference in the variable double:

    double := a => a * 2
    Variable references in expr are resolved in the same way as in the equivalent full function definition. For instance, expr may refer to an outer function's local variables (as in any nested function), in which case a new closure is created and returned each time the fat arrow expression is evaluated. The function is always assume-local, since declarations cannot be used.

    Specifying a name for the function allows it to be called recursively or by other nested functions without storing a reference to the closure within itself (thereby creating a problematic circular reference). It can also be helpful for debugging, such with Func.Name or when displayed on the debugger's call stack.

    Fat arrow syntax can also be used to define shorthand properties and methods.

    ,   
    Comma (multi-statement). Commas may be used to write multiple sub-expressions on a single line. This is most commonly used to group together multiple assignments or function calls. For example: x:=1, y+=2, ++index, MyFunc(). Such statements are executed in order from left to right.

    Note: A line that begins with a comma (or any other operator) is automatically appended to the line above it. See also: comma performance.

    Comma is also used to delimit the parameters of a function call or control flow statement. To include a multi-statement expression in a parameter list, enclose it in an extra set of parentheses. For example, MyFn((x, y)) evaluates both x and y but passes y as the first and only parameter of MyFn.

    The following types of sub-expressions override precedence/order of evaluation:

    Expression  Description
    (expression)    
    Any sub-expression enclosed in parentheses. For example, (3 + 2) * 2 forces 3 + 2 to be evaluated first.

    For a multi-statement expression, the result of the last statement is returned. For example, (a := 1, b := 2, c := 3) returns 3.

    Mod()
    Round()
    Abs()

    Function call. There must be no space between the function name or expression and the open parenthesis which begins the parameter list. For details, see Function Calls.

    (expression) is not necessarily required to be enclosed in parentheses, but doing so may eliminate ambiguity. For example, (x.y)() retrieves a function from a property and then calls it with no parameters, whereas x.y() would implicitly pass x as the first parameter.

    (expression)()

    Fn(Params*) 
    Variadic function call. Params is an enumerable object (an object with an __Enum method), such as an Array containing parameter values.

    x[y]
    [a, b, c]   
    Item access. Get or set the __Item property (or default property) of object x with the parameter y (or multiple parameters in place of y). This typically corresponds to an array element or item within a collection, where y is the item's index or key. The item can be assigned a value by using any assignment operator immediately after the closing bracket. For example, x[y] := z.

    Array literal. If the open-bracket is not preceded by a value (or a sub-expression which yields a value), it is interpreted as the beginning of an array literal. For example, [a, b, c] is equivalent to Array(a, b, c) (a, b and c are variables).

    See Arrays and Maps for common usage.

    {a: b, c: d}    
    Object literal. Create an Object. Each pair consists of a literal property name a and a property value expression b. For example, x := {a: b} is equivalent to x := Object(), x.a := b. Base may be set within the object literal, but all other properties are set as own value properties, potentially overriding properties inherited from the base object.

    To use a dynamic property name, enclose the sub-expression in percent signs. For example: {%nameVar%: valueVar}.*/

/* COM Objects
    ComValue
    Wraps a value, SafeArray or COM object for use by the script or for passing to a COM method.

    ComObj := ComValue(VarType, Value , Flags)
    ComValue itself is a class derived from Any, but is used only to create or identify COM wrapper objects.

    Parameters
    VarType
    Type: Integer

    An integer indicating the type of value. See ComObjType for a list of types.

    Value
    The value to wrap.

    If this is a pure integer and VarType is not VT_R4, VT_R8, VT_DATE or VT_CY, its value is used directly; in particular, VT_BSTR, VT_DISPATCH and VT_UNKNOWN can be initialized with a pointer value.

    In any other case, the value is copied into a temporary VARIANT using the same rules as normal COM methods calls. If the source variant type is not equal to VarType, conversion is attempted by calling VariantChangeType with a wFlags value of 0. An exception is thrown if conversion fails.

    Flags
    Type: Integer

    Flags affecting the behaviour of the wrapper object; see ComObjFlags for details.

    Return Value
    Type: ComValue, ComValueRef, ComObjArray or ComObject

    Returns a wrapper object containing a variant type and value or pointer.

    This object has multiple uses:

    Some COM methods may require specific types of values which have no direct equivalent within AutoHotkey. This function allows the type of a value to be specified when passing it to a COM method. For example, ComValue(0xB, true) creates an object which represents the COM boolean value true.
    Wrapping a COM object or SafeArray enables the script to interact with it more naturally, using object syntax. However, the majority of scripts do not need to do this manually since a wrapper object is created automatically by ComObject, ComObjArray, ComObjActive, ComObjGet and any COM method which returns an object.
    Wrapping a COM interface pointer allows the script to take advantage of automatic reference counting. An interface pointer can be wrapped immediately upon being returned to the script (typically from ComCall or DllCall), avoiding the need to explicitly release it at some later point.
    Ptr
    If a wrapper object's VarType is VT_UNKNOWN (13) or includes the VT_BYREF (0x4000) flag or VT_ARRAY (0x2000) flag, the Ptr property can be used to retrieve the address of the object, typed variable or SafeArray. This allows the ComObject itself to be passed to any DllCall or ComCall parameter which has the "Ptr" type, but can also be used explicitly. For example, ComObj.Ptr is equivalent to ComObjValue(ComObj) in these cases.

    If a wrapper object's VarType is VT_UNKNOWN (13) or VT_DISPATCH (9) and the wrapped pointer is null (0), the Ptr property can be used to retrieve the current null value or to assign a pointer to the wrapper object. Once assigned (if non-null), the pointer will be released automatically when the wrapper object is freed. This can be used with DllCall or ComCall output parameters of type "Ptr*" or "PtrP" to ensure the pointer will be released automatically, such as if an error occurs. For an example, see ComObjQuery.

    When a wrapper object with VarType VT_DISPATCH (9) and a null (0) pointer value is assigned a non-null pointer value, its type changes from ComValue to ComObject. The properties and methods of the wrapped object become available and the Ptr property becomes unavailable.

    ByRef
    If a wrapper object's VarType includes the VT_BYREF (0x4000) flag, empty brackets [] can be used to read or write the referenced value.

    When creating a reference, Value must be the memory address of a variable or buffer with sufficient capacity to store a value of the given type. For example, the following can be used to create a variable which a VBScript function can write into:

    vbuf := Buffer(24, 0)
    vref := ComValue(0x400C, vbuf.ptr)  ; 0x400C is a combination of VT_BYREF and VT_VARIANT.

    vref[] := "in value"
    sc.Run("Example", vref)  ; sc should be initialized as in the example below.
    MsgBox vref[]
    Note that although any previous value is freed when a new value is assigned by vref[] or the COM method, the final value is not freed automatically. Freeing the value requires knowing which type it is. Because it is VT_VARIANT in this case, it can be freed by calling VariantClear with DllCall or by using a simpler method: assign an integer, such as vref[] := 0.

    If the method accepts a combination of VT_BYREF and VT_VARIANT as shown above, a VarRef can be used instead. For example:

    some_var := "in value"
    sc.Run("Example", &some_var)
    MsgBox some_var
    However, some methods require a more specific variant type, such as VT_BYREF | VT_I4. In such cases, the first approach shown above must be used, replacing 0x400C with the appropriate variant type.

    General Remarks
    When this function is used to wrap an IDispatch or IUnknown interface pointer (passed as an integer), the wrapper object assumes responsibility for automatically releasing the pointer when appropriate. Therefore, if the script intends to use the pointer after calling this function, it must call ObjAddRef(DispPtr) first. By contrast, this is not necessary if Value is itself a ComValue or ComObject.

    Conversion from VT_UNKNOWN to VT_DISPATCH results in a call to IUnknown::QueryInterface, which may produce an interface pointer different to the original, and will throw an exception if the object does not implement IDispatch. By contrast, if Value is an integer and VarType is VT_DISPATCH, the value is used directly, and therefore must be an IDispatch-compatible interface pointer.

    The VarType of a wrapper object can be retrieved using ComObjType.

    The Value of a wrapper object can be retrieved using ComObjValue.

    Known limitation: Each time a COM object is wrapped, a new wrapper object is created. Comparisons and assignments such as obj1 == obj2 and array[obj1] := value treat the two wrapper objects as unique, even when they contain the same variant type and value.

    Related
    ComObjFromPtr, ComObject, ComObjGet, ComObjConnect, ComObjFlags, ObjAddRef/ObjRelease, ComObjQuery, GetActiveObject (Microsoft Docs)

    Examples
     Passes a VARIANT ByRef to a COM function.

    ; Preamble - ScriptControl requires a 32-bit version of AutoHotkey.
    code := "
    (
    Sub Example(Var)
        MsgBox Var
        Var = "out value!"
    End Sub
    )"
    sc := ComObject("ScriptControl"), sc.Language := "VBScript", sc.AddCode(code)


    ; Example: Pass a VARIANT ByRef to a COM method.
    var := ComVar()
    var[] := "in value"
    sc.Run("Example", var.ref)
    MsgBox var[]

    ; The same thing again, but more direct:
    variant_buf := Buffer(24, 0)  ; Make a buffer big enough for a VARIANT.
    var := ComValue(0x400C, variant_buf.ptr)  ; Make a reference to a VARIANT.
    var[] := "in value"
    sc.Run("Example", var)  ; Pass the VT_BYREF ComValue itself, no [] or .ref.
    MsgBox var[]
    ; If a VARIANT contains a string or object, it must be explicitly freed
    ; by calling VariantClear or assigning a pure numeric value:
    var[] := 0

    ; The simplest way when the method accepts VT_BYREF|VT_VARIANT:
    var := "in value"
    sc.Run("Example", &var)
    MsgBox var


    ; ComVar: An object which can be used to pass a value ByRef.
    ;   this[] retrieves the value.
    ;   this[] := Val sets the value.
    ;   this.ref retrieves a ByRef object for passing to a COM method.
    class ComVar {
        __new(vType := 0xC) {
            ; Allocate memory for a VARIANT to hold our value. VARIANT is used even
            ; when vType != VT_VARIANT so that VariantClear can be used by __delete.
            this.var := Buffer(24, 0)
            ; Create an object which can be used to pass the variable ByRef.
            this.ref := ComValue(0x4000|vType, this.var.ptr + (vType=0xC ? 0 : 8))
            ; Store the variant type for VariantClear (if not VT_VARIANT).
            if Type != 0xC
                NumPut "ushort", vType, this.var
        }
        __item {
            get => this.ref[]
            set => this.ref[] := value
        }
        __delete() {
            DllCall("oleaut32\VariantClear", "ptr", this.var)
        }
    }*/
/* Array Object
    
    class Array extends Object
    An Array object contains a list or sequence of values.

    Values are addressed by their position within the array (known as an array index), where position 1 is the first element.

    Arrays are often created by enclosing a list of values in brackets. For example:

    veg := ["Asparagus", "Broccoli", "Cucumber"]
    Loop veg.Length
        MsgBox veg[A_Index]
    A negative index can be used to address elements in reverse, so -1 is the last element, -2 is the second last element, and so on.

    Attempting to use an array index which is out of bounds (such as zero, or if its absolute value is greater than the Length of the array) is considered an error and will cause an IndexError to be thrown. The best way to add new elements to the array is to call InsertAt or Push. For example:

    users := Array()
    users.Push A_UserName
    MsgBox users[1]
    An array can also be extended by assigning a larger value to Length. This changes which indices are valid, but Has will show that the new elements have no value. Elements without a value are typically used for variadic calls or by variadic functions, but can be used for any purpose.

    "ArrayObj" is used below as a placeholder for any Array object, as "Array" is the class itself.

    In addition to the methods and property inherited from Object, Array objects have the following predefined methods and properties.

    Table of Contents
    Static Methods:
    Call: Creates a new Array containing the specified values.
    Methods:
    Clone: Returns a shallow copy of an array.
    Delete: Removes the value of an array element, leaving the index without a value.
    Get: Returns the value at a given index, or a default value.
    Has: Returns true if the specified index is valid and there is a value at that position.
    InsertAt: Inserts one or more values at a given position.
    Pop: Removes and returns the last array element.
    Push: Appends values to the end of an array.
    RemoveAt: Removes items from an array.
    __New: Appends items. Equivalent to Push.
    __Enum: Enumerates array elements.
    Properties:
    Length: Retrieves or sets the length of an array.
    Capacity: Retrieves or sets the current capacity of an array.
    Default: Defines the default value returned when an element with no value is requested.
    __Item: Retrieves or sets the value of an array element.
    Static Methods
    Call
    Creates a new Array containing the specified values.

    ArrayObj := Array(Value, Value2, ..., ValueN)
    Parameters are defined by __New.

    Methods
    Clone
    Returns a shallow copy of an array.

    Clone := ArrayObj.Clone()
    All array elements are copied to the new array. Object references are copied (like with a normal assignment), not the objects themselves.

    Own properties, own methods and base are copied as per Obj.Clone.

    Delete
    Removes the value of an array element, leaving the index without a value.

    ArrayObj.Delete(Index)
    Index
    Type: Integer

    A valid array index.

    Returns the removed value (blank if none).

    Delete does not affect the Length of the array.

    A ValueError is thrown if Index is out of range.

    Get
    Returns the value at a given index, or a default value.

    Value := ArrayObj.Get(Index , Default)
    This method does the following:

    Throw an IndexError if Index is zero or out of range.
    Return the value at Index, if there is one (see Has).
    Return the value of the Default parameter, if specified.
    Return the value of ArrayObj.Default, if defined.
    Throw an UnsetItemError.
    When Default is omitted, this is equivalent to ArrayObj[Index], except that __Item is not called.

    Has
    Returns true if the specified index is valid and there is a value at that position, otherwise false.

    ArrayObj.Has(Index)
    InsertAt
    Inserts one or more values at a given position.

    ArrayObj.InsertAt(Index, Value1 , Value2, ... ValueN)
    Index
    Type: Integer

    The position to insert Value1 at. Subsequent values are inserted at Index+1, Index+2, etc. Specifying an index of 0 is the same as specifying Length + 1.

    Value1 ...
    One or more values to insert. To insert an array of values, pass theArray* as the last parameter.

    InsertAt is the counterpart of RemoveAt.

    Any items previously at or to the right of Index are shifted to the right. Missing parameters are also inserted, but without a value. For example:

    x := []
    x.InsertAt(1, "A", "B") ; =>  ["A", "B"]
    x.InsertAt(2, "C")      ; =>  ["A", "C", "B"]

    ; Missing elements are preserved:
    x := ["A", , "C"]
    x.InsertAt(2, "B")      ; =>  ["A", "B",    , "C"]

    x := ["C"]
    x.InsertAt(1, , "B")    ; =>  [   , "B", "C"]
    A ValueError is thrown if Index is less than -ArrayObj.Length or greater than ArrayObj.Length + 1. For example, with an array of 3 items, Index must be between -3 and 4, inclusive.

    Pop
    Removes and returns the last array element.

    Value := ArrayObj.Pop()
    All of the following are equivalent:

    Value := ArrayObj.Pop()
    Value := ArrayObj.RemoveAt(ArrayObj.Length)
    Value := ArrayObj.RemoveAt(-1)
    If the array is empty (Length is 0), an Error is thrown.

    Push
    Appends values to the end of an array.

    ArrayObj.Push(Value, Value2, ..., ValueN)
    Value ...
    One or more values to insert. To insert an array of values, pass theArray* as the last parameter.

    RemoveAt
    Removes items from an array.

    ArrayObj.RemoveAt(Index , Length)
    Index
    Type: Integer

    The index of the value or values to remove.

    Length
    Type: Integer

    The length of the range of values to remove. If omitted, one item is removed.

    If Length is omitted, the removed value is returned (blank if none). Otherwise there is no return value.

    RemoveAt is the counterpart of InsertAt.

    A ValueError is thrown if the range indicated by Index and Length is not entirely within the array's current bounds.

    The remaining items to the right of Pos are shifted to the left by Length (or 1 if omitted). For example:

    x := ["A", "B"]
    MsgBox x.RemoveAt(1)  ; A
    MsgBox x[1]           ; B

    x := ["A", , "C"]
    MsgBox x.RemoveAt(1, 2)  ; 1
    MsgBox x[1]              ; C
    __New
    Appends items. Equivalent to Push.

    ArrayObj.__New(Value, Value2, ..., ValueN)
    This method exists to support Call, and is not intended to be called directly. See Construction and Destruction.

    __Enum
    Enumerates array elements.

    For Value in ArrayObj
    For Index, Value in ArrayObj
    Returns a new enumerator. This method is typically not called directly. Instead, the array object is passed directly to a for-loop, which calls __Enum once and then calls the enumerator once for each iteration of the loop. Each call to the enumerator returns the next array element. The for-loop's variables correspond to the enumerator's parameters, which are:

    Index
    Type: Integer

    The array index, typically the same as A_Index. This is present only in the two-parameter mode.

    Value
    The value (if there is no value, Value becomes uninitialized).

    Properties
    Length
    Retrieves or sets the length of an array.

    Length := ArrayObj.Length
    ArrayObj.Length := Length
    The length includes elements which have no value. Increasing the length changes which indices are considered valid, but the new elements have no value (as indicated by Has). Decreasing the length truncates the array.

    MsgBox ["A", "B", "C"].Length  ;  3
    MsgBox ["A",    , "C"].Length  ;  3
    Capacity
    Retrieves or sets the current capacity of an array.

    ArrayObj.Capacity := MaxItems
    MaxItems := ArrayObj.Capacity
    MaxItems
    Type: Integer

    The maximum number of elements the array should be able to contain before it must be automatically expanded. If setting a value less than Length, elements are removed.

    Default
    Defines the default value returned when an element with no value is requested.

    ArrayObj.Default := Value
    This property actually doesn't exist by default, but can be defined by the script. When the script requests an element which has no value, the array checks for this property before throwing an UnsetItemError. It can be implemented by any of the normal means, including a dynamic property or meta-function, but determining which key was queried would require overriding __Item or Get instead.

    Setting a default value does not prevent an error from being thrown when the index is out of range.

    __Item
    Retrieves or sets the value of an array element.

    Value := ArrayObj[Index]
    ArrayObj[Index] := Value
    Index
    Type: Integer

    A valid array index; that is, an integer with absolute value between 1 and Length (inclusive).

    A negative index can be used to address elements in reverse, so that -1 is the last element, -2 is the second last element, and so on.

    Attempting to use an index which is out of bounds (such as zero, or if its absolute value is greater than the Length of the array) is considered an error and will cause an IndexError to be thrown.

    The property name __Item is typically omitted, as shown above, but is used when overriding the property.*/
/* Map Object
 
    class Map extends Object
    A Map object associates or maps one set of values, called keys, to another set of values. A key and the value it is mapped to are known as a key-value pair. A map can contain any number of key-value pairs, but each key must be unique.

    A key may be any Integer, object reference or null-terminated String. Comparison of string keys is case-sensitive, while objects are compared by reference/address. Float keys are automatically converted to String.

    The simplest use of a map is to retrieve or set a key-value pair via the implicit __Item property, by simply writing the key between brackets following the map object. For example:

    clrs := Map()
    clrs["Red"] := "ff0000"
    clrs["Green"] := "00ff00"
    clrs["Blue"] := "0000ff"
    for clr in Array("Blue", "Green")
        MsgBox clrs[clr]
    "MapObj" is used below as a placeholder for any Map object, as "Map" is the class itself.

    In addition to the methods and property inherited from Object, Map objects have the following predefined methods and properties.

    Table of Contents
    Static Methods:
    Call: Creates a Map and sets items.
    Methods:
    Clear: Removes all key-value pairs from a map.
    Clone: Returns a shallow copy of a map.
    Delete: Removes a key-value pair from a map.
    Get: Returns the value associated with a key, or a default value.
    Has: Returns true if the specified key has an associated value within a map.
    Set: Sets zero or more items.
    __Enum: Enumerates key-value pairs.
    __New: Sets items. Equivalent to Set.
    Properties:
    Count: Retrieves the number of key-value pairs present in a map.
    Capacity: Retrieves or sets the current capacity of a map.
    CaseSense: Retrieves or sets a map's case sensitivity setting.
    Default: Defines the default value returned when a key is not found.
    __Item: Retrieves or sets the value of a key-value pair.
    Static Methods
    Call
    Creates a Map and sets items.

    MapObj := Map(Key1, Value1, Key2, Value2, ...)
    This is equivalent to setting each item with MapObj[Key] := Value, except that __Item is not called and Capacity is automatically adjusted to avoid expanding multiple times during a single call.

    Parameters are defined by __New.

    Methods
    Clear
    Removes all key-value pairs from a map.

    MapObj.Clear()
    Clone
    Returns a shallow copy of a map.

    Clone := MapObj.Clone()
    All key-value pairs are copied to the new map. Object references are copied (like with a normal assignment), not the objects themselves.

    Own properties, own methods and base are copied as per Obj.Clone.

    Delete
    Removes a key-value pair from a map.

    MapObj.Delete(Key)
    Key
    Type: Integer, object or String

    Any single key. If the map does not contain this key, an UnsetItemError is thrown.

    Returns the removed value.

    Get
    Returns the value associated with a key, or a default value.

    Value := MapObj.Get(Key , Default)
    This method does the following:

    Return the value associated with Key, if found.
    Return the value of the Default parameter, if specified.
    Return the value of MapObj.Default, if defined.
    Throw an UnsetItemError.
    When Default is omitted, this is equivalent to MapObj[Key], except that __Item is not called.

    Has
    Returns true if the specified key has an associated value within a map, otherwise false.

    MapObj.Has(Key)
    Set
    Sets zero or more items.

    MapObj.Set(Key, Value, Key2, Value2, ...)
    This is equivalent to setting each item with MapObj[Key] := Value, except that __Item is not called and Capacity is automatically adjusted to avoid expanding multiple times during a single call.

    Returns the map.

    __Enum
    Enumerates key-value pairs.

    For Key , Value in MapObj
    Returns a new enumerator. This method is typically not called directly. Instead, the map object is passed directly to a for-loop, which calls __Enum once and then calls the enumerator once for each iteration of the loop. Each call to the enumerator returns the next key and/or value. The for-loop's variables correspond to the enumerator's parameters, which are:

    Key
    Type: Integer, object or String

    The key.

    Value
    The value.

    __New
    Sets items. Equivalent to Set.

    MapObj.__New(Key, Value, Key2, Value2, ...)
    This method exists to support Call, and is not intended to be called directly. See Construction and Destruction.

    Properties
    Count
    Retrieves the number of key-value pairs present in a map.

    Count := MapObj.Count
    Capacity
    Retrieves or sets the current capacity of a map.

    MapObj.Capacity := MaxItems
    MaxItems := MapObj.Capacity
    MaxItems
    Type: Integer

    The maximum number of key-value pairs the map should be able to contain before it must be automatically expanded. If setting a value less than the current number of key-value pairs, that number is used instead, and any unused space is freed.

    CaseSense
    Retrieves or sets a map's case sensitivity setting.

    MapObj.CaseSense := Setting
    Setting := MapObj.CaseSense
    Setting
    Type: String

    One of the following values:

    "On": Key lookups are case sensitive. This is the default setting.

    "Off": The letters A-Z are considered identical to their lowercase counterparts.

    "Locale": Key lookups are case insensitive according to the rules of the current user's locale. For example, most English and Western European locales treat not only the letters A-Z as identical to their lowercase counterparts, but also non-ASCII letters like Ä and Ü as identical to theirs. Locale is 1 to 8 times slower than Off depending on the nature of the strings being compared.

    When assigning a value, the strings "1" and "0" can also be used.

    Attempting to assign to this property causes an exception to be thrown if the Map is not empty.

    Default
    Defines the default value returned when a key is not found.

    MapObj.Default := Value
    This property actually doesn't exist by default, but can be defined by the script. When the script queries a key which is not found, the map checks for this property before throwing an UnsetItemError. It can be implemented by any of the normal means, including a dynamic property or meta-function, but determining which key was queried would require overriding __Item or Get instead.

    __Item
    Retrieves or sets the value of a key-value pair.

    Value := MapObj[Key]
    MapObj[Key] := Value
    Key
    Type: Integer, object or String

    When retrieving a value, Key must be a unique value previously associated with another value. An UnsetItemError is thrown if Key has no associated value within the map, unless a Default property is defined, in which case its value is returned.

    When assigning a value, Key can be any value to associate with Value; in other words, the key used to later access Value. Float keys are automatically converted to String.

    The property name __Item is typically omitted, as shown above, but is used when overriding the property.*/
/* Error Types
    MemoryError: A memory allocation failed.
    OSError: An internal function call to a Win32 function failed. Message includes an error code and description generated by the operating system. OSErrors have an additional Number property which contains the error code. Calling OSError(code) with a numeric code sets Number and Message based on the given OS-defined error code. If code is omitted it defaults to A_LastError.
    TargetError: A function failed because its target could not be found. Message indicates what kind of target, such as a window, control, menu or status bar.
    TimeoutError: SendMessage timed out.
    TypeError: An unexpected type of value was used as input for a function, property assignment, or some other operation. Usually Message indicates the expected and actual type, and Extra contains a string representing the errant value.
    UnsetError: An attempt was made to read the value of a variable, property or item, but there was no value.
    MemberError
    PropertyError
    MethodError
    UnsetItemError
    ValueError: An unexpected value was used as input for a function, property assignment, or some other operation. Usually Message indicates which expectation was broken, and Extra contains a string representing the errant value.
    IndexError: The index parameter of an object's __Item property was invalid or out of range.
    ZeroDivisionError: Division by zero was attempted in an expression or with the Mod function.*/
/* __item
    -The __Item property is invoked when the indexing operator (array syntax) is used with the object. In the following example, the property is declared as static so that the indexing operator can be used on the Env class itself. For another example, see */
/* Class Initialization

    ;//==========
    Each class is initialized automatically when a reference to the class is evaluated for the first time. For example, if MyClass has not yet been initialized, MyClass.MyProp would cause the class to be initialized before the property is retrieved. Initialization consists of calling two static methods: __Init and __New.

    static __Init is defined automatically for every class, 
    and always begins with a reference to the base class if one was specified, to ensure it is initialized. 

    Static/class variables and nested classes are initialized in the order that they were defined, 
    except when a nested class is referenced during initialization of a previous variable or class.

    If the class defines or inherits a static __New method, it is called immediately after __Init. 
    It is important to note that __New may be called once for the class in which it is defined,
    and once for each subclass which does not define its own (or which calls super.__New()). 
    This can be used to perform common initialization tasks for each subclass, 
    or modify subclasses in some way before they are used.

    If static __New is not intended to act on derived classes, that can be avoided by checking the value of this. 
    In some cases it may be sufficient for the method to delete itself, 
    such as with this.DeleteProp('__New'); 
    however, the first execution of __New might be for a subclass...
    if one is nested in the base class or referenced during initialization of a static/class variable.

    A class definition also has the effect of referencing the class. 
    In other words, when execution reaches a class definition during script startup, 
    __Init and __New are called automatically, unless the class was already referenced by the script. 

    However, if execution is prevented from reaching the class definition, such as by return or an infinite loop, 
    the class is initialized only if it is referenced.

    Once automatic initialization begins, it will not occur again for the same class. 
    This is generally not a problem unless multiple classes refer to each other. 
    For example, consider the two classes below. 

    When A is initialized first, evaluating B.SharedArray (A1) causes B to be initialized before retrieving and returning the value, 
    but A.SharedValue (A3) is undefined and does not cause initialization of A because it is already in progress. 
    In other words, if A is accessed or initialized first,

     the order is A1 to A3;
      otherwise it is B1 to B4: 


      MsgBox A.SharedArray.Length
      MsgBox B.SharedValue

      class A {
          static SharedArray := B.SharedArray   ; A1          ; B3
          static SharedValue := 42                            ; B4
      }

      class B {
          static SharedArray := StrSplit("XYZ") ; A2          ; B1
          static SharedValue := A.SharedValue   ; A3 (Error)  ; B2
      } */