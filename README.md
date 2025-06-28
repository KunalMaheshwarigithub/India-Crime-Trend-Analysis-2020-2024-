# 🕵️‍♂️ Crime Analysis in India (2020–2024)

This project performs a detailed SQL-based analysis of crime records in India from **January 2020 to August 2024**. It explores crime trends, victim demographics, case status, and city-level distributions using MySQL queries.

---

## 📌 Project Overview

Using structured queries, this project identifies:

- Most common crimes
- Time-based crime trends
- Weapon usage in violent crimes
- City-wise crime rates
- Case closure vs. pending cases
- Gender and age-wise analysis of victims
- In-depth analysis of sexual assault cases

---

## 🗃️ Dataset Structure

The project uses a single table: **`crime_data`**

### Key Columns:
- `Crime Description`
- `Crime Domain`
- `Victim Gender`, `Victim Age`
- `City`
- `Date Reported`, `Time of Occurrence`, `Date Case Closed`
- `Case Closed` (Yes/No)
- `Weapon Used`

---

## ⚙️ Technologies Used

- MySQL Wrokbench and Server (Queries and Analysis)


---
## Published an Article on linkedin upon this Analysis, to view follow this link: 
https://www.linkedin.com/posts/kunal-maheshwari-189777251_unveiling-crime-patterns-through-data-analysis-activity-7307146261730680833-LMWN?utm_source=share&utm_medium=member_desktop&rcm=ACoAAD46SzkBJMRQQ3lUIGLLoI9Dd4a_O3sq3T4

## Analysis Description

Each insight is backed by SQL queries, demonstrating how raw data transforms into meaningful conclusions.

🔍 Crime Trends & Patterns: A Data-Driven Analysis
# 📊 1. Most Common Crimes (Jan 2020 - Aug 2024) 

# Query : 
SELECT 
    `Crime Description`, 
    COUNT(*) AS Total_Cases
FROM crime_data
GROUP BY `Crime Description`
ORDER BY Total_Cases DESC
LIMIT 10;


# Based on my analysis of crime records from January 2020 to August 2024, the most frequently occurring crimes are:

📌 Most Prevalent Crimes:

Burglary (1,980 cases) tops the list, indicating property-related offenses are highly common.
Vandalism (1,975 cases) follows closely, suggesting a significant number of cases involving damage to property.

📌 Financial & Identity Crimes:

Fraud (1,965 cases) and Identity Theft (1,918 cases) highlight the increasing concern over financial and cyber-related crimes.

📌 Violent Crimes:

Domestic Violence (1,932 cases), Sexual Assault (1,917 cases), and Assault (1,915 cases) emphasize ongoing issues with violent offenses.
Kidnapping (1,920 cases) and Robbery (1,928 cases) further underscore security concerns.

📌 Firearm-Related Offenses:

Firearm Offenses (1,931 cases) indicate a strong link between crime rates and weapon accessibility.

🚨 Key Takeaways:

Property crimes (Burglary & Vandalism) dominate the list.
Financial crimes like Fraud and Identity Theft are rising threats.
Violent crimes remain a major concern, requiring strong intervention.

# 📅 2. Crime Trends Over Time

# Query : 
SELECT 
    YEAR(`Time of Occurrence`) AS `Year`,
    MONTHNAME(`Time of Occurrence`) AS `Month`,
    COUNT(*) AS Total_Registered_Cases
FROM crime_data
GROUP BY `Year`, `Month`;


# Key Observations:
The highest number of cases in a single month appears to be 750 (May 2021).
The summer months (March – May) consistently show higher crime numbers, possibly indicating seasonal trends in criminal activities.
February often has lower cases compared to other months (e.g., February 2020: 695, February 2021: 674, February 2022: 669, February 2023: 674), which may indicate a trend of lower crime occurrences in this month.
2020 saw an increase in cases from February to August, followed by a decline in September and a slight rise in October.
2021 continued this pattern, with a peak in May (750 cases) and lower cases in June (714).
2022 and 2023 show a stable range of crime cases with occasional spikes.
In early 2024, crime cases seem relatively moderate, with March and April showing 744 and 721 cases, respectively.



# ⏰ 3. Peak Crime Hours

# Query : 
WITH CrimeRank AS (
  SELECT 
    CASE 
      WHEN HOUR(`Time of Occurrence`) BETWEEN 0 AND 3 THEN 'Late Night (12 AM - 4 AM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 4 AND 7 THEN 'Early Morning (4 AM - 8 AM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 8 AND 11 THEN 'Morning (8 AM - 12 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 12 AND 15 THEN 'Afternoon (12 PM - 4 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 16 AND 19 THEN 'Evening (4 PM - 8 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 20 AND 23 THEN 'Night (8 PM - 12 PM)' 
    END AS `Time Period`,
    `Crime Description`,
    COUNT(*) AS Total_Cases
  FROM crime_data
  GROUP BY `Time Period`, `Crime Description`
),
MaxCrime AS (
  SELECT `Time Period`, MAX(Total_Cases) AS Highest_Crimes 
  FROM CrimeRank 
  GROUP BY `Time Period`
)
SELECT 
  c.`Time Period`,
  c.`Crime Description`,
  c.Total_Cases
FROM CrimeRank c
JOIN MaxCrime m 
  ON c.`Time Period` = m.`Time Period` AND c.Total_Cases = m.Highest_Crimes
ORDER BY c.Total_Cases DESC;


# Key Insights:
Early Morning (4 AM - 8 AM): The highest reported crime is Vandalism. This could be linked to fewer people on the streets and a higher chance for property destruction.
Morning (8 AM - 12 PM): Fraud cases peak, likely due to financial transactions, scams, or cyber fraud activity during working hours.
Afternoon (12 PM - 4 PM): Homicide is surprisingly high in this period, possibly due to domestic disputes or planned attacks.
Evening (4 PM - 8 PM): Robbery spikes during this time, when people return from work, making them potential targets.
Night (8 PM - 12 AM): Traffic Violations dominate, possibly due to reckless driving or DUI cases.
Late Night (12 AM - 4 AM): Sexual Assault cases peak, highlighting safety concerns in isolated areas.

# 🌍 4. Crime Hotspots: Analyzing the Most Crime-Prone Areas

# Query : 
SELECT 
    City,
    COUNT(*) AS Total_Cases,
    ((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM crime_data)) AS Crime_Percentage
FROM crime_data
GROUP BY City
ORDER BY Crime_Percentage DESC;

# Key Insights:
🔴 Top Crime-Contributing Cities:
Delhi – 5,400 cases (≈13.45%)

Highest number of reported crimes, making it the most crime-prone city in the dataset.

Mumbai – 4,415 cases (≈10.99%)

Second-highest crime volume.

Bangalore – 3,588 cases (≈8.93%)

Significant contributor to national crime statistics.

🟠 Other High-Crime Cities:
Hyderabad, Kolkata, Chennai – Each contributes over 6% of total reported crimes.

These cities show dense urban crime patterns, likely due to population and urban stress.

🟡 Mid-Tier Cities:
Pune, Ahmedabad, Jaipur, Lucknow – Ranging from ~3.6% to 5.5%.

These cities are emerging urban centers with moderate crime levels.

🟢 Lower Crime-Reported Cities (Below 2%):
Agra, Ludhiana, Visakhapatnam, Thane, Ghaziabad, Indore

Patna, Bhopal, Meerut, Srinagar, Nashik, Vasai, Varanasi

These cities have fewer reported crimes, possibly due to smaller populations, better law enforcement, or underreporting.

📈 What This Tells Us:
The top 6 cities alone account for over 50% of total crime.

Urbanization, population density, and economic disparities may contribute to higher crime rates.

Smaller cities still face crime issues but at relatively lower intensity.


# 🔍5. Analyzing Crimes by Weapon Used: A Data-Driven Insight

# Query : 
SELECT 
    `Weapon Used`,
    COUNT(*) AS `No. of Times`,
    ((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM crime_data)) AS `Weapon_Involvement_Rate %`
FROM crime_data
WHERE `Crime Domain` = 'Violent Crime'
  AND `Weapon Used` <> 'None'
GROUP BY `Weapon Used`
ORDER BY `Weapon_Involvement_Rate %` DESC;


# Key Insights:

✅ Firearms & explosives are the top contributors to violent crimes.

✅ Blunt objects & poison show a similar crime pattern, possibly in domestic violence cases.

✅ Knives, though lower in percentage, remain a significant threat in violent incidents.



# 🔍 Victim Demographics: A Deep Dive into Crime Data
# 👶👨🦳1. Crime Victimization by Age Group: Who is Most at Risk?

# Query : 
SELECT 
  CASE
    WHEN `Victim Age` <= 18 THEN 'Age Group under 18yrs'
    WHEN `Victim Age` BETWEEN 19 AND 40 THEN 'Age Group of (19-40)yrs'
    WHEN `Victim Age` > 40 THEN 'Age Group of more than 40yrs'
  END AS Age_Group,
  COUNT(*) AS Total_Cases,
  ((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM crime_data)) AS `Victim Age Distribution(%)`
FROM crime_data
WHERE `Crime Domain` = 'Violent Crime'
GROUP BY Age_Group
ORDER BY Total_Cases DESC;

# Key Insights:
🔺 Most victims (55.46%) are over 40 years old, making them the most vulnerable to violent crimes.

🟠 Adults aged 19–40 are the second most affected group.

🧒 Children and teenagers (under 18) form the smallest group, but still a concerning 12.75%.

This shows that elderly and middle-aged people face a disproportionately high risk in violent crimes, highlighting the need for targeted protective measures for them.


# 👶🧑🦳 Who Are the Most Targeted Age Groups in Violent Crimes?

# Query : 
SELECT 
  CASE
    WHEN `Victim Age` <= 18 THEN 'Age Group under 18yrs'
    WHEN `Victim Age` BETWEEN 19 AND 40 THEN 'Age Group of (19-40)yrs'
    WHEN `Victim Age` > 40 THEN 'Age Group of more than 40yrs'
  END AS Age_Group,
  COUNT(*) AS Total_Cases,
  ((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM crime_data)) AS `Victim Age Distribution(%)`
FROM crime_data
WHERE `Crime Domain` = 'Violent Crime'
GROUP BY Age_Group
ORDER BY Total_Cases DESC;

# Key Intakes
🔺 Most victims (55.46%) are over 40 years old, making them the most vulnerable to violent crimes.

🟠 Adults aged 19–40 are the second most affected group.

🧒 Children and teenagers (under 18) form the smallest group, but still a concerning 12.75%.



 # 🚻 2.Gender-Wise Crime Distribution (2020-2024) 🔎

# Query : 
SELECT 
  `Victim Gender`,
  COUNT(*) AS Total_Cases,
  ((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM crime_data)) AS `Victim Gender Distribution(%)`
FROM crime_data
GROUP BY `Victim Gender`
ORDER BY `Victim Gender Distribution(%)` DESC;

# 🔎 Key Observations:
👩 Female Victims (F):

The highest percentage of cases (55.83%) involve female victims.
Crimes like domestic violence, harassment, and sexual offenses are major contributors.

👨 Male Victims (M):

Male victims make up 33.37% of total cases.
Crimes involving assault, robbery, and homicide are more common.

 Other Gender (X):

10.79% of cases involve individuals outside the traditional male-female binary.
This highlights the growing need for awareness and protection of marginalized gender groups.


# 🚔 Law Enforcement Effectiveness: A Deep Dive into Case Closures
# 🔎 Case Closure Rate Analysis (2020-2024): How Efficient Is the Justice System?

# Query : 
SELECT 
  (COUNT(CASE WHEN `Case Closed` = 'Yes' THEN 1 END) * 100.0 / COUNT(*)) AS `Case_Closure_rate(%)`,
  (COUNT(CASE WHEN `Case Closed` = 'No' THEN 1 END) * 100.0 / COUNT(*)) AS `Pending_case_rate(%)`
FROM crime_data;

# ⚖️ What This Means:
📌 Nearly half of all cases are still pending, raising concerns about delays in justice. 

📌 An efficient legal system should aim for a higher closure rate to ensure victim support and reduce case backlog. 

📌 More resources for law enforcement could help improve closure rates.



# ⏳ How Long Does It Take to Close a Case? A Deep Dive into Case Closure Time
Top 10 Cases That Took the Longest to Close

# Query : 
SELECT 
  `Date Reported`,
  `Date Case Closed`,
  City,
  `Crime Description`,
  `Victim Age`,
  `Victim Gender`,
  DATEDIFF(`Date Case Closed`, `Date Reported`) AS `Days Taken to Close`
FROM crime_data
WHERE `Case Closed` = 'Yes'
ORDER BY `Days Taken to Close` DESC
LIMIT 10;

# Key Insights :
⏳ 729 days (2 years) is the longest duration taken to close multiple cases.

These long durations include serious crimes like HOMICIDE and SEXUAL ASSAULT.

Cases are from cities like Mumbai, Kanpur, Pune, Chennai, Hyderabad, Delhi, etc.

Some victims were as young as 10 and as old as 75, indicating age is not a deciding factor in how fast cases are closed.

Gender marked as X appears in multiple long-duration cases, possibly suggesting missing/undisclosed data.

# Average Case Closure Time 
# Query :
SELECT 
  AVG(DATEDIFF(`Date Case Closed`, `Date Reported`)) AS `Avg Days Taken`
FROM crime_data
WHERE `Case Closed` = 'Yes';

# Key Insights
📌 Top 10 Longest Case Closures The cases with the longest resolution times took between 727 to 729 days to close. These cases predominantly involved homicide and sexual assault, with victims from various age groups and genders.

📌 Fastest Case Closures On the other hand, several cases—mostly related to public intoxication and traffic violations—were closed in just 1 day.

📌 Overall Average Case Closure Time The average number of days taken to close a case was 88.06 days, highlighting variations based on crime type and location.

⏳ What This Tells Us:

🚨 Serious crimes take significantly longer to resolve, often spanning years.
⚡ Minor offenses are handled swiftly, typically closed within a day.
🔄 Law enforcement efficiency varies, and improving the resolution of severe crimes remains a challenge

# 🔎 17. Top 25 Cities in Sexual Assault (Time, Gender, Age)
# Query :
WITH crime_time AS (
  SELECT 
    CASE 
      WHEN HOUR(`Time of Occurrence`) BETWEEN 0 AND 3 THEN 'Late Night (12 AM - 4 AM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 4 AND 7 THEN 'Early Morning (4 AM - 7 AM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 8 AND 11 THEN 'Early Morning (8 AM - 12 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 12 AND 15 THEN 'Afternoon (12 PM - 4 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 16 AND 19 THEN 'Evening (4 PM - 8 PM)'
      WHEN HOUR(`Time of Occurrence`) BETWEEN 20 AND 23 THEN 'Night (8 PM - 12 PM)'
    END AS `Crime Hour`,
    `Victim Gender`,
    CASE 
      WHEN `Victim Age` BETWEEN 0 AND 17 THEN 'Teenagers & Children (0-17 yrs)'
      WHEN `Victim Age` BETWEEN 18 AND 30 THEN 'Adults (18-30 yrs)'
      WHEN `Victim Age` BETWEEN 31 AND 50 THEN 'Middle Aged (31-50 yrs)'
      ELSE 'Elderly (50+ yrs)'
    END AS `Victim Age Group`,
    City,
    `Crime Description`
  FROM crime_data 
  WHERE `Crime Domain` = 'Violent Crime' AND `Crime Description` = "SEXUAL ASSAULT"
),
crime_stats AS (
  SELECT 
    `Crime Hour`, `Victim Gender`, `Victim Age Group`, City, `Crime Description`,
    COUNT(*) AS Total_Cases, 
    (COUNT(*) * 100.0) / (SELECT COUNT(*) 
                          FROM crime_data 
                          WHERE `Crime Domain` = 'Violent Crime' AND `Crime Description` = "SEXUAL ASSAULT") AS `Crime Percentage`
  FROM crime_time
  GROUP BY City, `Victim Gender`, `Crime Hour`, `Victim Age Group`
)
SELECT * FROM crime_stats ORDER BY `Crime Percentage` DESC LIMIT 25;

# Key Insights :
🔺 Most Affected Group:
Mumbai (Elderly Females) and Delhi (Elderly Females) both top the list with 59 cases each, contributing ~3.08% each to total sexual assault crimes.

The elderly (50+ years)—especially women—appear most frequently in the top rows, which is alarming.

👵 Age Group Trends:
Elderly (50+ yrs) victims dominate the list, indicating a worrying pattern of vulnerability among senior citizens.

Middle-aged (31–50 yrs) and Adults (18–30 yrs) also appear, but less frequently in the top cases.

👨‍👩‍👧‍👦 Gender Trends:
Most cases involve female victims (F), but some male (M) and unspecified (X) gender victims are present, showing a broader spectrum of victimization.

🏙️ City Hotspots:
Delhi, Mumbai, Hyderabad, Bangalore, Kolkata, Chennai, Pune, Ahmedabad are recurrent—clearly hotspots for such violent incidents.

Delhi appears most often across various gender and age groups.

# Thank You for Reading 

## 🧑‍💻 Author
# Kunal Maheshwari
Aspiring Data Engineer & Analyst
