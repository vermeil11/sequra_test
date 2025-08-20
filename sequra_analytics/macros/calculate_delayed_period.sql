{% macro calculate_delayed_period(days_unbalanced) %}
    case
        when {{ days_unbalanced }} > 90 then '90+'
        when {{ days_unbalanced }} > 60 then '60'
        when {{ days_unbalanced }} > 30 then '30'
        when {{ days_unbalanced }} > 17 then '17'
        else null
    end
{% endmacro %}