-- les titres et dates de sortie des films du plus récent au plus ancien
SELECT title, release_date 
FROM movie 
ORDER BY release_date DESC;

-- les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique
SELECT
    last_name,
    first_name,
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM actor
ORDER BY last_name ASC;

-- la liste des acteurs/actrices principaux pour un film donné
SELECT
    actor.last_name,
    actor.first_name,
    movie.title
FROM actor
    LEFT JOIN role ON actor.id = role.id_actor
    LEFT JOIN movie ON movie.id = role.id_movie
WHERE
    movie.title LIKE '%minuit%';

-- la liste des films pour un acteur/actrice donné
SELECT movie.title
FROM movie
    LEFT JOIN role ON movie.id = role.id_movie
    LEFT JOIN actor ON actor.id = role.id_actor
WHERE
    actor.last_name LIKE '%Ford%'
    OR actor.first_name LIKE '%Ford%';

-- ajouter un film
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

-- ajouter un acteur/actrice
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

-- modifier un film
UPDATE movie
SET title = 'Pierrot le fou',
    duration = 105,
    release_date = '1965-11-05',
    id_director = (SELECT id
                  FROM director
                  WHERE last_name = "Godard")
WHERE id = 4;

-- supprimer un acteur/actrice
DELETE FROM actor
WHERE id = 4;

-- afficher les 3 derniers acteurs/actrices ajouté(e)s
SELECT *, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age 
FROM actor 
ORDER BY id DESC 
LIMIT 3;