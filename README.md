# 04-jcup

1. Criar o arquivo `exemplo.flex`:
- `touch exemplo.flex`

2. Informar o conteúdo do arquivo `exemplo.flex`:
```java
/* Definição: seção para código do usuário. */

import java_cup.runtime.Symbol;

%%

/* Opções e Declarações: seção para diretivas e macros. */

// Diretivas:
%cup
%unicode
%line
%column
%class AnalisadorLexico

// Macros:
digito = [0-9]
inteiro = {digito}+

%%

/* Regras e Ações Associadas: seção de instruções para o analisador léxico. */

{inteiro} {
            Integer numero = Integer.valueOf(yytext());
            return new Symbol(sym.INTEIRO, yyline, yycolumn, numero);
          }
"+"       { return new Symbol(sym.MAIS); }
"-"       { return new Symbol(sym.MENOS); }
"("       { return new Symbol(sym.PARENTESQ); }
")"       { return new Symbol(sym.PARENTDIR); }
";"       { return new Symbol(sym.PTVIRG); }
\n        { /* Ignora nova linha. */ }
[ \t\r]+  { /* Ignora espaços. */ }
.         { System.err.println("\n Caractere inválido: " + yytext() +
                               "\n Linha: " + yyline +
                               "\n Coluna: " + yycolumn + "\n"); 
            return null; 
          }
```

3. Criar o arquivo `exemplo.cup`:
- `touch exemplo.cup`

4. Informar o conteúdo do arquivo `exemplo.cup`:
```java
import java_cup.runtime.*;

terminal Integer INTEIRO;
terminal MAIS, MENOS, PTVIRG, PARENTESQ, PARENTDIR;

non terminal inicio;
non terminal Integer expr;

precedence left MAIS, MENOS;

start with inicio;

inicio ::= expr:e PTVIRG {: System.out.println(e); :}
         ;

expr ::= expr:a MAIS expr:b         {: RESULT = a.intValue() + b.intValue(); :}
       | expr:a MENOS expr:b        {: RESULT = a.intValue() - b.intValue(); :}
       | PARENTESQ expr:a PARENTDIR {: RESULT = a.intValue(); :}
       | INTEIRO:a                  {: RESULT = a.intValue(); :}
       ;
```

5. Criar o arquivo `Main.java`:
- `touch Main.java`

6. Informar o conteúdo do arquivo `Main.java`:
```java
import java.io.*;

public class Main {
  public static void main(String[] args) throws Exception {
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
    System.out.println("Digite expressões (termine com ';') e pressione ENTER. Ctrl+C para sair.");

    while (true) {
      System.out.print("> ");
      
      String linha = bufferedReader.readLine();

      if (linha == null || linha.trim().isEmpty()) 
        continue;

      // Adicionar um \n no final para garantir que o analisador leia a linha completa:
      StringReader stringReader = new StringReader(linha + "\n");

      AnalisadorSintatico analisadorSintatico = new AnalisadorSintatico(new AnalisadorLexico(stringReader));
      
      try {
        analisadorSintatico.parse();
      } catch (Exception e) {
        System.err.println("Erro na expressão: " + e.getMessage());
      }
    }
  }
}
```

7. Criar o arquivo `executar.sh`:
- `touch executar.sh`

8. Informar o conteúdo do arquivo `executar.sh`:
```bash
#!/bin/bash

# Remover arquivos:
rm -rf *.class *.java~
rm -rf jcup.jar AnalisadorSintatico.java sym.java 
rm -rf jflex.jar AnalisadorLexico.java   

# Baixar JFlex e JCup:
wget https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar
wget https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar

# Gerar o Analisador Léxico:
java -cp jflex.jar:jcup.jar jflex.Main exemplo.flex

# Gerar o Analisador Sintático:
java -cp jcup.jar java_cup.Main -parser AnalisadorSintatico exemplo.cup

# Compilar as classes .java:
javac -cp jcup.jar *.java

# Executar a classe principal:
echo "Digite uma expressão:"
echo "Exemplos:"
echo "(10 + 5) - 2; -> 13"
echo "10 + (5 - 2); -> 13"
echo "10 + 5 - 2;   -> 13"
echo "10 - (5 + 2); ->  3"
echo "10 - 5 + 2;   ->  7"
java -cp .:jcup.jar Main
```

9. Dar permissão de execução para o arquivo de script `executar.sh` (torná-lo executável):
- `chmod +x executar.sh`

10. Executar o `executar.sh`:
- `./executar.sh`

11. Informar expressões matemáticas do tipo: 
- `1 + (2 - 7);` (é necessário terminar com ";")

- `1 * 7;` (é necessário terminar com ";")

- ```
  1 + (2
  - 7);
  ```
  (é necessário terminar com ";")
