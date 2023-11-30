 
 dirHtdocs="/www/html"
 # <=== Inicio Configuracao de Email ===>
        echo
        read -p "Gostaria de configurar os dados de e-mail? (S/N): " resposta
        if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
            echo "* Dados de Email nao alterado."
        elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
            echo
            read -p "Informe o Protocolo (Padrao: SMTP): " protocolo
            read -p "Informe o endereco do Host SMTP (Ex: smtp.seudominio.com): " hostsmtp
            read -p "Informe a Criptografia (SSL/TLS): " criptografia
            read -p "Informe a Porta (Ex: 587): " porta
            read -p "Informe o Email (Ex: nome@seudominio.com): " email
            read -p "Informe a Senha (****): " senha

            sed -i "s/\$config\['protocol'\].*/\$config\['protocol'\] = '$protocolo';/" $dirHtdocs/application/config/email.php
            sed -i "s/\$config\['smtp_host'\].*/\$config\['smtp_host'\] = '$hostsmtp';/" $dirHtdocs/application/config/email.php
            sed -i "s/\$config\['smtp_crypto'\].*/\$config\['smtp_crypto'\] = '$criptografia';/" $dirHtdocs/application/config/email.php
            sed -i "s/\$config\['smtp_port'\].*/\$config\['smtp_port'\] = '$porta';/" $dirHtdocs/application/config/email.php
            sed -i "s/\$config\['smtp_user'\].*/\$config\['smtp_user'\] = '$email';/" $dirHtdocs/application/config/email.php
            sed -i "s/\$config\['smtp_pass'\].*/\$config\['smtp_pass'\] = '$senha';/" $dirHtdocs/application/config/email.php
            echo
            echo "* Dados de Email alterados com sucesso."
        fi
    # <=== Fim Configuracao de Email ===>
     # <=== Inicio Configuracao da Cron ===>
        echo
        read -p "Gostaria de ativar disparo automatico de Emails? (S/N): " resposta
        if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
            echo "* Nao configurado disparo automatico."
        elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
            echo "* Disparo automatico configurado com sucesso."
            (crontab -l ; echo "*/2 * * * * php $dirHtdocs/index.php email/process") | crontab -
            (crontab -l ; echo "*/5 * * * * php $dirHtdocs/index.php email/retry") | crontab -
        fi
    # <=== Fim Configuracao da Cron ===>