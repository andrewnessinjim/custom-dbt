{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('orderitems_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'order_item_id',
        'quantity',
        'product_id',
        'modified_date',
        'order_id',
    ]) }} as _airbyte_orderitems_hashid,
    tmp.*
from {{ ref('orderitems_ab2') }} tmp
-- orderitems
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

