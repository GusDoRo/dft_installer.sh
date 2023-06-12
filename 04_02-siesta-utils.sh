#!/bin/bash

####DFT INSTALLER####
#(Instalador automatizado de VASP, SIESTA, bibliotecas y utilerias en
# modalidad serial y paralela en ambiente Linux)

#Autores:
#	Gustavo Dominguez Rodriguez[1]
#	Gabriel Ivan Canto Santana [1]
#	Jorge Alejandro Tapia Gonzalez [2]
#	Cesar Alberto Cab Cauich[2]

#	[1]Centro de Investigacion en Corrosion, Universidad Autonoma de
#		Campeche.
#	[2]Facultad de Ingenieria, Universidad Autonoma de Yucatan



#####Descripción del paquete de Instalación.#####

#El paquete consta de varias rutinas primarias que se ejecutan de manera
#secuencial, cada una pensada en instalar o configurar un paquete en
#concreto. Todos ellos se encuentran programados en bash de Linux,
#concretamente diversas versiones de OpenSUSE, y cada uno de ellos, 
#tiene la capacidad de no volverse a ejecutar, en caso de que su
#ejecución previa haya sido exitosa. De esta forma se puede ejecutar el
#script general "dft_installer.sh" sin la preocupación de que lo
#previamente instalado intente reinstalarse. Igualmente se puede
#ejecutar cada rutina de manera secuencial si de desea tener un poco
#más de control del ritmo de la instalación. También se ha implementado
#un sistema de manejo de errores que permite detener la ejecución en 
#caso de que algo no funcione de la manera esperada. 

#Igual se cuenta con una rutina ("dft_loader.sh") que inicia las
#variables de entorno para la instalación con la versión del MPICH y las
#librerías seleccionadas. Por lo que se puede contar con diferentes
#implementaciones en un mismo equipo e inicializar la que se requiera.

#El primer paquete llamado, "01_01-variables.sh", se cerciora,
#primeramente, de no haber sido ejecutado antes, posteriormente verifica
#qué archivos de instalación se encuentran disponibles y finalmente crea
#un archivo script llamado "variables.sh" donde se almacenan las
#variables de entorno usados y se lleva el control de los paquetes ya
#instalados.

#El segundo proceso, "01_02-preinstalls-superuser.sh", se centra en
#instalar paquetes necesarios en el sistema de cómputo para llevar a
#cabo la instalación, como son los compiladores de Fortran y C++ de la
#colección GCC, Python, y la herramienta Make. AL igual que descarga el
#instalador de ScaLAPACK en caso de no estar previamente descargada.

#Por otro lado, La tercera rutina se llama "02_01-mpich.sh"  prepara la
#instalación del MPICH que se encuentre en el directorio de trabajo,
#mientras que la cuarta rutina "02_02-mpich.sh" realiza la instalación
#propiamente dicha.

#Las quinta y sexta rutinas, llamadas “03_01-scalapack.sh” y
#"03_02-scalapack.sh", son las encargadas de instalar y configurar las
#librerías LAPACK, BLAS, TMG, y ScaLAPACK, la primera de ellas para una
#optimización "-O2", mientas que la segunda trabaja en una optimización
#"-O4". Ambas rutinas se cercioran que las direcciones del instalador
#concuerden con las versiones de LAPACK que se descargaron, y también se
#cercioran de que se instale ScaLAPACK, ya que se han cubierto los
#errores más comunes durante la instalación.

#Finalmente, comienzan las rutinas enfocadas a los paquetes de DFT,
#propiamente dichos, primero se instalan las rutinas relacionadas a
#SIESTA. La primera de ellas es “04_01-siesta.sh” que instala diversas
#versiones de SIESTA, cuyos archivos comprimidos se encuentren en el
#espacio de trabajo. Todas ellas se instalan en ambas optimizaciones
#(-O2 y -O4) ,y en las versiones de SIESTA-4.X.X se instala su versión
#de TranSIESTA para ambas optimizaciones.  Por otro lado, la rutina
#"04_02-siesta-utils.sh" instalará diferentes herramientas y utilerías
#para sus respectivas versiones de SIESTA y optimizaciones. Entre dichas
#rutinas se encuentra "eigfat2plot", "gnubands", "denchar", "fmpdos",
#etc. Para concluir con las rutinas relacionas con SIESTA, el módulo
#"04_03-siesta-rt.sh" instala una modificación del SIESTA, proporcionada
#por terceros, en caso de que se encuentre el archivo instalador.

#Para concluir con los paquetes de DFT, se cuenta con cuatro rutinas
#concerniendo al VASP, "05_01-vasp.sh" y "05_03-vasp.sh" instalan la
#librería de transformada rápida de Fourier, FFTW para las
#optimizaciones -O2 y -O4, respectivamente. Mientras que las rutinas
#"05_02-vasp.sh" y "05_04-vasp.sh" instalan las versiones del VASP
#disponibles, igualmente para las optimizaciones -O2 y -O4,
#respectivamente.



#####Instalación y Uso.#####

#•	Primeramente se descomprime el archivo "dft_installer.tar.gz" en el
#	directorio donde se desee realizar la instalación.

#•	Posteriormente, se copian en dicho directorio el archivo comprimido
#	con la versión del MPICH, que se desee usar. Este archivo debe tener
#	extensión tipo ".tar.gz", la cual es común para dicho paquete.

#•	Se copia el archivo comprimido con la versión del FFTW que se desee
#	usar. Igualmente con extensión ".tar.gz", que nuevamente es la común
#	para esta libreria.

#•	Opcionalmente se pueden copiar los archivos comprimidos para las
#	librerías LAPACK y ScaLAPACK con extensión "*.tgz", con la que
#	frecuentemente se encuentran. Si no se copian dichos archivos
#	comprimidos, se descargaran durante la instalación.

#•	Los archivos comprimidos de SIESTA que se deseen instalar también se
#	copiaran en el directorio de trabajo. Los archivos para las
#	versiones SIESTA-4.X.X se entregan con extensión ".tar.gz", mientras
#	que las versiones anteriores se proporcionan con extensión ".tgz".
#	Finalmente el SIESTA-RT debe copiarse con extensión ".zip", que es
#	la extensión con la que se descarga de su página oficial.

#•	Se copian los archivos comprimidos del VASP con extensiones
#	".tar.gz". la implementación actual solo instala las versiones 5.4.1
#	y 5.4.4.

#•	Para realizar la instalacion se cuenta con dos opciones:

#	o	Primeramente, se puede ejecutar la rutina primaria,
#		cerciorándose que el directorio de trabajo sea el directorio de
#		la instalación. EL comando de instalación es:

#			./dft_installer.sh

#	o	Finalmente, se pueden ir ejecutando las diferentes rutinas de
#		manera manual:

#			./01_01-variables.sh
#			./01_02-preinstalls-superuser.sh
#			./02_01-mpich.sh
#			./02_02-mpich.sh
#			./03_01-scalapack.sh
#			./03_02-scalapack.sh
#			./04_01-siesta.sh
#			./04_02-siesta-utils.sh
#			./04_03-siesta-rt.sh
#			./05_01-vasp.sh
#			./05_02-vasp.sh
#			./05_03-vasp.sh
#			./05_04-vasp.sh

#•	Una vez instalado se puede emplear la rutina dft_loader.sh para
#	cargar las variables de entorno. Igualmente, si solo se va a emplear
#	una implementación de los paquetes de DFT, puede escribirse en el
#	archivo ".bashrc" del usuario la siguiente línea de comando para
#	automatizar el proceso.

#			source [ruta de instalación]/dft_loader.sh

#	Donde [ruta de instalación] es la ruta de donde se realizo la
#	instalacion, sin poner corchetes y empleando el carácter "/" como
#	separador de directorios.



source tmp/variables.sh
source loader.sh

nombre=$(basename "$0"; )
nombre=`expr ${nombre:0:5}`

evaluacion='if test -z ${dft_'$nombre'+x}; then :; else exit 0; fi'
eval $evaluacion

#directorio y descompresión de siesta


for i in $dft_siesta_4_lista
do
	echo `expr ${i:6:(-7)}` >tmp/sinpuntos
	sinpuntos=`sed -e s/.// -e s/-// tmp/sinpuntos`
	./siesta-helper-utils.sh `expr ${i:0:(-7)}` $sinpuntos O2
	
	#if test $? -ne 0; then
	#	echo $'\n\n...\n\nHubo un error'
	#	exit 1
	#fi
	
	./siesta-helper-utils.sh `expr ${i:0:(-7)}` $sinpuntos O4
	
	#if test $? -ne 0; then
	#	echo $'\n\n...\n\nHubo un error'
	#	exit 1
	#fi
	rm tmp/sinpuntos
done

for i in $dft_siesta_3_lista
do
	echo `expr ${i:6:(-4)}` >tmp/sinpuntos
	sinpuntos=`sed -e s/.// -e s/-// tmp/sinpuntos`
	./siesta-helper-utils.sh `expr ${i:0:(-4)}` $sinpuntos O2
	
	if test $? -ne 0; then
		echo $'\n\n...\n\nHubo un error'
		exit 1
	fi
	
	./siesta-helper-utils.sh `expr ${i:0:(-4)}` $sinpuntos O4
	
	if test $? -ne 0; then
		echo $'\n\n...\n\nHubo un error'
		exit 1
	fi
	rm tmp/sinpuntos
done

echo "dft_"$nombre"=0">>$dft_instalacion/tmp/variables.sh
