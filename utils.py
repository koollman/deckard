import sys

def ignore_pipe():
    from signal import signal, SIGPIPE, SIG_DFL
    signal(SIGPIPE, SIG_DFL)

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
