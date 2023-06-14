{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('customers_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'customer_name',
        'customer_id',
        'modified_date',
        'email',
    ]) }} as _airbyte_customers_hashid,
    tmp.*
from {{ ref('customers_ab2') }} tmp
-- customers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

