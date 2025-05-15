import java_cup.runtime.Symbol;

%%

%public
%unicode
%line
%column
%cup
%class MeuScanner

PLUS = \+
NUM  = [0-9]+

%%

{NUM}     { return new Symbol(sym.NUM, yyline, yycolumn, Integer.parseInt(yytext())); }
{PLUS}    { return new Symbol(sym.PLUS); }
{ return new java_cup.runtime.Symbol(sym.EOF); }
\n        { /* ignora nova linha */ }
[ \t\r]+  { /* ignora espaços */ }
.         { System.err.println("Caractere inválido: " + yytext()); return null; }