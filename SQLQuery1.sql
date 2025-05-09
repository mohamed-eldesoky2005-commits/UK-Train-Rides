
--How does journey status (On Time vs. Delayed) vary by departure station?	

WITH JOURNEY AS (
    SELECT * FROM Journey_Dimension
)
SELECT 
    s.Departure_Station,
    COUNT(j.Journey_Status) AS Total_Journeys,
    SUM(CASE WHEN j.Journey_Status = 'Delayed' THEN 1 ELSE 0 END) AS Delayed_Journeys,
    ROUND(
        (SUM(CASE WHEN j.Journey_Status = 'Delayed' THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(j.Journey_Status), 2
    ) AS Delay_Percentage
FROM Station_Dimension s
JOIN Fact_Table F ON F.Station_ID = s.Station_ID
JOIN JOURNEY j ON j.Journey_ID = f.Journey_ID -- Assuming these are the related columns
GROUP BY s.Departure_Station
ORDER BY Delay_Percentage DESC;

--How does ticket pricing vary by ticket class and ticket type?	

SELECT 

    ticket_class,

    ticket_type,

    COUNT(*) AS total_tickets,

    AVG(F.price) AS average_price,

    MIN(F.price) AS min_price,

    MAX(F.price) AS max_price

FROM Ticket_Dimension T
JOIN Fact_Table F ON F.Ticket_ID = T.Ticket_ID

GROUP BY ticket_class, ticket_type

ORDER BY ticket_class, ticket_type;

--How often are refund requests made, and what are the main reasons?	
SELECT
    J.Reason_for_Delay,
    SUM(CASE WHEN F.Refund_Request = 1 THEN 1 ELSE 0 END) AS Refund_Count,
	ROUND ( SUM(CASE WHEN F.Refund_Request = 1 THEN 1 ELSE 0 END)*100.0 / COUNT (F.Refund_Request),2) As Refund_Percent
FROM Fact_Table F
JOIN Journey_Dimension J ON F.Journey_ID = J.Journey_ID
GROUP BY J.Reason_for_Delay
ORDER BY Refund_Percent DESC;

WITH JOURNEY AS (
    SELECT * FROM Journey_Dimension
)
SELECT 
    s.Departure_Station,
    COUNT(j.Journey_Status) AS Total_Journeys,
    SUM(CASE WHEN j.Journey_Status = 'On Time' THEN 1 ELSE 0 END) AS ON_Time_Journeys,
    ROUND(
        (SUM(CASE WHEN j.Journey_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(j.Journey_Status), 2
    ) AS On_Time_Percentage
FROM Station_Dimension s
JOIN Fact_Table F ON F.Station_ID = s.Station_ID
JOIN JOURNEY j ON j.Journey_ID = f.Journey_ID -- Assuming these are the related columns
GROUP BY s.Departure_Station
ORDER BY On_Time_Percentage DESC;