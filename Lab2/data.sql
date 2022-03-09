DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Judges;
DROP TABLE IF EXISTS Car_Score;



CREATE TABLE Cars(
	Car_ID TEXT PRIMARY KEY,
	Year INT,
	Make TEXT,
	Model TEXT,
	Name TEXT,
	Email TEXT
);

CREATE TABLE Judges(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Timestamp DATETIME

);


CREATE TABLE Car_Score(
	Car_ID TEXT PRIMARY KEY,
	Racer_Turbo INT,
	Racer_Supercharged INT,
	Racer_Performance INT,
	Racer_Horsepower INT,
	Car_Overall INT,
	Engine_Modifications INT,
	Engine_Performance INT,
	Engine_Chrome INT,
	Engine_Detailing INT,
	Engine_Cleanliness INT,
	Body_Frame_Undercarriage INT,
	Body_Frame_Suspension INT,
	Body_Frame_Chrome INT,
	Body_Frame_Detailing INT,
	Body_Frame_Cleanliness INT,
	Mods_Paint INT,
	Mods_Body INT,
	Mods_Wrap INT,
	Mods_Rims INT,
	Mods_Interior INT,
	Mods_Other INT,
	Mods_ICE INT,
	Mods_Aftermarket INT,
	Mods_WIP INT,
	Mods_Overall INT 
);


CREATE TEMP TABLE Datacsv(
	Timestamp DATETIME,
	Email TEXT,
	Name TEXT,
	Year INT,
	Make TEXT,
	Model TEXT,
	Car_ID TEXT,
	Judge_ID TEXT,
	Judge_Name TEXT,
	Racer_Turbo INT,
	Racer_Supercharged INT,
	Racer_Performance INT,
	Racer_Horsepower INT,
	Car_Overall INT,
	Engine_Modifications INT,
	Engine_Performance INT,
	Engine_Chrome INT,
	Engine_Detailing INT,
	Engine_Cleanliness INT,
	Body_Frame_Undercarriage INT,
	Body_Frame_Suspension INT,
	Body_Frame_Chrome INT,
	Body_Frame_Detailing INT,
	Body_Frame_Cleanliness INT,
	Mods_Paint INT,
	Mods_Body INT,
	Mods_Wrap INT,
	Mods_Rims INT,
	Mods_Interior INT,
	Mods_Other INT,
	Mods_ICE INT,
	Mods_Aftermarket INT,
	Mods_WIP INT,
	Mods_Overall INT

);

.headers on
.mode csv
.import data_lab2/data.csv Datacsv


INSERT INTO Cars(Car_ID,Year,Make,Model,Name,Email) SELECT Car_ID, Year, Make, Model, Name, Email FROM Datacsv WHERE 1;

DELETE FROM Cars WHERE Car_ID='Car_ID';

INSERT INTO Judges(Judge_ID,Judge_Name,Timestamp) SELECT Judge_ID, Judge_Name,Timestamp FROM Datacsv WHERE 1;


UPDATE Judges SET Timestamp = REPLACE(Timestamp,"/","-");
UPDATE Judges SET Timestamp = substr(Timestamp,5,4)||"-0"||substr(Timestamp,1,2)||-0||substr(Timestamp,3,1)|| " "|| substr(Timestamp,10,5);

  
DELETE FROM Judges WHERE Judge_ID='Judge_ID';

INSERT INTO Car_Score(Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall) SELECT Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall FROM Datacsv WHERE 1;

DELETE FROM Car_Score WHERE Car_ID='Car_ID';



DROP TABLE IF EXISTS Total_Score;

CREATE TABLE Total_Score(
	Car_ID TEXT,
	Year INT,
	Make TEXT,
	Model TEXT,
	Total INT

);

INSERT INTO Total_Score SELECT Car_ID,Year,Make,Model,(Racer_Turbo + Racer_Supercharged + Racer_Performance + Racer_Horsepower + Car_Overall + Engine_Modifications + Engine_Performance + Engine_Chrome + Engine_Detailing + Engine_Cleanliness + Body_Frame_Undercarriage + Body_Frame_Suspension + Body_Frame_Chrome + Body_Frame_Detailing + Body_Frame_Cleanliness + Mods_Paint + Mods_Body + Mods_Wrap + Mods_Rims + Mods_Interior + Mods_Other + Mods_ICE + Mods_Aftermarket + Mods_WIP + Mods_Overall) AS Total_Score FROM Datacsv ORDER BY Total_Score DESC;

DELETE FROM Total_Score WHERE Car_ID='Car_ID';

DROP TABLE IF EXISTS Ranks;
CREATE TABLE Ranks(
	Rank INT,
	Car_ID TEXT,
        Year INT,
        Make TEXT,
        Model TEXT,
        Total INT

);
INSERT INTO Ranks(Rank,Car_ID,Year,Make,Model,Total) SELECT rowid, Car_ID, Year, Make, Model, Total FROM Total_Score ORDER BY Total DESC;


DROP TABLE Datacsv;

.headers ON
.mode csv
.output extract1.csv
SELECT * FROM Ranks;

DROP TABLE IF EXISTS UnsortedRank;
CREATE TABLE UnsortedRank (
Rank INT,
Car_ID INT,
Year INT,
Make TEXT,
Model TEXT,
Total INT
);

INSERT INTO UnsortedRank(Rank, Car_ID, Year, Make, Model, Total) SELECT Rank, Car_ID, Year, Make, Model, Total 
FROM Ranks 
ORDER BY Make;

DROP TABLE IF EXISTS Top3;
CREATE TABLE Top3 (
	Rank INT,
	Car_ID INT,
	Year INT,
	Make TEXT,
	Model TEXT,
	Total INT
);

INSERT INTO Top3(Rank, Car_ID, Year, Make, Model, Total)
select *
from UnsortedRank
where (
   select count(*) from UnsortedRank as f
   where UnsortedRank = UnsortedRank.Make and f.Rank <= UnsortedRank.Rank
) <= 3;



.headers ON
.mode csv
.output extract2.csv
SELECT * FROM Top3;

DROP TABLE IF EXISTS UpdateJudges;
CREATE TABLE UpdateJudges(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Num_Cars INT,
	Start DATETIME,
	End DATETIME,
	Duration FLOAT,
	Average FLOAT
	
);

INSERT INTO UpdateJudges(Judge_ID,Judge_Name,Num_Cars,Start,End,Duration,Average)SELECT 
Judge_ID, 
Judge_Name, 
COUNT(Timestamp) AS Num_Cars, 
MIN(Timestamp) AS Start, 
MAX(Timestamp) AS End,
ROUND(CAST((julianday(MAX(Timestamp)) -julianday (MIN(Timestamp)))*24  AS FLOAT),2) AS Duration,
ROUND(CAST(((julianday (MAX(Timestamp)) -julianday (MIN(Timestamp)))*24*60) AS FLOAT) / COUNT(Timestamp),2) AS  Average
FROM Judges GROUP BY Judge_ID;


.headers ON
.mode csv
.output extract3.csv
SELECT * FROM UpdateJudges;
