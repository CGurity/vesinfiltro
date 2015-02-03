# Elimininacion de paquetes no deseados si existen
sudo apt-get remove wolfram-engine scratch sonic-pi
# Actualizacion
sudo apt-get update
sudo apt-upgrade
# Instalacion de paquetes a usar
sudo apt-get install python-pip python-setuptools python-dnspython python-argparse python-m2crypto ppp usb-modeswitch wvdial procmail
# Correccion de zona horaria
sudo cp /usr/share/zoneinfo/Europe/London /etc/localtime
# Copia de la configuracion de modems 3g en el directorio correspondiente
sudo cp otros/wvdial_global.conf /etc/wvdial.conf
# Instalacion de paquetes python mas actualizados o solo disponibles en pip
sudo pip install requests
sudo pip install centinel-dev==0.1.5.1
# Inicializacion de centinel para creacion de estructura de archivos en ~/.centinel
centinel-dev --sync
centinel-dev
# Sustitucion del archivo de configuracion de centinel para deshabilitar la seleccion aleatoria limitada de experimentos
cp otros/config.ini ~/.centinel/config.ini
# Copia de experimento device_data y peticion al usuario de setear los datos propios del dispositivo
cp otros/device_data.py ~/.centinel/experiments/device_data.py
cp otros/device_data.txt ~/.centinel/data/device_data.txt
nano ~/.centinel/data/device_data.txt
