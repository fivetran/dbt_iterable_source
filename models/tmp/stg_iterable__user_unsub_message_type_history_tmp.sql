{{ config(enabled=var('iterable__using_user_unsubscribed_message_type', True)) }}

{% if does_table_exist('user_unsubscribed_message_type') %}

select * 
from {{ var('user_unsubscribed_message_type') }}

{% else %}

select * 
from {{ var('user_unsubscribed_message_type_history') }}

{% endif %}
-- had to rename this to be compatible with postgres....