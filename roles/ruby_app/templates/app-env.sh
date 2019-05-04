{% for key, value in app.environment.iteritems() %}
  export {{key}}="{{value}}"
{% endfor %}
export TZ=UTC
export APP_NAME={{app.name}}
