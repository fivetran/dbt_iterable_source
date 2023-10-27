
{% if does_table_exist('user_unsubscribed_channel') %}

select *
from {{ var('user_unsubscribed_channel') }}

{% else %}

select *
from {{ var('user_unsubscribed_channel_history') }}

{% endif %}