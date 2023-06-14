{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_orderitems') }}
select
    {{ json_extract_scalar('_airbyte_data', ['order_item_id'], ['order_item_id']) }} as order_item_id,
    {{ json_extract_scalar('_airbyte_data', ['quantity'], ['quantity']) }} as quantity,
    {{ json_extract_scalar('_airbyte_data', ['product_id'], ['product_id']) }} as product_id,
    {{ json_extract_scalar('_airbyte_data', ['modified_date'], ['modified_date']) }} as modified_date,
    {{ json_extract_scalar('_airbyte_data', ['order_id'], ['order_id']) }} as order_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_orderitems') }} as table_alias
-- orderitems
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

