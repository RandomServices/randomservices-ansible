{% for key, value in app.environment.iteritems() %}
  export {{key}}="{{value}}"
{% endfor %}
