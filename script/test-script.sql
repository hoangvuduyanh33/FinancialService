select count(*) 
from loan_dimension LD join loan_started_date_dimension LSDD 
where LD.LoanStartedDateKey = LSDD.LoanStartedDateKey
group by LSDD.LoanStartedYear;

select count(*) 
from loan_dimension LD join loan_started_date_dimension LSDD join loan_transaction_facts LTF join customer_demographic_dimension CDD
where LD.LoanStartedDateKey = LSDD.LoanStartedDateKey and LTF.LoanKey = LD.LoanKey and CDD.CustomerDemographicKey = LTF.CustomerDemographickey
group by LSDD.LoanStartedYear;


drop schema financial_service_database;
create schema financial_service_database;
drop schema financial_service_datawarehouse;
create schema financial_service_datawarehouse;

select count(*) from loan_transaction;
select sum(amount) from loan_transaction where amount < 0;

select avg(LC.lifespan) from loan L join loan_category LC 
where L.CategoryID = LC.CategoryID;

select * from 
