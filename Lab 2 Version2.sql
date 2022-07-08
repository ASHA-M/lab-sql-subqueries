USE sakila;

#How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(inventory_id) AS number_of_copies, f.title 
FROM sakila.film f
JOIN sakila.inventory i USING (film_id)
WHERE f.title='Hunchback Impossible';

#List all films whose length is longer than the average of all the films.

SELECT title, length FROM film
WHERE length > (
  SELECT AVG(length)
  FROM film
)
ORDER BY length DESC;

#Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name,' ',last_name) AS 'Actors in Alone Trip'
FROM actor
WHERE actor_id IN 
	(SELECT actor_id FROM film_actor WHERE film_id = 
	(SELECT film_id FROM film WHERE title = 'Alone Trip'));


#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title AS 'Movie Title'
	FROM film AS f
	JOIN film_category AS fc ON fc.film_id = f.film_id
	JOIN category AS c ON c.category_id = fc.category_id
	WHERE c.name = 'Family';


#Get name and email from customers from Canada using subqueries. Do the same with joins. 
#Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

#Subquery
SELECT CONCAT(c.first_name,' ',c.last_name) AS 'Name', c.email AS 'E-mail'
	FROM customer AS c
	JOIN address AS a ON c.address_id = a.address_id
	JOIN city AS cy ON a.city_id = cy.city_id
	JOIN country AS ct ON ct.country_id = cy.country_id
	WHERE ct.country = 'Canada';

#Subquery
SELECT CONCAT(first_name,' ',last_name), email FROM customer
WHERE address_id IN (
SELECT address_id FROM address
WHERE city_id IN (
SELECT city_id FROM city
WHERE country_id IN (
SELECT country_id FROM country
WHERE country = 'Canada'))
);

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

CREATE TEMPORARY TABLE most_movies_actor AS (
SELECT actor_id, COUNT(film_id) FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1);

SELECT f.title 
FROM film f
WHERE film_id IN(
SELECT film_id FROM film_actor
WHERE actor_id = (SELECT actor_id FROM most_movies_actor)
);

#Subquery
SELECT title 
FROM film
WHERE film_id IN(
SELECT film_id FROM film_actor
WHERE actor_id = (SELECT actor_id FROM ( 
SELECT actor_id, COUNT(film_id) FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1)sub1) 
);

#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title
FROM film AS fi
WHERE film_id IN(
SELECT film_id FROM( 
SELECT film_id FROM inventory AS i
JOIN rental AS r 
USING (inventory_id)
WHERE customer_id = (SELECT customer_id FROM (
SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1)sub1))sub2
);


#Customers who spent more than the average payments.

SELECT SUM(amount), CONCAT(first_name,' ',last_name) FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id
HAVING SUM(amount) > (SELECT avg(total_payment) FROM (
SELECT customer_id, SUM(amount) AS total_payment FROM payment
GROUP BY customer_id) sub1)
ORDER BY SUM(amount) DESC;