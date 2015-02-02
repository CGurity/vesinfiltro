import centinel.primitives.http as http

from centinel.experiment import Experiment
import logging
#import urllib2

class HTTPRequestExperiment(Experiment):
    name = "datos_aguila"

    def __init__(self, input_file):
        self.input_file  = input_file
        self.results = []
        self.host = None
        self.path = "/"

    def run(self):
	result = {}
        for line in self.input_file:
	    imprimir = "Haciendo prueba de http_connect en %s" % line
	    logging.info(imprimir)
	    self.datos = line.split()
	    self.clave = self.datos[0]
	    self.valor = self.datos[1]
	    print self.clave + " -> " + self.valor
            result[self.clave] = self.valor
	    #self.valores_aguilas()
	result["ip"] = "222.333.444.555"
	self.results.append(result)

    #def valores_aguilasself):
        #result = {
	#    self.clave : self.valor
	#}
	#result = http.get_request(self.host, self.path)
        #self.results.append(result)
