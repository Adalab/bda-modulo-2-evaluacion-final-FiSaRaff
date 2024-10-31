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


/*16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración.
21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado.
22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores.*/ 