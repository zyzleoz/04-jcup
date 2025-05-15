#!/bin/bash

java -cp jflex.jar:jcup.jar jflex.Main exemplo.flex

java -cp jcup.jar java_cup.Main -parser Parser -symbols sym exemplo.cup

javac -cp jcup.jar *.java

# rm -rf Parser.java sym.java *.java~ *.class

echo "Digite uma expressão (ex: 1 + 2 + 3):"
java -cp "jcup.jar:." Main
