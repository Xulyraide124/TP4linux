# TP Avancé : "Mission Ultime : Sauvegarde et Sécurisation"

## Contexte
Votre serveur critique est opérationnel, mais de nombreuses failles subsistent. Votre objectif est d'identifier les faiblesses, de sécuriser les données et d’automatiser les surveillances pour garantir un fonctionnement sûr à long terme.

---

## Objectifs
1. Surveiller les répertoires critiques pour détecter des modifications suspectes.
2. Identifier et éliminer des tâches malveillantes laissées par des attaquants.
3. Réorganiser les données pour optimiser l’espace disque avec LVM.
4. Automatiser les sauvegardes et surveillances avec des scripts robustes.
5. Configurer un pare-feu pour protéger les services actifs.

# Étape 1 : Analyse et nettoyage du serveur
### 1.1 Lister les tâches cron pour détecter des backdoors :
Examinez les tâches cron de tous les utilisateurs pour repérer les activités suspectes :

```powershell

for user in $(cut -f1 -d: /etc/passwd); do
    echo "Tâches cron pour $user :"
    crontab -u $user -l 2>/dev/null || echo "Pas de tâches."
done

```
### 1.2 Identifier et supprimer les fichiers cachés :
```powershell
find /tmp /var/tmp /home -type f -name ".*" -exec ls -l {} \;
```
vérifiez chaque fichier trouvé par exemple : /tmp/.hidden_file et supprimez ceux qui semblent malveillants:

```powershell
rm -f /tmp/.hidden_file /tmp/.hidden_script
```

# Étape 2 : Configuration avancée de LVM

### 2.1 créer un snapshot de sécurité :

```powershell
sudo lvcreate -L 100M -s -n secure_snapshot /dev/vg_secure/secure_data


```

### 2.2 tester la restauration du snapshot :

``` powershell
rm /mnt/secure_data/sensitive1.txt
```


``` powershell
sudo mount /dev/vg_secure/secure_snapshot /mnt/secure_snapshot
sudo cp /mnt/secure_snapshot/sensitive1.txt /mnt/secure_data/
sudo umount /mnt/secure_snapshot
```

### 2.3 Optimiser l’espace disque :


``` powershell

sudo lvextend -L +500M /dev/vg_secure/secure_data
sudo resize2fs /dev/vg_secure/secure_data

```

# Étape 3 : Automatisation avec un script de sauvegarde





### création du scripte secure_backup.sh
``` powershell

#!/bin/bash
# Archive les données sensibles
backup_dir="/backup"
mkdir -p $backup_dir
tar --exclude="*.tmp" --exclude="*.log" --exclude=".*" -czf "$backup_dir/secure_data_$(date +%Y%m%d).tar.gz" /mnt/secure_data

find $backup_dir -type f -name "secure_data_*.tar.gz" -mtime +7 -exec rm {} \;

```






``` powershell
chmod +x secure_backup.sh
```




### 3.2 Ajouter une tâche cron :


Ajoue de la  tâche cron pour exécuter le script à 3h du matin :

``` powershell
echo "0 3 * * * /path/to/secure_backup.sh" | sudo crontab -
```

# Étape 4 : Surveillance avancée avec auditd

### 4.1 Configuration auditd :

je vien de rajouté une régle pour survellié /etc
``` powershell
sudo auditctl -w /etc/ -p wa -k etc_changes
```

### 4.2 Tester la surveillance :



``` powershell
sudo touch /etc/test_file
```



on consulte les log pour chek la sécurité 
``` powershell
sudo ausearch -k etc_changes
```




### 4.3 Exporter les logs filtrés :


c'est partie pour filtré  et métre dans un fichier
``` powershell
sudo ausearch -k etc_changes > /var/log/audit_etc.log

```



# Étape 5 : Sécurisation avec Firewalld


### 5.1 Configurer les ports SSH et HTTP/HTTPS uniquement :

on autrorsie les port de premirre nécéisé comme les produit quanc c'été le covide

``` powershell
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

```

### 5.2 Bloquer les IP suspectes :

on devient aussi toxique que mon ex quand je lui est bonjour sur le mauvais ton alor que j'étai pas révallié donc on bloque tout et on regarde tout
``` powershell
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="203.0.113.42" reject'
sudo firewall-cmd --reload

```


### 5.3 Restreindre SSH à un sous-réseau spécifique :
et cette foit si on empaiche notre pc d'allez voir allieur donc on stop le ssh a notre machine
``` powershell
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.0.0/24" service name="ssh" accept'
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --reload
```


