{% for key, value in app.environment.items() %}
export {{key}}="{{value}}"
{% endfor %}
export TZ=UTC
export APP_NAME={{app.name}}

. /etc/profile.d/rbenv.sh
{% if node_version is defined %}
. /etc/profile.d/nodenv.sh
{% endif %}
