create database CRIME;
use CRIME;
truncate crime_data;
select * from crime_data;
set sql_safe_updates=0;
UPDATE crime_data 
SET `Date Reported` = STR_TO_DATE(`Date Reported`, '%d-%m-%Y %H:%i');
update crime_data
set `Time of Occurrence`=str_to_date(`Time of Occurrence`, '%d-%m-%Y %H:%i'); 
update crime_data
set `Date Case Closed`=str_to_date(`Date Case Closed`,'%d-%m-%Y %H:%i')
where `Date Case Closed` is not null and `Date Case CLosed`<> '';
describe crime_data;
select  `Date Reported` from crime_data order by `Date Reported` desc;

/* Crime Records from Jan 2020 to Aug 2024 */

SELECT DISTINCT
    (`Crime Description`)
FROM
    crime_data; 

/* Total number of sexual assault cases categorized by victim gender from January 2020 to August 2024*/
SELECT 
    `Victim Gender`,
    `Crime Description`,
    COUNT(*) AS Total_Cases
FROM
    crime_data
WHERE
    `Crime Description` = 'SEXUAL ASSAULT'
GROUP BY `Victim Gender`;

/* Total sexual assault cases reported in various cities by gender (Jan 2020 - Aug 2024).*/
SELECT 
    City,
    `Crime Description`,
    `Victim Gender`,
    COUNT(*) AS Total_Cases
FROM
    crime_data
WHERE
    `Crime Description` = 'SEXUAL ASSAULT'
GROUP BY City , `Victim Gender`
ORDER BY Total_Cases DESC;  

/* Total number of pending sexual assault cases within the specified time period. */
SELECT 
    `Victim Gender`, COUNT(*) AS Total_Pending_Cases
FROM
    crime_data
WHERE
    `Crime Description` = 'SEXUAL ASSAULT'
        AND `Case Closed` = 'No'
GROUP BY `Victim Gender`;

/*Percentage of solved sexual assault cases categorized by victim gender within the specified time period.*/
SELECT 
    `Victim Gender`,
    (COUNT(CASE
        WHEN `Case Closed` = 'Yes' THEN 1
    END) * 100.0 / COUNT(*)) AS `Solved Percentage`
FROM
    crime_data
WHERE
    `Crime Description` = 'SEXUAL ASSAULT'
GROUP BY `Victim Gender`;

/*The most commonly reported crimes during the time frame.*/
SELECT 
    `Crime Description`, COUNT(*) AS Total_Cases
FROM
    crime_data
GROUP BY `Crime Description`
ORDER BY Total_Cases DESC
LIMIT 10;

/*Monthly and Yearly Crime Trends: Identifying Seasonal Patterns in Crime Data*/
SELECT 
    YEAR(`Time of Occurrence`) AS `Year`,
    MONTHNAME(`Time of Occurrence`) AS `Month`,
    COUNT(*) AS Total_Registered_Cases
FROM
    crime_data
GROUP BY `Year` , `Month`;

/*Most Prevalent Crime in Each Time Period of the Day*/
with CrimeRank as (
select case 
when Hour(`Time of Occurrence`) between 0 and 3 then 'Late Night (12 AM - 4 AM)'
when Hour(`Time of Occurrence`) between 4 and 7 then 'Early Morning (4 AM - 8 AM)'
when Hour(`Time of Occurrence`) between 8 and 11 then 'Morning (8 AM - 12 PM)'
when Hour(`Time of Occurrence`) between 12 and 15 then 'Afternoon (12 PM - 4 PM)'
when Hour(`Time of Occurrence`) between 16 and 19 then 'Evening (4 PM - 8 PM)'
when Hour(`Time of Occurrence`) between 20 and 23 then 'Night (8 PM - 12 PM)' 
end as `Time Period`,`Crime Description`, count(*) as Total_Cases from crime_data group by `Time Period`,`Crime Description`),
MaxCrime as (select `Time Period` , max(Total_Cases) as Highest_Crimes from CrimeRank group by `Time Period`)
select c.`Time Period`,c.`Crime Description`,c.Total_Cases from CrimeRank as c join MaxCrime as m 
on c.`Time Period`= m.`Time Period` and c.Total_Cases=m.Highest_Crimes
order by c.Total_Cases desc;

/*Cities with the Highest Crime Rates as a Percentage of Total Reported Crimes*/
SELECT 
    City,
    COUNT(*) AS Total_Cases,
    ((COUNT(*) * 100.0) / (SELECT 
            COUNT(*)
        FROM
            crime_data)) AS Crime_Percentage
FROM
    crime_data
GROUP BY City
ORDER BY Crime_Percentage DESC;

/*Weapon Usage in Violent Crimes: Frequency and Involvement Rate*/
SELECT 
    `Weapon Used`,
    COUNT(*) AS `No. of Times`,
    ((COUNT(*) * 100.0) / (SELECT 
            COUNT(*)
        FROM
            crime_data)) AS `Weapon_Involvement_Rate %`
FROM
    crime_data
WHERE
    `Crime Domain` = 'Violent Crime'
        AND `Weapon Used` <> 'None'
GROUP BY `Weapon Used`
ORDER BY `Weapon_Involvement_Rate %` DESC;

/*Analysis of Crimes Based on Victim Age Groups*/
SELECT 
    CASE
        WHEN `Victim Age` <= 18 THEN 'Age Group under 18yrs'
        WHEN `Victim Age` BETWEEN 19 AND 40 THEN 'Age Group of (19-40)yrs'
        WHEN `Victim Age` > 40 THEN 'Age Group of more than 40yrs'
    END AS Age_Group,
    COUNT(*) AS Total_Cases,
    ((COUNT(*) * 100.0) / (SELECT 
            COUNT(*)
        FROM
            crime_data)) AS `Victim Age Distribution(%)`
FROM
    crime_data
WHERE
    `Crime Domain` = 'Violent Crime'
GROUP BY Age_Group
ORDER BY Total_Cases DESC;

/* Analysis of Crimes Based on Victim Gender */
SELECT 
    `Victim Gender`,
    COUNT(*) AS Total_Cases,
    ((COUNT(*) * 100.0) / (SELECT 
            COUNT(*)
        FROM
            crime_data)) AS `Victim Gender Distribution(%)`
FROM
    crime_data
GROUP BY `Victim Gender`
ORDER BY `Victim Gender Distribution(%)` DESC;

/*Crime Case Status: Closed vs. Pending Percentage Analysis*/
SELECT 
    (COUNT(CASE
        WHEN `Case Closed` = 'Yes' THEN 1
    END) * 100.0 / COUNT(*)) AS `Case_Closure_rate(%)`,
    (COUNT(CASE
        WHEN `Case Closed` = 'No' THEN 1
    END) * 100.0 / COUNT(*)) AS `Pending_case_rate(%)`
FROM
    crime_data;

/*Analysis of Days Taken to Close Cases: Days from Report to Resolution*/
SELECT 
    `Date Reported`,
    `Date Case Closed`,
    City,
    `Crime Description`,
    `Victim Age`,
    `Victim Gender`,
    DATEDIFF(`Date Case Closed`, `Date Reported`) AS `Days Taken to Close`
FROM
    crime_data
WHERE
    `Case Closed` = 'Yes'
ORDER BY `Days Taken to Close` DESC
LIMIT 10;

/*Average Days taken to close a case */
SELECT 
    AVG(DATEDIFF(`Date Case Closed`, `Date Reported`)) AS `Avg Days Taken`
FROM
    crime_data
WHERE
    `Case Closed` = 'Yes';
    
/**/

with crime_time as(
select case when hour(`Time of Occurrence`) between 0 and 3 then 'Late Night (12 AM - 4 AM)' 
when hour(`Time of Occurrence`) between 4 and 7 then 'Early Morning (4 AM - 7 AM)'
when hour(`Time of Occurrence`) between 8 and 11 then 'Early Morning (8 AM - 12 PM)'
when hour(`Time of Occurrence`) between 12 and 15 then 'Afternoon (12 PM - 4 PM)'
when hour(`Time of Occurrence`) between 16 and 19 then 'Evening (4 PM - 8 PM)'
when hour(`Time of Occurrence`) between 20 and 23 then 'Night (8 PM - 12 PM)'
end as `Crime Hour`,
`Victim Gender`,
case when `Victim Age` between 0 and 17 then 'Teenagers & Childrens (0-17 yrs)'
when `Victim Age` between 18 and 30 then 'Adults (18-30 yrs)'
when `Victim Age` between 31 and 50 then 'Middle Aged (31-50 yrs)'
else 'Elderly (50+ yrs)'
end as `Victim Age Group`,
City,
`Crime Description`
from crime_data where `Crime Domain`='Violent Crime' and `Crime Description`="SEXUAL ASSAULT"), crime_stats as (select `Crime Hour`,`Victim Gender`,`Victim Age Group`,City,`Crime Description`,
count(*) as Total_Cases, (count(*)*100.0)/(select count(*) from crime_data where `Crime Domain`="Violent Crime" and `Crime Description`="SEXUAL ASSAULT") as `Crime Percentage` from crime_time
group by City,`Victim Gender`,`Crime Hour`,`Victim Age Group`)
select * from crime_stats order by `Crime Percentage` desc
limit 25;


with crime_time as(
select
`Victim Gender`,
case when `Victim Age` between 0 and 17 then 'Teenagers & Childrens (0-17 yrs)'
when `Victim Age` between 18 and 30 then 'Adults (18-30 yrs)'
when `Victim Age` between 31 and 50 then 'Middle Aged (31-50 yrs)'
else 'Elderly (50+ yrs)'
end as `Victim Age Group`,
City,
`Crime Description`
from crime_data 
where `Crime Domain`='Violent Crime' and `Crime Description`="SEXUAL ASSAULT"), 
crime_stats as 
(select City,
`Victim Age Group`,
`Victim Gender`,
count(*) as Total_Cases, 
round((count(*)*100.0)/(select count(*) from crime_data where `Crime Domain`="Violent Crime" and `Crime Description`="SEXUAL ASSAULT"),3) as `Crime Percentage` 
from crime_time
group by City,`Victim Gender`,`Victim Age Group`)
select * 
from crime_stats 
order by `Crime Percentage` desc limit 25;
