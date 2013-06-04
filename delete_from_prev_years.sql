delete from contacts             where year <> 2013;
delete from tournaments          where year <> 2013;

-- contents
delete from contents             where year <> 2013;
delete from content_categories   where year <> 2013;

-- activities
delete from attendee_activities  where year <> 2013;
delete from activities           where year <> 2013;
delete from activity_categories  where year <> 2013;

-- from plans to events
delete from attendee_plans       where year <> 2013;
delete from plans                where year <> 2013;
delete from plan_categories      where year <> 2013;
delete from events               where year <> 2013;

-- attendees then shirts
delete from attendees            where year <> 2013;
delete from shirts               where year <> 2013;

-- transactions before users
delete from transactions         where year <> 2013;
delete from users                where year <> 2013;

-- finally, the years
delete from years                where year <> 2013;
