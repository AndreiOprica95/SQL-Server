SELECT y.location, y.date,y.total_cases, y.New_cases, y.total_deaths, y.population
FROM dbo.Deaths y
ORDER BY 1,2


--Total cases vs Total deaths-- (AKA %people infected that died)

SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM dbo.Deaths 
WHERE location = 'Romania'
ORDER BY 1,2


--Total cases vs population--

SELECT location, date,population, total_cases,  (total_cases/population) * 100 as PercentInfected
FROM dbo.Deaths 
WHERE location = 'Romania'
ORDER BY 2

--Countries with highest infection rate compared to population--

SELECT location,population,MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population)) * 100 as PercentInfected
FROM dbo.Deaths 
--WHERE location = 'Romania'
GROUP BY location,population
ORDER BY PercentInfected DESC

--Showing countries with highest mortality rate--

SELECT location,MAX(CAST(Total_deaths as INT)) as TotalDeathCount --Have to use CAST function because data type for Total_deaths is nvarchar255
FROM dbo.Deaths 
--WHERE location = 'Romania'
WHERE continent IS NOT NULL --This line is because some redundant data within the dataset. If I dont use this line, other irelevant categories show up such as "HigherIncomeClass" or "LowerIncomeClass". I noticed these after I uploaded the dataset into SQL server. Thought I might as well leave them to show my ability to workaround "Dirty Data"
GROUP BY location
ORDER BY TotalDeathCount DESC

--placeholder--

SELECT location,MAX(CAST(Total_deaths as INT)) as TotalDeathCount --Have to use CAST function because data type for Total_deaths is nvarchar255
FROM dbo.Deaths 
--WHERE location = 'Romania'
WHERE continent IS NOT NULL --This line is because some redundant data within the dataset. If I dont use this line, other irelevant categories show up such as "HigherIncomeClass" or "LowerIncomeClass". I noticed these after I uploaded the dataset into SQL server. Thought I might as well leave them to show my ability to workaround "Dirty Data"
GROUP BY location
ORDER BY TotalDeathCount DESC


--Global numbers--

SELECT date, SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as INT)) as TotalDeaths --To get global numbers I have to group by date but I also need the number of cases. Therfore I use new_cases as an workaround(the sum of new_cases adds up to the total of cases per date)
FROM dbo.Deaths 
--WHERE location = 'Romania'
WHERE continent IS NOT NULL --This line is because some redundant data within the dataset. If I dont use this line, other irelevant categories show up such as "HigherIncomeClass" or "LowerIncomeClass". I noticed these after I uploaded the dataset into SQL server. Thought I might as well leave them to show my ability to workaround "Dirty Data"
GROUP BY date
ORDER BY 1,2

--Death percentage Globally--

SELECT date, SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as INT)) as TotalDeaths, SUM(CAST(new_deaths as INT))/SUM(new_cases) * 100 as DeathPercentageGlobally --To get global numbers I have to group by date but I also need the number of cases. Therfore I use new_cases as an workaround(the sum of new_cases adds up to the total of cases per date)
FROM dbo.Deaths 
--WHERE location = 'Romania'
WHERE continent IS NOT NULL --This line is because some redundant data within the dataset. If I dont use this line, other irelevant categories show up such as "HigherIncomeClass" or "LowerIncomeClass". I noticed these after I uploaded the dataset into SQL server. Thought I might as well leave them to show my ability to workaround "Dirty Data"
GROUP BY date
ORDER BY 1,2


--Total population vs vaccination--
--Using Partition By + order by location,date -> The purpose of this is to show the snowball effect of vaccinations. This way we can view the status of each day independently + total overall.
SELECT dea.continent,dea.location, dea.date, dea.population,
		vac.new_vaccinations,
		SUM(CAST(new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) TotalVaccinations
FROM Deaths dea
JOIN Vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--CTE

WITH PopvsVac 
AS
(SELECT dea.continent,dea.location, dea.date, dea.population,
		vac.new_vaccinations,
		SUM(CAST(new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) TotalVaccinations
FROM Deaths dea
JOIN Vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)


SELECT *,(TotalVaccinations/population) * 100 FROM POPVSVAC

--Creating View to store data for later visualisations--


