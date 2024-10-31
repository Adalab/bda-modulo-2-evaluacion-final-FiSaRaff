USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
EN: Select all film titles without duplicates. */ 

-- Accessig EER Diagram to look at the structure of the database.

SELECT DISTINCT(title)
	FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
EN: Display the names of all movies with a rating of 'PG-13'*/ 

SELECT title
	FROM film
    WHERE rating = 'PG-13';

/*3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
EN: Find the title and description of all films that contain the word 'amazing' in their description */

SELECT title, description
	FROM film
	WHERE description LIKE '%amazing%';
    
/*4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
EN: Find the title of all films with a duration greater than 120 minutes. */

SELECT title
	FROM film
	WHERE length > 120;

/*5. Recupera los nombres de todos los actores.
EN: Retrieve the names of all actors */ 

SELECT first_name
	FROM actor;

/*6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
EN: Find the first name and last name of actors who have 'Gibson' in their last name. */ 

SELECT first_name, last_name
	FROM actor
	WHERE last_name LIKE 'Gibson';

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
EN: Find the names of actors who have an actor_id between 10 and 20 */

SELECT first_name
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;
    
/*8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
EN: Find the titles of films in the film table that are neither 'R' nor 'PG-13' in terms of their rating.*/ 

SELECT title
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');

/*9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con
el recuento.
EN: Find the total number of films in each rating from the film table and display the rating along with the count. */ 

SELECT rating, COUNT(title) AS 'number of films'
	FROM film
    GROUP BY rating;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas.
EN: Find the total number of films rented by each customer and display the customer ID, first name, last name, and the number of rented films. */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(rental_id) AS 'number of rented films'
	FROM customer as c
    INNER JOIN rental as r
    USING (customer_id)
    GROUP BY c.customer_id;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres.
EN: Find the total number of films rented by category and display the category name along with the rental count. */

SELECT c.name, COUNT(r.rental_id) AS 'number of rentals'
	FROM film_category AS fc
    INNER JOIN category AS c
    USING (category_id)
	INNER JOIN film AS f
    USING (film_id)
    INNER JOIN inventory AS i
    USING (film_id)
    INNER JOIN rental AS r
    USING (inventory_id)
    GROUP BY c.name;

-- Ensuring the result is acurate

WITH rentals AS (SELECT c.name, COUNT(r.rental_id) AS number_of_rentals
						FROM film_category AS fc
						INNER JOIN category AS c
						USING (category_id)
						INNER JOIN film AS f
						USING (film_id)
						INNER JOIN inventory AS i
						USING (film_id)
						INNER JOIN rental AS r
						USING (inventory_id)
						GROUP BY c.name)
                        
SELECT SUM(number_of_rentals)
	FROM rentals; -- 16,044

SELECT COUNT(rental_id)
	FROM rental; -- 16,044 = correct

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
clasificación junto con el promedio de duración. 
EN: Find the average duration of films for each rating in the film table and display the rating along with the average duration */

SELECT rating, AVG(length) AS average_length
	FROM film
    GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". 
EN: Find the first name and last name of the actors who appear in the film titled 'Indian Love */

SELECT a.first_name, a.last_name
	FROM film AS f
	INNER JOIN film_actor AS fa
	USING (film_id)
    INNER JOIN actor AS a
    USING (actor_id)
    WHERE title IN ('Indian love');

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
EN: Display the titles of all films  that contain the word 'dog' or 'cat' in their description */

-- comment: it asks for words 'dog' and 'cat'. If it asked contains then you would use '%dog%' and '%cat%'

SELECT title
	FROM film
	WHERE title LIKE 'dog' OR title LIKE 'cat';

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. 
EN: Is there any actor or actress who does not appear in any films in the film_actor table? */

-- Comment: there aren't any actors or actresses who don't appear in any films as per the current table. Query set up to show them if the table changes in the future. 

SELECT CONCAT(a.first_name, " ", a.last_name) AS actor_in_no_films
	FROM actor AS a
    LEFT JOIN film_actor AS fa
    USING (actor_id)
    WHERE fa.film_id LIKE 'NULL';

/*16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */

SELECT title
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

-- Comment: checking that query returns correct results.

SELECT release_year
	FROM film;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". 
EN: Find the titles of all films in category 'Family */

SELECT f.title
	FROM film AS f
    INNER JOIN film_category AS fc
    USING (film_id)
    INNER JOIN category as c
    USING (category_id)
    WHERE c.name IN ('Family');
    
-- Comment: checking that query returns correct results.

SELECT c.name, COUNT(c.name)
	FROM film AS f
    INNER JOIN film_category AS fc
    USING (film_id)
    INNER JOIN category as c
    USING (category_id)
    GROUP BY c.name
    HAVING c.name IN ('Family');

/*18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. 
EN: Display the first name and last name of the actors who appear in more than 10 movies.*/

SELECT a.first_name, a.last_name  
	FROM actor AS a
    LEFT JOIN film_actor AS fa
	USING (actor_id)
    GROUP BY actor_id
    HAVING COUNT(actor_id) > 10;

-- Comment: checking that query returns correct results.

SELECT COUNT(actor_id)
	FROM actor;

SELECT a.first_name, a.last_name  
	FROM actor AS a
    LEFT JOIN film_actor AS fa
	USING (actor_id)
    GROUP BY actor_id
    HAVING COUNT(actor_id) < 10;

/*19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. 
EN: Find the title of all films that are rated 'R' and have a duration longer than 2 hours in the film table. */

SELECT title, length, rating
	FROM film
	WHERE rating IN ('R') AND length > 120;

/*20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración. 
EN: Find the film categories with an average duration of over 120 minutes, and display the category name along with 
the average duration.*/

SELECT c.name, AVG(f.length) AS length_average
	FROM film_category AS fc
    INNER JOIN category AS c
    USING (category_id)
    INNER JOIN film AS f
    USING (film_id)
    GROUP BY c.name
    HAVING AVG(f.length) > 120;

/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado. 
EN: Find the actors who have appeared in at least 5 films, and display the actor's name along with the number of 
films they have acted in. */

SELECT a.first_name, COUNT(fa.actor_id) AS number_films
	FROM film_actor as fa
    INNER JOIN actor AS a
    USING (actor_id)
    GROUP BY fa.actor_id
    HAVING COUNT(film_id) > 5;
    
/*22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. 
EN: Find the title of all films that were rented for more than 5 days. Use a subquery to find the rental_ids with a duration 
longer than 5 days, and then select the corresponding movies. */

SELECT title
	FROM (SELECT r.rental_id, f.title, rental_duration
			FROM film AS f
			INNER JOIN inventory AS i
			USING (film_id)
			INNER JOIN rental AS r
			USING (inventory_id)
			WHERE f.rental_duration > 5) AS rental_id_table
	GROUP BY title;
    
/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores.
EN: Find the first and last names of actors who have not acted in 'Horror' films. Use a subquery 
to find the actors who have appeared in 'Horror' movies and then exclude them from the list of actors */ 

SELECT a.first_name, a.last_name, c.name
	FROM film_actor AS fa
    INNER JOIN film as f
    USING (film_id)
    INNER JOIN film_category AS fc
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
    INNER JOIN actor AS a
    USING (actor_id)
    WHERE a.actor_id NOT IN (SELECT a.actor_id
							FROM film_actor AS fa
							INNER JOIN film as f
							USING (film_id)
							INNER JOIN film_category AS fc
							USING (film_id)
							INNER JOIN category AS c
							USING (category_id)
							INNER JOIN actor AS a
							USING (actor_id)
							WHERE c.name = 'Horror');

/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
tabla film. 
EN:Find the titles of films that are comedies and have a duration greater than 180 minutes in the film table.*/

SELECT f.title 
	FROM film as f
	INNER JOIN film_category AS fc
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
    WHERE c.name IN ('comedy') AND length > 180;

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. 
EN: Find all actors who have acted together in at least one movie. The query should display the first and last names of the 
actors and the number of movies they have acted in together. */

-- THIS IS WHERE I LEFT IT 31.10.24

SELECT first_name, last_name, COUNT(fa1.film_id)
	FROM film_actor AS fa1
    INNER JOIN actor AS a1
    WHERE fa1.film_id > (SELECT COUNT(fa2.film_id)
							FROM film_actor AS fa2
							INNER JOIN actor AS a2
                            WHERE a1.actor_id = a2.actor_id)
	GROUP BY a1.actor_id;
							