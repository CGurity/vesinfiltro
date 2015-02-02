import requests
import os
import glob
import getpass
from sys import argv
current_user = getpass.getuser()
user_home = os.path.expanduser('~' + current_user)
results_dir = os.path.join(user_home, '.centinel/results')
reciente = max(glob.iglob(results_dir + '/*.json'), key = os.path.getctime)
print reciente
r = requests.post('http://creceiver.guerracarlos.com/receiver.php', files={'fileToUpload': open( reciente, 'rb')})
os.remove(reciente)
