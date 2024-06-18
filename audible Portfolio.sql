/* Audible unclean to clean data.
Skills Used: substrings, converting data types, deleting duplicates, altering columns, constraints */

SELECT * FROM audible_uncleaned;

-- The data used will be based on the number of reviews so any row that doesn’t have a rating will be deleted. 


DELETE FROM audible_uncleaned WHERE stars = "Not rated yet";
  

 -- Next check for any null values. 
  

SELECT * FROM audible_uncleaned WHERE name IS NULL;


--Format dates of ‘releasedate’ column from d/m/y to y/m/d


UPDATE audible_uncleaned
SET releasedate = DATE_FORMAT(STR_TO_DATE(releasedate, ‘%d-%m-%Y’), ‘%Y-%m-%d’);



-- Putting space between names under author and narrator columns and deleting the redundancy of Writtenby and Narratedby in each row.



UPDATE audible_uncleaned
SET author = REPLACE(author, "Writtenby:", "");


UPDATE audible_uncleaned
SET narrator = REPLACE(narrator, 'Narratedby:', '');


-- Separating the ‘stars’ column into two separate columns ‘number_of_stars’ and ‘ratings’


ALTER TABLE audible_uncleaned
ADD COLUMN number_of_stars VARCHAR(255),
ADD COLUMN ratings VARCHAR(255);


UPDATE audible_uncleaned
SET number_of_stars = SUBSTRING(stars, 1, LOCATE(' stars', stars) - 1),
    ratings = SUBSTRING(stars, LOCATE(' stars', stars) + 6);




ALTER TABLE audible_uncleaned
DROP COLUMN stars;


-- Convert the numeric part of the string to a number for sorting.



SELECT *
FROM audible_uncleaned
ORDER BY CAST(SUBSTRING_INDEX(ratings, ' ', 1) AS UNSIGNED) DESC;



Delete Duplicates


-- add a new boolean column

ALTER table audible_uncleaned add tokeep boolean;




-- add a constraint on the duplicated columns AND the new column

alter table audible_uncleaned add constraint preventdupe unique (name, author, tokeep);






-- set the boolean column to true. This will succeed only on one of the duplicated rows because of the new constraint

update ignore audible_uncleaned set tokeep = true;



-- delete rows that have not been marked as tokeep

delete from audible_uncleaned where tokeep is null;

-- drop the added column

alter table audible_uncleaned drop tokeep;


--Only working with media written in English language


DELETE FROM audible_uncleaned
WHERE language <> 'English';
