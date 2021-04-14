
import sys
import yaml

with open(sys.argv[1],'r') as s:
	for data in yaml.load_all(s, Loader=yaml.FullLoader):
		if 'cargos' in data:
			for c in data['cargos']:
				print("{}\t{}".format(data['title'],c))
		break
	
