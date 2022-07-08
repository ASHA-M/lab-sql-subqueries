USE sakila;

#Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM store AS st 
INNER JOIN address AS ad 
ON st.address_id = ad.address_id 
INNER JOIN city AS ci 
ON ad.city_id = ci.city_id 
INNER JOIN country AS co 
ON co.country_id = ci.country_id; 


#Write a query to display how much business, in dollars, each store brought in.

SELECT sta.store_id, sum(amount)  #each time you write sum/count of second column and no function for first column use GROUP BY
FROM payment AS pay
INNER JOIN staff AS sta
ON pay.staff_id = sta.staff_id
INNER JOIN store AS sto
ON sta.store_id = sto.store_id
GROUP BY sta.store_id;


#Which film categories are longest?

SELECT name, AVG(length)
FROM film AS fi	
LEFT JOIN film_category AS ficat
ON fi.film_id = ficat.film_id
LEFT JOIN category AS cat
ON ficat.category_id = cat.category_id
GROUP BY name
ORDER BY AVG(length) DESC;

#Display the most frequently rented movies in descending order.

SELECT title, count(*)
FROM  film AS fi
INNER JOIN inventory AS inv
ON fi.film_id = inv.film_id
INNER JOIN rental AS ren
ON inv.inventory_id = ren.inventory_id
GROUP BY title
ORDER BY count(*) DESC;

#List the top five genres in gross revenue in descending order.

SELECT name, sum(amount)
FROM  category AS cat
INNER JOIN film_category AS ficat
on ficat.category_id = cat.category_id
INNER jOIN film AS fi
ON fi.film_id = ficat.film_id
INNER JOIN inventory AS inv
ON fi.film_id = inv.film_id
INNER JOIN rental AS ren
ON inv.inventory_id = ren.inventory_id
INNER JOIN payment AS pay
ON pay.rental_id = ren.rental_id
GROUP BY name
ORDER BY sum(amount) DESC
limit 5;


#Is "Academy Dinosaur" available for rent from Store 1?
SELECT st.store_id, title, inv.inventory_id
FROM store AS st
INNER JOIN inventory AS inv
ON st.store_id = inv.store_id
INNER JOIN film AS fi
ON fi.film_id = inv.film_id
WHERE st.store_id = 1 AND title = 'ACADEMY DINOSAUR';

#Get all pairs of actors that worked together.

SELECT * FROM film_actor AS a
INNER JOIN film_actor AS b
ON (a.actor_id <> b.actor_id) AND (a.film_id = b.film_id);


# Get all pairs of customers that have rented the same film more than 3 times.

SELECT cus.first_name, cus.last_name, COUNT(DISTINCT(rent.rental_id))
FROM customer as cus
JOIN rental as rent
on cus.customer_id = rent.customer_id
GROUP BY cus.first_name, cus.last_name
HAVING COUNT(rent.rental_id) > 3
ORDER BY COUNT(DISTINCT(rent.rental_id)) DESC;

# For each film, list actor that has acted in more films.

SELECT * FROM
(SELECT concat(first_name,' ', last_name) AS actor, title FROM actor
INNER JOIN film_actor 
USING (actor_id)
INNER JOIN film
USING (film_id)) AS table1
LEFT JOIN
(SELECT concat(first_name,' ', last_name) AS actor , count(*) AS countoffilms FROM actor
INNER JOIN film_actor 
USING (actor_id)
INNER JOIN film
USING (film_id)
GROUP BY actor_id) AS table2
USING (actor)

#Lab solution provided for this question says query not working yet.


