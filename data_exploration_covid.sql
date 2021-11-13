USE covidProject;

/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM covid_deaths;
SELECT * FROM covid_vaccinations;

-- Select Data that we are going to be starting with
SELECT 
	location, 
	date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT 
	location, 
	date, 
    total_cases,
    total_deaths, 
    (total_deaths/total_cases) * 100 AS death_percentage
FROM covid_deaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in the United States

SELECT 
	location, 
    date, 
    population, 
    total_cases,
    (total_cases/population) * 100 AS percent_population_infected
FROM covid_deaths
WHERE location = 'United States'
ORDER BY 1,2;


-- Countries with Highest Infection Rate compared to Population
SELECT 
	location, 
    population, 
    MAX(total_cases) AS highest_infection_count,  
    MAX(total_cases / population) * 100 AS percent_population_infected
FROM covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- Countries with Highest Death Count per Population
SELECT 
	location, 
	MAX(total_deaths) as total_death_count
FROM covid_deaths
-- Where location like '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
SELECT 
	continent, 
    MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths, 
    SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM covid_deaths dea
INNER JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;




