
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

WITH location_cases AS (
    SELECT Location, SUM(Total_Cases) AS TotalCases, SUM(Total_Deaths) AS TotalDeath, SUM(Total_Recovered) AS TotalRecovered, SUM(Total_Active_Cases) AS TotalActiveCases, 
    AVG(Population_Density) AS PopulationDensity, SUM(Total_Deaths) / SUM(TOTAL_CASES) * 100 AS DeathPercentage ,SUM(Total_Recovered) / SUM(TOTAL_CASES) * 100 AS RecoveryPercentage
    FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_HARSH_DHAUNDIYAL" GROUP BY Location ORDER BY SUM(TOTAL_CASES) DESC

)


 SELECT * FROM location_cases
