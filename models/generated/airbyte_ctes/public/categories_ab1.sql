{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_categories') }}
select
    {{ json_extract_scalar('_airbyte_data', ['category_name'], ['category_name']) }} as category_name,
    {{ json_extract_scalar('_airbyte_data', ['category_id'], ['category_id']) }} as category_id,
    {{ json_extract_scalar('_airbyte_data', ['modified_date'], ['modified_date']) }} as modified_date,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_categories') }} as table_alias
-- categories
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

