-- Test that recurrence rate is between 0 and 100
select count(*)
from {{ ref('shopper_recurrence_rate') }}
where recurrence_rate < 0 or recurrence_rate > 100
having count(*) > 0