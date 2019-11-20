import re
import sys

def get_filepath(file_id, fmap_lines):
    assert file_id > 0 and file_id <= len(fmap_lines), 'invalid file id'
    line = fmap_lines[file_id - 1]
    tokens = line.split(sep='\t')
    return tokens[1]

def get_enclosed_str(data):
    num_open_brackets = 1
    enclosed_str = ''
    j = None
    for i in range(0, len(data)):
        if data[i] == '[':
            num_open_brackets = num_open_brackets + 1
        elif data[i] == ']':
            num_open_brackets = num_open_brackets - 1
            if num_open_brackets == 0:
                enclosed_str = data[0:i]
                j = i
                break

    if data[j + 1] == '[':
        enclosed_str = enclosed_str + '][' + get_enclosed_str(data[(j + 2):len(data)])

    return enclosed_str

def find_array_indices(array_name, src_line):
    indices = []
    uses = list(re.finditer(array_name, src_line))
    for use in uses:
        # print(use.end())
        if src_line[use.end()] == '[':
            indices.append(get_enclosed_str(src_line[(use.end() + 1) : len(src_line)]))
        else:
            indices.append('')

    return indices


def possible_reduction(line, src_lines):
    assert line > 0 and line <= len(src_lines), 'invalid src line'
    src_line = src_lines[line - 1]
    while not ';' in src_line:
        line = line + 1
        if line > len(src_lines):
            return False
        src_line = src_line + ' ' + src_lines[line - 1]

    pos = src_line.find('=')
    if pos == -1:
        return True

    bracket_a = src_line[0:pos].find('[')
    if bracket_a == -1:
        return True
    bracket_b = src_line[0:pos].rfind(']')
    assert bracket_b != -1

    rex_search_res = re.search('([A-Za-z0-9_]+)\[', src_line[0:(bracket_a + 1)])
    if not rex_search_res:
        return True

    array_name = rex_search_res[1]
    array_index = src_line[(bracket_a + 1) : bracket_b]
    # print('"{} {}"'.format(array_name, array_index))

    array_indices = find_array_indices(array_name, src_line[pos:len(src_line)])
    # print(array_indices)
    for index in array_indices:
        if not index == array_index:
            return False

    return True

def is_reduction(reduction_line, fmap_lines):
    rex = re.compile('FileID : ([0-9]*) Loop Line Number : [0-9]* Reduction Line Number : ([0-9]*) ')
    if not rex:
        return False
    res = rex.search(reduction_line)
    file_id = int(res.group(1))
    file_line = int(res.group(2))
    # print(file_line)

    filepath = get_filepath(file_id, fmap_lines)
    # print(filepath)
    src_file = open(filepath)
    src_lines = src_file.read().splitlines()
    src_file.close()

    return possible_reduction(file_line, src_lines)

if not len(sys.argv) == 3:
    reduction_path = 'reduction.txt'
    fmap_path = 'FileMapping.txt'
else:
    reduction_path = sys.argv[1]
    fmap_path = sys.argv[2]

reduction_file = open(reduction_path)
reduction_lines = reduction_file.read().splitlines()
reduction_file.close()

fmap_file = open(fmap_path)
fmap_lines = fmap_file.read().splitlines()
fmap_file.close()

actual_reductions = []
for reduction_line in reduction_lines:
    if is_reduction(reduction_line, fmap_lines):
        actual_reductions.append(reduction_line)
    # else:
        # print('not a reduction : ' + reduction_line)

out_file = open('_reduction.txt', 'w')
for red in actual_reductions:
    out_file.write(red + '\n')
out_file.close()

