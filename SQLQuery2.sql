
SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--oRDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Total Cases vs Total Deaths
--Shows the likelihood of dying if one contracacted covid
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'India'
ORDER BY 1,2

--Total Cases vs Population
-- Percentage of population that has gotten covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as covid_percentage
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
ORDER BY 1,2

-- Percentage of population in India that has gotten covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as covid_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'India'
ORDER BY 1,2

--Countries with highest infection rate compared to population
SELECT location, max(total_cases) as highest_count, population, max((total_cases/population))*100 as percent_infected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
GROUP BY location, population
ORDER BY percent_infected desc


--Countries with highest death rate compared to population
SELECT location, max(cast(total_deaths as int)) as highest_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY highest_death_count desc

--Highest death rate by continent
SELECT location, max(cast(total_deaths as int)) as highest_death_count_by_continent
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY location   
ORDER BY highest_death_count_by_continent desc

--Global stats
SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , 
       sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
WHERE continent is not null
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--Using CTE
WITH PopVsVac (continent, location, date, population,new_vaccinations, current_vaccinations)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

SELECT* , (current_vaccinations/population)*100 as percentage_vaccinated
FROM PopVsVac

--using temp table
DROP TABLE IF exists #percentVaccinated
CREATE TABLE #percentVaccinated
(
continent nvarchar(25),
location nvarchar(25),
date datetime,
population numeric,
new_vaccinations numeric,
current_vaccinations numeric
)

INSERT INTO #percentVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT* , (current_vaccinations/population)*100 
FROM #percentVaccinated


--creating view to store data for visualizations
CREATE VIEW PercentVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentVaccinated