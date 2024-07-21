{% if app.environment is defined %}
{% for key, value in app.environment.items() %}
export {{key}}="{{value}}"
{% endfor %}
{% endif %}
export TZ=UTC
export APP_NAME={{app.name}}

. ~/.profile-nodenv.sh
