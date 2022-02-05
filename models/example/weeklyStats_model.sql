{{ config(materialized='table') }}


WITH weeklyGrouped AS (
    SELECT  WEEK( CAST(DATE AS date)) AS Week, SUM(New_Cases) AS NewCases, SUM(New_Deaths) NewDeaths, SUM(New_Recovered) NewRecovered, SUM(New_Active_Cases) NewActiveCases
     FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_HARSH_DHAUNDIYAL" GROUP BY WEEK( CAST(DATE AS date)) 
),

weeklyLag AS(
    SELECT Week, NewCases, NewDeaths, NewRecovered, NewActiveCases,
    LAG(NewCases, 1) OVER(ORDER BY WEEK) AS PrevCases, LAG(NewDeaths, 1) OVER(ORDER BY WEEK) AS PrevDeaths,
    LAG(NewRecovered, 1) OVER(ORDER BY WEEK) AS PrevRecovered
    FROM weeklyGrouped  ),

weekStats AS(
    SELECT Week, NewCases, NewDeaths, NewRecovered, NewActiveCases,  COALESCE(NewCases/PrevCases, 0) AS WeeklyCasesIncrease,
    COALESCE(NewDeaths/PrevDeaths, 0) AS WeeklyDeathsIncrease, COALESCE(NewRecovered/PrevRecovered, 0) AS WeeklyRecoveryIncrease,
    COALESCE( ((NewCases/NewDeaths)/(PrevCases/PrevDeaths)), 0 ) AS WeeklyDeathRateIncrease
    FROM weeklyLag
)

SELECT * FROM weekStats
