"""Smoke-test the OriginPro external-Python bridge on a licensed Windows runner."""

import sys

import originpro as op


def shutdown_hook(exctype, value, traceback):
    try:
        if op and op.oext:
            op.exit()
    finally:
        sys.__excepthook__(exctype, value, traceback)


if op and op.oext:
    sys.excepthook = shutdown_hook

try:
    if op.oext:
        op.set_show(False)

    sheet = op.new_sheet()
    sheet.from_list(0, [1, 2, 3, 4, 5], "X")
    sheet.from_list(1, [1, 4, 9, 16, 25], "Y")

    print("OriginPro automation smoke test passed.")
    print("Created worksheet:", sheet.lt_range())
finally:
    if op.oext:
        op.exit()
