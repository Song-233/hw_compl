%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token TRUE FLASE

%token T_CHAR T_INT T_STRING T_BOOL

%token K_SKIP K_FOR K_IF K_ELSE K_WHILE F_PRINT F_SCANF

%token LOP_ADD LOP_SUB LOP_MULT LOP_DEV LOP_AND LOP_OR LOP_NOT LOP_EQ LOP_L LOP_LEQ LOP_S LOP_SEQ

//%token LOP_ASSIGN 

%token SEMICOLON

%token LPAREN RPAREN LBRACE RBRACE

%token IDENTIFIER INTEGER CHAR BOOL STRING

%right COMMA
%right LOP_NOT
%left LOP_MUL LOP_DIV
%left LOP_ADD LOP_SUB
%left LOP_SEQ LOP_S LOP_LEQ LOP_L LOP_EQ LOP_NEQ
%left LOP_ASSIGN
%right LOP_ASSIGN
%right UMINUS UADD
%right K_ELSE

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| K_SKIP SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| if_else {$$ = $1;}
| while {$$ = $1;}
| assignment SEMICOLON {$$ = $1;}
| declaration SEMICOLON {$$ = $1;}
| printf SEMICOLON {$$ = $1;}
;

declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

expr
: IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
| expr LOP_ADD expr {
    TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype = OP_ADD;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_SUB expr{
    TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype = OP_SUB;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_MULT expr{
    TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype = OP_MULT;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_DEV expr{
    TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype = OP_DEV;
    node->addChild($1);
    node->addChild($3);
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}