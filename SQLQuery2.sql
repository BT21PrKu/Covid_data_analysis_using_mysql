
Select *
From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Total Cases vs Total Deaths
--Shows the likelihood of dying if one contracacted covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where location = 'India'
order by 1,2

--Total Cases vs Population
-- Percentage of population that has gotton covid
Select Location, date, total_cases, Population, (total_cases/Population)*100 as covid_percentage
From PortfolioProject..CovidDeaths
--Where location = 'India'
order by 1,2

Select Location, date, total_cases, Population, (total_cases/Population)*100 as covid_percentage
From PortfolioProject..CovidDeaths
Where location = 'India'
order by 1,2

--Countries with highest infection rate compared to population
Select Location, max(total_cases) as HighestCount, population, max((total_cases/population))*100 as Percent_Infected
From PortfolioProject..CovidDeaths
--Where location = 'India'
group by location, population
order by Percent_Infected desc


--Countries with highest death rate compared to population
Select Location, max(cast(total_deaths as int)) as Highest_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
group by location
order by Highest_Death_Count desc

--Highest death rate by continent
Select location, max(cast(total_deaths as int)) as Highest_Death_Count_By_Continent
From PortfolioProject..CovidDeaths
Where continent is null
group by location   
order by Highest_Death_Count_By_Continent desc

--Global stats
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , 
    sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
--Where location = 'India'
Where continent is not null
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Using CTE
with PopVsVac (continent, location, date, population,new_vaccinations, current_vaccinations)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select* , (current_vaccinations/population)*100 as percentage_vaccinated
from PopVsVac

--using temp table
drop table if exists #percentVaccinated
create table #percentVaccinated
(
Continent nvarchar(25),
Location nvarchar(25),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Current_Vaccinations numeric
)

insert into #percentVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select* , (current_vaccinations/population)*100 
from #percentVaccinated


--creating view to store data for visualizations
create view PercentVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as current_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select *
from PercentVaccinated