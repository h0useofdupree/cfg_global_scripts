def generate_excel_columns(n):
    columns = []
    for i in range(1, n + 1):
        column = ""
        while i > 0:
            i, remainder = divmod(i - 1, 26)
            column = chr(65 + remainder) + column
        columns.append(column)
    return columns


if __name__ == "__main__":
    for column in generate_excel_columns(114):
        print(column)
