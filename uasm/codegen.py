import ast
from signal_lines import signal_lines, num_signal_bytes
from parser import parser
import math


def resolve_dest(symbols, dest):
    if dest.is_literal:
        return dest.address
    if dest.label in symbols.keys():
        return symbols[dest.label]
    print("error: unkown symbol '%d' in destination" % dest.label)
    exit(1)


def evaluate_signal_expr(expr, addr, symbols):
    s = ast.Signal()
    s.branch_a = addr + 1 # default is to link to next addr

    for id in expr.signal_ids:
        idtype = type(id)

        if idtype == ast.SignalId:
            if id.label in signal_lines.keys():
                s.signal_lines.append(signal_lines[id.label])
            else:
                print("error: unkown signal id '%s'" % id.label)
                exit(1)

        elif idtype == ast.SignalBranch:
            if id.label == 'branch':
                s.branch_a = resolve_dest(symbols, id.destination_a)
                s.branch_b = resolve_dest(symbols, id.destination_b)

    return s


def parse_files(args):
    source = ''
    for input_file in args.input_files:
        source += open(input_file, 'r').read() + '\n'
    return parser.parse(source)


def generate_ucode(root):
    symbols = {}
    addr = 0

    for s in root.statements:
        stype = type(s)

        if stype == ast.AddressLiteralStatement:
            addr = s.address

        elif stype == ast.LabelStatement:
            symbols[s.label] = addr

        elif stype == ast.SignalExpr:
            addr += 1

    addr = 0
    rom_repr = {}
    for s in root.statements:
        stype = type(s)

        if stype == ast.AddressLiteralStatement:
            addr = s.address

        elif stype == ast.LabelStatement:
            symbols[s.label] = addr

        elif stype == ast.SignalExpr:
            rom_repr[addr] = evaluate_signal_expr(s, addr, symbols)
            addr += 1

    return addr, symbols, rom_repr


def write_logisim_rom_files(rom_repr, args):
    roms = [[0x0 , ] *0x100 for i in range(num_signal_bytes)]
    for k in rom_repr.keys():
        rk = rom_repr[k]
        if args.v:
            print("<%d>\ta: %d\tb: %d" %(k, rk.branch_a, rk.branch_b))
        for l in rk.signal_lines:
            byte = int(math.floor(l / 8))
            bit = l - byte * 8
            roms[byte][k] |= 1 << bit
            if args.v:
                print("    writing bit %d of byte %d" % (bit, byte))
        roms[-2][k] = rk.branch_a
        roms[-1][k] = rk.branch_b


    for i in range(num_signal_bytes):
        out = open( "u.%d.out" %i, 'w')
        out.write('v2.0 raw\n')
        for j in range(len(roms[i])):
            out.write(hex(roms[i][j])[2:] + ' ')
        out.close()


def parse_and_write(args):
    if args.v:
        print('rom size:', num_signal_bytes, 'bytes')
    root = parse_files(args)
    addr, symbols, rom_repr = generate_ucode(root)
    write_logisim_rom_files(rom_repr, args)
