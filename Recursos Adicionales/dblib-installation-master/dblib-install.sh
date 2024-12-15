#!/bin/bash
#Sistema que instala e configura o binário do DBLIB para conexão com o SQLSERVER
#Autor: João Pedro de Andrade
#TraduccionES: Alexis Pérez

# Verificando o UID do usuário que executou o script para apenas ser executado por "ROOT"
if [ $UID -ne 0 ]; then

    # Se for diferente de 0, imprime mensagem de erro.
    echo "Se requiere privilegios root."

    # Finaliando o script
    exit 1
fi

echo " _____    ______   _        _____  ______  
(____ \  (____  \ | |      (_____)(____  \ 
 _   \ \  ____)  )| |         _    ____)  )
| |   | ||  __  ( | |        | |  |  __  ( 
| |__/ / | |__)  )| |_____  _| |_ | |__)  )
|_____/  |______/ |_______)(_____)|______/ v0.1"

#Confirmação do usuário para execução do script.
echo "Desea continuar con la instalación del drive DBLIB [Yn]"
read RESPONSE

#Interropendo Script em caso de negação
test "$RESPONSE" = "n" && exit

echo "Preparando directorio para la descarga del archivo requerido..."

#Criando diretório para download do binário.
PATH_DOWNLOAD=$(pwd)
echo "#############################################################"
echo "Directorio para descarga del binario fue creado en: $PATH_DOWNLOAD "
echo "#############################################################"

#Realizando Download do 'freetds-0.95.95'
wget https://www.freetds.org/files/stable/freetds-0.95.95.tar.gz

#Decompactando binário baixado
echo "Descomprimiendo el archivo .zip del binario descargado en $PATH_DOWNLOAD"
tar -zxf freetds-0.95.95.tar.gz

#Instalação unixodbc-dev
sudo apt-get install unixodbc unixodbc-dev gcc nano wget make

#Aplicando permissão recursiva no diretório baixado
chmod -R 777 freetds-0.95.95/
echo "Permisos aplicados correctamente"

#Entrando no diretório baixado
cd freetds-0.95.95/

#Instalano build-essential
sudo apt-get install build-essential

#Executando configuração do binário para DBLIB utilizando FreeTds
echo "Ejecutando configuración del binario para la instalación de Freetds"
sudo ./configure --with-tdsver=7.4 --with-unixodbc=/usr --disable-libiconv --disable-static --disable-threadsafe --enable-msdblib --disable-sspi --with-gnu-ld --enable-sybase-compat && make && make install
echo "#############################################################"
echo "Fin de la instalación y configuración del binario."

#Visualilzação do binário compilado para o DBLIB juntamente com o caminho do arquivo freetds.conf
tsql -C

