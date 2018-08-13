from signal_lines import signal_lines

class Root:
    def __init__(self):
        self.statements = []


class AddressLiteralStatement:
    def __init__(self, address):
        self.address = address


class LabelStatement:
    def __init__(self, label):
        self.label = label


class ValueStatement:
    def __init__(self, label, signal_expr):
        self.label = label
        self.signal_expr = signal_expr


class SignalExpr:
    def __init__(self):
        self.signal_ids = []


class SignalId:
    def __init__(self, label):
        self.label = label


class SignalBranch:
    def __init__(self, label, destination_a, destination_b):
        self.label = label
        self.destination_a = destination_a
        self.destination_b = destination_b


class Destination:
    def __init__(self, label=None, address=None):
        self.label = label
        self.address = address
        self.is_literal = label == None


class Signal:
    def __init__(self):
        self.signal_lines = []
        self.branch_a = 0
        self.branch_b = 0