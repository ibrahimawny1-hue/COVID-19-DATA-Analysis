select *
from CovidDeaths cd 
order by 3,4


--selsct Date

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths cd 
order by 1,2


--اجمالي الحالات مقابل اجمالي وفيات
--نسبه الوفيات للبلد

select location,date,total_cases,total_deaths,(cast(total_deaths as float)/total_cases)*100 as percentage
from CovidDeaths cd 
where location like '%Africa%'
order by 1,2


-- اجمالي الحالات بالنسبه للسكان 
--نسبه للمصابين

select location,date,total_cases,population,(cast(total_cases as float) /population)*100 as percentage
from CovidDeaths cd 
--where location like '%State%'
order by 1,2


--الدوله زات اعلي معدل اصابه
 
select location ,population , max(cast(total_cases as int)) as max_strate 
,max( cast(total_cases as float)/population)*100 as populationinfected
from CovidDeaths cd 
group by 1,2




--دوله ذات اعلي معدل وفيات


select location , max(cast(total_deaths  as int)) as thetotalDeath
from CovidDeaths cd 
group by location
order by 2 desc



-- عدد الوفيات حسب القاره


select continent  , max(cast(total_deaths  as int)) as thetotalDeath
from CovidDeaths cd 
where continent is not null
and continent<>''
group by continent
order by 2 desc


--number of Data



select date,  sum(cast(total_deaths  as int)) as total_lDeath , sum(new_cases) as total_newCases,
sum(cast(total_deaths  as int))/ sum(new_cases)*100 as death 
from CovidDeaths cd 
where continent is not null
group by date
order by 1,2



--

select  max(cast(total_deaths  as int)) as total_Death , sum(new_cases) as total_Cases,MAX(cast(total_deaths as int)) as max_death,
max(cast(total_deaths  as int))/ sum(new_cases)*100 as death_percentage 
from CovidDeaths cd 
where continent is not null


-- 

select *
from CovidVaccinations cv 







select *
from CovidDeaths cd 
join CovidVaccinations cv 
on cd.continent = cv.continent 
and cd.date = cv.date 
and cd.location = cv.location 





-- اجمالي السكان ال تم تطعيمهم

--use CTE


with cdvscv(location,continent,date,population,new_vaccinations,totalvaccinations)
as
(
select cd.location ,cd.continent ,cd.population ,cd.date,cv.new_vaccinations_smoothed,
sum(cast(cv.new_vaccinations_smoothed  as int)) over (partition by cd.location order by cd.location ,cd.date ) as totalvaccinations
from CovidDeaths cd 
join CovidVaccinations cv 
on cd.continent = cv.continent 
and cd.date = cv.date 
and cd.location = cv.location 
 where cd.continent is not null 
--order by 1,2
)
select* ,(totalvaccinations/population)*100 as populationParcentage
from cdvscv



--Temp Table


Drop Table if exists percetpopulation
CREATE Temp table percetpopulation
(
location nvarchar(255),
continent nvarchar(255),
population float,
Date datetime,
new_vaccinations float ,
totalvaccinations float
)



insert into percetpopulation

select cd.location ,cd.continent ,cd.population ,cd.date,cv.new_vaccinations_smoothed,
sum(cast(cv.new_vaccinations_smoothed  as int)) over (partition by cd.location order by cd.location ,cd.date ) as totalvaccinations
from CovidDeaths cd 
join CovidVaccinations cv 
on cd.continent = cv.continent 
and cd.date = cv.date 
and cd.location = cv.location 
 --where cd.continent is not null 

select* ,(totalvaccinations/population)*100 as populationParcentage
from percetpopulation





--Creating view to store data foy Visualizat

CREATE view percetpopulation as

select cd.location ,cd.continent ,cd.population ,cd.date,cv.new_vaccinations_smoothed,
sum(cast(cv.new_vaccinations_smoothed  as int)) over (partition by cd.location order by cd.location ,cd.date ) as totalvaccinations
from CovidDeaths cd 
join CovidVaccinations cv 
on cd.continent = cv.continent 
and cd.date = cv.date 
and cd.location = cv.location 
 where cd.continent is not null 
 
 
 select *
 from percetpopulation

