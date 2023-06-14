{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('products_ab1') }}
select
    cast(price as {{ dbt_utils.type_float() }}) as price,
    cast(product_id as {{ dbt_utils.type_bigint() }}) as product_id,
    cast({{ empty_string_to_null('modified_date') }} as {{ type_timestamp_with_timezone() }}) as modified_date,
    cast(product_name as {{ dbt_utils.type_string() }}) as product_name,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('products_ab1') }}
-- products
where 1 = 1

