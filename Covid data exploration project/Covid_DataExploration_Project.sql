SELECT *
FROM "CovidDeaths"
Order BY 3,4;
--SELECT *
--FROM "CovidVaccinations"
--Order BY 3,4;

--Select Data we are using
SELECT Location, date, total_cases, new_cases, total_deaths, population_density
FROM "CovidDeaths"
Order BY 1,2

--Total Cases vs Total Deaths
SELECT Location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as DeathPercentage
FROM "CovidDeaths"
Where Location like '%States%'
Order BY 1,2


--Total cases vs population
SELECT Location, date, total_cases,population_density, total_deaths, ((total_cases/population_density)*100) 
FROM "CovidDeaths"
Where Location like '%nada'
Order BY 1,2

--Countries with highest infection rate
SELECT Location,  total_cases, max(total_deaths) as abc
FROM "CovidDeaths"
Where continent is not null
GROUP BY total_cases, Location, total_deaths
order by abc 


--Continent with total deaths

SELECT Continent, max(cast(total_deaths as int)) as deathcount
FROM "CovidDeaths"
Where continent is not null
GROUP BY  Continent
order by deathcount

-- Continents with highest deaths per population
SELECT Continent, max(cast((total_deaths/population_density) as int)) as deathcountperpopulation
FROM "CovidDeaths"
Where continent is not null
GROUP BY  Continent
order by deathcountperpopulation desc


--Global numbers
Select date, count(total_cases) countoftotal, count(total_deaths) countofdeath,((count(cast(total_deaths)as int)/count(cast(total_cases)as int)*100)) as deathpercentage
FROM "CovidDeaths"
--where total_deaths<>0
group by date
order by deathpercentage



--total population vs vaccinations
with PopvsVac (continent,location,date,population_density,new_vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from "CovidDeaths" dea
JOIN "CovidVaccinations" vac
ON dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population_density)*100 as popden
From PopvsVac
order by popden desc

