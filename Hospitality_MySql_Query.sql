create database Hospitality;
use hospitality;

select * from dim_date;
select * from dim_hotels;
select * from dim_rooms;
select * from fact_aggregated_bookings;
select* from fact_bookings;

/* 1.Total Revenue*/
select sum(revenue_realized) as TotalRevenue from fact_bookings;
select sum(revenue_generated) as total_revenue_generated from fact_bookings;

/* 2.Occupancy */
select (sum(successful_bookings)/sum(capacity)*100) as occupancy_rate from fact_aggregated_bookings;
select*from fact_bookings;

/* 3. Cancellation Rate*/
select 
(sum(case when booking_status="cancelled" then 1 else 0 end)/count(*))*100 as cancellation_rate from fact_bookings;
set sql_safe_updates=0;

/* 4.Total Booking*/
select count(booking_id) as Total_Bookings from fact_bookings;

/*5.Utilize capacity */
select sum(successful_bookings) as UtilizeCapacity from fact_aggregated_bookings;
select 
sum(successful_bookings) as total_bookings,
sum(capacity) as total_capacity,
round(sum(successful_bookings)/sum(capacity)*100,2) as utilized_percentage
from fact_aggregated_bookings;

select check_in_date,room_category,
sum(successful_bookings) as total_bookings,
sum(capacity) as total_capacity,
round(sum(successful_bookings)/sum(capacity)*100,2) as utilized_percentage
from fact_aggregated_bookings
group by check_in_date,room_category
order by
check_in_date,room_category;

/*6.Trend Analysis */
select dim_hotels.city,sum(fact_bookings.revenue_generated) as  RevenueGenerated ,sum(fact_bookings.revenue_realized) as RevenueRealized
from dim_hotels join fact_bookings
on dim_hotels.property_id=fact_bookings.property_id
group by dim_hotels.city;

/*7 Weekday  & Weekend  Revenue and Booking */
select
    dim_date.day_type,
    sum(fact_bookings.revenue_realized) AS TotalRevenue,
    count(fact_bookings.booking_id) AS TotalBookings
from dim_date join
    fact_bookings on fact_bookings.check_in_date
group by dim_date.day_type;

/*8.Revenue by State & hotel*/
select h.city,h.property_name,sum(fb.revenue_realized) as Total_revenue
from dim_hotels h
join fact_bookings fb on h.property_id=fb.property_id 
group by h.city,h.property_name order by h.city,h.property_name;

 /*9.Class Wise Revenue*/
select r.room_class,sum(fb.revenue_realized) as total_revenue from dim_rooms r join
fact_bookings fb on r.room_id=fb.room_category group by r.room_class;

/*10.Checked out cancel No show*/
select
booking_status,count(*) as BookingStatusCount
from fact_bookings
where booking_status in ('Checked Out', 'Cancelled', 'No Show') 
group by booking_status ;

/*11.Weekly trend Key trend (Revenue, Total booking, Occupancy) */
SELECT WEEK_NO,
SUM(REVENUE_REALIZED) AS Total_Revenue,
COUNT(FACT_BOOKINGS.BOOKING_ID) AS Total_Bookings
FROM DIM_DATE JOIN FACT_BOOKINGS on fact_bookings.CHECK_IN_DATE = FACT_BOOKINGS.BOOKING_DATE 
GROUP BY DIM_DATE.WEEK_no;


  
/*12.REVENUE BY CATEGORY*/
select
category,
sum(revenue_generated) as Total_Revenue
 from dim_hotels
  join fact_bookings
 on dim_hotels.property_id = fact_bookings.property_id  group by category;
 
 











