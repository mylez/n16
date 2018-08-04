%{
#include <iostream>
#include <string>
#include <vector>
#include "ast.h"

int yylex();
void yyerror(char *);
std::vector<ASTSignalIdentifier *> signalIdentifiersInExpr;

ASTRoot astRoot;

%}


%token IDENTIFIER LABEL_IDENTIFIER VALUE_IDENTIFIER NUMBER_HEX NUMBER_DEC

%union
{
    class ASTNode *node;
    class ASTStatement *statement;
    char *text;
    int intval;
}

%type <text>            IDENTIFIER LABEL_IDENTIFIER VALUE_IDENTIFIER NUMBER_HEX NUMBER_DEC signal_identifier
%type <node>            program signal_expr
%type <statement>       statement
%type <intval>          number



%%

program
    : statement
{
    std::cout << "first statement encountered\n";
    std::cout << "clearing sigId\n";
    signalIdentifiersInExpr.clear();
    astRoot.statements.push_back($1);
}
    | program statement
{
    signalIdentifiersInExpr.clear();
    astRoot.statements.push_back($2);
};

statement
    : LABEL_IDENTIFIER ':'
{
    std::cout << "label statement\n";
    $$ = new ASTLabelStatement($1);
}

    | VALUE_IDENTIFIER ':' signal_expr ';'
{
    std::cout << "value statement\n";
    $$ = new ASTValueStatement($1, signalIdentifiersInExpr);
}

    | signal_expr ';'
{
    std::cout << "anonymous statement\n";
    $$ = new ASTValueStatement("", signalIdentifiersInExpr);
}

    | '<' number '>'
{
    std::cout << "address literal: " << $2 << "\n";
};

signal_expr
    : signal_identifier
{
    signalIdentifiersInExpr.push_back(new ASTSignalIdentifier($1, ASTSignalIdentifierType::SINGLE_LINE));
}
    | signal_expr ',' signal_identifier
{
    signalIdentifiersInExpr.push_back(new ASTSignalIdentifier($3, ASTSignalIdentifierType::BUS));
};

signal_identifier
    : IDENTIFIER
{
    $$ = $1;
}
    | VALUE_IDENTIFIER
{
    $$ = $1;
};

number
    : NUMBER_DEC
{
    $$ = std::stoul($1, nullptr, 10);
}
    | NUMBER_HEX
{
    $$ = std::stoul($1, nullptr, 16);
};

%%

void yyerror(char *s)
{
    std::cout << "error: " << s << "\n";
}
