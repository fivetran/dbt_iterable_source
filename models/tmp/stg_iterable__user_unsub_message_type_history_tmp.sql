{{ config(enabled=var('iterable__using_user_unsubscribed_message_type', True)) }}

{% if var('iterable__using_user_unsubscribed_message_type', does_table_exist('user_unsubscribed_message_type_history')) %}

select * 
from {{ var('user_unsubscribed_message_type_history') }}

{% else %}

select * 
from {{ var('user_unsubscribed_message_type') }}

        {% endif %}
-- had to rename this to be compatible with postgres....