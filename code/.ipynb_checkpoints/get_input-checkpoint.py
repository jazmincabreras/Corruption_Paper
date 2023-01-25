
from subprocess import call
import platform
import shutil, os
import getpass

system = platform.system()
user = getpass.getuser()

if user == 'dell':
    path = r'C:/Users/dell/Documents/QLAB/Corruption_Paper'
    dataSources = [r'C:/Users/dell/Documents/QLAB/Corruption_Paper_Data/matrix_datospanel.dta',
                   r'C:/Users/dell/Documents/QLAB/Corruption_Paper_Data/matrix_renamu.dta',
                   r'C:/Users/dell/Documents/QLAB/Corruption_Paper_Data/matrix_siaf.dta']
    folder = '/input'
    shutil.rmtree( path + folder )
    os.mkdir( path + folder )
    
    for file in dataSources:
        call(['cp', file, path+'/input'], shell = True)
        
#if user == 'Usuario':
#    path = r'C:/Users/Usuario/Desktop/QLAB/GitHub/Corruption_Paper'
# Completar con datos de Jazmin

    