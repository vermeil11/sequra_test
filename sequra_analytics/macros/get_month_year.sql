{% macro get_month_year(date_column) %}
    to_char({{ date_column }}, 'YYYY-MM')
{% endmacro %}