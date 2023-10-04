# Brief Docker et SQL

## Description
Création d'un base donnée MySQL conteneurisée avec Docker, et administration de la base de donnée en suivant les instructions décrites dans le brief [Plateforme de streaming](https://github.com/2023-cda-alt-devops-p4/streaming).
## Procédures d'installation
Modifier le fichier .env pour y définir le mot de passe root, le login et le mot de passe de l'utilisateur principal.

Le nom de la base de données est définie par défaut sur "streaming" dans le fichier Docker Compose.

A la racine du projet exécuter la commande suivante pour lancer l'image

```
docker compose up -d
```
Au premier lancement, un volume sera créé pour la persistance des données dans l'emplacement prévu par la configuration de Docker.

## Exécuter les scripts SQL

#### Dans le répertoire du projet
Afin d'exécuter les scripts, récupérer d'abord l'ID du container docker
```
docker ps
```
Placer vous à la racine du projet et copier le script /sql/sump.sql à la racine de l'image Docker
```
docker cp ./sql/dump.sql [cotainer-id]:/dump.sql
```

Se connecter à la console de l'image
```
docker exec -it [container-id] /bin/bash
```

Se connecter à la console MySQL à l'aide de l'utilisateur **root** (nécessaire pour créer le trigger) et du mot de passe définit dans les variables d'environnement

```bash
mysql -u root -p

[Valider en appuyant sur la touche entrée et entrer le mot de passe]
```

#### Dans la console de MySQL

Créer et peupler la base de données en utilisant la commande source
```sql
source dump.sql
```

Se déconnecter de la console mysql
```sql
exit
```

#### Se déconnecter du container
```bash
exit
```

## Requêtes de test

Exemples de requêtes SQL pour tester la base de données.

Pour les utiliser, se connecter à la base de donnée en utilisant le login et le mot de passe créé dans le ficher de variables d'environnement :

```bash
mysql -u [username] -p

[Valider en appuyant sur la touche entrée et entrer le mot de passe]
```
- Tester la procédure stockée
```sql
CALL moviefromdirector('Godard');
```
- les titres et dates de sortie des films du plus récent au plus ancien
```sql
SELECT title, release_date 
FROM movie 
ORDER BY release_date DESC;
```

- les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique
```sql

SELECT
    last_name,
    first_name,
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM actor
ORDER BY last_name ASC;
```

- la liste des acteurs/actrices principaux pour un film donné
```sql

SELECT
    actor.last_name,
    actor.first_name,
    movie.title
FROM actor
    LEFT JOIN role ON actor.id = role.id_actor
    LEFT JOIN movie ON movie.id = role.id_movie
WHERE
    movie.title LIKE '%minuit%';
```
- la liste des films pour un acteur/actrice donné
```sql
SELECT movie.title
FROM movie
    LEFT JOIN role ON movie.id = role.id_movie
    LEFT JOIN actor ON actor.id = role.id_actor
WHERE
    actor.last_name LIKE '%Ford%'
    OR actor.first_name LIKE '%Ford%';
```

- ajouter un film
```sql

INSERT INTO
    movie (
        title,
        duration,
        release_date,
        id_director
    )
VALUES
(
        'titre',
        90,
        '1994-12-15',
        (SELECT id
        FROM director
        WHERE last_name = "Allen")
    );
```

- ajouter un acteur/actrice
```sql

INSERT INTO 
    actor (
        last_name,
        first_name,
        birthday
    )
VALUES
(
        'Depardieu',
        'Gérard',
        '1948-12-27'
);
```

- modifier un film
```sql

UPDATE movie
SET title = 'Pierrot le fou',
    duration = 105,
    release_date = '1965-11-05',
    id_director = (SELECT id
                  FROM director
                  WHERE last_name = "Godard")
WHERE id = 4;
```

- supprimer un acteur/actrice
```sql
DELETE FROM actor
WHERE id = 4;
```

- afficher les 3 derniers acteurs/actrices ajouté(e)s
```sql
SELECT *, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age 
FROM actor 
ORDER BY id DESC 
LIMIT 3;
```

### Contributeur
[Jonathan Moreschi](https://github.com/Eromnoj)