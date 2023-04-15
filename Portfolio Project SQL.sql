--Select *
--From PortfolioProject.dbo.CovidDeaths
--order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3,4 

Select *
From PortfolioProject.dbo.CovidDeaths

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths
Order By 1,2


--- Total Cases Versus TOtal Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like 'Phi%'
Order By 1,2

-- total case versus total population

Select location, date, population, total_cases,  (total_cases/population)*100 as CasesPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like 'Phi%'
Order By 1,2


-- Highest infection rate by country
Select location, population, Max(total_cases) as MaxCases,  MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like 'Phi%'
Group by location, population
Order By PercentPopulationInfected desc


-- Highest infection rate by country
Select location, population, Max(total_cases) as MaxCases,  CAST(MAX((total_cases/population))*100 AS DECIMAL(10,4)) as PercentPopulationInfected,
RANK() OVER (ORDER BY CAST(MAX((total_cases/population))*100 AS DECIMAL(10,2)) DESC) AS Rank
From PortfolioProject.dbo.CovidDeaths
--Where location like 'Phi%'
Group by location, population
Order By PercentPopulationInfected desc



-- Highest death rate by country
Select top 5 location, population, Max(total_deaths) as TotalDeathCount,  CAST(MAX((total_deaths/population))*100 AS DECIMAL(10,4)) as DeathPercentage,
RANK() OVER (ORDER BY CAST(MAX((total_deaths/population))*100 AS DECIMAL(10,4)) DESC) AS Rank
From PortfolioProject.dbo.CovidDeaths
--Where location like 'Phi%'
Group by location, population
Order By DeathPercentage desc



-- Highest death rate by country
SELECT 
    location, 
    population, 
    MAX(CAST(total_deaths AS int)) AS TotalDeathCount,  
    CAST(MAX((total_deaths/population))*100 AS DECIMAL(10,4)) AS DeathPercentage,
    RANK() OVER (ORDER BY CAST(MAX(CAST(total_deaths AS int))/population*100 AS DECIMAL(10,4)) DESC) AS Rank
FROM PortfolioProject.dbo.CovidDeaths
-- WHERE location LIKE 'Phi%'
where continent is not null
GROUP BY location, population
ORDER BY TotalDeathCount DESC



Select*
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidDeaths as vac
	on dea.location = vac.location
	and dea.date = vac.date


-- Looking at Total Population versus Total Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as CumulativeNewVac
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidDeaths as vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	Order by 2,3