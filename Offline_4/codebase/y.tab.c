/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "1705074.y"

#include<bits/stdc++.h>
using namespace std;

ofstream logFile;
ofstream errorFile;
ofstream asmFile;
ofstream optimizedAsmFile;

#include "1705074_Attribute.h"
#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"

#define YYSTYPE SymbolInfo*


int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error_count;

SymbolTable *symbolTable = new SymbolTable();
vector<SymbolInfo*> parametersInfo;
string declListType = "";
vector<SymbolInfo*> argumentsInfo;
string paramListErr;

int labelCount=0;
int tempCount=0;


void printError(string errMsg){
	error_count++;
	errorFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl;
	logFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl; 
}

void printLog(string logMsg, string symbolName, bool hasNewLine){
	logFile<<"At line no: "<< line_count <<" : "<<logMsg<<endl<<endl;
	logFile<<symbolName<<endl<<endl;
	if(hasNewLine){
		logFile<<endl;
	}		
}

void yyerror(char *s)
{
	cout<<"syntax error"<<endl;
	return;
}

void insertParameters(SymbolInfo* funcSymbol){

	for(int i = 0; i < parametersInfo.size(); i++){
		if(parametersInfo[i]->getName() == ""){
			printError(to_string(i+1)+"th parameter's name not given in function definition of "
					+ funcSymbol->getName());
		}
		symbolTable->Insert(parametersInfo[i]->getName(), parametersInfo[i]->getType(), 
								parametersInfo[i]->getDataType(), VARIABLE);
		
		SymbolInfo* paramSymbol = symbolTable->Lookup(parametersInfo[i]->getName());
		paramSymbol->setAsmSymbol("[bp+" + to_string((parametersInfo.size() - (1+i))*2 + 10) + "]");
													
	}
}

bool checkArgConsistency(SymbolInfo* funcSymbol, bool isDefinition){
	bool isConsistent = true;
	vector<SymbolInfo*> funcParameters = funcSymbol->getParameterList();
	int smallerVecSize = argumentsInfo.size();
	
	//cout<<line_count<<"	"<<argumentsInfo.size()<<" "<< funcSymbol->getNoOfParamters()<<endl;
	
	if(argumentsInfo.size() != funcSymbol->getNoOfParamters()){

		if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
			printError("Total number of arguments mismatch with declaration in function " + funcSymbol->getName());
		}	     
		else{
			printError("Total number of arguments mismatch in function " + funcSymbol->getName());
		}
		
		if(argumentsInfo.size() > funcSymbol->getNoOfParamters()){
			smallerVecSize = funcSymbol->getNoOfParamters();
		}
		isConsistent = false;		     
	}
	
	for(int i = 0; i < smallerVecSize; i++){
		if(argumentsInfo[i]->getAttribute() != funcParameters[i]->getAttribute()){
		
			if(argumentsInfo[i]->getAttribute() == ARRAY){
				printError("Type Mismatch, " + argumentsInfo[i]->getName()+ " is an array");
			}
			else if(funcParameters[i]->getAttribute() == ARRAY){
				printError("Type Mismatch, " + funcParameters[i]->getName()+ " is an array");
			}
			else {
				printError("Type Mismatch");
			}
			isConsistent = false;
			break;		
		}
		else if(argumentsInfo[i]->getDataType() != funcParameters[i]->getDataType()){
			if(isDefinition){
				printError(to_string(i+1) + "th argument mismatch in function " + funcSymbol->getName());
				isConsistent = false;
				break;
			}
		   	else if(funcParameters[i]->getDataType() != "float" && argumentsInfo[i]->getDataType() != "int"){
		   		
		   		printError(to_string(i+1) + "th argument mismatch in function " + funcSymbol->getName());
				isConsistent = false;
				break;
			}				
		}		
	}
	
	return isConsistent;
}


string newLabel()
{
	string label = "L" + to_string(labelCount);
	labelCount++;
	return label;
}

string newTemp()
{
	string tempVar = "t" + to_string(tempCount);
	tempCount++;
	return tempVar;
}

#include "1705074_Util.h"
#include "1705074_Assembly.h"


#line 214 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    FOR = 260,
    WHILE = 261,
    DO = 262,
    CHAR = 263,
    INT = 264,
    FLOAT = 265,
    VOID = 266,
    DOUBLE = 267,
    RETURN = 268,
    DEFAULT = 269,
    CONTINUE = 270,
    PRINTLN = 271,
    LTHIRD = 272,
    RTHIRD = 273,
    LCURL = 274,
    RCURL = 275,
    LPAREN = 276,
    RPAREN = 277,
    NOT = 278,
    COMMA = 279,
    SEMICOLON = 280,
    ADDOP = 281,
    MULOP = 282,
    INCOP = 283,
    DECOP = 284,
    RELOP = 285,
    ASSIGNOP = 286,
    LOGICOP = 287,
    ID = 288,
    CONST_INT = 289,
    CONST_FLOAT = 290,
    CONST_CHAR = 291,
    NUMBER_ERR = 292,
    LOWER_THAN_ELSE = 293
  };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define FOR 260
#define WHILE 261
#define DO 262
#define CHAR 263
#define INT 264
#define FLOAT 265
#define VOID 266
#define DOUBLE 267
#define RETURN 268
#define DEFAULT 269
#define CONTINUE 270
#define PRINTLN 271
#define LTHIRD 272
#define RTHIRD 273
#define LCURL 274
#define RCURL 275
#define LPAREN 276
#define RPAREN 277
#define NOT 278
#define COMMA 279
#define SEMICOLON 280
#define ADDOP 281
#define MULOP 282
#define INCOP 283
#define DECOP 284
#define RELOP 285
#define ASSIGNOP 286
#define LOGICOP 287
#define ID 288
#define CONST_INT 289
#define CONST_FLOAT 290
#define CONST_CHAR 291
#define NUMBER_ERR 292
#define LOWER_THAN_ELSE 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  11
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   203

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  39
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  27
/* YYNRULES -- Number of rules.  */
#define YYNRULES  83
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  148

#define YYUNDEFTOK  2
#define YYMAXUTOK   293


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   158,   158,   196,   206,   216,   223,   230,   239,   259,
     273,   280,   290,   289,   349,   348,   395,   414,   427,   442,
     456,   468,   476,   488,   496,   507,   519,   528,   537,   544,
     551,   561,   580,   600,   618,   642,   648,   654,   659,   666,
     678,   697,   703,   709,   709,   723,   743,   759,   779,   797,
     817,   826,   833,   842,   847,   856,   861,   869,   891,   923,
     932,   962,   971,  1014,  1023,  1071,  1081,  1112,  1122,  1183,
    1201,  1217,  1228,  1237,  1272,  1280,  1287,  1294,  1307,  1320,
    1326,  1333,  1339,  1352
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IF", "ELSE", "FOR", "WHILE", "DO",
  "CHAR", "INT", "FLOAT", "VOID", "DOUBLE", "RETURN", "DEFAULT",
  "CONTINUE", "PRINTLN", "LTHIRD", "RTHIRD", "LCURL", "RCURL", "LPAREN",
  "RPAREN", "NOT", "COMMA", "SEMICOLON", "ADDOP", "MULOP", "INCOP",
  "DECOP", "RELOP", "ASSIGNOP", "LOGICOP", "ID", "CONST_INT",
  "CONST_FLOAT", "CONST_CHAR", "NUMBER_ERR", "LOWER_THAN_ELSE", "$accept",
  "start", "program", "unit", "func_declaration", "func_definition", "$@1",
  "$@2", "parameter_list", "compound_statement", "var_declaration",
  "type_specifier", "declaration_list", "statements", "statement", "$@3",
  "expression_statement", "variable", "expression", "logic_expression",
  "rel_expression", "simple_expression", "term", "unary_expression",
  "factor", "argument_list", "arguments", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293
};
# endif

#define YYPACT_NINF (-94)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-44)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      20,   -94,   -94,   -94,    11,    20,   -94,   -94,   -94,   -94,
      14,   -94,   -94,   -11,    88,    12,   -94,     6,   134,   -15,
      47,   -94,    26,    74,   -94,    71,    -3,    31,   -94,    85,
      91,   -94,   -94,    70,   -94,   101,    81,    15,   -94,   -94,
     106,   108,   -94,    78,   -94,   127,   -94,   101,   -94,    38,
     107,   137,   135,   141,   145,   149,   142,   151,   -94,   142,
     142,   -94,   142,   100,   -94,   -94,   -94,   -94,    19,   113,
     -94,   101,   -94,    99,    16,   -94,   146,   111,   153,   -94,
     -94,   -94,   -94,   -94,   -94,   -94,   -94,   -94,   142,    33,
     142,    60,   154,   162,    45,   -94,   -94,   142,   142,   169,
     -94,   -94,   -94,   -94,   -94,   142,   163,   -94,   142,   142,
     142,   142,   167,    33,   168,   166,   -94,   170,   -94,   175,
     -94,   172,   171,   -94,   -94,   -94,   153,   173,   -94,   148,
     142,   148,   -94,    68,   -94,   -94,   142,   192,   176,   -94,
     177,   -94,   -94,   148,   148,   -94,   -94,   -94
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,    28,    29,    30,     0,     2,     4,     6,     7,     5,
       0,     1,     3,     0,    33,     0,    37,     0,     0,     0,
       0,    26,     0,     0,    23,     0,     0,     0,    27,    35,
      31,    38,    34,     0,     9,     0,     0,     0,    22,    18,
       0,     0,    11,     0,    15,     0,     8,     0,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    25,     0,
       0,    53,     0,    57,    75,    76,    79,    41,     0,     0,
      39,     0,    42,    72,     0,    59,    61,    63,    65,    67,
      71,    10,    13,    20,    16,    36,    32,    55,     0,     0,
       0,     0,     0,     0,    72,    70,    69,     0,    81,    33,
      24,    40,    44,    77,    78,     0,     0,    54,     0,     0,
       0,     0,     0,     0,     0,     0,    50,     0,    74,     0,
      83,     0,    80,    60,    56,    62,    66,    64,    68,     0,
       0,     0,    52,     0,    58,    73,     0,    46,     0,    48,
       0,    49,    82,     0,     0,    51,    47,    45
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -94,   -94,   -94,   195,   -94,   -94,   -94,   -94,   -94,    39,
      23,     9,   -94,   -94,   -66,   -94,    18,   -60,   -55,   -93,
      89,    93,    92,   -54,   -94,   -94,   -94
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     4,     5,     6,     7,     8,    47,    35,    26,    44,
      67,    68,    15,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,   121,   122
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      94,    91,    94,   101,    93,   120,    95,    22,    96,    10,
      28,    11,   123,    19,    10,    13,    48,   106,    29,    36,
      13,    37,    16,     9,     1,     2,     3,    27,     9,     1,
       2,     3,    38,   112,    52,   114,    20,    21,    94,    83,
      23,   107,   119,   142,    31,    94,    49,    14,    94,    94,
      94,    94,    99,   -19,    59,   -19,    60,   128,    61,    62,
     -17,   115,   -17,   137,    39,   139,    63,    64,    65,   140,
      66,    84,    33,   103,   104,   138,    94,   146,   147,    52,
      30,    53,    45,    54,    55,   116,    82,     1,     2,     3,
     -14,    56,    32,   141,    57,    42,    34,   -43,    58,    59,
     -12,    60,    40,    61,    62,    17,    46,   113,    41,    18,
     102,    63,    64,    65,    52,    66,    53,    97,    54,    55,
      43,    98,     1,     2,     3,    85,    56,   103,   104,    57,
     105,   130,   -43,   100,    59,    24,    60,   109,    61,    62,
      50,   110,    51,     1,     2,     3,    63,    64,    65,    52,
      66,    53,    81,    54,    55,    86,    25,     1,     2,     3,
      87,    56,    88,    59,    57,    60,    89,   -43,    62,    59,
      90,    60,    92,    61,    62,    63,    64,    65,   108,    66,
     111,    63,    64,    65,   118,    66,    17,   117,   124,   129,
     131,   132,   133,   134,   135,   136,   143,   125,   144,   109,
      12,   126,   145,   127
};

static const yytype_uint8 yycheck[] =
{
      60,    56,    62,    69,    59,    98,    60,     1,    62,     0,
      25,     0,   105,     1,     5,     1,     1,     1,    33,    22,
       1,    24,    33,     0,     9,    10,    11,    18,     5,     9,
      10,    11,     1,    88,     1,    90,    24,    25,    98,     1,
      34,    25,    97,   136,    18,   105,    37,    33,   108,   109,
     110,   111,    33,    22,    21,    24,    23,   111,    25,    26,
      22,     1,    24,   129,    33,   131,    33,    34,    35,     1,
      37,    33,     1,    28,    29,   130,   136,   143,   144,     1,
      33,     3,     1,     5,     6,    25,    47,     9,    10,    11,
      19,    13,    18,    25,    16,    25,    25,    19,    20,    21,
      19,    23,    17,    25,    26,    17,    25,    89,    17,    21,
      71,    33,    34,    35,     1,    37,     3,    17,     5,     6,
      19,    21,     9,    10,    11,    18,    13,    28,    29,    16,
      31,   113,    19,    20,    21,     1,    23,    26,    25,    26,
      34,    30,    34,     9,    10,    11,    33,    34,    35,     1,
      37,     3,    25,     5,     6,    18,    22,     9,    10,    11,
      25,    13,    21,    21,    16,    23,    21,    19,    26,    21,
      21,    23,    21,    25,    26,    33,    34,    35,    32,    37,
      27,    33,    34,    35,    22,    37,    17,    33,    25,    22,
      22,    25,    22,    18,    22,    24,     4,   108,    22,    26,
       5,   109,    25,   110
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     9,    10,    11,    40,    41,    42,    43,    44,    49,
      50,     0,    42,     1,    33,    51,    33,    17,    21,     1,
      24,    25,     1,    34,     1,    22,    47,    50,    25,    33,
      33,    18,    18,     1,    25,    46,    22,    24,     1,    33,
      17,    17,    25,    19,    48,     1,    25,    45,     1,    50,
      34,    34,     1,     3,     5,     6,    13,    16,    20,    21,
      23,    25,    26,    33,    34,    35,    37,    49,    50,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    25,    48,     1,    33,    18,    18,    25,    21,    21,
      21,    57,    21,    57,    56,    62,    62,    17,    21,    33,
      20,    53,    48,    28,    29,    31,     1,    25,    32,    26,
      30,    27,    57,    55,    57,     1,    25,    33,    22,    57,
      58,    64,    65,    58,    25,    59,    61,    60,    62,    22,
      55,    22,    25,    22,    18,    22,    24,    53,    57,    53,
       1,    25,    58,     4,    22,    25,    53,    53
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    39,    40,    41,    41,    42,    42,    42,    43,    43,
      43,    43,    45,    44,    46,    44,    47,    47,    47,    47,
      47,    47,    47,    47,    48,    48,    49,    49,    50,    50,
      50,    51,    51,    51,    51,    51,    51,    51,    51,    52,
      52,    53,    53,    54,    53,    53,    53,    53,    53,    53,
      53,    53,    53,    55,    55,    55,    55,    56,    56,    57,
      57,    58,    58,    59,    59,    60,    60,    61,    61,    62,
      62,    62,    63,    63,    63,    63,    63,    63,    63,    63,
      64,    64,    65,    65
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     6,     5,
       7,     6,     0,     7,     0,     6,     4,     3,     2,     1,
       4,     3,     2,     1,     3,     2,     3,     4,     1,     1,
       1,     3,     6,     1,     4,     3,     6,     2,     4,     1,
       2,     1,     1,     0,     2,     7,     5,     7,     5,     5,
       3,     6,     4,     1,     2,     2,     3,     1,     4,     1,
       3,     1,     3,     1,     3,     1,     3,     1,     3,     2,
       2,     1,     1,     4,     3,     1,     1,     2,     2,     1,
       1,     0,     3,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 159 "1705074.y"
        {
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"start : program"<<endl<<endl<<endl<<endl;
		
		logFile<<"Symbol Table :"<<endl<<endl;
		symbolTable->printAllScopeTable();

		logFile<<"Total Lines: "<<line_count<<endl<<endl;
		logFile << "Total errors: "<<error_count<<endl<<endl;
		errorFile << "Total errors: "<<error_count<<endl<<endl;
		
		if(error_count == 0){							
			string programCode = yyvsp[0]->getCode();
			string stackDataSegCode = appendStackDataSegment();
			asmFile << stackDataSegCode;
			optimizedAsmFile << stackDataSegCode;

			asmFile << ".CODE\n\n";
			optimizedAsmFile << ".CODE\n\n";

			if(programCode.find("println") != std::string::npos){
				string printlnAsmCode = getAsmOfPrintln();
				asmFile << printlnAsmCode;
				optimizedAsmFile << printlnAsmCode;
			}

			asmFile << programCode;
			optimizedAsmFile << generateOptimizedAsmCode(programCode);

			asmFile << "\nEND MAIN\n";
			optimizedAsmFile << "\nEND MAIN\n";		
		}
				
		delete yyvsp[0];		
	}
#line 1660 "y.tab.c"
    break;

  case 3:
#line 197 "1705074.y"
        {
		string newName = yyvsp[-1]->getName() + "\n" + yyvsp[0]->getName();
		string code = yyvsp[-1]->getCode() + yyvsp[0]->getCode();
		yyval = new SymbolInfo(newName, "program", "undefined", UNDEFINED, "", code);
					
		logFile<<endl;
		printLog("program : program unit", yyval->getName(), true);
		delete yyvsp[-1]; delete yyvsp[0];
	}
#line 1674 "y.tab.c"
    break;

  case 4:
#line 207 "1705074.y"
        {
		yyval = new SymbolInfo(yyvsp[0]->getName(), "program", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
 		
		logFile<<endl;
		printLog("program : unit", yyval->getName(), true);
		delete yyvsp[0];	
	}
#line 1686 "y.tab.c"
    break;

  case 5:
#line 217 "1705074.y"
         {
 		yyval = new SymbolInfo(yyvsp[0]->getName(), "unit", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
 		logFile<<endl;
 		printLog("unit : var_declaration", yyval->getName(), false);
 		delete yyvsp[0];				 	
	 }
#line 1697 "y.tab.c"
    break;

  case 6:
#line 224 "1705074.y"
     {
     	yyval = new SymbolInfo(yyvsp[0]->getName(), "unit", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
 		logFile<<endl;
 		printLog("unit : func_declaration", yyval->getName(), false);
 		delete yyvsp[0];    	
     }
#line 1708 "y.tab.c"
    break;

  case 7:
#line 231 "1705074.y"
     {
     	yyval = new SymbolInfo(yyvsp[0]->getName(), "unit", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
 		logFile<<endl;
 		printLog("unit : func_definition", yyval->getName(), false); 
 		delete yyvsp[0];    
     }
#line 1719 "y.tab.c"
    break;

  case 8:
#line 240 "1705074.y"
                {
			bool isInserted = symbolTable->Insert(yyvsp[-4]->getName(), "ID", yyvsp[-5]->getDataType(), FUNCTION_PROTOTYPE);
			
			if(!isInserted){
				printError("Multiple Declaration of " + yyvsp[-4]->getName());		  		
	  		}
	  		else{
		  		SymbolInfo* funcProtoSymbol = symbolTable->Lookup(yyvsp[-4]->getName());
		  		funcProtoSymbol->setParameterList(parametersInfo);	  		
	  		}
			
			string newName = yyvsp[-5]->getName() + " " + yyvsp[-4]->getName() + "(" + yyvsp[-2]->getName() + ")" + ";";
			yyval = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");
			
			printLog("func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON", yyval->getName(), 
				false);
				
			delete yyvsp[-5]; delete yyvsp[-4]; delete yyvsp[-2];							
		}
#line 1743 "y.tab.c"
    break;

  case 9:
#line 260 "1705074.y"
                {
			bool isInserted = symbolTable->Insert(yyvsp[-3]->getName(), "ID", yyvsp[-4]->getDataType(), FUNCTION_PROTOTYPE);
			
	  		if(!isInserted){
				printError("Multiple Declaration of " + yyvsp[-3]->getName());			  		
	  		}			
		
			string newName = yyvsp[-4]->getName() + " " + yyvsp[-3]->getName() + "(" + ")" + ";";
			yyval = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");
			
			printLog("func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON", yyval->getName(), false);
			delete yyvsp[-4]; delete yyvsp[-3];
		}
#line 1761 "y.tab.c"
    break;

  case 10:
#line 274 "1705074.y"
                {	  				
			string newName = yyvsp[-6]->getName() + " " + yyvsp[-5]->getName() + "(" + yyvsp[-3]->getName() + ")";
			yyval = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");		
			printError("syntax error");
			delete yyvsp[-6]; delete yyvsp[-5]; delete yyvsp[-3];
		}
#line 1772 "y.tab.c"
    break;

  case 11:
#line 281 "1705074.y"
                {		
			string newName = yyvsp[-5]->getName() + " " + yyvsp[-4]->getName() + "(" + ")";
			yyval = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");		
			printError("syntax error");
			delete yyvsp[-5]; delete yyvsp[-4];
		}
#line 1783 "y.tab.c"
    break;

  case 12:
#line 290 "1705074.y"
                                  {
			  		bool isConsistent = true;
			  		bool isRedeclared = false;
			  		
			  		SymbolInfo* funcSymbol = symbolTable->Lookup(yyvsp[-3]->getName());
			  		if(funcSymbol != NULL){
			  		
			  			if(funcSymbol->getAttribute() == FUNCTION){
			  				printError("Multiple Definition of function : "+yyvsp[-3]->getName());
			  				isRedeclared = true;						  
			  			}
			  			else if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
				  			isConsistent = checkArgConsistency(funcSymbol, true);
				  			argumentsInfo.clear();
				  			
				  			if(yyvsp[-4]->getDataType() != funcSymbol->getDataType()){
				  				isConsistent = false;
				  				printError("Return type mismatch with function declaration in function "
				  							+ yyvsp[-3]->getName());
				  			}
			  			}
			  			else{
			  				printError("Multiple declaration of " + yyvsp[-3]->getName());
			  			}
			  		}
			  		if(isConsistent && !isRedeclared){
			  			symbolTable->Remove(yyvsp[-3]->getName());
			  			symbolTable->Insert(yyvsp[-3]->getName(), "ID", yyvsp[-4]->getDataType(), FUNCTION);
			  		}
			  		else{
			  			//printError("Function definition is not consistent with declaration");				  	
			  		}
			  		
			  		symbolTable->enterScope(30, yyvsp[-3]->getName());
			  		if(isConsistent){
				  		SymbolInfo* funcSymbol = symbolTable->Lookup(yyvsp[-3]->getName());
				  		
						string tempVar1 = yyvsp[-3]->getName() + "_ra";
						funcSymbol->setFuncReturnAsmSymbol(tempVar1);

				  		if(!isRedeclared){
				  			funcSymbol->setParameterList(parametersInfo);
				  		}		  			
				  		insertParameters(funcSymbol);
			  		}
				  			 	
				  }
#line 1835 "y.tab.c"
    break;

  case 13:
#line 338 "1705074.y"
                {	
			string newName = yyvsp[-6]->getName() + " " + yyvsp[-5]->getName() + "(" + yyvsp[-3]->getName() + ")" + yyvsp[0]->getName();
			string code = getAsmOfParameterizedFunction(yyvsp[-5], yyvsp[0]);

			yyval = new SymbolInfo(newName, "func_definition", "undefined", UNDEFINED, "", code);
			printLog("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement", 
				yyval->getName(), false);	
				
			delete yyvsp[-6]; delete yyvsp[-5]; delete yyvsp[-3]; delete yyvsp[0];		
		}
#line 1850 "y.tab.c"
    break;

  case 14:
#line 349 "1705074.y"
                  {
		  		bool isConsistent = true;
		  		bool isRedeclared = false;
		  		argumentsInfo.clear();
		  		
		  		SymbolInfo* funcSymbol = symbolTable->Lookup(yyvsp[-2]->getName());
		  		if(funcSymbol != NULL){
		  		
		  			if(funcSymbol->getAttribute() == FUNCTION){
						printError("Multiple Definition of function : " + yyvsp[-2]->getName());
						isRedeclared = true;					  
		  			}		  		
		  			else if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
			  			isConsistent = checkArgConsistency(funcSymbol, true);
			  			argumentsInfo.clear();
		  			}
		  		}
		  		if(isConsistent && !isRedeclared){
		  			symbolTable->Remove(yyvsp[-2]->getName());
		  			symbolTable->Insert(yyvsp[-2]->getName(), "ID", yyvsp[-3]->getDataType(), FUNCTION);
		  		}
		  		else{
					//printError("Function definition is not consistent with declaration");				  	
		  		}
		  		
		  		symbolTable->enterScope(30, yyvsp[-2]->getName());
		  		
		  		if(yyvsp[-2]->getName() != "main"){
					SymbolInfo* currentFuncSymbol = symbolTable->Lookup(yyvsp[-2]->getName());
					string tempVar1 = yyvsp[-2]->getName() + "_ra";
					currentFuncSymbol->setFuncReturnAsmSymbol(tempVar1);
				}		  			 	
		  }
#line 1888 "y.tab.c"
    break;

  case 15:
#line 383 "1705074.y"
                {
			string newName = yyvsp[-5]->getName() + " " + yyvsp[-4]->getName() + "()" + yyvsp[0]->getName();
			string code = getAsmOfNonParamFunction(yyvsp[-4], yyvsp[0]);
			
			yyval = new SymbolInfo(newName, "func_definition", "undefined", UNDEFINED, "", code);
			printLog("func_definition : type_specifier ID LPAREN RPAREN compound_statement", yyval->getName(), 				false);
			
			delete yyvsp[-5]; delete yyvsp[-4]; delete yyvsp[0];					
		}
#line 1902 "y.tab.c"
    break;

  case 16:
#line 396 "1705074.y"
                {
			SymbolInfo* paramSymbol = new SymbolInfo(yyvsp[0]->getName(), "ID", yyvsp[-1]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			argumentsInfo.push_back(paramSymbol);
			
			for(int i = 0; i < parametersInfo.size()-1; i++){
				if(parametersInfo[parametersInfo.size()-1]->getName() == parametersInfo[i]->getName()){
					printError("Multiple declaration of " + parametersInfo[i]->getName() + " in parameter");
					break;
				}
			}
		
			string newName = yyvsp[-3]->getName() + "," + yyvsp[-1]->getName() + " " + yyvsp[0]->getName();
			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : parameter_list COMMA type_specifier ID", yyval->getName(), false);
			delete yyvsp[-3]; delete yyvsp[-1]; delete yyvsp[0];		
		}
#line 1925 "y.tab.c"
    break;

  case 17:
#line 415 "1705074.y"
                {
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", yyvsp[0]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
			argumentsInfo.push_back(paramSymbol);		
		
			string newName = yyvsp[-2]->getName() + "," + yyvsp[0]->getName();
			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : parameter_list COMMA type_specifier", yyval->getName(), false);
			delete yyvsp[-2]; delete yyvsp[0];
		}
#line 1942 "y.tab.c"
    break;

  case 18:
#line 428 "1705074.y"
                {
 			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo(yyvsp[0]->getName(), "ID", yyvsp[-1]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);			
 		
 			string newName = yyvsp[-1]->getName() + " " + yyvsp[0]->getName();
 			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
 			
 			printLog("parameter_list : type_specifier ID", yyval->getName(), false);
 			delete yyvsp[-1]; delete yyvsp[0];
 		}
#line 1961 "y.tab.c"
    break;

  case 19:
#line 443 "1705074.y"
                {
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", yyvsp[0]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);					
		
			yyval = new SymbolInfo(yyvsp[0]->getName(), "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : type_specifier", yyval->getName(), false);
			delete yyvsp[0];
		}
#line 1979 "y.tab.c"
    break;

  case 20:
#line 457 "1705074.y"
                {
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", yyvsp[-1]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
					
			string newName = yyvsp[-3]->getName() + "," + yyvsp[-1]->getName();
			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = newName;		
			printError("syntax error");
			
			delete yyvsp[-3]; delete yyvsp[-1];
		}
#line 1995 "y.tab.c"
    break;

  case 21:
#line 469 "1705074.y"
                {
			string newName = yyvsp[-2]->getName() + ",";
			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = newName;		
			printError("syntax error");
			delete yyvsp[-2];
		}
#line 2007 "y.tab.c"
    break;

  case 22:
#line 477 "1705074.y"
                {
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", yyvsp[-1]->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
					
			yyval = new SymbolInfo(yyvsp[-1]->getName(), "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = yyvsp[-1]->getName();
			printError("syntax error");
			
			delete yyvsp[-1];
		}
#line 2023 "y.tab.c"
    break;

  case 23:
#line 489 "1705074.y"
                {
			string newName = paramListErr;
			yyval = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			//printError("syntax error p.4");	
		}
#line 2033 "y.tab.c"
    break;

  case 24:
#line 497 "1705074.y"
                        {			
				string newName = "{\n" + yyvsp[-1]->getName() + "\n}";
				yyval = new SymbolInfo(newName, "compound_statement", "undefined", UNDEFINED, "", yyvsp[-1]->getCode());
				printLog("compound_statement : LCURL statements RCURL", yyval->getName(), false);
				delete yyvsp[-1];
				
				freeTempVarOfCurrScope();					
				symbolTable->printAllScopeTable();
				symbolTable->exitScope();									
			}
#line 2048 "y.tab.c"
    break;

  case 25:
#line 508 "1705074.y"
                    {	
				string newName = "{\n}";
				yyval = new SymbolInfo(newName, "compound_statement", "undefined", UNDEFINED, "", "");
				printLog("compound_statement : LCURL RCURL", yyval->getName(), false);
				
				freeTempVarOfCurrScope();
				symbolTable->printAllScopeTable();
				symbolTable->exitScope();					 		    
 		    }
#line 2062 "y.tab.c"
    break;

  case 26:
#line 519 "1705074.y"
                                                            {
			
			string newName = yyvsp[-2]->getName() + " " + yyvsp[-1]->getName() + ";";
			yyval = new SymbolInfo(newName, "var_declaration", "undefined", UNDEFINED, "", "");
			
			declListType = "";
			printLog("var_declaration : type_specifier declaration_list SEMICOLON", yyval->getName(), false);
			delete yyvsp[-2]; delete yyvsp[-1];
		 }
#line 2076 "y.tab.c"
    break;

  case 27:
#line 529 "1705074.y"
                 {
			string newName = yyvsp[-3]->getName() + " " + yyvsp[-2]->getName();
			yyval = new SymbolInfo(newName, "var_declaration", "undefined", UNDEFINED, "", "");
			printError("syntax error");
			delete yyvsp[-3]; delete yyvsp[-2];		 	
		 }
#line 2087 "y.tab.c"
    break;

  case 28:
#line 538 "1705074.y"
                {
			declListType = "int";
			
			yyval = new SymbolInfo("int", "type_specifier", "int", UNDEFINED, "", "");
			printLog("type_specifier : INT", yyval->getName(), false);
		}
#line 2098 "y.tab.c"
    break;

  case 29:
#line 545 "1705074.y"
                {
 			declListType = "float";
 		
			yyval = new SymbolInfo("float", "type_specifier", "float", UNDEFINED, "", "");
			printLog("type_specifier : FLOAT", yyval->getName(), false);		
 		}
#line 2109 "y.tab.c"
    break;

  case 30:
#line 552 "1705074.y"
                {
 			declListType = "void";
 		
			yyval = new SymbolInfo("void", "type_specifier", "void", UNDEFINED, "", "");
			printLog("type_specifier : VOID", yyval->getName(), false);	
 		}
#line 2120 "y.tab.c"
    break;

  case 31:
#line 562 "1705074.y"
                  {	
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{		  	
			  		bool isInserted = symbolTable->Insert(yyvsp[0]->getName(), "ID", declListType, VARIABLE, "0");
			  		
			  		if(!isInserted){
			  			printError("Multiple Declaration of " + yyvsp[0]->getName());		  		
			  		}
		  		//}
		  
				string newName = yyvsp[-2]->getName() + "," + yyvsp[0]->getName();
				yyval = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
				
				printLog("declaration_list : declaration_list COMMA ID", yyval->getName(), false);
				delete yyvsp[-2]; delete yyvsp[0];
		  }
#line 2143 "y.tab.c"
    break;

  case 32:
#line 581 "1705074.y"
                  {
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{ 		  
	 		  		bool isInserted = symbolTable->Insert(yyvsp[-3]->getName(), "ID", declListType, ARRAY, yyvsp[-1]->getName());
	 		  		
			  		if(!isInserted){
						printError("Multiple Declaration of " + yyvsp[-3]->getName());		  		
			  		}
		  		//} 		  		
 		  
				string newName = yyvsp[-5]->getName() + "," + yyvsp[-3]->getName() + "[" + yyvsp[-1]->getName() + "]";
				yyval = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
				
				printLog("declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD", yyval->getName(), 					false);
				
				delete yyvsp[-5]; delete yyvsp[-3]; delete yyvsp[-1];			 	  
 		  }
#line 2167 "y.tab.c"
    break;

  case 33:
#line 601 "1705074.y"
                  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert(yyvsp[0]->getName(), "ID", declListType, VARIABLE, "0");
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + yyvsp[0]->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  	yyval = new SymbolInfo(yyvsp[0]->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	
 		  	printLog("declaration_list : ID", yyval->getName(), false);
 		  	delete yyvsp[0];
 		  }
#line 2189 "y.tab.c"
    break;

  case 34:
#line 619 "1705074.y"
                  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert(yyvsp[-3]->getName(), "ID", declListType, ARRAY, yyvsp[-1]->getName());
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + yyvsp[-3]->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  
 		  	string newName = yyvsp[-3]->getName() + "[" + yyvsp[-1]->getName() + "]";
			yyval = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
			 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "
 		  		   <<"declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
 		  	logFile<<yyvsp[-1]->getName()<<endl<<endl;
 		  	logFile<<yyval->getName()<<endl<<endl;
 		  	
 		  	delete yyvsp[-3]; delete yyvsp[-1];   		  	
 		  }
#line 2217 "y.tab.c"
    break;

  case 35:
#line 643 "1705074.y"
                  {
 		  	printError("syntax error");
 		  	yyval = new SymbolInfo(yyvsp[-2]->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	delete yyvsp[-2];
 		  }
#line 2227 "y.tab.c"
    break;

  case 36:
#line 649 "1705074.y"
                  {
 		  	printError("syntax error");
 		  	yyval = new SymbolInfo(yyvsp[-5]->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	delete yyvsp[-5];
 		  }
#line 2237 "y.tab.c"
    break;

  case 37:
#line 655 "1705074.y"
                  {
 		  	printError("syntax error");
 		  	yyval = new SymbolInfo("", "declaration_list", "undefined", UNDEFINED, "", "");
 		  }
#line 2246 "y.tab.c"
    break;

  case 38:
#line 660 "1705074.y"
                  {
 		  	printError("syntax error");
 		  	yyval = new SymbolInfo("", "declaration_list", "undefined", UNDEFINED, "", "");
 		  }
#line 2255 "y.tab.c"
    break;

  case 39:
#line 667 "1705074.y"
           {
	   	   	string documentation = yyvsp[0]->getName();
	   		if(yyvsp[0]->getAsmSymbol() == "if" || yyvsp[0]->getAsmSymbol() == "for" || yyvsp[0]->getAsmSymbol() == "while"){
	   			documentation = yyvsp[0]->getAsmSymbol();
	   		}
	   		
	   		string code = "\n;" + documentation + "\n" + yyvsp[0]->getCode();
			yyval = new SymbolInfo(yyvsp[0]->getName(), "statements", "undefined", UNDEFINED, "", code);
			printLog("statements : statement", yyval->getName(), true);
			delete yyvsp[0];		   
	   }
#line 2271 "y.tab.c"
    break;

  case 40:
#line 679 "1705074.y"
           {
	   		string newName = yyvsp[-1]->getName();
	   		if(yyvsp[0]->getName() != ""){
	   			newName = yyvsp[-1]->getName() + "\n" + yyvsp[0]->getName();
	   		}
	   		
	   		string documentation = yyvsp[0]->getName();
	   		if(yyvsp[0]->getAsmSymbol() == "if" || yyvsp[0]->getAsmSymbol() == "for" || yyvsp[0]->getAsmSymbol() == "while"){
	   			documentation = yyvsp[0]->getAsmSymbol();
	   		}
	   		string code = yyvsp[-1]->getCode() + "\n;" + documentation + "\n" + yyvsp[0]->getCode();
			yyval = new SymbolInfo(newName, "statements", "undefined", UNDEFINED, "", code);
			
			printLog("statements : statements statement", yyval->getName(), true);
			delete yyvsp[-1]; delete yyvsp[0];	   
	   }
#line 2292 "y.tab.c"
    break;

  case 41:
#line 698 "1705074.y"
          {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "statement", "undefined", UNDEFINED, "", "");
			printLog("statement : var_declaration", yyval->getName(), true);
			delete yyvsp[0];		  
	  }
#line 2302 "y.tab.c"
    break;

  case 42:
#line 704 "1705074.y"
          {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "statement", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
			printLog("statement : expression_statement", yyval->getName(), true);
			delete yyvsp[0]; 	  
	  }
#line 2312 "y.tab.c"
    break;

  case 43:
#line 709 "1705074.y"
            {
	  		string scopeName = symbolTable->getCurrentScopeTable()->getName();
	  		string newScopeName = "undefined";
	  		if(scopeName != "undefined" && scopeName != "global"){
	  			newScopeName = scopeName;
	  		}
	  		symbolTable->enterScope(30, newScopeName);
	  }
#line 2325 "y.tab.c"
    break;

  case 44:
#line 718 "1705074.y"
          {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "statement", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
			printLog("statement : compound_statement", yyval->getName(), true);
			delete yyvsp[0];  
	  }
#line 2335 "y.tab.c"
    break;

  case 45:
#line 724 "1705074.y"
          {
		 	string newName = "for(" + yyvsp[-4]->getName() + yyvsp[-3]->getName() + yyvsp[-2]->getName() + ")" + yyvsp[0]->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = yyvsp[-4]->getCode();
		 	code += label1 + ":\n";
		 	code += yyvsp[-3]->getCode();
		 	code += "cmp " + yyvsp[-3]->getAsmSymbol() + ", 0\n";
		 	code += "je " + label2 + "\n";
		 	code += yyvsp[0]->getCode();
		 	code += yyvsp[-2]->getCode();
		 	code += "jmp " + label1 + "\n";
		 	code += label2 + ":\n";
		 	
			yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "for", code);
			printLog("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement", 					yyval->getName(), true);
			delete yyvsp[-4]; delete yyvsp[-3]; delete yyvsp[-2]; delete yyvsp[0];		  
	  }
#line 2359 "y.tab.c"
    break;

  case 46:
#line 744 "1705074.y"
          {
		 	string newName = "if(" + yyvsp[-2]->getName() + ")" + yyvsp[0]->getName();
		 	string label1 = newLabel();
		 	
		 	string code = yyvsp[-2]->getCode();
		 	code += "mov ax, " + yyvsp[-2]->getAsmSymbol() + "\n";
		 	code += "cmp ax, 0\n";
		 	code += "je " + label1 + "\n";
		 	code += yyvsp[0]->getCode();  	//if
		 	code += label1 + ":\n\n";
		 	
			yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "if", code);
			printLog("statement : IF LPAREN expression RPAREN statement", yyval->getName(), true);
			delete yyvsp[-2]; delete yyvsp[0];	  
	  }
#line 2379 "y.tab.c"
    break;

  case 47:
#line 760 "1705074.y"
          {
		 	string newName = "if(" + yyvsp[-4]->getName() + ")" + yyvsp[-2]->getName() + "else" + yyvsp[0]->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = yyvsp[-4]->getCode();
		 	code += "mov ax, " + yyvsp[-4]->getAsmSymbol() + "\n";
		 	code += "cmp ax, 1\n";
		 	code += "jne " + label1 + "\n";
		 	code += yyvsp[-2]->getCode();  	//if
		 	code += "jmp " + label2 + "\n";
		 	code += label1 + ":\n";		//else
		 	code += yyvsp[0]->getCode();
		 	code += label2 + ":\n\n";  
		 	
			yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "if", code);
			printLog("statement : IF LPAREN expression RPAREN statement ELSE statement", yyval->getName(), true);
			delete yyvsp[-4]; delete yyvsp[-2]; delete yyvsp[0];	  
	  }
#line 2403 "y.tab.c"
    break;

  case 48:
#line 780 "1705074.y"
          {
		 	string newName = "while(" + yyvsp[-2]->getName() + ")" + yyvsp[0]->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = label1 + ":\n";
		 	code += yyvsp[-2]->getCode();
		 	code += "cmp " + yyvsp[-2]->getAsmSymbol() + ", 0\n";
		 	code += "je " + label2 + "\n";
		 	code += yyvsp[0]->getCode();
		 	code += "jmp " + label1 + "\n";
		 	code += label2 + ":\n";
		 	
			yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "while", code);
			printLog("statement : WHILE LPAREN expression RPAREN statement", yyval->getName(), true);
			delete yyvsp[-2]; delete yyvsp[0];  
	  }
#line 2425 "y.tab.c"
    break;

  case 49:
#line 798 "1705074.y"
          {
	  		SymbolInfo* idSymbol = symbolTable->Lookup(yyvsp[-2]->getName());
	  		string code = "";
	  		
	  		if(idSymbol == NULL){
	  			printError("Undeclared Variable : " + yyvsp[-2]->getName());
	  		}
			else{
			 	code += "push " + idSymbol->getAsmSymbol() + "\n";
			 	code += "mov dx, 0\n";
			 	code += "mov cx, 0\n";
			 	code += "call println\n";
		 	}
		 	
		 	string newName = "println(" + yyvsp[-2]->getName() + ");";
			yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "", code);
			printLog("statement : PRINTLN LPAREN ID RPAREN SEMICOLON", yyval->getName(), true);
			delete yyvsp[-2];  
	  }
#line 2449 "y.tab.c"
    break;

  case 50:
#line 818 "1705074.y"
          {
	  	string newName = "return " + yyvsp[-1]->getName() + ";";
	  	string code = getAsmOfReturn(yyvsp[-1]);
	  	
		yyval = new SymbolInfo(newName, "statement", "statement", UNDEFINED, "", code);
		printLog("statement : RETURN expression SEMICOLON", yyval->getName(), true);
		delete yyvsp[-1];		  
	  }
#line 2462 "y.tab.c"
    break;

  case 51:
#line 827 "1705074.y"
          {
	 	string newName = "println(" + yyvsp[-3]->getName() + ")";
		yyval = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "", "");
		printError("syntax error");
		delete yyvsp[-3];	  
	  }
#line 2473 "y.tab.c"
    break;

  case 52:
#line 834 "1705074.y"
          {
	  	string newName = "return " + yyvsp[-2]->getName();
		yyval = new SymbolInfo("", "statement", "undefined", UNDEFINED, "", "");	  	
	  	printError("syntax error");
	  	delete yyvsp[-2];
	  }
#line 2484 "y.tab.c"
    break;

  case 53:
#line 843 "1705074.y"
                        {
				yyval = new SymbolInfo(";", "expression_statement", "undefined", UNDEFINED, "", "");
				printLog("expression_statement : SEMICOLON", yyval->getName(), false);				
			}
#line 2493 "y.tab.c"
    break;

  case 54:
#line 848 "1705074.y"
                        {
			 	string newName = yyvsp[-1]->getName() + ";";
				yyval = new SymbolInfo(newName, "expression_statement", "undefined", UNDEFINED,
						yyvsp[-1]->getAsmSymbol() , yyvsp[-1]->getCode());
							
				printLog("expression_statement : expression SEMICOLON", yyval->getName(), false);
				delete yyvsp[-1];		
			}
#line 2506 "y.tab.c"
    break;

  case 55:
#line 857 "1705074.y"
                        {
				yyval = new SymbolInfo("", "expression_statement", "undefined", UNDEFINED, "", ""); 
				printError("syntax error"); 
			}
#line 2515 "y.tab.c"
    break;

  case 56:
#line 862 "1705074.y"
                        {
				yyval = new SymbolInfo("", "expression_statement", "undefined", UNDEFINED, "", "");
				printError("syntax error");
				delete yyvsp[-2];
			}
#line 2525 "y.tab.c"
    break;

  case 57:
#line 870 "1705074.y"
         {
	 	SymbolInfo* idSymbol = symbolTable->Lookup(yyvsp[0]->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	string asmSymbol = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 	}
	 	else{
	 		printError("Undeclared Variable : " + yyvsp[0]->getName());
	 	}	 	
	 	
		yyval = new SymbolInfo(yyvsp[0]->getName(), "variable", dataType, attribute, asmSymbol, "");
		yyval->baseProperty = VARIABLE;
		
		printLog("variable : ID", yyval->getName(), false);		
		delete yyvsp[0];
	 }
#line 2551 "y.tab.c"
    break;

  case 58:
#line 892 "1705074.y"
         {
	 	SymbolInfo* idSymbol = symbolTable->Lookup(yyvsp[-3]->getName());
	 	string dataType = "undefined";
	 	string asmSymbol = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 		
	 		if(idSymbol->getAttribute() != ARRAY){
	 			printError(yyvsp[-3]->getName() + " not an array. Index must be used with array");
	 		}
		 	if(yyvsp[-1]->getDataType() == "float"){
		 		printError("Expression inside third brackets not an integer");
		 	}	 			
	 	}
	 	else{
	 		printError("Undeclared Variable : " + yyvsp[-3]->getName());
	 	}
	 	 		 
	 	string newName = yyvsp[-3]->getName() + "[" + yyvsp[-1]->getName() + "]";
	 	string code = yyvsp[-1]->getCode() + "mov bx, " + yyvsp[-1]->getAsmSymbol() +"\nadd bx, bx\n";
	 	
		yyval = new SymbolInfo(newName, "variable", dataType, VARIABLE, asmSymbol, code);
		yyval->baseProperty = ARRAY;
		
		printLog("variable : ID LTHIRD expression RTHIRD", yyval->getName(), false);
		delete yyvsp[-3]; delete yyvsp[-1];		 	
	 }
#line 2585 "y.tab.c"
    break;

  case 59:
#line 924 "1705074.y"
           {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "expression", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
					yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());

			freeTempVarAfterExpression(yyvsp[0]->getAsmSymbol());	
			printLog("expression : logic_expression", yyval->getName(), false);
			delete yyvsp[0];	   
 	   }
#line 2598 "y.tab.c"
    break;

  case 60:
#line 933 "1705074.y"
           {
	   		if(yyvsp[0]->getDataType() == "void" && yyvsp[0]->getAttribute() == FUNCTION){
	   			printError("Void function used in expression");
	   		}
	   		else if((yyvsp[-2]->getAttribute() == ARRAY || yyvsp[0]->getAttribute() == ARRAY) 
				&& yyvsp[-2]->getAttribute() != yyvsp[0]->getAttribute()) {
				
					if(yyvsp[-2]->getAttribute() == ARRAY){ printError("Type Mismatch, "+yyvsp[-2]->getName()+" is an array"); } 	
					if(yyvsp[0]->getAttribute() == ARRAY){ printError("Type Mismatch, "+yyvsp[0]->getName()+" is an array"); } 
			}
			else if(yyvsp[-2]->getDataType() != yyvsp[0]->getDataType()){
				if(yyvsp[-2]->getDataType() == "void" || yyvsp[0]->getDataType() == "void"){
					printError("Type Mismatch");
				}
				else if((yyvsp[-2]->getDataType() != "undefined" && yyvsp[0]->getDataType() != "undefined") &&
				(yyvsp[-2]->getDataType() != "float" && yyvsp[0]->getDataType() != "int")){
					printError("Type Mismatch");
				}
			}
	   		
			string newName = yyvsp[-2]->getName() + "=" + yyvsp[0]->getName();
			string code = getAsmOfAssignment(yyvsp[-2], yyvsp[0]);
			
			yyval = new SymbolInfo(newName, "expression", "undefined", UNDEFINED, yyvsp[-2]->getAsmSymbol(), code);
			printLog("expression : variable ASSIGNOP logic_expression", yyval->getName(), false);
			delete yyvsp[-2]; delete yyvsp[0];	   	
	   }
#line 2630 "y.tab.c"
    break;

  case 61:
#line 963 "1705074.y"
                 {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "logic_expression", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
					yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
			yyval->isNumber = yyvsp[0]->isNumber;
			yyval->baseProperty = yyvsp[0]->baseProperty;
			printLog("logic_expression : rel_expression", yyval->getName(), false);
			delete yyvsp[0];	 
		 }
#line 2643 "y.tab.c"
    break;

  case 62:
#line 972 "1705074.y"
                 {
		 	if(yyvsp[-2]->getDataType() == "void"){
		 		printError("1st operand of LOGICOP operation is void");
		 	}
		 	if(yyvsp[0]->getDataType() == "void"){
		 		printError("2nd operand of LOGICOP operation is void");
		 	}
		 	
		 	string tempVar = getDstAddress(yyvsp[-2], yyvsp[0]);
		 	string label1 = newLabel();
			string label2 = newLabel();
			
			string code = getAsmOfALU(yyvsp[-2], yyvsp[0]);
		 	code += "cmp ax, 0\n";
		 			 	
		 	if(yyvsp[-1]->getName() == "&&"){
		 		code += "je " + label1 + "\n";
			 	code += "cmp bx, 0\n";
			 	code += "je " + label1 + "\n";
				code += "mov " + tempVar + ", 1\n";
				code += "jmp " + label2 + "\n";
			 	code += label1 + ":\n" + "mov "+ tempVar + ", 0\n";
		 	}
		 	else if(yyvsp[-1]->getName() == "||"){
		 		code += "jne " + label1 + "\n";
			 	code += "cmp bx, 0\n";
			 	code += "jne " + label1 + "\n";
				code += "mov " + tempVar + ", 0\n";
				code += "jmp " + label2 + "\n";
			 	code += label1 + ":\n" + "mov "+ tempVar + ", 1\n";
		 	}		 	
		 	code += label2 + ":\n\n";
		 
			string newName = yyvsp[-2]->getName() + yyvsp[-1]->getName() + yyvsp[0]->getName();
			yyval = new SymbolInfo(newName, "logic_expression", "int", VARIABLE, tempVar, code);
			yyval->baseProperty = ALU;
			
			printLog("logic_expression : rel_expression LOGICOP rel_expression", yyval->getName(), false);
			delete yyvsp[-2]; delete yyvsp[-1]; delete yyvsp[0];		 
		 }
#line 2688 "y.tab.c"
    break;

  case 63:
#line 1015 "1705074.y"
                {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "rel_expression", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
					yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
			yyval->isNumber = yyvsp[0]->isNumber;
			yyval->baseProperty = yyvsp[0]->baseProperty;
			printLog("rel_expression : simple_expression", yyval->getName(), false);
			delete yyvsp[0];			
		}
#line 2701 "y.tab.c"
    break;

  case 64:
#line 1024 "1705074.y"
                {
		 	if(yyvsp[-2]->getDataType() == "void"){
		 		printError("1st operand of RELOP operation is void");
		 	}
		 	if(yyvsp[0]->getDataType() == "void"){
		 		printError("2nd operand of RELOP operation is void");
		 	}		
		
			string newName = yyvsp[-2]->getName() + yyvsp[-1]->getName() + yyvsp[0]->getName();
			string tempVar = getDstAddress(yyvsp[-2], yyvsp[0]);
			string label1 = newLabel();
			string label2 = newLabel();
			
			string code = getAsmOfALU(yyvsp[-2], yyvsp[0]);
			code += "cmp ax, bx\n";
			
			if(yyvsp[-1]->getName() == "<"){
				code += "jl " + label1 + "\n";
			}
			else if(yyvsp[-1]->getName() == "<="){
				code += "jle " + label1 + "\n";
			}
			else if(yyvsp[-1]->getName() == ">"){
				code += "jg " + label1 + "\n";
			}
			else if(yyvsp[-1]->getName() == ">="){
				code += "jge " + label1 + "\n";
			}
			else if(yyvsp[-1]->getName() == "=="){
				code += "je " + label1 + "\n";
			}
			else if(yyvsp[-1]->getName() == "!="){
				code += "jne " + label1 + "\n";
			}
			
			code += "mov " + tempVar + ", 0\n";
			code += "jmp " + label2 + "\n";
			code += label1 + ":\n" + "mov "+ tempVar + ", 1\n";
			code += label2 + ":\n\n";			
			
			yyval = new SymbolInfo(newName, "rel_expression", "int", VARIABLE, tempVar, code);
			yyval->baseProperty = ALU;
			printLog("rel_expression : simple_expression RELOP simple_expression", yyval->getName(), false);
			delete yyvsp[-2]; delete yyvsp[-1]; delete yyvsp[0];		
		}
#line 2751 "y.tab.c"
    break;

  case 65:
#line 1072 "1705074.y"
                  {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "simple_expression", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
					yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
			yyval->isNumber = yyvsp[0]->isNumber;
			yyval->baseProperty = yyvsp[0]->baseProperty;
			
			printLog("simple_expression : term", yyval->getName(), false);
			delete yyvsp[0];			  
		  }
#line 2765 "y.tab.c"
    break;

  case 66:
#line 1082 "1705074.y"
                  {
		  	string newName = yyvsp[-2]->getName() + yyvsp[-1]->getName() + yyvsp[0]->getName();
			
			string dataType = "int";
			if(yyvsp[-2]->getDataType() == "float" || yyvsp[0]->getDataType() == "float"){
				dataType = "float";
			}
			if(yyvsp[-2]->getDataType() == "void" || yyvsp[0]->getDataType() == "void"){
				printError("operation on void type");
			}
						
		 	string tempVar = getDstAddress(yyvsp[-2], yyvsp[0]);
			string code = getAsmOfALU(yyvsp[-2], yyvsp[0]);
			
			if(yyvsp[-1]->getName() == "+"){
				code += "add ax, bx\n";
			}
			else{
				code += "sub ax, bx\n";
			}
			code += "mov " + tempVar + ", ax\n";
			
			yyval = new SymbolInfo(newName, "simple_expression", dataType, VARIABLE, tempVar, code);
			yyval->baseProperty = ALU;
			printLog("simple_expression : simple_expression ADDOP term", yyval->getName(), false);
			
			delete yyvsp[-2]; delete yyvsp[-1]; delete yyvsp[0];		  
		  }
#line 2798 "y.tab.c"
    break;

  case 67:
#line 1113 "1705074.y"
                {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "term", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), yyvsp[0]->getAsmSymbol(),
					yyvsp[0]->getCode());
			yyval->isNumber = yyvsp[0]->isNumber;
			yyval->baseProperty = yyvsp[0]->baseProperty;
			
			printLog("term : unary_expression", yyval->getName(), false);
			delete yyvsp[0];			
		}
#line 2812 "y.tab.c"
    break;

  case 68:
#line 1123 "1705074.y"
                {
		 	string dataType = "undefined";
		 	if(yyvsp[-1]->getName() == "%"){
		 		if(yyvsp[-2]->getDataType() == "float" || yyvsp[0]->getDataType() == "float"){
		 			printError("Non-Integer operand on modulus operator");
				}
				else{
					dataType = "int"; 
				}    
		 	}
		 	else{
				dataType = "int";
				if(yyvsp[-2]->getDataType() == "float" || yyvsp[0]->getDataType() == "float"){
					dataType = "float";
				}     	
		 	}
		 	
			if(yyvsp[0]->getDataType() == "void" && yyvsp[0]->getAttribute() == FUNCTION){
	   			printError("Void function used in expression");
	   		}
	   		else if(yyvsp[-2]->getDataType() == "void" || yyvsp[0]->getDataType() == "void"){
				printError("operation on void type");
			}
		 	else if(yyvsp[0]->getAttribute() == VARIABLE && yyvsp[0]->isNumber && stof(yyvsp[0]->getName()) == 0.0){
		 		if(yyvsp[-1]->getName() == "%"){
		 			printError("Modulus by Zero");
		 		}
		 		else if(yyvsp[-1]->getName() == "/"){
		 			printError("Divide by Zero");
		 		}
		 	}		
		
		 	string newName = yyvsp[-2]->getName() + yyvsp[-1]->getName() + yyvsp[0]->getName();
		 	string tempVar = getDstAddress(yyvsp[-2], yyvsp[0]);
		 	string code = getAsmOfALU(yyvsp[-2], yyvsp[0]);
			
			if(yyvsp[-1]->getName() == "*"){
				code += "mul bx\n";
			}
			else if(yyvsp[-1]->getName() == "/" || yyvsp[-1]->getName() == "%"){
				code += "xor dx, dx\n";
				code += "div bx\n";
			}
			
			if(yyvsp[-1]->getName() == "%"){
				code += "mov " + tempVar + ", dx\n";
			}
			else{
				code += "mov " + tempVar + ", ax\n";
			}
			
			yyval = new SymbolInfo(newName, "term", dataType, VARIABLE, tempVar, code);
			yyval->baseProperty = ALU;
			
			printLog("term : term MULOP unary_expression", yyval->getName(), false);
			
			delete yyvsp[-2]; delete yyvsp[-1]; delete yyvsp[0];		
		}
#line 2875 "y.tab.c"
    break;

  case 69:
#line 1184 "1705074.y"
                 {
		 	string newName = yyvsp[-1]->getName() + yyvsp[0]->getName();
			string code = "";
			string tempVar = getDstAddressForUnary(yyvsp[0]);
			
			if(yyvsp[-1]->getName() == "-"){
				code += getAsmOfUnary(yyvsp[0]);
				code += "neg ax\n";
				code += "mov " + tempVar + ", ax\n";
			}
			
			yyval = new SymbolInfo(newName, "unary_expression", yyvsp[0]->getDataType(), VARIABLE, tempVar, code);
			yyval->isNumber = yyvsp[0]->isNumber;
			printLog("unary_expression : ADDOP unary_expression", yyval->getName(), false);
			
			delete yyvsp[-1]; delete yyvsp[0];	 
		 }
#line 2897 "y.tab.c"
    break;

  case 70:
#line 1202 "1705074.y"
                 {
		 	string newName = "!" + yyvsp[0]->getName();
		 	string code = "";
			string tempVar = getDstAddressForUnary(yyvsp[0]);
			
			code += getAsmOfUnary(yyvsp[0]);
			code += "not ax\n";
			code += "mov " + tempVar + ", ax\n";
		 	
			yyval = new SymbolInfo(newName, "unary_expression", yyvsp[0]->getDataType(), VARIABLE, tempVar, code);
			yyval->isNumber = yyvsp[0]->isNumber;
			printLog("unary_expression : NOT unary_expression", yyval->getName(), false);
			
			delete yyvsp[0];		 
		 }
#line 2917 "y.tab.c"
    break;

  case 71:
#line 1218 "1705074.y"
                 {
			yyval = new SymbolInfo(yyvsp[0]->getName(), "unary_expression", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
				yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
			yyval->isNumber = yyvsp[0]->isNumber;
			yyval->baseProperty = yyvsp[0]->baseProperty;
			printLog("unary_expression : factor", yyval->getName(), false);
			delete yyvsp[0];		 
		 }
#line 2930 "y.tab.c"
    break;

  case 72:
#line 1229 "1705074.y"
        {
		yyval = new SymbolInfo(yyvsp[0]->getName(), "factor", yyvsp[0]->getDataType(), yyvsp[0]->getAttribute(), 
				yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
				
		yyval->baseProperty = yyvsp[0]->baseProperty;			
		printLog("factor : variable", yyval->getName(), false);		
		delete yyvsp[0];	
	}
#line 2943 "y.tab.c"
    break;

  case 73:
#line 1238 "1705074.y"
        {
		SymbolInfo* idSymbol = symbolTable->Lookup(yyvsp[-3]->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	string asmSymbol = "";
	 	string code = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 		
	 		if(attribute == FUNCTION_PROTOTYPE){
	 			printError("Callee Function has no body");	 	
	 		}
		 	else if(attribute != FUNCTION && attribute != FUNCTION_PROTOTYPE){
		 		printError("A function call cannot be made with non-function type identifier");
		 	}
		 	else{
		 		code = getAsmOfFunctionCall(idSymbol, yyvsp[-1]);
		 		checkArgConsistency(idSymbol, false);
		 		argumentsInfo.clear();
		 	}	 		
	 	}
	 	else{
	 		printError("Undeclared Function : " + yyvsp[-3]->getName());
	 	}
	 	
	 	string newName = yyvsp[-3]->getName() + "(" + yyvsp[-1]->getName() + ")";
	 	
		yyval = new SymbolInfo(newName, "factor", dataType, attribute, asmSymbol, code);
		printLog("factor : ID LPAREN argument_list RPAREN", yyval->getName(), false);
		delete yyvsp[-3]; delete yyvsp[-1];		
	}
#line 2982 "y.tab.c"
    break;

  case 74:
#line 1273 "1705074.y"
        {
	 	string newName = "(" + yyvsp[-1]->getName() + ")";
		yyval = new SymbolInfo(newName, "factor", yyvsp[-1]->getDataType(), yyvsp[-1]->getAttribute(), 
			yyvsp[-1]->getAsmSymbol(), yyvsp[-1]->getCode());
		printLog("factor : LPAREN expression RPAREN", yyval->getName(), false);
		delete yyvsp[-1];		
	}
#line 2994 "y.tab.c"
    break;

  case 75:
#line 1281 "1705074.y"
        {
		yyval = new SymbolInfo(yyvsp[0]->getName(), "factor", yyvsp[0]->getDataType(), VARIABLE, yyvsp[0]->getName(), "");
		yyval->isNumber = true;
		printLog("factor : CONST_INT", yyval->getName(), false);
		delete yyvsp[0];	
	}
#line 3005 "y.tab.c"
    break;

  case 76:
#line 1288 "1705074.y"
        {
		yyval = new SymbolInfo(yyvsp[0]->getName(), "factor", yyvsp[0]->getDataType(), VARIABLE, yyvsp[0]->getName(), "");
		yyval->isNumber = true;
		printLog("factor : CONST_FLOAT", yyval->getName(), false);
		delete yyvsp[0];	
	}
#line 3016 "y.tab.c"
    break;

  case 77:
#line 1295 "1705074.y"
        {
	 	string newName = yyvsp[-1]->getName() + "++";
	 	string tempVar = getDstAddressForUnary(yyvsp[0]);
	 	
	 	string code = getAsmOfUnary(yyvsp[-1]);
	 	code += "add " + yyvsp[-1]->getAsmSymbol() + ", 1\n";
	 	code += "mov " + tempVar + ", ax\n";
	 	
		yyval = new SymbolInfo(newName, "factor", yyvsp[-1]->getDataType(), yyvsp[-1]->getAttribute(), tempVar, code);
		printLog("factor : variable INCOP", yyval->getName(), false);
		delete yyvsp[-1];	
	}
#line 3033 "y.tab.c"
    break;

  case 78:
#line 1308 "1705074.y"
        {
	 	string newName = yyvsp[-1]->getName() + "--";
	 	string tempVar = getDstAddressForUnary(yyvsp[0]);
	 	
	 	string code = getAsmOfUnary(yyvsp[-1]);
	 	code += "sub " + yyvsp[-1]->getAsmSymbol() + ", 1\n";
	 	code += "mov " + tempVar + ", ax\n";
	 	
		yyval = new SymbolInfo(newName, "factor", yyvsp[-1]->getDataType(), yyvsp[-1]->getAttribute(), tempVar, code);
		printLog("factor : variable DECOP", yyval->getName(), false);
		delete yyvsp[-1];		
	}
#line 3050 "y.tab.c"
    break;

  case 79:
#line 1321 "1705074.y"
        {
		yyval = new SymbolInfo(yyvsp[0]->getName(), "factor", yyvsp[0]->getDataType(), VARIABLE, "", "");
	}
#line 3058 "y.tab.c"
    break;

  case 80:
#line 1327 "1705074.y"
                          {
					yyval = new SymbolInfo(yyvsp[0]->getName(), "argument_list", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
					printLog("argument_list : arguments", yyval->getName(), false);
					delete yyvsp[0];			  
			  }
#line 3068 "y.tab.c"
    break;

  case 81:
#line 1333 "1705074.y"
                          {
					yyval = new SymbolInfo("", "argument_list", "undefined", UNDEFINED, "", "");
					printLog("argument_list :", yyval->getName(), false);			  
			  }
#line 3077 "y.tab.c"
    break;

  case 82:
#line 1340 "1705074.y"
                  {
	      		SymbolInfo* expSymbol = new SymbolInfo(yyvsp[0]->getName(), yyvsp[0]->getType(), yyvsp[0]->getDataType(),
	      												yyvsp[0]->getAttribute(), yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
	      		argumentsInfo.push_back(expSymbol);		  
		  
			 	string newName = yyvsp[-2]->getName() + "," + yyvsp[0]->getName();
			 	string code = yyvsp[0]->getCode()	+ yyvsp[-2]->getCode();
				yyval = new SymbolInfo(newName, "arguments", "undefined", UNDEFINED, "", code);
				
				printLog("arguments : arguments COMMA logic_expression", yyval->getName(), false);
				delete yyvsp[-2]; delete yyvsp[0];		  
		  }
#line 3094 "y.tab.c"
    break;

  case 83:
#line 1353 "1705074.y"
              {
	      		argumentsInfo.clear();
	      		SymbolInfo* expSymbol = new SymbolInfo(yyvsp[0]->getName(), yyvsp[0]->getType(), yyvsp[0]->getDataType(),
	      												yyvsp[0]->getAttribute(), yyvsp[0]->getAsmSymbol(), yyvsp[0]->getCode());
	      		argumentsInfo.push_back(expSymbol);
				yyval = new SymbolInfo(yyvsp[0]->getName(), "arguments", "undefined", UNDEFINED, "", yyvsp[0]->getCode());
				printLog("arguments : logic_expression", yyval->getName(), false);
				delete yyvsp[0];			      
	      }
#line 3108 "y.tab.c"
    break;


#line 3112 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1365 "1705074.y"

int main(int argc,char *argv[])
{
    if(argc!=2){
		cout << "Please provide input file name and try again" << endl;
		return 0;
    } 

    FILE *fin=fopen(argv[1],"r");
    if(fin==NULL){
		cout << "Cannot open specified file" << endl;
		return 0;
    }
	
	logFile.open("1705074_log.txt", ios::out);
	errorFile.open("1705074_error.txt", ios::out);
	asmFile.open("code.asm", ios::out);
    optimizedAsmFile.open("optimized_code.asm", ios::out);
	
	symbolTable->enterScope(30, "global");

	yyin= fin;
	yyparse();
	
	fclose(yyin);
	
	logFile.close();
	errorFile.close();
	asmFile.close();
    optimizedAsmFile.close();
	
	return 0;
}
		  			       
