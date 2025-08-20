-- Test that recurrence rate is between 0 and 100
select *
from {{ ref('shopper_recurrence_rate') }}
where recurrence_rate < 0 or recurrence_rate > 100