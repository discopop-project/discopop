from pathlib import Path

src_files = Path('.').glob('**/*.[ch]')
out_file = open('FileMapping.txt', 'w')

counter = 0
for filename in src_files:
    counter += 1
    out_file.write('{}\t{}\n'.format(counter, filename.absolute()))

out_file.close()
