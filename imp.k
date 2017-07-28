/*!
\title {K3 project: Extended IMP with COBOL condition constructs}
\author {Paolo D'Arienzo, Federica Carloni}
*/

/*@ \section{Abstract}
This project extend IMP with conditional COBOL constructs:
IF condition statement, relation condition, negated condition,
sign condition, class condition, condition-name condition, combined condition. \\
Version of K Framework used: 3.5.2
*/

module IMP-SYNTAX
/*@ \section{Syntax}
This module defines the syntax of extended IMP.*/

//@Syntax of arithmetic expressions
 syntax AExp ::= Int | Id
               | AExp "**" AExp                                           [left, strict]   //Power
               > AExp "*" AExp                                            [left, strict]
               | AExp "/" AExp                                            [left, strict]
               > AExp "+" AExp                                            [left, strict]
               | AExp "-" AExp                                            [left, strict]
               > "(" AExp ")"                                             [bracket]

//@Syntax of expressions on strings
syntax SExp ::= String | Id
              | SExp "+" SExp                                             [left, strict]
              > "(" SExp ")"                                              [bracket]

//@Syntax of both arithmetic and on-strings expression
syntax Exps ::= AExp | SExp

//@Defining the syntax of the construct of the following type: (I1, I2), where I1 and I2 are integers
syntax RangeInt ::= "(" Int "," Int ")"
//@Defining the syntax of the construct of the following type: (S1, S2), where S1 and S2 are the same string, so that the K compiler can distinguish between condition-name condition on strings and string declaration
syntax RangeString ::= "(" String "," String ")"
//@Setting RangeInt and RangeString as a KItem
syntax KItem ::= RangeInt
syntax KItem ::= RangeString

/*@
Syntax of boolean condition, negated condition, relation condition, 
sign condition, combined condition, class condition.
*/
 syntax BExp ::= Bool | Id | RangeInt | RangeString
               | Exps "==" Exps	                                          [left, seqstrict]
               | Exps ">" Exps                                            [left, seqstrict]
               | Exps "<" Exps	                                          [left, seqstrict]
               | Exps ">=" Exps                                           [left, seqstrict]
               | Exps "<=" Exps                                           [left, seqstrict]
               | Exps "!=" Exps                                           [left, seqstrict] //Not equal
               | "!" BExp                                                 [strict]          //Not
//Negated condition syntax
               | "NOT" BExp                                               [strict]
//Relation condition syntax
               | Exps "IS" "EQUAL TO" Exps                                [left, seqstrict]
               | Exps "IS" "GREATER THAN" Exps                            [left, seqstrict]
               | Exps "IS" "LESS THAN" Exps                               [left, seqstrict]
               | Exps "IS" "GREATER THAN" "OR" "EQUAL TO" Exps            [left, seqstrict]
               | Exps "IS" "LESS THAN" "OR" "EQUAL TO" Exps               [left, seqstrict]
               | Exps "IS" "=" Exps                                       [left, seqstrict]
               | Exps "IS" ">" Exps                                       [left, seqstrict]
               | Exps "IS" "<" Exps                                       [left, seqstrict]
               | Exps "IS" ">=" Exps                                      [left, seqstrict]
               | Exps "IS" "<=" Exps                                      [left, seqstrict]
               | Exps "IS" "NOT" "EQUAL TO" Exps                          [left, seqstrict]
               | Exps "IS" "NOT" "GREATER THAN" Exps                      [left, seqstrict]
               | Exps "IS" "NOT" "LESS THAN" Exps                         [left, seqstrict]
               | Exps "IS" "NOT" "=" Exps                                 [left, seqstrict]
               | Exps "IS" "NOT" ">" Exps                                 [left, seqstrict]
               | Exps "IS" "NOT" "<" Exps                                 [left, seqstrict]
//Sign condition syntax
               | AExp "IS" "POSITIVE"                                     [strict]
               | AExp "IS" "NEGATIVE"                                     [strict]
               | AExp "IS" "ZERO"                                         [strict]
               | AExp "IS" "NOT" "POSITIVE"                               [strict]
               | AExp "IS" "NOT" "NEGATIVE"                               [strict]
               | AExp "IS" "NOT" "ZERO"                                   [strict]
//Class condition syntax
               | Exps "IS" "NUMERIC"                                      [strict]
               | Exps "IS" "ALPHABETIC"                                   [strict]
               | Exps "IS" "ALPHABETIC-LOWER"                             [strict]
               | Exps "IS" "ALPHABETIC-UPPER"                             [strict]
               | Exps "IS" "NOT" "NUMERIC"                                [strict]
               | Exps "IS" "NOT" "ALPHABETIC"                             [strict]
               | Exps "IS" "NOT" "ALPHABETIC-LOWER"                       [strict]
               | Exps "IS" "NOT" "ALPHABETIC-UPPER"                       [strict]
//Combined condition syntax
               > BExp "AND" BExp                                          [left, strict(1)]
               | BExp "&&" BExp                                           [left, strict(1)]
               | BExp "OR" BExp                                           [left, strict(1)]
               | BExp "||" BExp                                           [left, strict(1)]
               > "(" BExp ")"                                             [bracket]

//@Syntax of blocks
  syntax Block ::= "{" "}"
                 | "{" Stmts "}"

//@Syntax of statements
  syntax Stmt  ::= Block
                 | Exps ";"                                               [strict] //allows "3+4;"-like line
                 | "int" Ids ";"                                          //int declaration
                 | "bool" Ids ";"                                         //bool declaration
                 | "string" Ids ";"                                       //string declaration
                 | Id "=" Exps ";"                                        [strict(2)] //Variable assignment (int, string)
                 | Id "=" BExp ";"                                        [strict(2)] //Variable assignment (bool)
                 | "IF" BExp "THEN"
                  Stmts "ELSE" Stmts "END-IF"                             [strict(1)]
                 | "int" Id ";" CondName                                  //Condition-name condition with int
                 | "string" Id ";" CondName                               //Condition-name condition with string

//@Syntax of condition-name condition
  syntax CondName ::= "88" Id "VALUE" Int "."
                    | "88" Id "VALUE" String "."
                    | "88" Id "VALUE" "IS" Int "."
                    | "88" Id "VALUE" "IS" String "."
                    | "88" Id "VALUES" Int "THRU" Int "."
                    | "88" Id "VALUES" "ARE" Int "THRU" Int "."
//More than one condition-name declared
                    | "88" Id "VALUE" Int "." CondName
                    | "88" Id "VALUE" String "." CondName
                    | "88" Id "VALUE" "IS" Int "." CondName
                    | "88" Id "VALUE" "IS" String "." CondName
                    | "88" Id "VALUES" Int "THRU" Int "." CondName
                    | "88" Id "VALUES" "ARE" Int "THRU" Int "." CondName

//@Syntax of program
  syntax Pgm ::= Blocks

//@Syntax of id list
  syntax Ids ::= List{Id,","}
//@Syntax of statements list
  syntax Stmts ::= List{Stmt,""}
//@Syntax of block list
  syntax Blocks ::= List{Block, ""}

endmodule

///////////////////////////////////////////////////////////////////////////////////////////

module IMP
/*@ \section{Semantics}
This module defines the semantics of extended IMP.*/

 imports IMP-SYNTAX

/*@ \subsection{Values and results}
Extended IMP can have five kind of results, primitive type as integers, booleans or strings,
and the KItems RangeInt and RangeString, that are needed to the K compiler to understand the distinction between condition-name variables and variables. \\
That distinction is achieved using the following form: (A,B), where A and B can be integers or strings. In the second case, A and B are always equal.
*/
  syntax KResult ::= Int | Bool | String | RangeInt | RangeString

  configuration <T color="GreenYellow">
                  <k color="Violet"> $PGM:Pgm </k>
                  <env color="LightSkyBlue"> .Map </env>
                  <store color="Red"> .Map </store>
                  <condName color="Yellow"> .Map </condName>
                </T>

///////////////////////////////////////////////////////////////////////////////////////////

//AExp

//@Semantics that handle numerical operations
 rule I1 ** I2 => I1 ^Int I2
 rule I1 * I2 => I1 *Int I2
 rule I1 / I2 => I1 /Int I2 when I2 =/=Int 0
 rule I1:Int + I2:Int => I1 +Int I2
 rule I1 - I2 => I1 -Int I2

//@String concatenation
 rule S1:String + S2:String => S1 +String S2

///////////////////////////////////////////////////////////////////////////////////////////

// BExp on integers

//@Semantics of boolean conditions on integers
 rule I1 == I2 => I1 ==Int I2
 rule I1 > I2 => I1 >Int I2
 rule I1 < I2 => I1 <Int I2
 rule I1 >= I2 => I1 >=Int I2
 rule I1 <= I2 => I1 <=Int I2
 rule I1 != I2 => I1 =/=Int I2
 rule ! B => notBool B

//BExp on strings

//@Semantics of boolean conditions on strings
 rule S1 == S2 => S1 ==String S2
 rule S1 > S2 => S1 >String S2
 rule S1 < S2 => S1 <String S2
 rule S1 >= S2 => S1 >=String S2
 rule S1 <= S2 => S1 <=String S2
 rule S1 != S2 => S1 =/=String S2

//NEGATED CONDITION
//@Semantics of negated condition
 rule NOT B => notBool B

// CONDITIONS

//Relation Condition

//@Semantics of relation condition
 rule I1 IS EQUAL TO I2 => I1 ==Int I2
 rule S1 IS EQUAL TO S2 => S1 ==String S2

 rule I1 IS GREATER THAN I2 => I1 >Int I2
 rule I1 IS GREATER THAN OR EQUAL TO I2 => I1 >=Int I2
 rule S1 IS GREATER THAN S2 => S1 >String S2
 rule S1 IS GREATER THAN OR EQUAL TO S2 => S1 >=String S2

 rule I1 IS LESS THAN I2 => I1 <Int I2
 rule I1 IS LESS THAN OR EQUAL TO I2 => I1 <=Int I2
 rule S1 IS LESS THAN S2 => S1 <String S2
 rule S1 IS LESS THAN OR EQUAL TO S2 => S1 <=String S2

//With symbols

 rule I1 IS = I2 => I1 ==Int I2
 rule S1 IS = S2 => S1 ==String S2

 rule I1 IS > I2 => I1 >Int I2
 rule I1 IS >= I2 => I1 >=Int I2
 rule S1 IS > S2 => S1 >String S2
 rule S1 IS >= S2 => S1 >=String S2

 rule I1 IS < I2 => I1 <Int I2
 rule I1 IS <= I2 => I1 <=Int I2
 rule S1 IS < S2 => S1 <String S2
 rule S1 IS <= S2 => S1 <=String S2

//NOT

 rule I1 IS NOT EQUAL TO I2 => I1 =/=Int I2
 rule S1 IS NOT EQUAL TO S2 => S1 =/=String S2

 rule I1 IS NOT GREATER THAN I2 => notBool I1 >Int I2
 rule S1 IS NOT GREATER THAN S2 => notBool S1 >String S2

 rule I1 IS NOT LESS THAN I2 => notBool I1 <Int I2
 rule S1 IS NOT LESS THAN S2 => notBool S1 <String S2


//Not with symbols

 rule I1 IS NOT = I2 => I1 =/=Int I2
 rule S1 IS NOT = S2 => S1 =/=String S2

 rule I1 IS NOT > I2 => notBool I1 >Int I2
 rule S1 IS NOT > S2 => notBool S1 >String S2

 rule I1 IS NOT < I2 => notBool I1 <Int I2
 rule S1 IS NOT < S2 => notBool S1 <String S2

//Sign condition

//@Semantics of sign condition
 rule I1 IS POSITIVE => I1 >Int 0
 rule I1 IS NEGATIVE => I1 <Int 0
 rule I1 IS ZERO => I1 =Int 0
 rule I1 IS NOT POSITIVE => notBool I1 >Int 0
 rule I1 IS NOT NEGATIVE => notBool I1 <Int 0
 rule I1 IS NOT ZERO => I1 =/=Int 0

//Class Condition

//@Semantics of class condition
 rule I:Int IS NUMERIC => true
 rule S:String IS NUMERIC => 
   #if lengthString(S) =/=Int 1 #then 
      substrString(S, 0, lengthString(S)/Int 2) IS NUMERIC && substrString(S, lengthString(S)/Int 2, lengthString(S)) IS NUMERIC
   #else 
      (#isDigit(S))
   #fi when S =/=String ""

 rule I:Int IS ALPHABETIC => false
 rule S:String IS ALPHABETIC =>
   #if lengthString(S) =/=Int 1 #then 
      substrString(S, 0, lengthString(S)/Int 2) IS ALPHABETIC && substrString(S, lengthString(S)/Int 2, lengthString(S)) IS ALPHABETIC
   #else 
      (isLowerCase(S) OR isUpperCase(S)) OR (#isWhiteSpace(S))
   #fi when S =/=String ""

 rule I:Int IS ALPHABETIC-LOWER => false
 rule S:String IS ALPHABETIC-LOWER =>
   #if lengthString(S) =/=Int 1 #then 
      substrString(S, 0, lengthString(S)/Int 2) IS ALPHABETIC-LOWER && substrString(S, lengthString(S)/Int 2, lengthString(S)) IS ALPHABETIC-LOWER
   #else 
      (isLowerCase(S) OR (#isWhiteSpace(S)))
   #fi when S =/=String ""

 rule I:Int IS ALPHABETIC-UPPER => false
 rule S:String IS ALPHABETIC-UPPER =>
   #if lengthString(S) =/=Int 1 #then 
      substrString(S, 0, lengthString(S)/Int 2) IS ALPHABETIC-UPPER && substrString(S, lengthString(S)/Int 2, lengthString(S)) IS ALPHABETIC-UPPER
   #else 
      (isUpperCase(S) OR (#isWhiteSpace(S)))
   #fi when S =/=String ""

 rule E IS NOT NUMERIC => !(E IS NUMERIC)
 rule E IS NOT ALPHABETIC => !(E IS ALPHABETIC)
 rule E IS NOT ALPHABETIC-LOWER => !(E IS ALPHABETIC-LOWER)
 rule E IS NOT ALPHABETIC-UPPER => !(E IS ALPHABETIC-UPPER)

//Combined condition

//@Semantics of combined condition
 rule true AND B => B
 rule false AND _ => false
 rule true OR _ => true
 rule false OR B => B

 rule true && B => B
 rule false && _ => false
 rule true || _ => true
 rule false || B => B

///////////////////////////////////////////////////////////////////////////////////////////

//Block

//@Semantics of block 
 rule <k> {Ss} => Ss ~> Rho ...</k> <env> Rho </env>                           [structural]

 //Tali regole non sono necessarie per i requisiti del progetto
 //rule <k> {} => . ~> Rho ...</k> <env> Rho </env>                            [structural]
 //rule <k> Rho => . ...</k> <env> _ => Rho </env>                             [structural]

///////////////////////////////////////////////////////////////////////////////////////////

//Lookup rules

//@Rule of id lookup; associates the corresponding value to the id
 rule <k> X:Id => I ...</k>
      <env> X |-> N ...</env>
      <store> N |-> I ...</store>                                              [lookup]

//@Rule of Condition-name condition lookup on integers; recognize when the variable is a condition-name on integers and translates it in the corresponding boolean expression
 rule <k> C:Id => ((X IS GREATER THAN OR EQUAL TO N1) AND (X IS LESS THAN OR EQUAL TO N2)) ...</k>
      <env> C |-> (N1:Int, N2:Int) ...</env>
	<condName> C |-> X ...</condName>                                      [lookup]

//@Rule of Condition-name condition lookup on strings; recognize when the variable is a condition-name on a string and translates it in the corresponding boolean expression
 rule <k> C:Id => (X IS EQUAL TO N1) ...</k>
      <env> C |-> (N1:String, N2:String) ...</env>
	<condName> C |-> X ...</condName>                                      [lookup]


///////////////////////////////////////////////////////////////////////////////////////////

//Stmt

//@Declaration of variables
  rule <k> int (X:Id,Xs => Xs); ...</k>
       <env> Rho => Rho[X <- !N:Int] </env>
       <store> .Map => !N |-> 0 ...</store>
       when notBool(X in keys(Rho))                                     [declaration]

  rule <k> bool (X:Id,Xs => Xs); ...</k>
       <env> Rho => Rho[X <- !N:Int] </env>
       <store> .Map => !N |-> false ...</store>
       when notBool(X in keys(Rho))                                     [declaration]

  rule <k> string (X:Id,Xs => Xs); ...</k>
       <env> Rho => Rho[X <- !N:Int] </env>
       <store> .Map => !N |-> "" ...</store>
       when notBool(X in keys(Rho))                                     [declaration]

//@Semantics of assignment of int, bool and string
 rule <k> X = I:Int; => . ...</k>
       <env> X |-> N ...</env>
       <store> N |-> (_ => I) ...</store>                               [assignment]

  rule <k> X = B:Bool; => . ...</k>
       <env> X |-> N ...</env>
       <store> N |-> (_ => B) ...</store>                               [assignment]

 rule <k> X = S:String; => . ...</k>
       <env> X |-> N ...</env>
       <store> N |-> (_ => S) ...</store>                               [assignment]

//@Semantics of IF condition statement
 rule IF (true) THEN S ELSE _ END-IF => S
 rule IF (false) THEN _ ELSE S END-IF => S

///////////////////////////////////////////////////////////////////////////////////////////

//Condition-name condition

//@Semantics of condition-name condition

//Not recursive
//Int

 rule <k> int X:Id; 88 C:Id VALUE V:Int . => int X; ...</k>
      <env> Rho => Rho[C <- (V,V)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id; 88 C:Id VALUE IS V:Int . => int X; ...</k>
      <env> Rho => Rho[C <- (V,V)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id; 88 C:Id VALUES V1:Int THRU V2:Int . => int X; ...</k>
      <env> Rho => Rho[C <- (V1,V2)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id; 88 C:Id VALUES ARE V1:Int THRU V2:Int . => int X; ...</k>
      <env> Rho => Rho[C <- (V1,V2)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

//String

 rule <k> string X:Id; 88 C:Id VALUE S:String . => string X; ...</k>
      <env> Rho => Rho[C <- (S,S)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> string X:Id; 88 C:Id VALUE IS S:String . => string X; ...</k>
      <env> Rho => Rho[C <- (S,S)] </env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

//Recursive
//Int

 rule <k> int X:Id ; 88 C:Id VALUE V:Int . CN:CondName => int X; CN ...</k>
      <env> Rho => Rho[C <- (V,V)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id ; 88 C:Id VALUE IS V:Int . CN:CondName => int X; CN ...</k>
      <env> Rho => Rho[C <- (V,V)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id ; 88 C:Id VALUES V1:Int THRU V2:Int . CN:CondName => int X; CN ...</k>
      <env> Rho => Rho[C <- (V1,V2)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> int X:Id ; 88 C:Id VALUES ARE V1:Int THRU V2:Int . CN:CondName => int X; CN ...</k>
      <env> Rho => Rho[C <- (V1,V2)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

//String

 rule <k> string X:Id ; 88 C:Id VALUE S:String . CN:CondName => string X; CN ...</k>
      <env> Rho => Rho[C <- (S,S)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

 rule <k> string X:Id ; 88 C:Id VALUE IS S:String . CN:CondName => string X; CN ...</k>
      <env> Rho => Rho[C <- (S,S)] ...</env>
      <condName> Sigma => Sigma[C <- X:Id] </condName>                                        [declaration]

///////////////////////////////////////////////////////////////////////////////////////////

//Lists

//@Semantics of list of ids, stmts and blocks
  rule int .Ids; => .                                                   [structural]
  rule bool .Ids; => .                                                  [structural]
  rule string .Ids; => .                                                [structural]
     
  rule .Stmts => .                                                      [structural]
  rule S:Stmt Ss:Stmts => S ~> Ss                                       [structural]

  rule .Blocks => .                                                     [structural]
  rule B:Block Bb:Blocks => B ~> Bb                                     [structural]

endmodule
