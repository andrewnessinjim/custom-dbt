{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('customers_ab1') }}
select
    cast(customer_name as {{ dbt_utils.type_string() }}) as customer_name,
    cast(customer_id as {{ dbt_utils.type_bigint() }}) as customer_id,
    cast({{ empty_string_to_null('modified_date') }} as {{ type_timestamp_with_timezone() }}) as modified_date,
    cast(email as {{ dbt_utils.type_string() }}) as email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('customers_ab1') }}
-- customers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

