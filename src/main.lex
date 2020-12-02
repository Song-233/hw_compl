%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+
DOUBLE ([0-9]+)?(\.[0-9]+)([eE](\+|-)?[0-9]+)?

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
RESERVED "auto"|"enum"|"signed"|"sizeof"|"static"|"struct"|"tpoedef"|"union"|"unsigned"|"volatile"

%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */
{RESERVED} cerr << "{ line"" << lineno <<" } reserved token: " << yytext <<endl;

"skip" return K_SKIP;

"true" return TRUE;
"false" return FALSE;

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;

"for" return K_FOR;
"if" return K_IF;
"else" return K_ELSE;


"=" return LOP_ASSIGN;

";" return  SEMICOLON;

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%