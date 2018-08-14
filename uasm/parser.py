import ast
import ply.yacc as yacc
from lexer import *


##
## program
##
def p_root(t):
    r" root : statement "
    t[0] = ast.Root()
    t[0].statements.append(t[1])

def p_compound_program(t):
    r" root : root statement "
    t[0] = t[1]
    t[0].statements.append(t[2])


##
##  statements
##
def p_label_statement(t):
    r" statement : LABEL_ID ':' "
    t[0] = ast.LabelStatement(t[1])

def p_expr_statement(t):
    r" statement : signal_expr ';' "
    t[0] = t[1]

def p_value_statement(t):
    r" statement : VALUE_ID ':' signal_expr ';' "
    t[0] = ast.ValueStatement(t[1], t[3])

def p_address_literal_statement(t):
    r" statement : '<' number '>' "
    t[0] = ast.AddressLiteralStatement(t[2])


##
## expressions
##
def p_signal_expr(t):
    r" signal_expr : signal "
    t[0] = ast.SignalExpr()
    t[0].signal_ids.append(t[1])

def p_compound_signal_expr(t):
    r" signal_expr : signal_expr ',' signal "
    t[0] = t[1]
    t[0].signal_ids.append(t[3])


##
## signal
##
def p_signal_branch(t):
    r" signal : SIGNAL_ID '(' destination ',' destination ')' "
    t[0] = ast.SignalBranch(t[1], t[3], t[5])

def p_signal_signal_id(t):
    r" signal : SIGNAL_ID "
    t[0] = ast.SignalId(t[1])


##
## destination
##
def p_destination_label(t):
    r" destination : LABEL_ID"
    t[0] = ast.Destination(label=t[1])

def p_destination_number(t):
    r" destination : number"
    t[0] = ast.Destination(address=t[1])


##
## numbers
##
def p_number(t):
    '''
    number : NUMBER_HEX
           | NUMBER_DEC
    '''
    t[0] = int(t[1], 0)

def p_error(t):
    print("syntax error at '%s'" % t.value)


parser = yacc.yacc()

