{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('categories_ab1') }}
select
    cast(category_name as {{ dbt_utils.type_string() }}) as category_name,
    cast(category_id as {{ dbt_utils.type_bigint() }}) as category_id,
    cast({{ empty_string_to_null('modified_date') }} as {{ type_timestamp_with_timezone() }}) as modified_date,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('categories_ab1') }}
-- categories
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

