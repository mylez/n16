import re
import math
txt = open('signal-lines.txt', 'r').read()

signal_lines = {}

for line in txt.splitlines():
    split = re.split('\s+', line)
    if len(split) == 2:
        signal_lines[split[1]] = int(split[0], 16)

num_signal_lines = len(signal_lines)
num_signal_bytes = 6#2 + int(math.ceil(num_signal_lines/8))