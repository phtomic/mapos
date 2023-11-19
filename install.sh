#!/bin/bash

# Verifica execucao SUDO

##############################################################
## Script desenvolvido por Bruno Barreto e Leonardo Bernardi
## Versao Instalador: v1.0.20230916
## Publicado na versao 4.41.0 do MapOS
##############################################################
apt-get update
apt-get install software-properties-common -y
add-apt-repository ppa:ondrej/php
apt-get update
# <=== Inicio STEP00 ===>
    echo "**************************************************"
    echo "**************************************************"
    echo "**                                              **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**           SCRIPT AUTO INSTALADOR             **"
    echo "**    MAP-OS - SISTEMA DE ORDEM DE SERVICO      **"
    echo "**          LINUX (Debian / Ubuntu)             **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**************************************************"
    echo "**************************************************"
    echo
    # <=== Inicio SET Diretorios ===>
        comando_instalar="apt-get"
        dirDefault="/opt/InstaladorMAPOS"
        urlXampp="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.4/xampp-linux-x64-8.2.4-0-installer.run/download"
        dirXampp="/opt/lampp"
        dirHtdocs="/opt/lampp/htdocs"
    # <=== Fim SET Diretorios ===>
# <=== Fim STEP00 ===>
    echo "AVISO IMPORTANTE!"
    echo "Recomendamos que, se houver instalações anteriores do Map-OS, faça backup de todos os dados importantes antes de prosseguir com a instalacao. Ao continuar com a instalacao, você concorda que nao responsabilizara os desenvolvedores do script por quaisquer perdas de dados que possam ocorrer."
# <=== Inicio STEP01 ===>
    clear
    echo "01 BAIXANDO DEPENDENCIAS..."
    echo
    echo "01.1 Verificando pasta de instalacao"
    mkdir $dirDefault 
    echo
    echo "01.2 Verificando Ferramentas"
    $comando_instalar install -y wget unzip curl
# <=== Fim STEP01 ===>

# <=== Inicio STEP02 ===>
    echo "02 SERVIDOR WEB XAMPP..."
    echo
    echo "02.1 Verificando Instalacao XAMPP"
    if [ -d "$dirXampp" ]
    then
        echo "* XAMPP ja esta instalado."
    else
        echo "* Por favor aguarde, baixando instalador."
        wget --quiet --show-progress "$urlXampp" -O $dirDefault/xampp-installer.run
        echo
        echo "* Por favor aguarde, a instalacao pode levar ate 5 min."
        chmod +x $dirDefault/xampp-installer.run
        $dirDefault/xampp-installer.run --mode unattended
        echo
        echo "* Por favor aguarde, instalando Extensões PHP"
        $comando_instalar install -y php-curl php-gd php-zip php-xml
        $dirXampp restart
    fi
    echo
    echo "02.2 Verificando Inicializado com o sistema"
    if [ -d "/etc/init.d/start_xampp" ]
    then
        echo "* XAMPP ja inicia com o sistema"
    else
        echo "[Unit]"> /etc/systemd/system/xampp.service
        echo "Description=XAMPP Control Panel">> /etc/systemd/system/xampp.service
        echo "[Service]">> /etc/systemd/system/xampp.service
        echo "ExecStart=/opt/lampp/lampp start">> /etc/systemd/system/xampp.service
        echo "ExecStop=/opt/lampp/lampp stop">> /etc/systemd/system/xampp.service
        echo "Type=forking">> /etc/systemd/system/xampp.service
        echo "[Install]">> /etc/systemd/system/xampp.service
        echo "WantedBy=multi-user.target">> /etc/systemd/system/xampp.service
        systemctl daemon-reload
        systemctl enable xampp.service
        echo "* Configurado inicializacao automatica"
    fi
# <=== Fim STEP02 ===>

#  <=== Inicio STEP03 ===>
    echo "03 INSTALACAO SISTEMA MAP-OS..."
    echo "03.1 Verificando MapOS GitHUB"
    if [ -d "$dirHtdocs/mapos" ]
    then
        echo "* Map-OS presente no sistema."
    else
        echo "* Baixando a ultima versao do projeto."
        wget --quiet --show-progress -O $dirDefault/MapOS.zip $(curl -s https://api.github.com/repos/RamonSilva20/mapos/releases/latest | grep "zipball_url" | awk -F\" '{print $4}')
        echo
        echo "* Extraindo projeto."
        unzip -q $dirDefault/MapOS.zip -d $dirHtdocs/
        mv -i $dirHtdocs/RamonSilva20-mapos-* $dirHtdocs/mapos
        echo
        echo "* Atribuindo permissões."
        chmod 777 $dirHtdocs/mapos/updates/
        chmod 777 $dirHtdocs/mapos/index.php
        chmod 777 $dirHtdocs/mapos/application/config/config.php
        chmod 777 $dirHtdocs/mapos/application/config/database.php
        echo
        echo "* Criando banco de dados."
    fi
# <=== Fim STEP03 ===>

# <=== Inicio STEP04 ===>
apt-get install -y tzdata 
apt-get install php8.1
    echo "04 COMPLEMENTO COMPOSER..."
    echo
    echo "04.1 Executando instalador COMPOSER"
    if command -v composer &> /dev/null
    then
        echo "* Composer ja esta instalado."
    else
        echo "* Instalando Composer"
        apt install composer -y
    fi
    echo
    echo "04.2 Verificando complemento"
    if [ -f "$dirHtdocs/mapos/application/vendor" ]
    then
        echo "* Complementos ja instalados."
    else
        echo "* Instalando complementos."
        cd $dirHtdocs/mapos
        composer install --no-dev -n
    fi
# <=== Fim STEP04 ===>

# Mensagem de status
echo  "************************************************"
echo  "****    MAPOS CONFIGURADO COM SUCESSO       ****"
echo  "************************************************"
sleep 5
rm -rf $dirDefault
