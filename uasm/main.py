from parser import parser
import argparse
import ast
from signal_lines import signal_lines, num_signal_bytes
import math


argp = argparse.ArgumentParser(description='A microcode assembler for the n16 and n32')
argp.add_argument('input_files', nargs='+')
argp.add_argument('-o', type=str, default='u')

args = argp.parse_args()

source = ''
for input_file in args.input_files:
    source += open(input_file, 'r').read() + '\n'



root = parser.parse(source)

print(root.statements)


# find symbols
symbols = {}
addr = 0
print('first pass')
for s in root.statements:
    stype = type(s)

    if stype == ast.AddressLiteralStatement:
        addr = s.address

    elif stype == ast.LabelStatement:
        symbols[s.label] = addr

    elif stype == ast.SignalExpr:
        addr += 1


def resolve_dest(dest):
    if dest.is_literal:
        return dest.address

    if dest.label in symbols.keys():
        return symbols[dest.label]

    print("error: unkown symbol '%d' in destination" % dest.label)


def evaluate_signal_expr(expr, addr):
    s = ast.Signal()
    s.branch_a = addr + 1  # default is to link to next addr

    for id in expr.signal_ids:
        idtype = type(id)

        if idtype == ast.SignalId:
            if id.label in signal_lines.keys():
                s.signal_lines.append(signal_lines[id.label])
            else:
                print("error: unkown signal id '%s'" % id.label)

        elif idtype == ast.SignalBranch:
            if id.label == 'branch':
                s.branch_a = resolve_dest(id.destination_a)
                s.branch_b = resolve_dest(id.destination_b)

    return s



print('second pass')
addr = 0
rom_repr = {}
for s in root.statements:
    stype = type(s)

    if stype == ast.AddressLiteralStatement:
        addr = s.address

    elif stype == ast.LabelStatement:
        symbols[s.label] = addr

    elif stype == ast.SignalExpr:
        rom_repr[addr] = evaluate_signal_expr(s, addr)
        addr += 1


print('rom image:')

for k in rom_repr.keys():
    rk = rom_repr[k]
    print(k, '\t', 'a:', rk.branch_a, 'b:', rk.branch_b, 'l:', rk.signal_lines)


print('write roms')
roms = [[0x0,]*0x100 for i in range(num_signal_bytes)]

for k in rom_repr.keys():
    rk = rom_repr[k]

    print("<%d>\ta: %d\tb: %d"%(k, rk.branch_a, rk.branch_b))

    for l in rk.signal_lines:
        byte = int(math.floor(l / 8))
        bit = l - byte * 8
        roms[byte][k] |= 1 << bit

        print("    writing bit %d of byte %d" % (bit, byte))

    roms[num_signal_bytes - 2][k] = rk.branch_a
    roms[num_signal_bytes - 1][k] = rk.branch_b


for i in range(num_signal_bytes):
    out = open("u.%d.out"%i, 'w')
    out.write('v2.0 raw\n')
    for j in range(len(roms[i])):
        out.write(hex(roms[i][j])[2:] + ' ')
    out.close()