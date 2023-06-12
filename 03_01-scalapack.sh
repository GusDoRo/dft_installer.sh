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

nombre=$(basename "$0"; )
nombre=`expr ${nombre:0:5}`

evaluacion='if test -z ${dft_'$nombre'+x}; then :; else exit 0; fi'
eval $evaluacion

#alias necesario en algunos casos para compilar blas
#alias f77="gfortran"

#directorio y descompresión de scalapack
#cp scalapack_installer.tgz ./build/
cd build

tar -xzvf scalapack_installer.tgz

cd scalapack_installer

if test -d "build"; then
	if test -d "build/download"; then
		:
	else
		mkdir build/download
	fi
else
	mkdir build
	mkdir build/download
fi

cd build
if test -f "download/lapack.tgz"; then
	:
else
	if test -f "../../../lapack-*.tgz"; then
		tempo= `ls ../../../lapack-*.tgz`
		cp $tempo download/lapack.tgz
	#else
	#	wget "http://www.netlib.org/lapack/lapack.tgz"
	#	mv lapack.tgz download/
	fi
	
	#tar -xvf download/lapack.tgz
fi

if test -f "download/scalapack.tgz"; then
	:
else
	if test -f "../../../scalapack-*.tgz"; then
		tempo= `ls ../../../scalapack-*.tgz`
		cp $tempo download/scalapack.tgz
	#else
	#	wget "http://www.netlib.org/scalapack/scalapack.tgz"
	#	mv scalapack.tgz download/
	fi
	
	#tar -xvf download/scalapack.tgz
fi
cd ..


#instalación de scalapack

chmod a+x setup.py

mkdir opt-O2

./setup.py --prefix=./opt-O2 --mpibindir=$dft_instalacion/build/mpich-$dft_mpich_version/install/bin --mpiincdir=$dft_instalacion/build/mpich-$dft_mpich_version/install/include --ccflags="-O2 -fallow-argument-mismatch" --fcflags="-O2 -fallow-argument-mismatch" --noopt="-fallow-argument-mismatch" --downall

#permite ejecutarse dos veces par actualizar algunos nombres erroneos en los scripts
if test $? -ne 0; then
	#mecanismo de robustez
	#busca la version de lapack en los scripts
	lapack_version=`awk '($0 ~ /lapack-/ && $1 != "#") { print $1}' script/lapack.py`
	lapack_version=${lapack_version:(-9):(-3)}
	
	#busca la version de lapack descargada
	lapack_downloaded=`ls -d build/lapack-*`
	lapack_downloaded=${lapack_downloaded:(-6)}
	
	#sustituye la descargada en la actual de los scripts en caso de ser distintas.
	if test $lapack_version != $lapack_downloaded; then
		sed -i 's/'$lapack_version'/'$lapack_downloaded'/g' script/lapack.pyc
		sed -i 's/'$lapack_version'/'$lapack_downloaded'/g' script/lapack.py
	fi
	
	sed -i "s!shutil.copy('libreflapack.a',os.path.join(self.prefix,'lib/libreflapack.a'))!shutil.copy('"$dft_instalacion"/build/scalapack_installer/build/lapack-$lapack_downloaded/SRC/libreflapack.a',os.path.join(self.prefix,'lib/libreflapack.a'))!g" script/lapack.py
	sed -i "s!shutil.copy('libtmg.a',os.path.join(self.prefix,'lib/libtmg.a'))!shutil.copy('"$dft_instalacion"/build/scalapack_installer/build/lapack-$lapack_downloaded/TESTING/MATGEN/libtmg.a',os.path.join(self.prefix,'lib/libtmg.a'))!g" script/lapack.py
	#sed -i "s/import os/import os, glob/g" script/blas.py
	#sed -i "s/os.chdir(os.path.join(os.getcwd(),'BLAS'))/os.chdir(os.path.join(os.getcwd(),os.path.basename(glob.glob('.\/BLAS\*')[0])))/g" script/blas.py
	
	#sed -i "s/import os/import os, glob/g" script/lapack.py
	#sed -i "s/os.chdir(os.path.join(os.getcwd(),'$lapack_downloaded'))/os.chdir(os.path.join(os.getcwd(),os.path.basename(glob.glob('.\/lapack-\*')[0])))/g" script/lapack.py
	#sed -i "s/os.path.join(os.getcwd(),'$lapack_downloaded\/INSTALL')/os.path.join(os.getcwd(),os.path.basename(glob.glob('.\/lapack-\*')[0]),'INSTALL'))/g" script/lapack.py
	
	#hechizo para cambiar todo lo que cumpla con BLAS* a BLAS
	#echo 'mv' >a
	#ls -d build/BLAS* >>a
	#echo 'build/BLAS' >>a
	#cat a | tr '\n' ' ' | bash

	#sed -i 's!TMGLIB       = libtmg.a!TMGLIB       = /home/dft/build/scalapack_installer/opt-O2/lib/libtmg.a!g' $dft_instalacion/build/scalapack_installer/build/lapack-$lapack_downloaded/make.inc

	./setup.py --prefix=./opt-O2 --mpibindir=$dft_instalacion/build/mpich-$dft_mpich_version/install/bin --mpiincdir=$dft_instalacion/build/mpich-$dft_mpich_version/install/include --ccflags="-O2 -fallow-argument-mismatch" --fcflags="-O2 -fallow-argument-mismatch" --noopt="-fallow-argument-mismatch" --downall
	if test $? -ne 0; then
		echo $'\n\n...\n\nHubo un error'
		exit 1
	fi

	if test -f $dft_instalacion"/build/scalapack_installer/opt-O2/lib/libscalapack.a"; then
		:
	else
		./setup.py --prefix=./opt-O2 --mpibindir=$dft_instalacion/build/mpich-$dft_mpich_version/install/bin --mpiincdir=$dft_instalacion/build/mpich-$dft_mpich_version/install/include --ccflags="-O2 -fallow-argument-mismatch" --fcflags="-O2 -fallow-argument-mismatch" --noopt="-fallow-argument-mismatch" --downall --notesting
		if test $? -ne 0; then
			echo $'\n\n...\n\nHubo un error'
			exit 1
		fi
	fi
fi
#./setup.py --prefix=./opt-O2 --mpibindir=/home/SIESTA/build/mpich-3.2.1/install/bin --mpiincdir=/home/SIESTA/build/mpich-3.2.1/install/include --ccflags="-O2" --fcflags="-O2" --downblas

echo "dft_"$nombre"=0">>$dft_instalacion/tmp/variables.sh
