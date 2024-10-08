select * from netflix;

select count(*) as total_content
from netflix;

select distinct type
from netflix;

-- 15 business problems
-- 1 . count the number of Movies vs TV Shows

select 
	type,
	count(*)as total_content
 from netflix
group by type

-- 2 Find the most common rating for movies and tv show

SELECT 
    type,
    rating
FROM 
    (SELECT 
        type,
        rating,
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating) AS t1
WHERE 
    ranking = 1;

-- 3) List all movies released in a specific year(eg . 2022)
--

SELECT * 
FROM netflix
WHERE 
	type = 'Movie'
	and
	release_year = 2020

-- 4) Find the top 5 countries with the most content in Netflix

Select 
	Unnest (STRING_TO_ARRAY(country, ',')) AS new_country,
	count (show_id) as total_content
	from netflix
	group by 1
	order by 2 desc
	limit 5

-- 5) Identify the longest movie

select * from netflix
where 
	type = 'Movie'
	and 	
	duration = (select max (duration) from netflix)

-- 6) find content added in the last 5 years 

select *
	from netflix
where 
	to_date(date_added , 'Month DD, YYYY') >= current_date - interval '5 years'


-- 7) Find all the movies/TV shows by director 'Rajiv Chilaka'

select * from netflix
where director ilike '%Rajiv Chilaka%'


--8) List all TV shows with more than 5 seasons

select *
	from netflix
where 
	type = 'TV Show'
	and
	SPLIT_PART (duration, ' ', 1):: numeric > 5 

-- 9) count the number of content items in each genre 

select 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	count(show_id) as total_content
	from netflix
	group by 1

--10) find each year and the average numbers of content release by india on netlfix.
--return top 5 year with highest avvg content release.

TOTAL CONTENT 333/972
	
select 
	EXTRACT(YEAR FROM TO_DATE (date_added,'Month DD , YYYY')) AS Year,
	count(*),
ROUND(count(*):: numeric /(SELECT COUNT(*)FROM netflix Where country = 'India') :: numeric * 100 ,2) as Avg_content_per_year
	from netflix
where country = 'India'
group by 1

-- 11) List all the movies which are documentries 

select * from netflix
where listed_in like '%Documentaries%'

-- 12) find all content without a director 

select * from netflix 
where
	director IS NULL

-- 13) Find how many movies actor 'Salman Khan ' appread in last 10 Years 

select * from netflix
where 
	casts like'%Salman Khan%'
	and 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--14) Find the top 10 actors who have appeared in the highest number of movies produced in India

select 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	count(*) as total_content
	from netflix
	where country ILike '%India%'
 	group by 1
 	order by 2 desc
 	limit 10

-- 15)  categorize the content based on the presence of keywords 'kill'
--and 'violence' in the description field . Label content contaitning these keywords
--as 'Bad' and all other content as 'Good'. count how mant items fall
--into each category

with new_table 
	as
	(
	
select *,
	case
	when description ilike '%kill%' or 
	description ilike '%violence%' then 'Bad_content'
	else 'Good_content'
	End category
from netflix
)

select 
	category,
	count(*)as total_content
from new_table
group by 1]