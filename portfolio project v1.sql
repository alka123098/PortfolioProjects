SELECT *
FROM Portfolio_Project..covid_deaths$
ORDER BY 5 DESC

--selecting data required

SELECT location,date,total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..covid_deaths$
ORDER BY 1,2

--finiding out infectionpercent total_cases/population
SELECT location,date,total_cases,population,(total_cases/population)*100 as infection_rate
FROM Portfolio_Project..covid_deaths$
WHERE location ='India'
ORDER BY 1,2

-- finiding max population infected

SELECT location,population,MAX(total_cases),MAX(total_cases/population)*100 as infection_rate
FROM Portfolio_Project..covid_deaths$
GROUP BY location,population
ORDER BY infection_rate DESC

--Finiding max deaths percent

SELECT location,MAX(CAST(total_deaths as int)) as total_death_count
FROM Portfolio_Project..covid_deaths$
WHERE continent!='NULL'
GROUP BY location
ORDER BY total_death_count DESC

-- Showing continents with the highest death counts per population
SELECT continent,MAX(CAST(total_deaths as int)) as total_death_count
FROM Portfolio_Project..covid_deaths$
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC

SELECT *
FROM Portfolio_Project..covid_vaccinations$

-- total population vs total vaccinations
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.date,dea.location) as rolling_vacination
FROM Portfolio_Project..covid_deaths$ dea
JOIN Portfolio_Project..covid_vaccinations$ vac
    ON dea.location=vac.location and
	dea.date=vac.date
where dea.continent is not null
ORDER BY 2,3
