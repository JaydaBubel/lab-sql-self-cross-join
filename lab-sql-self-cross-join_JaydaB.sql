use sakila;

# 1. Get all pairs of actors that worked together.
# two tables, actor and film_acotr, are joined - duplicates not shown
select actor.actor_id, actor.first_name, actor.last_name, film_actor.actor_id, actor.first_name, actor.last_name from actor
left join film_actor on actor.actor_id = film_actor.actor_id
left join film_actor as film_actor2 on film_actor.film_id = film_actor2.film_id and film_actor.actor_id < film_actor2.actor_id
left join actor as actor2 on film_actor2.actor_id = actor2.actor_id;

# 2. Get all pairs of customers that have rented the same film more than 3 times.
# Use group by + store in temp. table (customer + movie), + count rental times, then self join using where statement
# the long way around... thanks Carles for the help!

select c1.customer_id, c2.customer_id, count(*) as num_films
from sakila.customer c1
inner join rental r1 on r1.customer_id = c1.customer_id
inner join inventory i1 on r1.inventory_id = i1.inventory_id
inner join film f1 on i1.film_id = f1.film_id
inner join inventory i2 on i2.film_id = f1.film_id
inner join rental r2 on r2.inventory_id = i2.inventory_id
inner join customer c2 on r2.customer_id = c2.customer_id
where c1.customer_id <> c2.customer_id
group by c1.customer_id, c2.customer_id
having count(*) > 3
order by num_films desc;

# 3. Get all possible pairs of actors and films.
# use distinct then cross join
select distinct film_actor.actor_id, film_actor.film_id from film_actor
cross join actor;