# COVID-19 Data Analysis Using MySQL

This project analyzes COVID-19 data with a focus on cases, deaths, and vaccinations across different locations. The data is sourced from 'https://github.com/owid/covid-19-data/tree/master/public/data' and converted to two primary tables: `CovidDeaths` and `CovidVaccinations`. The analysis includes calculating infection and death rates, comparing these rates across various countries and continents, and visualizing vaccination progress.

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Analysis and Results](#analysis-and-results)
- [Conclusions](#conclusions)

## Project Overview

This project aims to provide insights into the impact of COVID-19 through various SQL queries and analyses. The main objectives are to understand the infection and death rates globally and by country, and to track vaccination progress.

## Data Sources

The data is obtained from two tables:
1. `CovidDeaths`: Contains data on COVID-19 cases and deaths.
2. `CovidVaccinations`: Contains data on COVID-19 vaccinations.

## Analysis and Results

1. **Basic Data Retrieval**: Extract and sort basic COVID-19 data by location and date.
2. **Death Percentage Calculation**: Determine the likelihood of dying if one contracts COVID-19.
3. **Infection Rate Calculation**: Calculate the percentage of the population that has contracted COVID-19.
4. **Highest Infection and Death Rates**: Identify countries with the highest infection rates compared to their population and the highest death rates.
5. **Global Statistics**: Summarize global statistics on cases and deaths.
6. **Vaccination Analysis**: Track vaccination progress and calculate the percentage of the population vaccinated.

## Conclusions

This analysis highlights the varying impact of COVID-19 across different regions. It underscores the importance of vaccination and provides a framework for understanding the spread and severity of the virus. The results can inform public health strategies and policy decisions.
