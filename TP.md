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

---

## Étape 1 : Analyse et nettoyage du serveur

1. **Lister les tâches cron pour détecter des backdoors** :
   - Analysez les tâches cron de tous les utilisateurs pour identifier celles qui semblent malveillantes.

2. **Identifier et supprimer les fichiers cachés** :
   - Recherchez les fichiers cachés dans les répertoires `/tmp`, `/var/tmp` et `/home`.
   - Supprimez tout fichier suspect ou inconnu.

3. **Analyser les connexions réseau actives** :
   - Listez les connexions actives pour repérer d'éventuelles communications malveillantes.

---

## Étape 2 : Configuration avancée de LVM

1. **Créer un snapshot de sécurité pour `/mnt/secure_data`** :
   - Prenez un snapshot du volume logique `secure_data`.

2. **Tester la restauration du snapshot** :
   - Supprimez un fichier dans `/mnt/secure_data`.
   - Montez le snapshot et restaurez le fichier supprimé.

3. **Optimiser l’espace disque** :
   - Si le volume logique `secure_data` est plein, étendez-le en ajoutant de l’espace à partir du groupe de volumes existant.

---

## Étape 3 : Automatisation avec un script de sauvegarde

1. **Créer un script `secure_backup.sh`** :
   - Archive le contenu de `/mnt/secure_data` dans `/backup/secure_data_YYYYMMDD.tar.gz`.
   - Exclut les fichiers temporaires (.tmp, .log) et les fichiers cachés.

2. **Ajoutez une fonction de rotation des sauvegardes** :
   - Conservez uniquement les 7 dernières sauvegardes pour économiser de l’espace.

3. **Testez le script** :
   - Exécutez le script manuellement et vérifiez que les archives sont créées correctement.

4. **Automatisez avec une tâche cron** :
   - Planifiez le script pour qu’il s’exécute tous les jours à 3h du matin.

---

## Étape 4 : Surveillance avancée avec `auditd`

1. **Configurer auditd pour surveiller `/etc`** :
   - Ajoutez une règle avec `auditctl` pour surveiller toutes les modifications dans `/etc`.

2. **Tester la surveillance** :
   - Créez ou modifiez un fichier dans `/etc` et vérifiez que l’événement est enregistré dans les logs d’audit.

3. **Analyser les événements** :
   - Recherchez les événements associés à la règle configurée et exportez les logs filtrés dans `/var/log/audit_etc.log`.

---

## Étape 5 : Sécurisation avec Firewalld

1. **Configurer un pare-feu pour SSH et HTTP/HTTPS uniquement** :
   - Autorisez uniquement les ports nécessaires pour SSH et HTTP/HTTPS.
   - Bloquez toutes les autres connexions.

2. **Bloquer des IP suspectes** :
   - À l’aide des logs d’audit et des connexions réseau, bloquez les adresses IP malveillantes identifiées.

3. **Restreindre SSH à un sous-réseau spécifique** :
   - Limitez l’accès SSH à votre réseau local uniquement (par exemple, 192.168.x.x).

---