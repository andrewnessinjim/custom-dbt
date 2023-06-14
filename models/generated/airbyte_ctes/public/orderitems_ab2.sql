{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('orderitems_ab1') }}
select
    cast(order_item_id as {{ dbt_utils.type_bigint() }}) as order_item_id,
    cast(quantity as {{ dbt_utils.type_bigint() }}) as quantity,
    cast(product_id as {{ dbt_utils.type_bigint() }}) as product_id,
    cast({{ empty_string_to_null('modified_date') }} as {{ type_timestamp_with_timezone() }}) as modified_date,
    cast(order_id as {{ dbt_utils.type_bigint() }}) as order_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('orderitems_ab1') }}
-- orderitems
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

