with unpivoted_data as(
    select student_id,
    first_name,
    last_name,
    gender,
    D_O_B,
    '2021' as Year,
    x2021_attainment as attainment,
    x2021_effort as effort,
    x2021_attendance as attendance,
    x2021_behaviour as behaviour
from pd2023_wk21
union all

select student_id,
    first_name,
    last_name,
    gender,
    D_O_B,
    '2022' as Year,
    x2022_attainment as attainment,
    x2022_attendance as attendance,
    x2022_behaviour as behaviour,
    x2022_effort as effort
from pd2023_wk21
),

pivoted_data as(
SELECT
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    'ATTAINMENT' AS CATEGORY,
    MAX(CASE WHEN YEAR = '2021' THEN ATTAINMENT END) AS "2021_SCORE",
    MAX(CASE WHEN YEAR = '2022' THEN ATTAINMENT END) AS "2022_SCORE"
FROM unpivoted_data
GROUP BY STUDENT_ID, FIRST_NAME, LAST_NAME, GENDER, D_O_B
UNION ALL
SELECT
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    'EFFORT' AS CATEGORY,
    MAX(CASE WHEN YEAR = '2021' THEN EFFORT END) AS "2021_SCORE",
    MAX(CASE WHEN YEAR = '2022' THEN EFFORT END) AS "2022_SCORE"
FROM unpivoted_data
GROUP BY STUDENT_ID, FIRST_NAME, LAST_NAME, GENDER, D_O_B
UNION ALL
SELECT
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    'ATTENDANCE' AS CATEGORY,
    MAX(CASE WHEN YEAR = '2021' THEN ATTENDANCE END) AS "2021_SCORE",
    MAX(CASE WHEN YEAR = '2022' THEN ATTENDANCE END) AS "2022_SCORE"
FROM unpivoted_data
GROUP BY STUDENT_ID, FIRST_NAME, LAST_NAME, GENDER, D_O_B
UNION ALL
SELECT
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    'BEHAVIOUR' AS CATEGORY,
    MAX(CASE WHEN YEAR = '2021' THEN BEHAVIOUR END) AS "2021_SCORE",
    MAX(CASE WHEN YEAR = '2022' THEN BEHAVIOUR END) AS "2022_SCORE"
FROM unpivoted_data
GROUP BY STUDENT_ID, FIRST_NAME, LAST_NAME, GENDER, D_O_B
ORDER BY STUDENT_ID, CATEGORY
),

AVG_GRADES AS(
select 
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    avg("2021_SCORE") AS AVG_2021_GRADE,
    AVG("2022_SCORE") AS AVG_2022_GRADE
from pivoted_data
GROUP BY ALL
),

difference as(
SELECT 
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    AVG_2021_GRADE,
    AVG_2022_GRADE,
    SUM("AVG_2021_GRADE"-"AVG_2022_GRADE") as difference

FROM AVG_GRADES
GROUP BY ALL
)

select 
    STUDENT_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    D_O_B,
    AVG_2021_GRADE,
    AVG_2022_GRADE,
    difference,
    case 
        when difference > 0 then 'improvement'
        when difference = 0 then 'no change'
        when difference < 0 then 'cause for concern'
    end as status
from difference
where status = 'cause for concern'
group by all
