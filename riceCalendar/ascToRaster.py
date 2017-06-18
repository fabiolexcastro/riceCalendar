# ---------------------------------------------------------------------------
# Autor: Antonio Pantoja;  grupo: Dapa; empresa: CIAT; lugar: CAli, Colombia
# Fecha: febrero 10 de 2011
# Actualizado: septiembre 8 2011
# Proposito: conversion formato asc a raster 
# Nota: opcion de una o varias carpetas
# mas informacion : jesuspantoja@gmail.com
# ---------------------------------------------------------------------------

import arcgisscripting, os, sys, string,glob
gp = arcgisscripting.create(9.3)


os.system('cls')


def process():
    x= raw_input(''' \n pasar de formato asc a raster       \n\n\n\n\tDigite un numero :

                1  para una sola carpeta de asc's
                    \n\t\t2  para varios modelos

                    ''')



    if x == "2":

        carpete_asc = raw_input("Entrar capeta de modelos ->  ")
        carpete_rasters = raw_input("\nEntrar una carpeta de salida ->  ")

        lista_modelos = [s for s in os.listdir(carpete_asc)
                if os.path.isdir(os.path.join(carpete_asc))]
        for lm in lista_modelos:
            #comprobador de carpeta modelo salida
            if not os.path.exists(carpete_rasters +"\\"+ lm): os.mkdir(carpete_rasters +"\\"+ lm)
            archivos_entrada = glob.glob(carpete_asc + "\\" + lm + "\\*.asc")             
            for archivo in archivos_entrada:
                nombre = os.path.basename(archivo)
                #comprobador de archivo salida
                if not os.path.exists(carpete_rasters+"\\"+ lm + "\\" + nombre[:-4]):
                    print "procesando", archivo
                    salida = carpete_rasters+"\\"+ lm + "\\" + nombre[:-4] + ".tif"
                    gp.ASCIIToRaster_conversion(archivo, salida, "FLOAT")
                else: print "\tYa existe el archivo: ", archivo + "  en modelo:     " , lm
        print
        print " Entrada fue: ", carpete_asc
        print ""
        print " Salida es:   ", carpete_rasters
        


    elif x=="1":
        carpete_asc = raw_input("Entrar capeta de los asc's -> ")
        carpete_rasters = raw_input("\nCarpeta salida de rasters -> ")
        archivos_entrada = glob.glob(carpete_asc + "\\*.asc")
        for archivo in archivos_entrada:
            
             
                #comprobador de archivo salida
                nombre = os.path.basename(archivo)
                if not os.path.exists(carpete_rasters+"\\" + nombre[:-4]):
##                    print archivos_entrada
                    
                    print "procesando: " , archivo
                    salida = carpete_rasters+ "\\" + nombre[:-4] + ".tif"
                    print "salida es ", salida
                    gp.ASCIIToRaster_conversion(archivo, salida, "FLOAT")
                else: print "\tYa existe el archivo: ", archivo 
        print
        print " Entrada fue: ", carpete_asc
        print ""
        print " Salida es:   ", carpete_rasters



    elif x != "1" and x!= "2":
        os.system('cls')
        print " \nIntroduzca el munero 1  o el numero 2 \n\n\n\t\t\tPara mas informacion: jesuspantoja@gmail.com\n\n\n\n\n\n"
        process()

process()        

        
        