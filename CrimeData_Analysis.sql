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

select distinct(`Crime Description`) from crime_data; 

/* Total number of sexual assault cases categorized by victim gender from January 2020 to August 2024*/
Select `Victim Gender`,`Crime Description`,count(*) as Total_Cases from crime_data where `Crime Description`="SEXUAL ASSAULT" group by `Victim Gender`;

/* Total sexual assault cases reported in various cities by gender (Jan 2020 - Aug 2024).*/
select City,`Crime Description`,`Victim Gender`,count(*) as Total_Cases from crime_data where `Crime Description` = "SEXUAL ASSAULT" 
group by City,`Victim Gender` order by Total_Cases desc;  

/* Total number of pending sexual assault cases within the specified time period. */
select `Victim Gender`,count(*) as Total_Pending_Cases from crime_data where `Crime Description` = "SEXUAL ASSAULT" and `Case Closed`="No" group by `Victim Gender`;

/*Percentage of solved sexual assault cases categorized by victim gender within the specified time period.*/
SELECT 
    `Victim Gender`, 
    (COUNT(CASE WHEN `Case Closed` = 'Yes' THEN 1 END) * 100.0 / COUNT(*)) AS `Solved Percentage`
FROM crime_data
WHERE `Crime Description` = 'SEXUAL ASSAULT'
GROUP BY `Victim Gender`;

/*The most commonly reported crimes during the time frame.*/
select `Crime Description`,count(*) as Total_Cases 
from crime_data group by `Crime Description` order by Total_Cases desc limit 10;

/*Monthly and Yearly Crime Trends: Identifying Seasonal Patterns in Crime Data*/
select year(`Time of Occurrence`) as `Year`,
monthname(`Time of Occurrence`) as `Month`, 
count(*) as Total_Registered_Cases 
from crime_data group by `Year`,`Month`;

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
select City , count(*) as Total_Cases, ((count(*)*100.0) / (select count(*) from crime_data)) as Crime_Percentage 
from crime_data group by City order by Crime_Percentage desc;

/*Weapon Usage in Violent Crimes: Frequency and Involvement Rate*/
select `Weapon Used`,count(*) as `No. of Times`, 
((count(*)*100.0)/(select count(*) from crime_data)) as `Weapon_Involvement_Rate %`
from crime_data
where `Crime Domain`=  "Violent Crime" and `Weapon Used`<>'None' group by `Weapon Used`
order by `Weapon_Involvement_Rate %` desc;

/*Analysis of Crimes Based on Victim Age Groups*/
select case when `Victim Age` <= 18 then 'Age Group under 18yrs'
when `Victim Age` between 19 and 40 then 'Age Group of (19-40)yrs'
when `Victim Age` >40 then 'Age Group of more than 40yrs'
end as Age_Group,count(*) as Total_Cases , 
((count(*)*100.0)/(select count(*) from crime_data)) as `Victim Age Distribution(%)` 
from crime_data  where `Crime Domain` = "Violent Crime"group by Age_Group
order by Total_Cases desc;

/* Analysis of Crimes Based on Victim Gender */
select `Victim Gender`, count(*) as Total_Cases , 
((count(*)*100.0)/(select count(*) from crime_data)) as `Victim Gender Distribution(%)` 
from crime_data group by `Victim Gender` order by `Victim Gender Distribution(%)` desc;

/*Crime Case Status: Closed vs. Pending Percentage Analysis*/
select (count(case when `Case Closed`='Yes' then 1 end)*100.0/ count(*) ) as `Case_Closure_rate(%)`,
(count(case when `Case Closed`="No" then 1 end)*100.0/count(*)) as `Pending_case_rate(%)` 
from crime_data ;

/*Analysis of Days Taken to Close Cases: Days from Report to Resolution*/
select `Date Reported`, `Date Case Closed` , City,`Crime Description`,`Victim Age`, `Victim Gender`,
datediff(`Date Case Closed`,`Date Reported`) as `Days Taken to Close` 
from crime_data where `Case Closed`="Yes" order by `Days Taken to Close` desc limit 10;

/*Average Days taken to close a case */
select avg(datediff(`Date Case Closed`,`Date Reported`)) as `Avg Days Taken` 
from crime_data where `Case Closed` = "Yes";

