# Spotify Advanced SQL Project and Query Optimization 
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity, and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
CREATE TABLE Spotify
	(
		Artist VARCHAR(255),
		Track VARCHAR(255),
		Album VARCHAR(255),
		Album_type VARCHAR(50),
		Danceability FLOAT,
		Energy FLOAT,
		Loudness FLOAT,
		Speechiness FLOAT,
		Acousticness FLOAT,
		Instrumentalness FLOAT,
		Liveness FLOAT,
		Valence FLOAT,
		Tempo FLOAT,
		Duration_min FLOAT,
		Title VARCHAR(255),
		Channel VARCHAR(255),
		Views FLOAT,
		Likes FLOAT,
		Comments FLOAT,
		Licensed BOOLEAN,
		official_video BOOLEAN,
		Stream FLOAT,
		EnergyLiveness FLOAT,
		most_playedon VARCHAR(50)
	);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 2. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. 

### 3. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## Business Questions

1. **Retrieve the names of all tracks that have more than 1 billion streams.**
```sql
SELECT track, stream 
FROM Spotify
WHERE stream > 1000000000;
```

2. **List all albums along with their respective artists.**
```sql
SELECT DISTINCT Album, Artist
FROM Spotify;
```

3. **Get the total number of comments for tracks where `licensed = TRUE`.**
```sql
SELECT SUM(Comments) AS total_comments 
FROM Spotify
WHERE Licensed = 'TRUE';
```

4. **Find all tracks that belong to the album type `single`.**
```sql
SELECT track
FROM Spotify
WHERE Album_type = 'single';
```

5. **Count the total number of tracks by each artist.**
```sql
SELECT Artist, COUNT(track) AS total_tracks
FROM Spotify
GROUP BY Artist
ORDER BY total_tracks DESC
LIMIT 10;
```

6. **Calculate the average danceability of tracks in each album.**
```sql
SELECT Album, COUNT(track) AS total_tracks, AVG(Danceability) AS avg_danceability 
FROM Spotify
GROUP BY Album;
```

7. **Find the top 5 tracks with the highest energy values.**
```sql
SELECT track, Energy
FROM Spotify
ORDER BY Energy DESC
LIMIT 5;
```

8. **List all tracks along with their views and likes where `official_video = TRUE`.**
```sql
SELECT DISTINCT track, Views, Likes
FROM Spotify
WHERE official_video = 'TRUE';
```

9. **For each album, calculate the total views of all associated tracks.**
```sql
SELECT Album, COUNT(track) AS total_tracks, SUM(Views) AS total_views
FROM Spotify
GROUP BY Album;
```

10. **Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
SELECT DISTINCT track FROM Spotify
WHERE most_playedon = 'Spotify';
```

11. **Find the top 3 most-viewed tracks for each artist using window functions.**
```sql
WITH ranking_artist
AS
(
SELECT Artist, track, SUM(Views) AS total_views, 
DENSE_RANK() OVER(PARTITION BY Artist ORDER BY SUM(Views) DESC) AS RANK
FROM Spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE RANK <= 3;
```

12. **Write a query to find tracks where the liveness score is above the average.**
```sql
SELECT DISTINCT track
FROM Spotify 
WHERE Liveness > (SELECT AVG(Liveness) FROM Spotify);
```

13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH CTE
AS
(
    SELECT Album, MAX(Energy) AS highest_energy, MIN(Energy) AS lowest_energy
    FROM Spotify
    GROUP BY Album
)
SELECT Album, highest_energy - lowest_energy AS energy_diff
FROM CTE
ORDER BY energy_diff DESC;
```

14. **Find tracks where the energy-to-liveness ratio is greater than 1.2.**
```sql
SELECT DISTINCT track, Energy, Liveness
FROM Spotify
WHERE Energy/Liveness > 1.2;
```

15. **Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.**
```sql
SELECT track, Views, Likes,
SUM(Likes) OVER (ORDER BY Views) AS cumulative_likes
FROM Spotify
ORDER BY Views DESC;
```

---

## Query Optimization Technique 

To improve query performance, I carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - I began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **11.979 ms**
        - Planning time (P.T.): **2.281 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/stenneti18/Project_SQL-3/blob/main/Without%20Index.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, I created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON Spotify(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.065 ms**
        - Planning time (P.T.): **0.330 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/stenneti18/Project_SQL-3/blob/main/With%20Index.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
      ![Performance Graph](https://github.com/stenneti18/Project_SQL-3/blob/main/spotify_graphical%20view%201.png)
      ![Performance Graph](https://github.com/stenneti18/Project_SQL-3/blob/main/spotify_graphical%20view%202.png)
      ![Performance Graph](https://github.com/stenneti18/Project_SQL-3/blob/main/spotify_graphical%20view%203.png)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4, PostgreSQL 

## Author - Santhosh Tenneti

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/santhoshtenneti/)

Thank you, and I look forward to connecting with you!
