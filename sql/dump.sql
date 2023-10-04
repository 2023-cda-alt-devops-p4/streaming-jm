-- Move current user to the streaming db
USE streaming;

-- Creation of the tables
CREATE TABLE
    IF NOT EXISTS actor (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        last_name VARCHAR(150) NOT NULL,
        first_name VARCHAR(150) NOT NULL,
        birthday DATE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    IF NOT EXISTS director (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        last_name VARCHAR(150) NOT NULL,
        first_name VARCHAR(150) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    IF NOT EXISTS movie (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(150) NOT NULL,
        duration INT NOT NULL,
        release_date DATE,
        id_director INT NOT NULL,,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (id_director) REFERENCES director(id) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS role (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        role_name VARCHAR(150) NOT NULL,
        id_actor INT NOT NULL,
        id_movie INT NOT NULL,,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (id_actor) REFERENCES actor(id) ON DELETE CASCADE,
        FOREIGN KEY (id_movie) REFERENCES movie(id) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS user (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        last_name VARCHAR(150) NOT NULL,
        first_name VARCHAR(150) NOT NULL,
        email VARCHAR(150) NOT NULL,
        password VARCHAR(150) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    IF NOT EXISTS user_movie (
        id_user INT NOT NULL,
        id_movie INT NOT NULL,,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (id_user) REFERENCES user(id),
        FOREIGN KEY (id_movie) REFERENCES movie(id),
        PRIMARY KEY (id_user, id_movie),
        UNIQUE (id_user, id_movie)
    );

CREATE TABLE
    IF NOT EXISTS admin (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        id_user INT NOT NULL,,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (id_user) REFERENCES user(id) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS archive (
        id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        id_user INT NOT NULL,
        field ENUM(
            'last_name',
            'first_name',
            'email'
        ),
        old_value VARCHAR(150),
        new_value VARCHAR(150),
        update_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_user) REFERENCES user(id) ON DELETE CASCADE
    );


-- Procedure to retrieve the movies from a specific director
DELIMITER //

CREATE PROCEDURE moviefromdirector(IN directorname VARCHAR(150))
  BEGIN
    SELECT title 
    FROM movie 
    INNER JOIN director ON movie.id_director = director.id 
    WHERE director.last_name = directorname;
  END //


DELIMITER ;

-- Trigger to populate the archive table when changes occur to the user table
DELIMITER //

CREATE TRIGGER USER_ARCHIVE_TRIGGER 
BEFORE UPDATE ON user 
FOR EACH ROW 
BEGIN
	IF OLD.last_name != NEW.last_name THEN
	INSERT INTO
	    archive (
	        id_user,
	        field,
	        old_value,
	        new_value
	    )
	VALUES (
	        NEW.id,
	        'last_name',
	        OLD.last_name,
	        NEW.last_name
	    );
	END IF;
	IF OLD.first_name != NEW.first_name THEN
	INSERT INTO
	    archive (
	        id_user,
	        field,
	        old_value,
	        new_value
	    )
	VALUES (
	        NEW.id,
	        'first_name',
	        OLD.first_name,
	        NEW.first_name
	    );
	END IF;
	IF OLD.email != NEW.email THEN
	INSERT INTO
	    archive (
	        id_user,
	        field,
	        old_value,
	        new_value
	    )
	VALUES (
	        NEW.id,
	        'email',
	        OLD.email,
	        NEW.email
	    );
	END IF;

	END;


//

DELIMITER ;


-- Populate database 
INSERT INTO director (last_name, first_name)
VALUES
    ('Lucas', 'Georges'),
    ('Allen', 'Woody'),
    ('Godard', 'Jean-Luc');

INSERT INTO actor (last_name, first_name, birthday)
VALUES
    ('Ford', 'Harrison', '1942-07-13'),
    ('Fisher', 'Carrie', '1956-11-21'),
    ('Wilson','Owen','1968-11-18'),
    ('Seberg','Jean','1938-11-13'),
    ('McAdams', 'Rachel', '1978-11-07'),
    ('Belmondo', 'Jean-Paul', '1933-04-09');

INSERT INTO movie (title, duration, release_date, id_director)
VALUES
    ('Star Wars', 120, '1977-10-19', 1),
    ('Minuit à Paris', 94, '2011-05-11', 2),
    ('A bout de souffle', 90, '1960-03-16', 3);

INSERT INTO role (role_name, id_actor, id_movie)
VALUES
    ('Han Solo', 1, 1),
    ('Princesse Leia', 2, 1),
    ('Gil', 3, 2),
    ('Inez', 4, 2),
    ('Patricia Franchini', 5, 3),
    ('Michel Poiccard - Laslo Kovacs', 6, 3);

INSERT INTO user (last_name, first_name, email, password)
VALUES
    ('Marcq', 'Cyril', 'mcyril@example.com', 'password123'),
    ('Herbez', 'Nicolas', 'nicoherbz@example.com', 'securepassword'),
    ('Lavisse', 'JB', 'levillageducode@example.com', 'letmein');

INSERT INTO user_movie (id_user, id_movie)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 3);

INSERT INTO admin (id_user)
VALUES
    (1);