export RBENV_ROOT="/usr/local/rbenv"
eval "$(/usr/local/rbenv/bin/rbenv init -)"

{% for key, value in app.environment.iteritems() %}
  export {{key}}="{{value}}"
{% endfor %}
