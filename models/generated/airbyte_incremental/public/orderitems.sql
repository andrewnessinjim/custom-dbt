{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('orderitems_scd') }}
select
    _airbyte_unique_key,
    order_item_id,
    quantity,
    product_id,
    modified_date,
    order_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_orderitems_hashid
from {{ ref('orderitems_scd') }}
-- orderitems from {{ source('public', '_airbyte_raw_orderitems') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

