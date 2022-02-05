
-- Use the `ref` function to select from other models

{{ config(materialized='table') }}


WITH monthGrouped AS (
    SELECT  MONTH( CAST(DATE AS date)) AS Month, SUM(New_Cases) AS NewCases, SUM(New_Deaths) NewDeaths, SUM(New_Recovered) NewRecovered, SUM(New_Active_Cases) NewActiveCases
     FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_HARSH_DHAUNDIYAL" GROUP BY MONTH( CAST(DATE AS date)) 
),

monthLag AS(
    SELECT Month,  NewCases, NewDeaths, NewRecovered, NewActiveCases,
    LAG(NewCases, 1) OVER(ORDER BY MONTH) AS PrevCases, LAG(NewDeaths, 1) OVER(ORDER BY MONTH) AS PrevDeaths,
    LAG(NewRecovered, 1) OVER(ORDER BY MONTH) AS PrevRecovered
    FROM monthGrouped  ),

monthStats AS(
    SELECT Month, NewCases, NewDeaths, NewRecovered, NewActiveCases,  COALESCE(NewCases/PrevCases, 0) AS MonthlyCasesIncrease,
    COALESCE(NewDeaths/PrevDeaths, 0) AS MonthlyDeathsIncrease, COALESCE(NewRecovered/PrevRecovered, 0) AS MonthlyRecoveryIncrease,
    COALESCE( ((NewCases/NewDeaths)/(PrevCases/PrevDeaths)), 0 ) AS MonthlyDeathRateIncrease
    FROM monthLag
)

SELECT * FROM monthStats
