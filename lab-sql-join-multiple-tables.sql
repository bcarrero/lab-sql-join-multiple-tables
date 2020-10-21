/* Lab | SQL Joins on multiple tables
In this lab, you will be using the Sakila database of movie rentals.
Instructions
    1. Write a query to display for each store its store ID, city, and country.
    2. Write a query to display how much business, in dollars, each store brought in.
    3. What is the average running time of films by category?
    4. Which film categories are longest?
    5. Display the most frequently rented movies in descending order.
    6. List the top five genres in gross revenue in descending order.
    7. Is "Academy Dinosaur" available for rent from Store 1?
    */
use sakila;
# 1. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
# city => a field in city table
# country => a field in country table
select s.store_id, a.address  from store as s
join address as a on a.address_id = s.address_id;

# we add the city by joining with city table
select s.store_id, a.address, c.city  from store as s
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id;

# we add the country by joining with country table
select s.store_id,c.city, coun.country  from store as s
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id
join country as coun on coun.country_id = c.country_id;

#  2. Write a query to display how much business, in dollars, each store brought in.
# to do this, we need information from payment, rental and inventory
select * from rental
group by staff_id;
select r.rental_id, p.amount from payment as p
join rental as r on r.rental_id = p.rental_id
group by rental_id;

select i.store_id, i.inventory_id, r.rental_id, p.amount from payment as p
join rental as r on r.rental_id = p.rental_id
join inventory as i on i.inventory_id = r.inventory_id
group by rental_id;

select i.store_id, sum(p.amount) from payment as p
join rental as r on r.rental_id = p.rental_id
join inventory as i on i.inventory_id = r.inventory_id
group by i.store_id;

# 3. What is the average running time of films by category?
# length => film table
# name => category table
# film_category
select cat.name, round(avg(f.length),0) as 'avg_running_time' from category as cat
join film_category as f_c on f_c.category_id = cat.category_id
join film as f on f.film_id = f_c.film_id
group by name
order by avg_running_time DESC;

# 4. Which film categories are longest?
	# Games and sports
# 5. Display the most frequently rented movies in descending order.
# we need:
#title from film
#inventory_id from inventory
#rental_id from rental
select inventory_id, count(rental_id) as num_rentals from rental
group by inventory_id
order by num_rentals DESC, inventory_id;

select i.inventory_id, count(rental_id) as num_rentals from rental as r
join inventory as i on i.inventory_id = r.inventory_id
group by inventory_id
order by num_rentals DESC, i.inventory_id;

select f.title, count(rental_id) as num_rentals from rental as r
join inventory as i on i.inventory_id = r.inventory_id
join film as f on f.film_id = i.film_id
group by f.title
order by num_rentals DESC, i.inventory_id;

# 6. List the top five genres in gross revenue in descending order.
# film_category
# film
# category
# inventory
# rental 
# amount => payment table
select p.rental_id, sum(p.amount) from rental as r
join payment as p on p.rental_id = r.rental_id;

select cat.name, round(sum(p.amount),0) as total_amount from rental as r
join payment as p on p.rental_id = r.rental_id
join inventory as i on i.inventory_id = r.inventory_id
join film as f on f.film_id = i.film_id
join film_category as f_c on f_c.film_id=f.film_id
join category as cat on cat.category_id = f_c.category_id
group by name
order by total_amount DESC;

# 7. Is "Academy Dinosaur" available for rent from Store 1?
select f.title, i.store_id, i.film_id from inventory as i
join film as f on f.film_id = i.film_id
where title = "Academy Dinosaur" and store_id = 1;

use sakila;
select * from actor;