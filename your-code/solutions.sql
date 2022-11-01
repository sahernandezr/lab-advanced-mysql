USE publications;
SHOW tables;

-- Challenge 1 - Most Profiting Authors: who are the top 3 most profiting authors?
-- Total profit an author receives by publishing a book is the sum of the advance and the royalties
-- The royalties the author will receive is typically a percentage of the entire book sales
-- Your output should have the following columns:
-- AUTHOR ID - the ID of the author
-- LAST NAME - author last name
-- FIRST NAME - author first name
-- PROFIT - total profit the author has received combining the advance and royalties
-- Your output should be ordered from higher PROFIT values to lower values.
-- Only output the top 3 most profiting authors.

-- I need what books are of which author, ytd_sales by title, what is the royalty percentage by title, the advancement by title.
-- Calculate profit as advancement plus (sales by royalty) 

-- Step 1: Calculate the royalties of each sales for each author
SELECT 
titleauthor.title_id as Title_ID,  authors.au_id AS Author_ID, authors.au_fname AS Author_FName, authors.au_lname as Author_LName, titles.title AS Titulo, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publications.authors
INNER JOIN titleauthor
on authors.au_id = titleauthor.au_id
INNER JOIN titles
on titleauthor.title_id = titles.title_id
INNER JOIN sales
on titles.title_id = sales.title_id;

-- Step 2: Aggregate the total royalties for each title for each author
SELECT Author_ID, Title_ID, Author_FName, Author_Lname, Titulo, Advance,
sum(Sales_Royalty) as Aggregated_Royalty
FROM (
SELECT 
titleauthor.title_id as Title_ID,  authors.au_id AS Author_ID, authors.au_fname AS Author_FName, authors.au_lname as Author_LName, titles.title AS Titulo, titles.advance AS Advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publications.authors
INNER JOIN titleauthor
on authors.au_id = titleauthor.au_id
INNER JOIN titles
on titleauthor.title_id = titles.title_id
INNER JOIN sales
on titles.title_id = sales.title_id
) summary
group by Title_ID, Author_ID
; 

-- Step 3: Calculate the total profits of each author
SELECT Author_ID, Author_FName, Author_LName, Titulo,
SUM((Aggregated_Royalty) + Advance) AS Total_Profits
FROM (
SELECT Author_ID, Title_ID, Author_FName, Author_Lname, Titulo, Advance,
sum(Sales_Royalty) as Aggregated_Royalty
FROM (
SELECT 
titleauthor.title_id as Title_ID,  authors.au_id AS Author_ID, authors.au_fname AS Author_FName, authors.au_lname as Author_LName, titles.title AS Titulo, titles.advance AS Advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publications.authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id
) summary
GROUP BY Title_ID, Author_ID
) summary2
GROUP BY Author_ID
ORDER BY Total_Profits DESC
Limit 3
;

-- Challenge 3
CREATE TABLE most_profiting_authors (
SELECT Author_ID, Author_FName, Author_LName, Titulo,
SUM((Aggregated_Royalty) + Advance) AS Total_Profits
FROM (
SELECT Author_ID, Title_ID, Author_FName, Author_Lname, Titulo, Advance,
sum(Sales_Royalty) as Aggregated_Royalty
FROM (
SELECT 
titleauthor.title_id as Title_ID,  authors.au_id AS Author_ID, authors.au_fname AS Author_FName, authors.au_lname as Author_LName, titles.title AS Titulo, titles.advance AS Advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publications.authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id
) summary
GROUP BY Title_ID, Author_ID
) summary2
GROUP BY Author_ID
ORDER BY Total_Profits DESC
Limit 3
);

SHOW TABLES;