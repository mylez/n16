import ply.lex as lex

tokens = (
    'VALUE_ID', 'LABEL_ID', 'SIGNAL_ID', 'NUMBER_DEC', 'NUMBER_HEX'
)

t_VALUE_ID = r'[%][0-9a-zA-Z_]+'
t_LABEL_ID = r'[@][0-9a-zA-Z_]+'
t_SIGNAL_ID = r'[a-zA-Z_][0-9a-zA-Z_]*'
t_NUMBER_DEC = r'[0]|[1-9][0-9]*'
t_NUMBER_HEX = r'[0][xX][0-9a-fA-F]+'

literals = [';', ':', ',', '<', '>', '(', ')']
t_ignore = ' \t'

def t_inline_comment(t):
    r'//[^\n]*'

def t_newline(t):
    r'\n'
    t.lexer.lineno += t.value.count('\n')

def t_error(t):
    print("illegal character '%s'" % t.value[0])
    exit(1)

# build lexer
lexer = lex.lex()

