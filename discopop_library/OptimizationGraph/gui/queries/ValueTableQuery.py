from typing import List, Tuple, Optional, Dict, cast

from sympy import Symbol, Expr
from tkinter import *


def query_user_for_symbol_values(
    symbols: List[Symbol], suggested_values: Dict[Symbol, Expr]
) -> List[Tuple[Symbol, Optional[float], Optional[float], Optional[float]]]:
    """Opens a GUI-Table to query values for each given Symbol from the user.
    The queried values are: Specific value, Range start, Range end.
    In every case, either a specific value, or a range must be given
    Return: [(symbol, symbol_value, range_start, range_end]"""
    query_result: List[Tuple[Symbol, Optional[float], Optional[float], Optional[float]]] = []
    column_headers = ["Symbol Name", "Symbol Value", "Range Start", "Range End"]

    root = Tk()
    rows = []
    # set column headers
    header_cols = []
    for col_idx, header in enumerate(column_headers):
        e = Entry(root, relief=RIDGE)
        e.grid(row=0, column=col_idx, sticky=NSEW)
        e.insert(END, header)
        e.configure(state=DISABLED, disabledforeground="black")
        header_cols.append(e)
    rows.append(header_cols)

    # create query Table
    for row_idx, free_symbol in enumerate(symbols):
        row_idx = row_idx + 1  # to account for column headers
        cols = []
        for col_idx, column_name in enumerate(column_headers):
            e = Entry(relief=RIDGE)
            e.grid(row=row_idx, column=col_idx, sticky=NSEW)
            if col_idx == 0:
                # symbol name
                e.insert(END, str(free_symbol))
                e.configure(state=DISABLED, disabledforeground="black")
            else:
                # queried value
                if col_idx == 1 and free_symbol in suggested_values:
                    # insert suggested value, if one exists
                    e.insert(END, str(suggested_values[free_symbol]))
            cols.append(e)
        rows.append(cols)

    def validate() -> bool:
        ret_val = True
        # validate entries
        for row_idx, row in enumerate(rows):
            if row_idx == 0:
                continue
            row_valid = False
            # check if either a specific value or ranges are set
            if len(row[1].get()) != 0:
                # specific value
                row_valid = True
            elif len(row[2].get()) != 0 and len(row[3].get()) != 0:
                # range specified
                row_valid = True
            else:
                # row invalid
                ret_val = False
            # mark row
            if row_valid:
                for col in row[1:]:
                    col.configure(background="grey")
            else:
                for col in row[1:]:
                    col.configure(background="red")
        return ret_val

    def onPress():
        if not validate():
            return
        # fetch entries
        for row_idx, row in enumerate(rows):
            if row_idx == 0:
                continue
            row_element = []
            for col_idx, col in enumerate(row):
                if col_idx == 0:
                    # append symbol to row_element
                    row_element.append(symbols[row_idx-1])  # -1 to account for column headers
                else:
                    field_value = col.get()
                    if len(field_value) == 0:
                        row_element.append(None)
                    else:
                        row_element.append(float(field_value))
            query_result.append(cast(Tuple[Symbol, Optional[float], Optional[float], Optional[float]], tuple(row_element)))
        root.destroy()

    Button(root, text="Save", command=lambda: onPress()).grid()
    Button(root, text="Validate", command=lambda: validate()).grid()
    mainloop()
    return query_result
