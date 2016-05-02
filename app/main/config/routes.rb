# See https://github.com/voltrb/volt#routes for more info on routes

client '/about', action: 'about'

# Routes for login and signup, provided by user_templates component gem
client '/signup', component: 'user_templates', controller: 'signup'
client '/login', component: 'user_templates', controller: 'login', action: 'index'
client '/password_reset', component: 'user_templates', controller: 'password_reset', action: 'index'
client '/forgot', component: 'user_templates', controller: 'login', action: 'forgot'
client '/account', component: 'user_templates', controller: 'account', action: 'index'

client '/{{ username }}/loops/{{ title }}', component: 'music', controller: 'loops', action: 'editor'

client '/loops', component: 'main', controller: 'main', action: 'loops'
client '/explore', component: 'main', controller: 'main', action: 'explore'
client '/explore/{{ username }}/loops', component: 'main', controller: 'main', action: 'explore_loops'

# The main route, this should be last. It will match any params not
# previously matched.
client '/', {}
