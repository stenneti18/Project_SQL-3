-- ADVANCED SQL PROJECT ON SPOTIFY

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
SELECT * FROM Spotify;

---------------------------------------------------------------
--EXPLORATORY DATA ANALYSIS
SELECT COUNT(*) FROM Spotify;
SELECT COUNT(DISTINCT  Artist) FROM Spotify;
SELECT COUNT(DISTINCT  Album) FROM Spotify;
SELECT DISTINCT  Album_type FROM Spotify;
SELECT MAX(Duration_min) FROM Spotify;

DELETE FROM Spotify 
WHERE Duration_min = 0;

---------------------------------------------------------------
-- BUSINESS PROBLEMS:

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track, stream 
FROM Spotify
WHERE stream > 1000000000;

-- 2.List all albums along with their respective artists.
SELECT DISTINCT Album, Artist
FROM Spotify;

-- 3.Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(Comments) AS total_comments 
FROM Spotify
WHERE Licensed = 'TRUE';

-- 4.Find all tracks that belong to the album type single.
SELECT track
FROM Spotify
WHERE Album_type = 'single';

-- 5.Count the total number of tracks by each artist. Give the top 10 artiats with most number of tracks.
SELECT Artist, COUNT(track) AS total_tracks
FROM Spotify
GROUP BY Artist
ORDER BY total_tracks DESC
LIMIT 10;

-- 6.Calculate the average danceability of tracks in each album.
SELECT Album, COUNT(track) AS total_tracks, AVG(Danceability) AS avg_danceability 
FROM Spotify
GROUP BY Album;

-- 7.Find the top 5 tracks with the highest energy values.
SELECT track, Energy
FROM Spotify
ORDER BY Energy DESC
LIMIT 5;

-- 8.List all tracks along with their views and likes where official_video = TRUE.
SELECT DISTINCT track, Views, Likes
FROM Spotify
WHERE official_video = 'TRUE';

-- 9.For each album, calculate the total views of all associated tracks.
SELECT Album, COUNT(track) AS total_tracks, SUM(Views) AS total_views
FROM Spotify
GROUP BY Album;

-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT DISTINCT track FROM Spotify
WHERE most_playedon = 'Spotify';

-- 11.Find the top 3 most-viewed tracks for each artist using window functions.
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

-- 12.Write a query to find tracks where the liveness score is above the average.
SELECT DISTINCT track
FROM Spotify 
WHERE Liveness > (SELECT AVG(Liveness) FROM Spotify);

-- 13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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

-- 14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT DISTINCT track, Energy, Liveness
FROM Spotify
WHERE Energy/Liveness > 1.2;

-- 15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT track, Views, Likes,
SUM(Likes) OVER (ORDER BY Views) AS cumulative_likes
FROM Spotify
ORDER BY Views DESC;

-- END OF THE PROJECT.
















