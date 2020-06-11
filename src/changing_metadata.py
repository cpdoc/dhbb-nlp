# pyconll documentation: https://readthedocs.org/projects/pyconll/downloads/pdf/latest/

import os
import pyconll
from sys import argv, exit

if __name__ == '__main__':
	try:
		dir_ = argv[1]
		if dir_[-1] != "/":
			dir_ += "/"
	except IndexError:
		print("Invalid directory")
		exit()
	files = [f for f in os.listdir(dir_) if 'conllu' in f]
	for file in files:
		conllu = pyconll.load_from_file(dir_+file)
		for sentence in conllu:
			sentence.set_meta("reviewed", "no")
		f = open(dir_+file, "w")
		f.write(conllu.conll())
		f.close()


