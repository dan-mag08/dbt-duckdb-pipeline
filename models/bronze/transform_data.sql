WITH raw AS (
    SELECT * FROM {{ ref('my_first_dbt_model') }}
)
SELECT
    id,
    UPPER(name) AS cleaned_name,
    age
FROM raw
