# streaming-jm
Brief Docker et SQL

## Procédures d'installation
Modifier le fichier .env pour y définir le mot de passe root, le login et le mot de passe de l'utilisateur principal.

Le nom de la base de données est définie par défaut sur "streaming" dans le fichier Docker Compose.

A la racine du projet exécuter la commande suivante pour lancer l'image

```
docker compose up -d
```
Au premier lancement, un volume sera créé pour la persistance des données.

## Exécuter les scripts SQL
Afin d'exécuter les scripts, récupérer d'abord l'ID du container docker
```
docker ps
```
Copier le script sql à la racine
```
docker cp ./sql/dump.sql [cotainer-id]:/dump.sql
```

Se connecter à la console de l'image
```
docker exec -it [container-id] /bin/bash
```

Se connecter à l'aide de l'utilisateur **root** (nécessaire pour créer le trigger) et du mot de passe définit dans les variables d'environnement

```bash
mysql -u [username] -p

[Valider et entrer le mot de passe]
```

Dans la console de MySQL

Créer et peupler la base de données en utilisant la commande source
```sql
source dump.sql
```

Se déconnecter de la console mysql
```sql
exit
```

Se déconnecter du container
```bash
exit
```

