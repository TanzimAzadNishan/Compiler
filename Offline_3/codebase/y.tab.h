/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

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
    LOWER_THAN_ELSE = 292
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
#define LOWER_THAN_ELSE 292

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
