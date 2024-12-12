### 1. Configurer ssmtp

Assure-toi que `ssmtp` est installé et configuré correctement.

1. Installe `ssmtp`:
   ```bash
   sudo dnf install ssmtp
   ```

2. Configure `ssmtp` en éditant le fichier `/etc/ssmtp/ssmtp.conf` :
   ```ini
   root=sire@gmail.com
   mailhub=smtp.gmail.com:587
   rewriteDomain=gmail.com
   AuthUser=jepense@gmail.com
   AuthPass=xxx
   FromLineOverride=YES
   UseSTARTTLS=YES
   ```

### 2. Écrire le script Bash

Crée un script Bash qui envoie un e-mail avec un message "Hello" pour tester l'envoi d'email.

1. Crée le script `send_test_email.sh` :
   ```bash
   #!/bin/bash

   # Destinataire de l'email
   destinataire="sireh@gmail.com"

   # Contenu de l'email
   email_content="To: $destinataire\nFrom: jepense@gmail.com\nSubject: Test Email\n\nHello"

   # Envoyer l'email
   echo -e $email_content | /usr/sbin/ssmtp $destinataire
   ```

2. Rends le script exécutable et exécute-le pour tester :
   ```bash
   chmod +x send_test_email.sh
   ./send_test_email.sh
   ```

### 3. Ajout des informations sur le système

Une fois que l'envoi du message "Hello" fonctionne, nous pouvons ajouter les informations sur le système.

1. Crée ou modifie le script `send_system_status.sh` :
   ```bash
   #!/bin/bash

   # Récupérer les informations du système
   cpu_info=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
   ram_info=$(free -m | awk 'NR==2{printf "Usage de la RAM : %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
   disk_info=$(df -h | awk '$NF=="/"{printf "Usage du disque : %d/%dGB (%s)\n", $3,$2,$5}')

   # Créer le fichier HTML avec du style et un tableau
   html_file="/tmp/system_status.html"
   echo "<html>
   <head>
     <style>
       body { font-family: Arial, sans-serif; }
       h1 { color: #333333; }
       table { width: 50%; margin: auto; border-collapse: collapse; }
       th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
       th { background-color: #f2f2f2; }
     </style>
   </head>
   <body>
     <h1 style=\"text-align:center;\">État du Système</h1>
     <table>
       <tr>
         <th>Composant</th>
         <th>État</th>
       </tr>
       <tr>
         <td>CPU</td>
         <td>$cpu_info</td>
       </tr>
       <tr>
         <td>RAM</td>
         <td>$ram_info</td>
       </tr>
       <tr>
         <td>Disque</td>
         <td>$disk_info</td>
       </tr>
     </table>
   </body>
   </html>" > $html_file

   # Envoyer l'email
   destinataire="sireh@gmail.com"
   email_content="To: $destinataire\nFrom: jepense@gmail.com\nSubject: État du Système\nContent-Type: text/html\n\n$(cat $html_file)"

   echo -e $email_content | /usr/sbin/ssmtp $destinataire
   ```

2. Rends le script exécutable et exécute-le :
   ```bash
   chmod +x send_system_status.sh
   ./send_system_status.sh
   ```

### Résumé

1. Configure `ssmtp` avec les détails de ton compte Gmail.
2. Crée un script Bash pour tester l'envoi d'un email simple.
3. Modifie le script pour inclure les informations du système et les envoyer sous forme de tableau HTML.

Voilà ! Ce mini tutoriel devrait t'aider à envoyer un email avec les informations sur l'état du système. Si tu as d'autres questions ou besoin de précisions, fais-le moi savoir.