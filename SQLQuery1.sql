Select *
From Portfolio..Covid_deaths
Order by 3,4

Select *
From Portfolio..Covid_vaccination
Order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From Portfolio..Covid_deaths
Order by 1,2

--Total cases vs total deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_procentage
From Portfolio..Covid_deaths
Where location like '%states%'
Order by 1,2

--looking the total casees vs population

Select location,date,population,total_cases,(total_cases/population)*100 as sickness_procentage
From Portfolio..Covid_deaths
Where location like '%states%'
Order by 1,2

--Countries with highies infecteion rate

Select location,population,max (total_cases) as Highest_infection_rate ,max((total_cases/population))*100 as sickness_procentage
From Portfolio..Covid_deaths
Group by location,population
Order by sickness_procentage desc

--coutnries with highest death count per population

Select location, max(cast(total_deaths as int)) as total_death_count
From Portfolio..Covid_deaths
where continent is not null
Group by location
Order by total_death_count desc

--comparing continets

Select continent, max(cast(total_deaths as int)) as total_death_count
From Portfolio..Covid_deaths
where continent is not null
Group by continent
Order by total_death_count desc


-- Global Numbers


Select  sum (new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deats ,SUM(cast(new_deaths as int))/sum(new_cases)*100
From Portfolio..Covid_deaths
where continent is null
--Group by date
Order by 1,2 


--Total populatoin vs Vaccinations (continent 
with PopvsVac  (Continent,Location,date,population,new_vaccinations,peoplevacc)
as
(
select dea.continent , dea.location ,dea.date, dea.population , vac.new_vaccinations, Sum(convert(bigint,vac.new_vaccinations)) OVER( Partition by dea.location Order by dea.location,dea.date) as peoplevacc
From Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(peoplevacc/population)*100 
from PopvsVac

--Temp table

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
peoplevacc numeric)


insert into #PercentPopulationVaccinated
select dea.continent , dea.location ,dea.date, dea.population , vac.new_vaccinations, Sum(convert(bigint,vac.new_vaccinations)) OVER( Partition by dea.location Order by dea.location,dea.date) as peoplevacc
From Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * ,(peoplevacc/population)*100 
from #PercentPopulationVaccinated

--creating view

 Create view PercentPopulationVaccinated as
 Select dea.continent , dea.location ,dea.date, dea.population , vac.new_vaccinations, Sum(convert(bigint,vac.new_vaccinations)) OVER( Partition by dea.location Order by dea.location,dea.date) as peoplevacc
From Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated 





