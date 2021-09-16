/* Created a schema for movies using the CREATE command and
used IF NOT EXISTS to prevent an error from occuring if the database already exist */
CREATE DATABASE IF NOT EXISTS Movies;

-- Creating table Movies and setting the primary key of the table as the combination of Year and Title attributes
CREATE TABLE `Movies`.`Movies` (
  `Year` INT NOT NULL, /* as primary key cannot be null */
  `Length` INT NULL,
  `Title` VARCHAR(100) NOT NULL, /* as primary key cannot be null */
  `Subject` VARCHAR(45) NULL,
  `Actor` VARCHAR(100) NULL,
  `Actress` VARCHAR(100) NULL,
  `Director` VARCHAR(100) NULL,
  `Popularity` INT NULL,
  `Awards` VARCHAR(3) NULL,
  PRIMARY KEY (`Year`, `Title`)); /* primary key as combination of year and title */
  

/* For the genere Comedy and Drama which director got more than 3 awards */

SELECT subject AS Genere,
       director,
       Sum(CASE
             WHEN awards = 'Yes' THEN 1
             ELSE 0
           end) Awards /* as attribute Awards is in string format hence used the case statement to find the count of awards */
FROM   `movies`.`movies`
WHERE  subject IN ( "comedy", "drama" ) /* gave the underlying genere condition */
GROUP  BY subject,
          director /* grouped the data on subject and then the director as per the business question */
HAVING Sum(CASE
             WHEN awards = 'Yes' THEN 1
             ELSE 0
           end) > 3 /* gave the awards>3 condition */
ORDER  BY awards DESC /* ordered the data in descending order of number of awards*/ ; 



/* In the period of 1990 to 1995 who were the lead actors who did Drama movies and acted in more than 3 movies */

SELECT subject  AS Genere,
       actor    AS LeadActor,
       Count(*) AS NumberofMovies /* Counted the number of movies */
FROM   `movies`.`movies`
WHERE  subject IN ( "drama" ) /* filtered the drama movies */
       AND year BETWEEN 1990 AND 1995 /* filtered data on years as per business question */
GROUP  BY subject,
          actor /* grouped data on genre and actor */
HAVING( Count(*) ) > 3 /* filtered the movies with count>3 with the underlying group by conditions */
ORDER  BY numberofmovies DESC /* ordered the data in highest movie count to lowest */ ;

 
# Which Genre Has The Highest Release Of Movies in the duration 1980 to 1990 with the average movie popularity being scored 40?
SELECT subject AS Genre,
       Count(*) CountOfMovieReleased /* counted the no. of movies */
FROM   `movies`.`movies`
WHERE  subject <> "" /* few movies did not have genre so adding these condition to exclude them */
       AND year BETWEEN 1980 AND 1990 /* added the underlying year condition mentioned in the business question */
GROUP  BY subject /* aggregated the data on subject which is the genre */
HAVING Avg(popularity) > 40 /* to include only those genre which has an average popularity of 40*/
ORDER  BY countofmoviereleased DESC; /* Ordered the data in descending order of number of movie released*/;  
 
/* which movie having average movie duration in that genre more than 100 minutes got least popularity in the genre Horror and Music having but still got award and who were the lead cast and director of the movie? */
SELECT m.subject AS Genre,
       title,
       actor,
       actress,
       director
/* required columns selected */
FROM   `movies`.`movies` M
       INNER JOIN (SELECT subject,
                          Min(popularity) AS minpopularity /* found the least popular value using the min function */
                   FROM   `movies`.`movies`
                   WHERE  subject IN ( "music", "horror" )
                          AND awards = "yes"
                   /* underlying conditions mentioned in the business question given in the where clause */
                   GROUP  BY subject /* grouped the data on genres */
                   HAVING avg(length)>100) minpopular /* gave average movie duration length of more than 100 minutes */
               /* created a view to get the least popular movie by grouping on subject and using the min function */
               ON m.subject = minpopular.subject
                  /* joined the view on subject and least of popularity value with the main table to get the least popular movie for each subject */
                  AND m.popularity = minpopular.minpopularity
ORDER  BY m.subject; /* ordered the final result by subject in ascending order */
