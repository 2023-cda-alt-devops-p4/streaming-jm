# Brief Docker et SQL

## Description
Création d'un base donnée MySQL conteneurisée avec Docker, et administration de la base de donnée en suivant les instructions décrites dans le brief [Plateforme de streaming](https://github.com/2023-cda-alt-devops-p4/streaming).
## Procédures d'installation
Modifiez le fichier .env pour y définir le mot de passe root, le login et le mot de passe de l'utilisateur principal.
Le port par défaut utilisé par MySQL est 3306, dans le cas où se port sera déjà utilisé, vous pouvez aussi le modifier dans le ficher .env pour utiliser un port libre.

```conf
# Set root password
MYSQL_ROOT_PASSWORD=5up3RS7r0N9P4ssW0rD

# Set user login and password
MYSQL_USER=streaming_admin
MYSQL_PASSWORD=5up3RS7r0N9P4ssW0rD4U5eR

# Set output port in case default MySQL port is already taken. Default port is 3306
PORT=3306
```
Le nom de la base de données est définie par défaut sur "streaming" dans le fichier Docker Compose.

A la racine du projet exécuter la commande suivante pour lancer l'image

```
docker compose up -d
```
Au premier lancement, un volume sera créé pour la persistance des données dans l'emplacement prévu par la configuration de Docker.

L'image utilisé est dérivé de l'image MySQL et est configurée pour créer les tables de la base de donnée, créer le Trigger et la procédure stockée, ainsi que de peupler la base de données avec des données de test.

Vous pouvez trouver l'image personnalisée sur ce repository [Docker Hub](https://hub.docker.com/repository/docker/eromnoj/streaming-jm/general)
## Se connecter à la base

Connectez-vous à la base de donnée en utilisant un client SQL et le port que vous avez défini dans le fichier .env .

Dans le cas d'une utilisation de MySQL en console, le protocole tcp doit être renseigné lors de la connexion

```bash
mysql -h 127.0.0.1 -P [PORT] --protocol=tcp -u [MYSQL_USER] -p

```

## Requêtes de test

Exemples de requêtes SQL pour tester la base de données.

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

## Evaluation par les pairs
# Critères d'évaluation

- [✔️] OK
- [:x:] NOT OK

*replace check markdown after evaluation*



## Livrables

Un dépôt GitHub contenant :
- [ ] L'environnement docker
- [ ] Le dictionnaire de données
- [ ] MCD
- [ ] MPD
- [ ] MLD
- [ ] Un fichier permettant de générer la bdd (incluant quelques données)
- [ ] Le jeu de requêtes dans le *README.md*

## Critères de performance

- [ ] Récupération facile de votre environnement
- [ ] Exactitude des relations entre les tables
- [ ] Trigger* mis en place
- [ ] Bonne présentation des requêtes sur le *README.md*
- [ ] Exécution des requêtes sans erreur

### Les requêtes

- [ ] Les titres et dates de sortie des films du plus récent au plus ancien
- [ ] Les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique
- [ ] La liste des acteurs/actrices principaux pour un film donné
- [ ] La liste des films pour un acteur/actrice donné
- [ ] Ajouter un film
- [ ] Ajouter un acteur/actrice
- [ ] Modifier un film
- [ ] Supprimer un acteur/actrice
- [ ] Afficher les 3 derniers acteurs/actrices ajouté(e)s

### Procédures

- [ ] Lister grâce à une procédure stockée les films d'un réalisateur donné en paramètre

### Triggers

- [ ] Garder grâce à un trigger une trace de toutes les modifications apportées à la table des utilisateurs. Ainsi, une table d'archive conservera la date de la mise à jour, l'identifiant de l'utilisateur concerné, l'ancienne valeur ainsi que la nouvelle.
- [ ] Pour chaque entrée dans la base de données, il y aura la date de création et de modification.

### Contributeur
[Jonathan Moreschi](https://github.com/Eromnoj)