
--- PAN Number Validation Project using SQL ---

-- 1. Identify and handle missing data
select * from pancard where pancard_numbers is null;


-- 2. Check for duplicates
select pancard_numbers, count(1) 
from pancard 
where pancard_numbers is not null
group by pancard_numbers
having count(1) > 1; 

select distinct * from pancard;


-- 3. Handle leading/trailing spaces
select *
from pancard 
where pancard_numbers <> trim(pancard_numbers)


-- 4. Correct letter case
select *
from pancard 
where pancard_numbers <> upper(pancard_numbers)


-- Cleaned Pancard table:

select distinct upper(trim(pancard_numbers)) as pancard_numbers
from pancard 
where pancard_numbers is not null
and trim(pancard_numbers) <> '';


-- Function to check if adjacent characters are repetative. 
-- Returns true if adjacent characters are adjacent else returns false
create or replace function fn_check_adjacent_repetition(p_str text)
returns boolean
language plpgsql
as $$
begin
	for i in 1 .. (length(p_str) - 1)
	loop
		if substring(p_str, i, 1) = substring(p_str, i+1, 1)
		then 
			return true;
		end if;
	end loop;
	return false;
end;
$$



-- Function to check if characters are sequencial such as ABCDE, LMNOP, XYZ etc. 
-- Returns true if characters are sequencial else returns false
create or replace function fn_check_sequence(p_str text)
returns boolean
language plpgsql
as $$
begin
	for i in 1 .. (length(p_str) - 1)
	loop
		if ascii(substring(p_str, i+1, 1)) - ascii(substring(p_str, i, 1)) <> 1
		then 
			return false;
		end if;
	end loop;
	return true;
end;
$$


-- Valid Invalid PAN categorization
create or replace view vw_valid_invalid_pans 
as 
with cte_cleaned_pan as
		(select distinct upper(trim(pancard_numbers)) as pancard_numbers
		from pancard 
		where pancard_numbers is not null
		and trim(pancard_numbers) <> ''),
	cte_valid_pan as
		(select *
		from cte_cleaned_pan
		where fn_check_adjacent_repetition(pancard_numbers) = 'false'
		and fn_check_sequence(substring(pancard_numbers,1,5)) = 'false'
		and fn_check_sequence(substring(pancard_numbers,6,4)) = 'false'
		and pancard_numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]$')
select cln.pancard_numbers
, case when vld.pancard_numbers is null 
			then 'Invalid PAN' 
	   else 'Valid PAN' 
  end as status
from cte_cleaned_pan cln
left join cte_valid_pan vld on vld.pancard_numbers = cln.pancard_numbers;

	
-- Summary report
with cte as 
	(select 
	    (select count(*) from pancard) as total_processed_records,
	    count(*) filter (where vw.status = 'Valid PAN') as total_valid_pans,
	    count(*) filter (where vw.status = 'Invalid PAN') as total_invalid_pans
	from  vw_valid_invalid_pans vw)
select total_processed_records, total_valid_pans, total_invalid_pans
, total_processed_records - (total_valid_pans+total_invalid_pans) as missing_incomplete_PANS
from cte;
  