{% for key, value in app.environment.items() %}
  export {{key}}="{{value}}"
{% endfor %}
export TZ=UTC
export APP_NAME={{app.name}}
