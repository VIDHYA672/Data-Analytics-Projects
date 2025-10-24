SELECT TOP (1000) [Constituency]
      ,[Const_No]
      ,[Parliament_Constituency]
      ,[Leading_Candidate]
      ,[Trailing_Candidate]
      ,[Margin]
      ,[Status]
      ,[State_ID]
      ,[State]
  FROM [party].[dbo].[statewiseresults]
  select * from  state;
  select * from partwiseresults;
  select * from constituencywise;
  select * from constituenywisresults;
    
    select * from state;

    select  
    distinct s.state as statename,
    count(parliament_constituency) as total_seats
    from state s join  statewiseresults r
    on s.State_ID=r.State_ID group by s.state ;

    select distinct party as party_name from partwiseresults
    
   select sum(won) as total_seats_per_NDA ,
SELECT 
    SUM(CASE 
            WHEN party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
            ) THEN [Won]
            ELSE 0 
        END) AS NDA_Total_Seats_Won
FROM 
    partwiseresults


  select  party as part_name,won  as seats_won 
  from partwiseresults
  where party in ( 'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM')
                order by won desc;
           select * from partwiseresults 
           select distinct party from partwiseresults


           select  c.Winning_Candidate,c.Total_Votes,c.Margin,p.Party as party_name,t.State as state_name,s.Constituency as constituency_name
           from constituenywisresults c
           join partwiseresults p on c.Party_ID=p.Party_ID 
            join statewiseresults s on c.Parliament_Constituency=s.Parliament_Constituency 
            join state t on  s.State_ID=t.State_ID
/* What is the distribution of EVM votes versus postal votes for candidates in a specific constituency? */

select  c.Candidate,c.EVM_Votes,c.Party,c.Postal_Votes,c.Total_Votes,s.Constituency
from  constituencywise c  join constituenywisresults n on  c.Constituency_ID=n.Constituency_ID
join statewiseresults s on n.Parliament_Constituency=s.Parliament_Constituency
where s.Constituency='MATHURA'  /* we have specfic  constituency to use below where clause*/
order by c.Total_Votes desc


/* Which parties won the most seats in s State, and how many seats did each party win?*/
with po as(
  select distinct p.Party as party_name,p.won , s.State 
  from partwiseresults p join constituenywisresults c on p.Party_ID=c.Party_ID
  join statewiseresults s on c.Parliament_Constituency=s.Parliament_Constituency
   where  s.State='Andhra Pradesh'
GROUP BY 
    p.Party,p.won , s.State 
ORDER BY 
    p.Won DESC



  group  by  p.Party , max(p.won), s.State 
  )
  select
   distinct p.Party as party_name,p.Won, s.State as state_name
  from  po
  group by max(p.won)



  SELECT 
    p.Party,
    COUNT(cr.Constituency_ID) AS Seats_Won,s.State
FROM 
    constituenywisresults cr
JOIN 
    partwiseresults p ON cr.Party_ID = p.Party_ID
JOIN 
    statewiseresults     sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN state s ON sr.State_ID = s.State_ID
WHERE 
    s.state = 'kerala'
GROUP BY 
    p.Party,s.State
ORDER BY 
    Seats_Won DESC;
  
  
/* What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024 */
select


t.State,
sum(case when
p.party_alliance='NDA' then 1 else 0 end )as NDA_won_seats,
sum(case when p.party_alliance='I.N.D.I.A' then 1 else 0 end) as INDIA_WON_SEATS,
sum(case when p.party_alliance='othes' then 1 else 0 end)as others_seats_won 

from  constituenywisresults c join partwiseresults p on c.Party_ID=p.Party_ID   
join statewiseresults  s on c.Parliament_Constituency=s.Parliament_Constituency
join state t on s.State_ID=t.State_ID
where p.party_alliance in('NDA','I.N.D.I.A','othes')
group by t.State 
order by t.State;





select count( c.Constituency_ID) as toa,s.State,p.party_alliance
from  constituenywisresults c join partwiseresults p on c.Party_ID=p.Party_ID   
join statewiseresults  s on c.Parliament_Constituency=s.Parliament_Constituency
group by s.State,p.party_alliance order by s.State


 /* Which candidate received the highest number of EVM votes in each constituency (Top 10)?*/
 with poo as(
  select  top 10 w.EVM_Votes ,s.Constituency,w.Candidate
  from 
  constituencywise w  join constituenywisresults c on w.Constituency_ID=c.Constituency_ID join 
  statewiseresults s  on c.Parliament_Constituency=s.Parliament_Constituency 
  group by s.Constituency,w.Candidate , w.EVM_Votes
 order by w.EVM_Votes desc
 )
 select count(*) as total_number_rows
  from poo

 /* Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?*/

 select distinct c.Winning_Candidate,t.State,s.Constituency

 from 
 constituenywisresults c join constituencywise o on c.Constituency_ID=o.Constituency_ID 
 join statewiseresults s on c.Parliament_Constituency=s.Parliament_Constituency join 
 state t on t.State_ID=s.State_ID

 select c.*,
 max(total_votes) over() as max_total_votes
 from constituenywisresults c

 select  top 1  max(total_votes) as tot,Winning_Candidate
 from constituenywisresults
 group by Winning_Candidate order by max(total_votes)  desc


 
with winner_runner as  (
 select 
      w.Constituency_Name,c.Total_Votes,
      c.Constituency_ID,
      c.Candidate,
       ROW_NUMBER() over(partition by  c.Constituency_ID order by (c.EVM_Votes + c.Postal_Votes) desc) as rank_wise,
      sum(c.Total_Votes) over(partition by  c.Constituency_ID) as total_votes_per_consultuency
 from 
 constituencywise as c
 join
 constituenywisresults as w on c.Constituency_ID=w.Constituency_ID
)
select
Constituency_ID,constituency_Name,total_votes_per_consultuency,
max(case when rank_wise = 1 then candidate end) as winner,
max(case when rank_wise=  1  then total_votes end ) as winner_votes,
max(case when rank_wise = 2 then candidate end) as ruuner_up,
max(case when rank_wise = 2  then total_votes  end )as runner_votes
from 
winner_runner
where Constituency_ID='U084'
group by Constituency_ID,total_votes_per_consultuency,
Constituency_Name order by Constituency_Name asc

select * from constituencywise;



select  
count( distinct w.Constituency_ID )as total_seats,t.State,
COUNT(DISTINCT c.Candidate) AS Total_Candidates,
    COUNT(DISTINCT p.Party) AS Total_Parties,
    SUM(c.EVM_Votes + c.Postal_Votes) AS Total_Votes,
    SUM(c.EVM_Votes) AS Total_EVM_Votes,
    SUM(c.Postal_Votes) AS Total_Postal_Votes

from   constituencywise  c join constituenywisresults  w on c.Constituency_ID=w.Constituency_ID
join statewiseresults s on w.Parliament_Constituency=s.Parliament_Constituency join state t on s.State_ID=t.State_ID join 
partwiseresults p on p.Party_ID=w.Party_ID
where  t.State = 'Maharashtra'
group by t.State






SELECT 
    COUNT(DISTINCT cr.Constituency_ID) AS Total_Seats,
    COUNT(DISTINCT cd.Candidate) AS Total_Candidates,
    COUNT(DISTINCT p.Party) AS Total_Parties,
    SUM(cd.EVM_Votes + cd.Postal_Votes) AS Total_Votes,
    SUM(cd.EVM_Votes) AS Total_EVM_Votes,
    SUM(cd.Postal_Votes) AS Total_Postal_Votes
FROM 
      constituenywisresults  cr
JOIN 
    constituencywise cd ON cr.Constituency_ID = cd.Constituency_ID
JOIN 

   statewiseresults  sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN 
     state s ON sr.State_ID = s.State_ID
JOIN 
    partwiseresults p ON cr.Party_ID = p.Party_ID
WHERE 
    s.State = 'Maharashtra';




