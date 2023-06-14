{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_orders') }}
select
    {{ json_extract_scalar('_airbyte_data', ['order_date'], ['order_date']) }} as order_date,
    {{ json_extract_scalar('_airbyte_data', ['customer_id'], ['customer_id']) }} as customer_id,
    {{ json_extract_scalar('_airbyte_data', ['modified_date'], ['modified_date']) }} as modified_date,
    {{ json_extract_scalar('_airbyte_data', ['order_id'], ['order_id']) }} as order_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_orders') }} as table_alias
-- orders
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

