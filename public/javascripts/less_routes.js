function less_json_eval(json){return eval('(' +  json + ')')}  

function less_get_params(obj){
   
  if (jQuery) { return obj }
  if (obj == null) {return '';}
  var s = [];
  for (prop in obj){
    s.push(prop + "=" + obj[prop]);
  }
  return s.join('&') + '';
}

function less_merge_objects(a, b){
   
  if (b == null) {return a;}
  z = new Object;
  for (prop in a){z[prop] = a[prop]}
  for (prop in b){z[prop] = b[prop]}
  return z;
}

function less_ajax(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  var res;
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    res = jQuery.ajax(less_merge_objects({async:false, url: url, type: v, data: p}, options)).responseText;
  } else {  
    new Ajax.Request(url, less_merge_objects({asynchronous: false, method: verb, parameters: less_get_params(params), onComplete: function(r){res = r.responseText;}}, options));
  }
  if (url.indexOf('.json') == url.length-5){ return less_json_eval(res);}
  else {return res;}
}
function less_ajaxx(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    jQuery.ajax(less_merge_objects({ url: url, type: v, data: p, complete: function(r){eval(r.responseText)}}, options));
  } else {  
    new Ajax.Request(url, less_merge_objects({method: verb, parameters: less_get_params(params), onComplete: function(r){eval(r.responseText);}}, options));
  }
}
function root_path(verb){ return '';}
function root_ajax(verb, params, options){ return less_ajax('', verb, params, options);}
function root_ajaxx(verb, params, options){ return less_ajaxx('', verb, params, options);}
function signup_path(verb){ return '/signup';}
function signup_ajax(verb, params, options){ return less_ajax('/signup', verb, params, options);}
function signup_ajaxx(verb, params, options){ return less_ajaxx('/signup', verb, params, options);}
function signin_path(verb){ return '/signin';}
function signin_ajax(verb, params, options){ return less_ajax('/signin', verb, params, options);}
function signin_ajaxx(verb, params, options){ return less_ajaxx('/signin', verb, params, options);}
function login_path(verb){ return '/login';}
function login_ajax(verb, params, options){ return less_ajax('/login', verb, params, options);}
function login_ajaxx(verb, params, options){ return less_ajaxx('/login', verb, params, options);}
function logout_path(verb){ return '/logout';}
function logout_ajax(verb, params, options){ return less_ajax('/logout', verb, params, options);}
function logout_ajaxx(verb, params, options){ return less_ajaxx('/logout', verb, params, options);}
function activate_path(id, verb){ return '/activate/' + id + '';}
function activate_ajax(id, verb, params, options){ return less_ajax('/activate/' + id + '', verb, params, options);}
function activate_ajaxx(id, verb, params, options){ return less_ajaxx('/activate/' + id + '', verb, params, options);}
function forgot_password_path(verb){ return '/forgot_password';}
function forgot_password_ajax(verb, params, options){ return less_ajax('/forgot_password', verb, params, options);}
function forgot_password_ajaxx(verb, params, options){ return less_ajaxx('/forgot_password', verb, params, options);}
function reset_password_path(id, verb){ return '/reset_password/' + id + '';}
function reset_password_ajax(id, verb, params, options){ return less_ajax('/reset_password/' + id + '', verb, params, options);}
function reset_password_ajaxx(id, verb, params, options){ return less_ajaxx('/reset_password/' + id + '', verb, params, options);}
function user_settings_path(id, verb){ return '/users/' + id + '/settings';}
function user_settings_ajax(id, verb, params, options){ return less_ajax('/users/' + id + '/settings', verb, params, options);}
function user_settings_ajaxx(id, verb, params, options){ return less_ajaxx('/users/' + id + '/settings', verb, params, options);}
function about_path(verb){ return '/about';}
function about_ajax(verb, params, options){ return less_ajax('/about', verb, params, options);}
function about_ajaxx(verb, params, options){ return less_ajaxx('/about', verb, params, options);}
function contact_path(verb){ return '/contact';}
function contact_ajax(verb, params, options){ return less_ajax('/contact', verb, params, options);}
function contact_ajaxx(verb, params, options){ return less_ajaxx('/contact', verb, params, options);}
function terms_path(verb){ return '/terms';}
function terms_ajax(verb, params, options){ return less_ajax('/terms', verb, params, options);}
function terms_ajaxx(verb, params, options){ return less_ajaxx('/terms', verb, params, options);}
function privacy_path(verb){ return '/privacy';}
function privacy_ajax(verb, params, options){ return less_ajax('/privacy', verb, params, options);}
function privacy_ajaxx(verb, params, options){ return less_ajaxx('/privacy', verb, params, options);}
function welcome_path(verb){ return '/welcome';}
function welcome_ajax(verb, params, options){ return less_ajax('/welcome', verb, params, options);}
function welcome_ajaxx(verb, params, options){ return less_ajaxx('/welcome', verb, params, options);}
function help_path(verb){ return '/help';}
function help_ajax(verb, params, options){ return less_ajax('/help', verb, params, options);}
function help_ajaxx(verb, params, options){ return less_ajaxx('/help', verb, params, options);}
function popular_path(verb){ return '/popular';}
function popular_ajax(verb, params, options){ return less_ajax('/popular', verb, params, options);}
function popular_ajaxx(verb, params, options){ return less_ajaxx('/popular', verb, params, options);}
function popular_arcades_path(verb){ return '/popular/arcades';}
function popular_arcades_ajax(verb, params, options){ return less_ajax('/popular/arcades', verb, params, options);}
function popular_arcades_ajaxx(verb, params, options){ return less_ajaxx('/popular/arcades', verb, params, options);}
function popular_games_path(verb){ return '/popular/games';}
function popular_games_ajax(verb, params, options){ return less_ajax('/popular/games', verb, params, options);}
function popular_games_ajaxx(verb, params, options){ return less_ajaxx('/popular/games', verb, params, options);}
function arcades_distance_path(verb){ return '/arcades/distace';}
function arcades_distance_ajax(verb, params, options){ return less_ajax('/arcades/distace', verb, params, options);}
function arcades_distance_ajaxx(verb, params, options){ return less_ajaxx('/arcades/distace', verb, params, options);}
function arcades_map_path(verb){ return '/arcades/map';}
function arcades_map_ajax(verb, params, options){ return less_ajax('/arcades/map', verb, params, options);}
function arcades_map_ajaxx(verb, params, options){ return less_ajaxx('/arcades/map', verb, params, options);}
function arcade_map_path(id, verb){ return '/arcades/' + id + '/map';}
function arcade_map_ajax(id, verb, params, options){ return less_ajax('/arcades/' + id + '/map', verb, params, options);}
function arcade_map_ajaxx(id, verb, params, options){ return less_ajaxx('/arcades/' + id + '/map', verb, params, options);}
function new_arcade_1_path(verb){ return '/arcades/new/details';}
function new_arcade_1_ajax(verb, params, options){ return less_ajax('/arcades/new/details', verb, params, options);}
function new_arcade_1_ajaxx(verb, params, options){ return less_ajaxx('/arcades/new/details', verb, params, options);}
function new_arcade_3_path(verb){ return '/arcades/new/addgames';}
function new_arcade_3_ajax(verb, params, options){ return less_ajax('/arcades/new/addgames', verb, params, options);}
function new_arcade_3_ajaxx(verb, params, options){ return less_ajaxx('/arcades/new/addgames', verb, params, options);}
function new_arcade_2_path(verb){ return '/arcades/new/verify';}
function new_arcade_2_ajax(verb, params, options){ return less_ajax('/arcades/new/verify', verb, params, options);}
function new_arcade_2_ajaxx(verb, params, options){ return less_ajaxx('/arcades/new/verify', verb, params, options);}
function game_arcades_map_path(game_id, verb){ return '/games/' + game_id + '/arcades/map';}
function game_arcades_map_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/map', verb, params, options);}
function game_arcades_map_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/map', verb, params, options);}
function profile_arcades_map_path(user_id, verb){ return '/users/' + user_id + '/arcades/map';}
function profile_arcades_map_ajax(user_id, verb, params, options){ return less_ajax('/users/' + user_id + '/arcades/map', verb, params, options);}
function profile_arcades_map_ajaxx(user_id, verb, params, options){ return less_ajaxx('/users/' + user_id + '/arcades/map', verb, params, options);}
function countries_arcades_path(verb){ return '/arcades/countries';}
function countries_arcades_ajax(verb, params, options){ return less_ajax('/arcades/countries', verb, params, options);}
function countries_arcades_ajaxx(verb, params, options){ return less_ajaxx('/arcades/countries', verb, params, options);}
function country_arcades_path(id, verb){ return '/arcades/countries/' + id + '';}
function country_arcades_ajax(id, verb, params, options){ return less_ajax('/arcades/countries/' + id + '', verb, params, options);}
function country_arcades_ajaxx(id, verb, params, options){ return less_ajaxx('/arcades/countries/' + id + '', verb, params, options);}
function regions_arcades_path(verb){ return '/arcades/regions';}
function regions_arcades_ajax(verb, params, options){ return less_ajax('/arcades/regions', verb, params, options);}
function regions_arcades_ajaxx(verb, params, options){ return less_ajaxx('/arcades/regions', verb, params, options);}
function region_arcades_path(id, verb){ return '/arcades/regions/' + id + '';}
function region_arcades_ajax(id, verb, params, options){ return less_ajax('/arcades/regions/' + id + '', verb, params, options);}
function region_arcades_ajaxx(id, verb, params, options){ return less_ajaxx('/arcades/regions/' + id + '', verb, params, options);}
function games_update_path(verb){ return '/games/update';}
function games_update_ajax(verb, params, options){ return less_ajax('/games/update', verb, params, options);}
function games_update_ajaxx(verb, params, options){ return less_ajaxx('/games/update', verb, params, options);}
function arcades_path(verb){ return '/arcades';}
function arcades_ajax(verb, params, options){ return less_ajax('/arcades', verb, params, options);}
function arcades_ajaxx(verb, params, options){ return less_ajaxx('/arcades', verb, params, options);}
function formatted_arcades_path(format, verb){ return '/arcades.' + format + '';}
function formatted_arcades_ajax(format, verb, params, options){ return less_ajax('/arcades.' + format + '', verb, params, options);}
function formatted_arcades_ajaxx(format, verb, params, options){ return less_ajaxx('/arcades.' + format + '', verb, params, options);}
function new_arcade_path(verb){ return '/arcades/new';}
function new_arcade_ajax(verb, params, options){ return less_ajax('/arcades/new', verb, params, options);}
function new_arcade_ajaxx(verb, params, options){ return less_ajaxx('/arcades/new', verb, params, options);}
function formatted_new_arcade_path(format, verb){ return '/arcades/new.' + format + '';}
function formatted_new_arcade_ajax(format, verb, params, options){ return less_ajax('/arcades/new.' + format + '', verb, params, options);}
function formatted_new_arcade_ajaxx(format, verb, params, options){ return less_ajaxx('/arcades/new.' + format + '', verb, params, options);}
function edit_arcade_path(id, verb){ return '/arcades/' + id + '/edit';}
function edit_arcade_ajax(id, verb, params, options){ return less_ajax('/arcades/' + id + '/edit', verb, params, options);}
function edit_arcade_ajaxx(id, verb, params, options){ return less_ajaxx('/arcades/' + id + '/edit', verb, params, options);}
function formatted_edit_arcade_path(id, format, verb){ return '/arcades/' + id + '/edit.' + format + '';}
function formatted_edit_arcade_ajax(id, format, verb, params, options){ return less_ajax('/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_arcade_ajaxx(id, format, verb, params, options){ return less_ajaxx('/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function arcade_path(id, verb){ return '/arcades/' + id + '';}
function arcade_ajax(id, verb, params, options){ return less_ajax('/arcades/' + id + '', verb, params, options);}
function arcade_ajaxx(id, verb, params, options){ return less_ajaxx('/arcades/' + id + '', verb, params, options);}
function formatted_arcade_path(id, format, verb){ return '/arcades/' + id + '.' + format + '';}
function formatted_arcade_ajax(id, format, verb, params, options){ return less_ajax('/arcades/' + id + '.' + format + '', verb, params, options);}
function formatted_arcade_ajaxx(id, format, verb, params, options){ return less_ajaxx('/arcades/' + id + '.' + format + '', verb, params, options);}
function arcade_games_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/games';}
function arcade_games_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games', verb, params, options);}
function arcade_games_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games', verb, params, options);}
function formatted_arcade_games_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/games.' + format + '';}
function formatted_arcade_games_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games.' + format + '', verb, params, options);}
function formatted_arcade_games_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games.' + format + '', verb, params, options);}
function new_arcade_game_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/games/new';}
function new_arcade_game_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/new', verb, params, options);}
function new_arcade_game_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/new', verb, params, options);}
function formatted_new_arcade_game_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/games/new.' + format + '';}
function formatted_new_arcade_game_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/new.' + format + '', verb, params, options);}
function formatted_new_arcade_game_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/new.' + format + '', verb, params, options);}
function edit_arcade_game_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/games/' + id + '/edit';}
function edit_arcade_game_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/' + id + '/edit', verb, params, options);}
function edit_arcade_game_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/' + id + '/edit', verb, params, options);}
function formatted_edit_arcade_game_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/games/' + id + '/edit.' + format + '';}
function formatted_edit_arcade_game_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_arcade_game_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/' + id + '/edit.' + format + '', verb, params, options);}
function arcade_game_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/games/' + id + '';}
function arcade_game_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/' + id + '', verb, params, options);}
function arcade_game_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/' + id + '', verb, params, options);}
function formatted_arcade_game_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/games/' + id + '.' + format + '';}
function formatted_arcade_game_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/games/' + id + '.' + format + '', verb, params, options);}
function formatted_arcade_game_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/games/' + id + '.' + format + '', verb, params, options);}
function arcade_profiles_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/profiles';}
function arcade_profiles_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles', verb, params, options);}
function arcade_profiles_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles', verb, params, options);}
function formatted_arcade_profiles_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/profiles.' + format + '';}
function formatted_arcade_profiles_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles.' + format + '', verb, params, options);}
function formatted_arcade_profiles_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles.' + format + '', verb, params, options);}
function new_arcade_profile_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/profiles/new';}
function new_arcade_profile_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/new', verb, params, options);}
function new_arcade_profile_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/new', verb, params, options);}
function formatted_new_arcade_profile_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/profiles/new.' + format + '';}
function formatted_new_arcade_profile_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/new.' + format + '', verb, params, options);}
function formatted_new_arcade_profile_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/new.' + format + '', verb, params, options);}
function edit_arcade_profile_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/profiles/' + id + '/edit';}
function edit_arcade_profile_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/' + id + '/edit', verb, params, options);}
function edit_arcade_profile_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/' + id + '/edit', verb, params, options);}
function formatted_edit_arcade_profile_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/profiles/' + id + '/edit.' + format + '';}
function formatted_edit_arcade_profile_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_arcade_profile_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function arcade_profile_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/profiles/' + id + '';}
function arcade_profile_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/' + id + '', verb, params, options);}
function arcade_profile_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/' + id + '', verb, params, options);}
function formatted_arcade_profile_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/profiles/' + id + '.' + format + '';}
function formatted_arcade_profile_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/profiles/' + id + '.' + format + '', verb, params, options);}
function formatted_arcade_profile_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/profiles/' + id + '.' + format + '', verb, params, options);}
function arcade_favorites_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/favorites';}
function arcade_favorites_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites', verb, params, options);}
function arcade_favorites_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites', verb, params, options);}
function formatted_arcade_favorites_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/favorites.' + format + '';}
function formatted_arcade_favorites_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites.' + format + '', verb, params, options);}
function formatted_arcade_favorites_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites.' + format + '', verb, params, options);}
function new_arcade_favorite_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/favorites/new';}
function new_arcade_favorite_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/new', verb, params, options);}
function new_arcade_favorite_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/new', verb, params, options);}
function formatted_new_arcade_favorite_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/favorites/new.' + format + '';}
function formatted_new_arcade_favorite_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/new.' + format + '', verb, params, options);}
function formatted_new_arcade_favorite_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/new.' + format + '', verb, params, options);}
function edit_arcade_favorite_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/favorites/' + id + '/edit';}
function edit_arcade_favorite_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/' + id + '/edit', verb, params, options);}
function edit_arcade_favorite_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/' + id + '/edit', verb, params, options);}
function formatted_edit_arcade_favorite_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/favorites/' + id + '/edit.' + format + '';}
function formatted_edit_arcade_favorite_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_arcade_favorite_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function arcade_favorite_path(arcade_id, id, verb){ return '/arcades/' + arcade_id + '/favorites/' + id + '';}
function arcade_favorite_ajax(arcade_id, id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/' + id + '', verb, params, options);}
function arcade_favorite_ajaxx(arcade_id, id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/' + id + '', verb, params, options);}
function formatted_arcade_favorite_path(arcade_id, id, format, verb){ return '/arcades/' + arcade_id + '/favorites/' + id + '.' + format + '';}
function formatted_arcade_favorite_ajax(arcade_id, id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/favorites/' + id + '.' + format + '', verb, params, options);}
function formatted_arcade_favorite_ajaxx(arcade_id, id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/favorites/' + id + '.' + format + '', verb, params, options);}
function new_arcade_address_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/address/new';}
function new_arcade_address_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address/new', verb, params, options);}
function new_arcade_address_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address/new', verb, params, options);}
function formatted_new_arcade_address_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/address/new.' + format + '';}
function formatted_new_arcade_address_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address/new.' + format + '', verb, params, options);}
function formatted_new_arcade_address_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address/new.' + format + '', verb, params, options);}
function edit_arcade_address_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/address/edit';}
function edit_arcade_address_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address/edit', verb, params, options);}
function edit_arcade_address_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address/edit', verb, params, options);}
function formatted_edit_arcade_address_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/address/edit.' + format + '';}
function formatted_edit_arcade_address_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address/edit.' + format + '', verb, params, options);}
function formatted_edit_arcade_address_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address/edit.' + format + '', verb, params, options);}
function arcade_address_path(arcade_id, verb){ return '/arcades/' + arcade_id + '/address';}
function arcade_address_ajax(arcade_id, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address', verb, params, options);}
function arcade_address_ajaxx(arcade_id, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address', verb, params, options);}
function formatted_arcade_address_path(arcade_id, format, verb){ return '/arcades/' + arcade_id + '/address.' + format + '';}
function formatted_arcade_address_ajax(arcade_id, format, verb, params, options){ return less_ajax('/arcades/' + arcade_id + '/address.' + format + '', verb, params, options);}
function formatted_arcade_address_ajaxx(arcade_id, format, verb, params, options){ return less_ajaxx('/arcades/' + arcade_id + '/address.' + format + '', verb, params, options);}
function games_path(verb){ return '/games';}
function games_ajax(verb, params, options){ return less_ajax('/games', verb, params, options);}
function games_ajaxx(verb, params, options){ return less_ajaxx('/games', verb, params, options);}
function formatted_games_path(format, verb){ return '/games.' + format + '';}
function formatted_games_ajax(format, verb, params, options){ return less_ajax('/games.' + format + '', verb, params, options);}
function formatted_games_ajaxx(format, verb, params, options){ return less_ajaxx('/games.' + format + '', verb, params, options);}
function new_game_path(verb){ return '/games/new';}
function new_game_ajax(verb, params, options){ return less_ajax('/games/new', verb, params, options);}
function new_game_ajaxx(verb, params, options){ return less_ajaxx('/games/new', verb, params, options);}
function formatted_new_game_path(format, verb){ return '/games/new.' + format + '';}
function formatted_new_game_ajax(format, verb, params, options){ return less_ajax('/games/new.' + format + '', verb, params, options);}
function formatted_new_game_ajaxx(format, verb, params, options){ return less_ajaxx('/games/new.' + format + '', verb, params, options);}
function edit_game_path(id, verb){ return '/games/' + id + '/edit';}
function edit_game_ajax(id, verb, params, options){ return less_ajax('/games/' + id + '/edit', verb, params, options);}
function edit_game_ajaxx(id, verb, params, options){ return less_ajaxx('/games/' + id + '/edit', verb, params, options);}
function formatted_edit_game_path(id, format, verb){ return '/games/' + id + '/edit.' + format + '';}
function formatted_edit_game_ajax(id, format, verb, params, options){ return less_ajax('/games/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_game_ajaxx(id, format, verb, params, options){ return less_ajaxx('/games/' + id + '/edit.' + format + '', verb, params, options);}
function game_path(id, verb){ return '/games/' + id + '';}
function game_ajax(id, verb, params, options){ return less_ajax('/games/' + id + '', verb, params, options);}
function game_ajaxx(id, verb, params, options){ return less_ajaxx('/games/' + id + '', verb, params, options);}
function formatted_game_path(id, format, verb){ return '/games/' + id + '.' + format + '';}
function formatted_game_ajax(id, format, verb, params, options){ return less_ajax('/games/' + id + '.' + format + '', verb, params, options);}
function formatted_game_ajaxx(id, format, verb, params, options){ return less_ajaxx('/games/' + id + '.' + format + '', verb, params, options);}
function game_arcades_path(game_id, verb){ return '/games/' + game_id + '/arcades';}
function game_arcades_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades', verb, params, options);}
function game_arcades_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades', verb, params, options);}
function formatted_game_arcades_path(game_id, format, verb){ return '/games/' + game_id + '/arcades.' + format + '';}
function formatted_game_arcades_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades.' + format + '', verb, params, options);}
function formatted_game_arcades_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades.' + format + '', verb, params, options);}
function new_game_arcade_path(game_id, verb){ return '/games/' + game_id + '/arcades/new';}
function new_game_arcade_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/new', verb, params, options);}
function new_game_arcade_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/new', verb, params, options);}
function formatted_new_game_arcade_path(game_id, format, verb){ return '/games/' + game_id + '/arcades/new.' + format + '';}
function formatted_new_game_arcade_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/new.' + format + '', verb, params, options);}
function formatted_new_game_arcade_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/new.' + format + '', verb, params, options);}
function edit_game_arcade_path(game_id, id, verb){ return '/games/' + game_id + '/arcades/' + id + '/edit';}
function edit_game_arcade_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/' + id + '/edit', verb, params, options);}
function edit_game_arcade_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/' + id + '/edit', verb, params, options);}
function formatted_edit_game_arcade_path(game_id, id, format, verb){ return '/games/' + game_id + '/arcades/' + id + '/edit.' + format + '';}
function formatted_edit_game_arcade_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_game_arcade_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function game_arcade_path(game_id, id, verb){ return '/games/' + game_id + '/arcades/' + id + '';}
function game_arcade_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/' + id + '', verb, params, options);}
function game_arcade_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/' + id + '', verb, params, options);}
function formatted_game_arcade_path(game_id, id, format, verb){ return '/games/' + game_id + '/arcades/' + id + '.' + format + '';}
function formatted_game_arcade_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/arcades/' + id + '.' + format + '', verb, params, options);}
function formatted_game_arcade_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/arcades/' + id + '.' + format + '', verb, params, options);}
function game_profiles_path(game_id, verb){ return '/games/' + game_id + '/profiles';}
function game_profiles_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles', verb, params, options);}
function game_profiles_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles', verb, params, options);}
function formatted_game_profiles_path(game_id, format, verb){ return '/games/' + game_id + '/profiles.' + format + '';}
function formatted_game_profiles_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles.' + format + '', verb, params, options);}
function formatted_game_profiles_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles.' + format + '', verb, params, options);}
function new_game_profile_path(game_id, verb){ return '/games/' + game_id + '/profiles/new';}
function new_game_profile_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/new', verb, params, options);}
function new_game_profile_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/new', verb, params, options);}
function formatted_new_game_profile_path(game_id, format, verb){ return '/games/' + game_id + '/profiles/new.' + format + '';}
function formatted_new_game_profile_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/new.' + format + '', verb, params, options);}
function formatted_new_game_profile_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/new.' + format + '', verb, params, options);}
function edit_game_profile_path(game_id, id, verb){ return '/games/' + game_id + '/profiles/' + id + '/edit';}
function edit_game_profile_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/' + id + '/edit', verb, params, options);}
function edit_game_profile_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/' + id + '/edit', verb, params, options);}
function formatted_edit_game_profile_path(game_id, id, format, verb){ return '/games/' + game_id + '/profiles/' + id + '/edit.' + format + '';}
function formatted_edit_game_profile_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_game_profile_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function game_profile_path(game_id, id, verb){ return '/games/' + game_id + '/profiles/' + id + '';}
function game_profile_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/' + id + '', verb, params, options);}
function game_profile_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/' + id + '', verb, params, options);}
function formatted_game_profile_path(game_id, id, format, verb){ return '/games/' + game_id + '/profiles/' + id + '.' + format + '';}
function formatted_game_profile_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/profiles/' + id + '.' + format + '', verb, params, options);}
function formatted_game_profile_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/profiles/' + id + '.' + format + '', verb, params, options);}
function game_favorites_path(game_id, verb){ return '/games/' + game_id + '/favorites';}
function game_favorites_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites', verb, params, options);}
function game_favorites_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites', verb, params, options);}
function formatted_game_favorites_path(game_id, format, verb){ return '/games/' + game_id + '/favorites.' + format + '';}
function formatted_game_favorites_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites.' + format + '', verb, params, options);}
function formatted_game_favorites_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites.' + format + '', verb, params, options);}
function new_game_favorite_path(game_id, verb){ return '/games/' + game_id + '/favorites/new';}
function new_game_favorite_ajax(game_id, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/new', verb, params, options);}
function new_game_favorite_ajaxx(game_id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/new', verb, params, options);}
function formatted_new_game_favorite_path(game_id, format, verb){ return '/games/' + game_id + '/favorites/new.' + format + '';}
function formatted_new_game_favorite_ajax(game_id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/new.' + format + '', verb, params, options);}
function formatted_new_game_favorite_ajaxx(game_id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/new.' + format + '', verb, params, options);}
function edit_game_favorite_path(game_id, id, verb){ return '/games/' + game_id + '/favorites/' + id + '/edit';}
function edit_game_favorite_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/' + id + '/edit', verb, params, options);}
function edit_game_favorite_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/' + id + '/edit', verb, params, options);}
function formatted_edit_game_favorite_path(game_id, id, format, verb){ return '/games/' + game_id + '/favorites/' + id + '/edit.' + format + '';}
function formatted_edit_game_favorite_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_game_favorite_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function game_favorite_path(game_id, id, verb){ return '/games/' + game_id + '/favorites/' + id + '';}
function game_favorite_ajax(game_id, id, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/' + id + '', verb, params, options);}
function game_favorite_ajaxx(game_id, id, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/' + id + '', verb, params, options);}
function formatted_game_favorite_path(game_id, id, format, verb){ return '/games/' + game_id + '/favorites/' + id + '.' + format + '';}
function formatted_game_favorite_ajax(game_id, id, format, verb, params, options){ return less_ajax('/games/' + game_id + '/favorites/' + id + '.' + format + '', verb, params, options);}
function formatted_game_favorite_ajaxx(game_id, id, format, verb, params, options){ return less_ajaxx('/games/' + game_id + '/favorites/' + id + '.' + format + '', verb, params, options);}
function users_path(verb){ return '/users';}
function users_ajax(verb, params, options){ return less_ajax('/users', verb, params, options);}
function users_ajaxx(verb, params, options){ return less_ajaxx('/users', verb, params, options);}
function formatted_users_path(format, verb){ return '/users.' + format + '';}
function formatted_users_ajax(format, verb, params, options){ return less_ajax('/users.' + format + '', verb, params, options);}
function formatted_users_ajaxx(format, verb, params, options){ return less_ajaxx('/users.' + format + '', verb, params, options);}
function new_user_path(verb){ return '/users/new';}
function new_user_ajax(verb, params, options){ return less_ajax('/users/new', verb, params, options);}
function new_user_ajaxx(verb, params, options){ return less_ajaxx('/users/new', verb, params, options);}
function formatted_new_user_path(format, verb){ return '/users/new.' + format + '';}
function formatted_new_user_ajax(format, verb, params, options){ return less_ajax('/users/new.' + format + '', verb, params, options);}
function formatted_new_user_ajaxx(format, verb, params, options){ return less_ajaxx('/users/new.' + format + '', verb, params, options);}
function edit_user_path(id, verb){ return '/users/' + id + '/edit';}
function edit_user_ajax(id, verb, params, options){ return less_ajax('/users/' + id + '/edit', verb, params, options);}
function edit_user_ajaxx(id, verb, params, options){ return less_ajaxx('/users/' + id + '/edit', verb, params, options);}
function formatted_edit_user_path(id, format, verb){ return '/users/' + id + '/edit.' + format + '';}
function formatted_edit_user_ajax(id, format, verb, params, options){ return less_ajax('/users/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/users/' + id + '/edit.' + format + '', verb, params, options);}
function user_path(id, verb){ return '/users/' + id + '';}
function user_ajax(id, verb, params, options){ return less_ajax('/users/' + id + '', verb, params, options);}
function user_ajaxx(id, verb, params, options){ return less_ajaxx('/users/' + id + '', verb, params, options);}
function formatted_user_path(id, format, verb){ return '/users/' + id + '.' + format + '';}
function formatted_user_ajax(id, format, verb, params, options){ return less_ajax('/users/' + id + '.' + format + '', verb, params, options);}
function formatted_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/users/' + id + '.' + format + '', verb, params, options);}
function addresses_path(verb){ return '/addresses';}
function addresses_ajax(verb, params, options){ return less_ajax('/addresses', verb, params, options);}
function addresses_ajaxx(verb, params, options){ return less_ajaxx('/addresses', verb, params, options);}
function formatted_addresses_path(format, verb){ return '/addresses.' + format + '';}
function formatted_addresses_ajax(format, verb, params, options){ return less_ajax('/addresses.' + format + '', verb, params, options);}
function formatted_addresses_ajaxx(format, verb, params, options){ return less_ajaxx('/addresses.' + format + '', verb, params, options);}
function new_address_path(verb){ return '/addresses/new';}
function new_address_ajax(verb, params, options){ return less_ajax('/addresses/new', verb, params, options);}
function new_address_ajaxx(verb, params, options){ return less_ajaxx('/addresses/new', verb, params, options);}
function formatted_new_address_path(format, verb){ return '/addresses/new.' + format + '';}
function formatted_new_address_ajax(format, verb, params, options){ return less_ajax('/addresses/new.' + format + '', verb, params, options);}
function formatted_new_address_ajaxx(format, verb, params, options){ return less_ajaxx('/addresses/new.' + format + '', verb, params, options);}
function edit_address_path(id, verb){ return '/addresses/' + id + '/edit';}
function edit_address_ajax(id, verb, params, options){ return less_ajax('/addresses/' + id + '/edit', verb, params, options);}
function edit_address_ajaxx(id, verb, params, options){ return less_ajaxx('/addresses/' + id + '/edit', verb, params, options);}
function formatted_edit_address_path(id, format, verb){ return '/addresses/' + id + '/edit.' + format + '';}
function formatted_edit_address_ajax(id, format, verb, params, options){ return less_ajax('/addresses/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_address_ajaxx(id, format, verb, params, options){ return less_ajaxx('/addresses/' + id + '/edit.' + format + '', verb, params, options);}
function address_path(id, verb){ return '/addresses/' + id + '';}
function address_ajax(id, verb, params, options){ return less_ajax('/addresses/' + id + '', verb, params, options);}
function address_ajaxx(id, verb, params, options){ return less_ajaxx('/addresses/' + id + '', verb, params, options);}
function formatted_address_path(id, format, verb){ return '/addresses/' + id + '.' + format + '';}
function formatted_address_ajax(id, format, verb, params, options){ return less_ajax('/addresses/' + id + '.' + format + '', verb, params, options);}
function formatted_address_ajaxx(id, format, verb, params, options){ return less_ajaxx('/addresses/' + id + '.' + format + '', verb, params, options);}
function sessions_path(verb){ return '/sessions';}
function sessions_ajax(verb, params, options){ return less_ajax('/sessions', verb, params, options);}
function sessions_ajaxx(verb, params, options){ return less_ajaxx('/sessions', verb, params, options);}
function formatted_sessions_path(format, verb){ return '/sessions.' + format + '';}
function formatted_sessions_ajax(format, verb, params, options){ return less_ajax('/sessions.' + format + '', verb, params, options);}
function formatted_sessions_ajaxx(format, verb, params, options){ return less_ajaxx('/sessions.' + format + '', verb, params, options);}
function new_session_path(verb){ return '/sessions/new';}
function new_session_ajax(verb, params, options){ return less_ajax('/sessions/new', verb, params, options);}
function new_session_ajaxx(verb, params, options){ return less_ajaxx('/sessions/new', verb, params, options);}
function formatted_new_session_path(format, verb){ return '/sessions/new.' + format + '';}
function formatted_new_session_ajax(format, verb, params, options){ return less_ajax('/sessions/new.' + format + '', verb, params, options);}
function formatted_new_session_ajaxx(format, verb, params, options){ return less_ajaxx('/sessions/new.' + format + '', verb, params, options);}
function edit_session_path(id, verb){ return '/sessions/' + id + '/edit';}
function edit_session_ajax(id, verb, params, options){ return less_ajax('/sessions/' + id + '/edit', verb, params, options);}
function edit_session_ajaxx(id, verb, params, options){ return less_ajaxx('/sessions/' + id + '/edit', verb, params, options);}
function formatted_edit_session_path(id, format, verb){ return '/sessions/' + id + '/edit.' + format + '';}
function formatted_edit_session_ajax(id, format, verb, params, options){ return less_ajax('/sessions/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_session_ajaxx(id, format, verb, params, options){ return less_ajaxx('/sessions/' + id + '/edit.' + format + '', verb, params, options);}
function session_path(id, verb){ return '/sessions/' + id + '';}
function session_ajax(id, verb, params, options){ return less_ajax('/sessions/' + id + '', verb, params, options);}
function session_ajaxx(id, verb, params, options){ return less_ajaxx('/sessions/' + id + '', verb, params, options);}
function formatted_session_path(id, format, verb){ return '/sessions/' + id + '.' + format + '';}
function formatted_session_ajax(id, format, verb, params, options){ return less_ajax('/sessions/' + id + '.' + format + '', verb, params, options);}
function formatted_session_ajaxx(id, format, verb, params, options){ return less_ajaxx('/sessions/' + id + '.' + format + '', verb, params, options);}
function passwords_path(verb){ return '/passwords';}
function passwords_ajax(verb, params, options){ return less_ajax('/passwords', verb, params, options);}
function passwords_ajaxx(verb, params, options){ return less_ajaxx('/passwords', verb, params, options);}
function formatted_passwords_path(format, verb){ return '/passwords.' + format + '';}
function formatted_passwords_ajax(format, verb, params, options){ return less_ajax('/passwords.' + format + '', verb, params, options);}
function formatted_passwords_ajaxx(format, verb, params, options){ return less_ajaxx('/passwords.' + format + '', verb, params, options);}
function new_password_path(verb){ return '/passwords/new';}
function new_password_ajax(verb, params, options){ return less_ajax('/passwords/new', verb, params, options);}
function new_password_ajaxx(verb, params, options){ return less_ajaxx('/passwords/new', verb, params, options);}
function formatted_new_password_path(format, verb){ return '/passwords/new.' + format + '';}
function formatted_new_password_ajax(format, verb, params, options){ return less_ajax('/passwords/new.' + format + '', verb, params, options);}
function formatted_new_password_ajaxx(format, verb, params, options){ return less_ajaxx('/passwords/new.' + format + '', verb, params, options);}
function edit_password_path(id, verb){ return '/passwords/' + id + '/edit';}
function edit_password_ajax(id, verb, params, options){ return less_ajax('/passwords/' + id + '/edit', verb, params, options);}
function edit_password_ajaxx(id, verb, params, options){ return less_ajaxx('/passwords/' + id + '/edit', verb, params, options);}
function formatted_edit_password_path(id, format, verb){ return '/passwords/' + id + '/edit.' + format + '';}
function formatted_edit_password_ajax(id, format, verb, params, options){ return less_ajax('/passwords/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_password_ajaxx(id, format, verb, params, options){ return less_ajaxx('/passwords/' + id + '/edit.' + format + '', verb, params, options);}
function password_path(id, verb){ return '/passwords/' + id + '';}
function password_ajax(id, verb, params, options){ return less_ajax('/passwords/' + id + '', verb, params, options);}
function password_ajaxx(id, verb, params, options){ return less_ajaxx('/passwords/' + id + '', verb, params, options);}
function formatted_password_path(id, format, verb){ return '/passwords/' + id + '.' + format + '';}
function formatted_password_ajax(id, format, verb, params, options){ return less_ajax('/passwords/' + id + '.' + format + '', verb, params, options);}
function formatted_password_ajaxx(id, format, verb, params, options){ return less_ajaxx('/passwords/' + id + '.' + format + '', verb, params, options);}
function favorites_path(verb){ return '/favorites';}
function favorites_ajax(verb, params, options){ return less_ajax('/favorites', verb, params, options);}
function favorites_ajaxx(verb, params, options){ return less_ajaxx('/favorites', verb, params, options);}
function formatted_favorites_path(format, verb){ return '/favorites.' + format + '';}
function formatted_favorites_ajax(format, verb, params, options){ return less_ajax('/favorites.' + format + '', verb, params, options);}
function formatted_favorites_ajaxx(format, verb, params, options){ return less_ajaxx('/favorites.' + format + '', verb, params, options);}
function new_favorite_path(verb){ return '/favorites/new';}
function new_favorite_ajax(verb, params, options){ return less_ajax('/favorites/new', verb, params, options);}
function new_favorite_ajaxx(verb, params, options){ return less_ajaxx('/favorites/new', verb, params, options);}
function formatted_new_favorite_path(format, verb){ return '/favorites/new.' + format + '';}
function formatted_new_favorite_ajax(format, verb, params, options){ return less_ajax('/favorites/new.' + format + '', verb, params, options);}
function formatted_new_favorite_ajaxx(format, verb, params, options){ return less_ajaxx('/favorites/new.' + format + '', verb, params, options);}
function edit_favorite_path(id, verb){ return '/favorites/' + id + '/edit';}
function edit_favorite_ajax(id, verb, params, options){ return less_ajax('/favorites/' + id + '/edit', verb, params, options);}
function edit_favorite_ajaxx(id, verb, params, options){ return less_ajaxx('/favorites/' + id + '/edit', verb, params, options);}
function formatted_edit_favorite_path(id, format, verb){ return '/favorites/' + id + '/edit.' + format + '';}
function formatted_edit_favorite_ajax(id, format, verb, params, options){ return less_ajax('/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_favorite_ajaxx(id, format, verb, params, options){ return less_ajaxx('/favorites/' + id + '/edit.' + format + '', verb, params, options);}
function favorite_path(id, verb){ return '/favorites/' + id + '';}
function favorite_ajax(id, verb, params, options){ return less_ajax('/favorites/' + id + '', verb, params, options);}
function favorite_ajaxx(id, verb, params, options){ return less_ajaxx('/favorites/' + id + '', verb, params, options);}
function formatted_favorite_path(id, format, verb){ return '/favorites/' + id + '.' + format + '';}
function formatted_favorite_ajax(id, format, verb, params, options){ return less_ajax('/favorites/' + id + '.' + format + '', verb, params, options);}
function formatted_favorite_ajaxx(id, format, verb, params, options){ return less_ajaxx('/favorites/' + id + '.' + format + '', verb, params, options);}
function search_admin_users_path(verb){ return '/admin/users/search';}
function search_admin_users_ajax(verb, params, options){ return less_ajax('/admin/users/search', verb, params, options);}
function search_admin_users_ajaxx(verb, params, options){ return less_ajaxx('/admin/users/search', verb, params, options);}
function formatted_search_admin_users_path(format, verb){ return '/admin/users/search.' + format + '';}
function formatted_search_admin_users_ajax(format, verb, params, options){ return less_ajax('/admin/users/search.' + format + '', verb, params, options);}
function formatted_search_admin_users_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users/search.' + format + '', verb, params, options);}
function admin_users_path(verb){ return '/admin/users';}
function admin_users_ajax(verb, params, options){ return less_ajax('/admin/users', verb, params, options);}
function admin_users_ajaxx(verb, params, options){ return less_ajaxx('/admin/users', verb, params, options);}
function formatted_admin_users_path(format, verb){ return '/admin/users.' + format + '';}
function formatted_admin_users_ajax(format, verb, params, options){ return less_ajax('/admin/users.' + format + '', verb, params, options);}
function formatted_admin_users_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users.' + format + '', verb, params, options);}
function new_admin_user_path(verb){ return '/admin/users/new';}
function new_admin_user_ajax(verb, params, options){ return less_ajax('/admin/users/new', verb, params, options);}
function new_admin_user_ajaxx(verb, params, options){ return less_ajaxx('/admin/users/new', verb, params, options);}
function formatted_new_admin_user_path(format, verb){ return '/admin/users/new.' + format + '';}
function formatted_new_admin_user_ajax(format, verb, params, options){ return less_ajax('/admin/users/new.' + format + '', verb, params, options);}
function formatted_new_admin_user_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users/new.' + format + '', verb, params, options);}
function edit_admin_user_path(id, verb){ return '/admin/users/' + id + '/edit';}
function edit_admin_user_ajax(id, verb, params, options){ return less_ajax('/admin/users/' + id + '/edit', verb, params, options);}
function edit_admin_user_ajaxx(id, verb, params, options){ return less_ajaxx('/admin/users/' + id + '/edit', verb, params, options);}
function formatted_edit_admin_user_path(id, format, verb){ return '/admin/users/' + id + '/edit.' + format + '';}
function formatted_edit_admin_user_ajax(id, format, verb, params, options){ return less_ajax('/admin/users/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_admin_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/admin/users/' + id + '/edit.' + format + '', verb, params, options);}
function admin_user_path(id, verb){ return '/admin/users/' + id + '';}
function admin_user_ajax(id, verb, params, options){ return less_ajax('/admin/users/' + id + '', verb, params, options);}
function admin_user_ajaxx(id, verb, params, options){ return less_ajaxx('/admin/users/' + id + '', verb, params, options);}
function formatted_admin_user_path(id, format, verb){ return '/admin/users/' + id + '.' + format + '';}
function formatted_admin_user_ajax(id, format, verb, params, options){ return less_ajax('/admin/users/' + id + '.' + format + '', verb, params, options);}
function formatted_admin_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/admin/users/' + id + '.' + format + '', verb, params, options);}
function search_profiles_path(verb){ return '/profiles/search';}
function search_profiles_ajax(verb, params, options){ return less_ajax('/profiles/search', verb, params, options);}
function search_profiles_ajaxx(verb, params, options){ return less_ajaxx('/profiles/search', verb, params, options);}
function formatted_search_profiles_path(format, verb){ return '/profiles/search.' + format + '';}
function formatted_search_profiles_ajax(format, verb, params, options){ return less_ajax('/profiles/search.' + format + '', verb, params, options);}
function formatted_search_profiles_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles/search.' + format + '', verb, params, options);}
function profiles_path(verb){ return '/profiles';}
function profiles_ajax(verb, params, options){ return less_ajax('/profiles', verb, params, options);}
function profiles_ajaxx(verb, params, options){ return less_ajaxx('/profiles', verb, params, options);}
function formatted_profiles_path(format, verb){ return '/profiles.' + format + '';}
function formatted_profiles_ajax(format, verb, params, options){ return less_ajax('/profiles.' + format + '', verb, params, options);}
function formatted_profiles_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles.' + format + '', verb, params, options);}
function new_profile_path(verb){ return '/profiles/new';}
function new_profile_ajax(verb, params, options){ return less_ajax('/profiles/new', verb, params, options);}
function new_profile_ajaxx(verb, params, options){ return less_ajaxx('/profiles/new', verb, params, options);}
function formatted_new_profile_path(format, verb){ return '/profiles/new.' + format + '';}
function formatted_new_profile_ajax(format, verb, params, options){ return less_ajax('/profiles/new.' + format + '', verb, params, options);}
function formatted_new_profile_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles/new.' + format + '', verb, params, options);}
function delete_icon_profile_path(id, verb){ return '/profiles/' + id + '/delete_icon';}
function delete_icon_profile_ajax(id, verb, params, options){ return less_ajax('/profiles/' + id + '/delete_icon', verb, params, options);}
function delete_icon_profile_ajaxx(id, verb, params, options){ return less_ajaxx('/profiles/' + id + '/delete_icon', verb, params, options);}
function formatted_delete_icon_profile_path(id, format, verb){ return '/profiles/' + id + '/delete_icon.' + format + '';}
function formatted_delete_icon_profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '/delete_icon.' + format + '', verb, params, options);}
function formatted_delete_icon_profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '/delete_icon.' + format + '', verb, params, options);}
function edit_profile_path(id, verb){ return '/profiles/' + id + '/edit';}
function edit_profile_ajax(id, verb, params, options){ return less_ajax('/profiles/' + id + '/edit', verb, params, options);}
function edit_profile_ajaxx(id, verb, params, options){ return less_ajaxx('/profiles/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_path(id, format, verb){ return '/profiles/' + id + '/edit.' + format + '';}
function formatted_edit_profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '/edit.' + format + '', verb, params, options);}
function profile_path(id, verb){ return '/profiles/' + id + '';}
function profile_ajax(id, verb, params, options){ return less_ajax('/profiles/' + id + '', verb, params, options);}
function profile_ajaxx(id, verb, params, options){ return less_ajaxx('/profiles/' + id + '', verb, params, options);}
function formatted_profile_path(id, format, verb){ return '/profiles/' + id + '.' + format + '';}
function formatted_profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '.' + format + '', verb, params, options);}
function profile_friends_path(profile_id, verb){ return '/profiles/' + profile_id + '/friends';}
function profile_friends_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends', verb, params, options);}
function profile_friends_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends', verb, params, options);}
function formatted_profile_friends_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/friends.' + format + '';}
function formatted_profile_friends_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends.' + format + '', verb, params, options);}
function formatted_profile_friends_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends.' + format + '', verb, params, options);}
function new_profile_friend_path(profile_id, verb){ return '/profiles/' + profile_id + '/friends/new';}
function new_profile_friend_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/new', verb, params, options);}
function new_profile_friend_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/new', verb, params, options);}
function formatted_new_profile_friend_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/friends/new.' + format + '';}
function formatted_new_profile_friend_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/new.' + format + '', verb, params, options);}
function formatted_new_profile_friend_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/new.' + format + '', verb, params, options);}
function edit_profile_friend_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/friends/' + id + '/edit';}
function edit_profile_friend_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '/edit', verb, params, options);}
function edit_profile_friend_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_friend_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/friends/' + id + '/edit.' + format + '';}
function formatted_edit_profile_friend_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_friend_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '/edit.' + format + '', verb, params, options);}
function profile_friend_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/friends/' + id + '';}
function profile_friend_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '', verb, params, options);}
function profile_friend_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '', verb, params, options);}
function formatted_profile_friend_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/friends/' + id + '.' + format + '';}
function formatted_profile_friend_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_friend_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '.' + format + '', verb, params, options);}
function profile_blogs_path(profile_id, verb){ return '/profiles/' + profile_id + '/blogs';}
function profile_blogs_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs', verb, params, options);}
function profile_blogs_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs', verb, params, options);}
function formatted_profile_blogs_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/blogs.' + format + '';}
function formatted_profile_blogs_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs.' + format + '', verb, params, options);}
function formatted_profile_blogs_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs.' + format + '', verb, params, options);}
function new_profile_blog_path(profile_id, verb){ return '/profiles/' + profile_id + '/blogs/new';}
function new_profile_blog_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/new', verb, params, options);}
function new_profile_blog_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/new', verb, params, options);}
function formatted_new_profile_blog_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/blogs/new.' + format + '';}
function formatted_new_profile_blog_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/new.' + format + '', verb, params, options);}
function formatted_new_profile_blog_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/new.' + format + '', verb, params, options);}
function edit_profile_blog_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '/edit';}
function edit_profile_blog_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '/edit', verb, params, options);}
function edit_profile_blog_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_blog_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '/edit.' + format + '';}
function formatted_edit_profile_blog_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_blog_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '/edit.' + format + '', verb, params, options);}
function profile_blog_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '';}
function profile_blog_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '', verb, params, options);}
function profile_blog_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '', verb, params, options);}
function formatted_profile_blog_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '.' + format + '';}
function formatted_profile_blog_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_blog_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '.' + format + '', verb, params, options);}
function profile_photos_path(profile_id, verb){ return '/profiles/' + profile_id + '/photos';}
function profile_photos_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos', verb, params, options);}
function profile_photos_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos', verb, params, options);}
function formatted_profile_photos_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/photos.' + format + '';}
function formatted_profile_photos_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos.' + format + '', verb, params, options);}
function formatted_profile_photos_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos.' + format + '', verb, params, options);}
function new_profile_photo_path(profile_id, verb){ return '/profiles/' + profile_id + '/photos/new';}
function new_profile_photo_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/new', verb, params, options);}
function new_profile_photo_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/new', verb, params, options);}
function formatted_new_profile_photo_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/photos/new.' + format + '';}
function formatted_new_profile_photo_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/new.' + format + '', verb, params, options);}
function formatted_new_profile_photo_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/new.' + format + '', verb, params, options);}
function edit_profile_photo_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/photos/' + id + '/edit';}
function edit_profile_photo_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '/edit', verb, params, options);}
function edit_profile_photo_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_photo_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/photos/' + id + '/edit.' + format + '';}
function formatted_edit_profile_photo_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_photo_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '/edit.' + format + '', verb, params, options);}
function profile_photo_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/photos/' + id + '';}
function profile_photo_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '', verb, params, options);}
function profile_photo_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '', verb, params, options);}
function formatted_profile_photo_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/photos/' + id + '.' + format + '';}
function formatted_profile_photo_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_photo_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '.' + format + '', verb, params, options);}
function profile_comments_path(profile_id, verb){ return '/profiles/' + profile_id + '/comments';}
function profile_comments_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments', verb, params, options);}
function profile_comments_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments', verb, params, options);}
function formatted_profile_comments_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/comments.' + format + '';}
function formatted_profile_comments_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments.' + format + '', verb, params, options);}
function formatted_profile_comments_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments.' + format + '', verb, params, options);}
function new_profile_comment_path(profile_id, verb){ return '/profiles/' + profile_id + '/comments/new';}
function new_profile_comment_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/new', verb, params, options);}
function new_profile_comment_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/new', verb, params, options);}
function formatted_new_profile_comment_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/comments/new.' + format + '';}
function formatted_new_profile_comment_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/new.' + format + '', verb, params, options);}
function formatted_new_profile_comment_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/new.' + format + '', verb, params, options);}
function edit_profile_comment_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/comments/' + id + '/edit';}
function edit_profile_comment_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '/edit', verb, params, options);}
function edit_profile_comment_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_comment_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/comments/' + id + '/edit.' + format + '';}
function formatted_edit_profile_comment_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_comment_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '/edit.' + format + '', verb, params, options);}
function profile_comment_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/comments/' + id + '';}
function profile_comment_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '', verb, params, options);}
function profile_comment_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '', verb, params, options);}
function formatted_profile_comment_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/comments/' + id + '.' + format + '';}
function formatted_profile_comment_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_comment_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '.' + format + '', verb, params, options);}
function profile_feed_items_path(profile_id, verb){ return '/profiles/' + profile_id + '/feed_items';}
function profile_feed_items_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items', verb, params, options);}
function profile_feed_items_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items', verb, params, options);}
function formatted_profile_feed_items_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/feed_items.' + format + '';}
function formatted_profile_feed_items_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items.' + format + '', verb, params, options);}
function formatted_profile_feed_items_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items.' + format + '', verb, params, options);}
function new_profile_feed_item_path(profile_id, verb){ return '/profiles/' + profile_id + '/feed_items/new';}
function new_profile_feed_item_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/new', verb, params, options);}
function new_profile_feed_item_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/new', verb, params, options);}
function formatted_new_profile_feed_item_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/feed_items/new.' + format + '';}
function formatted_new_profile_feed_item_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/new.' + format + '', verb, params, options);}
function formatted_new_profile_feed_item_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/new.' + format + '', verb, params, options);}
function edit_profile_feed_item_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '/edit';}
function edit_profile_feed_item_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '/edit', verb, params, options);}
function edit_profile_feed_item_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_feed_item_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '/edit.' + format + '';}
function formatted_edit_profile_feed_item_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_feed_item_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '/edit.' + format + '', verb, params, options);}
function profile_feed_item_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '';}
function profile_feed_item_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '', verb, params, options);}
function profile_feed_item_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '', verb, params, options);}
function formatted_profile_feed_item_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '.' + format + '';}
function formatted_profile_feed_item_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_feed_item_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '.' + format + '', verb, params, options);}
function profile_messages_path(profile_id, verb){ return '/profiles/' + profile_id + '/messages';}
function profile_messages_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages', verb, params, options);}
function profile_messages_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages', verb, params, options);}
function formatted_profile_messages_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/messages.' + format + '';}
function formatted_profile_messages_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages.' + format + '', verb, params, options);}
function formatted_profile_messages_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages.' + format + '', verb, params, options);}
function new_profile_message_path(profile_id, verb){ return '/profiles/' + profile_id + '/messages/new';}
function new_profile_message_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/new', verb, params, options);}
function new_profile_message_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/new', verb, params, options);}
function formatted_new_profile_message_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/messages/new.' + format + '';}
function formatted_new_profile_message_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/new.' + format + '', verb, params, options);}
function formatted_new_profile_message_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/new.' + format + '', verb, params, options);}
function edit_profile_message_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/messages/' + id + '/edit';}
function edit_profile_message_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '/edit', verb, params, options);}
function edit_profile_message_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_message_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/messages/' + id + '/edit.' + format + '';}
function formatted_edit_profile_message_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_message_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '/edit.' + format + '', verb, params, options);}
function profile_message_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/messages/' + id + '';}
function profile_message_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '', verb, params, options);}
function profile_message_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '', verb, params, options);}
function formatted_profile_message_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/messages/' + id + '.' + format + '';}
function formatted_profile_message_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_message_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '.' + format + '', verb, params, options);}
function profile_arcades_path(profile_id, verb){ return '/profiles/' + profile_id + '/arcades';}
function profile_arcades_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades', verb, params, options);}
function profile_arcades_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades', verb, params, options);}
function formatted_profile_arcades_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/arcades.' + format + '';}
function formatted_profile_arcades_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades.' + format + '', verb, params, options);}
function formatted_profile_arcades_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades.' + format + '', verb, params, options);}
function new_profile_arcade_path(profile_id, verb){ return '/profiles/' + profile_id + '/arcades/new';}
function new_profile_arcade_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/new', verb, params, options);}
function new_profile_arcade_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/new', verb, params, options);}
function formatted_new_profile_arcade_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/arcades/new.' + format + '';}
function formatted_new_profile_arcade_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/new.' + format + '', verb, params, options);}
function formatted_new_profile_arcade_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/new.' + format + '', verb, params, options);}
function edit_profile_arcade_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/arcades/' + id + '/edit';}
function edit_profile_arcade_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/' + id + '/edit', verb, params, options);}
function edit_profile_arcade_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_arcade_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/arcades/' + id + '/edit.' + format + '';}
function formatted_edit_profile_arcade_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_arcade_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/' + id + '/edit.' + format + '', verb, params, options);}
function profile_arcade_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/arcades/' + id + '';}
function profile_arcade_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/' + id + '', verb, params, options);}
function profile_arcade_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/' + id + '', verb, params, options);}
function formatted_profile_arcade_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/arcades/' + id + '.' + format + '';}
function formatted_profile_arcade_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/arcades/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_arcade_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/arcades/' + id + '.' + format + '', verb, params, options);}
function profile_games_path(profile_id, verb){ return '/profiles/' + profile_id + '/games';}
function profile_games_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games', verb, params, options);}
function profile_games_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games', verb, params, options);}
function formatted_profile_games_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/games.' + format + '';}
function formatted_profile_games_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games.' + format + '', verb, params, options);}
function formatted_profile_games_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games.' + format + '', verb, params, options);}
function new_profile_game_path(profile_id, verb){ return '/profiles/' + profile_id + '/games/new';}
function new_profile_game_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/new', verb, params, options);}
function new_profile_game_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/new', verb, params, options);}
function formatted_new_profile_game_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/games/new.' + format + '';}
function formatted_new_profile_game_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/new.' + format + '', verb, params, options);}
function formatted_new_profile_game_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/new.' + format + '', verb, params, options);}
function edit_profile_game_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/games/' + id + '/edit';}
function edit_profile_game_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/' + id + '/edit', verb, params, options);}
function edit_profile_game_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/' + id + '/edit', verb, params, options);}
function formatted_edit_profile_game_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/games/' + id + '/edit.' + format + '';}
function formatted_edit_profile_game_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_game_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/' + id + '/edit.' + format + '', verb, params, options);}
function profile_game_path(profile_id, id, verb){ return '/profiles/' + profile_id + '/games/' + id + '';}
function profile_game_ajax(profile_id, id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/' + id + '', verb, params, options);}
function profile_game_ajaxx(profile_id, id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/' + id + '', verb, params, options);}
function formatted_profile_game_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/games/' + id + '.' + format + '';}
function formatted_profile_game_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/games/' + id + '.' + format + '', verb, params, options);}
function formatted_profile_game_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/games/' + id + '.' + format + '', verb, params, options);}
function new_profile_address_path(profile_id, verb){ return '/profiles/' + profile_id + '/address/new';}
function new_profile_address_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address/new', verb, params, options);}
function new_profile_address_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address/new', verb, params, options);}
function formatted_new_profile_address_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/address/new.' + format + '';}
function formatted_new_profile_address_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address/new.' + format + '', verb, params, options);}
function formatted_new_profile_address_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address/new.' + format + '', verb, params, options);}
function edit_profile_address_path(profile_id, verb){ return '/profiles/' + profile_id + '/address/edit';}
function edit_profile_address_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address/edit', verb, params, options);}
function edit_profile_address_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address/edit', verb, params, options);}
function formatted_edit_profile_address_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/address/edit.' + format + '';}
function formatted_edit_profile_address_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address/edit.' + format + '', verb, params, options);}
function formatted_edit_profile_address_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address/edit.' + format + '', verb, params, options);}
function profile_address_path(profile_id, verb){ return '/profiles/' + profile_id + '/address';}
function profile_address_ajax(profile_id, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address', verb, params, options);}
function profile_address_ajaxx(profile_id, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address', verb, params, options);}
function formatted_profile_address_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/address.' + format + '';}
function formatted_profile_address_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/address.' + format + '', verb, params, options);}
function formatted_profile_address_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/address.' + format + '', verb, params, options);}
function sent_messages_path(verb){ return '/messages/sent';}
function sent_messages_ajax(verb, params, options){ return less_ajax('/messages/sent', verb, params, options);}
function sent_messages_ajaxx(verb, params, options){ return less_ajaxx('/messages/sent', verb, params, options);}
function formatted_sent_messages_path(format, verb){ return '/messages/sent.' + format + '';}
function formatted_sent_messages_ajax(format, verb, params, options){ return less_ajax('/messages/sent.' + format + '', verb, params, options);}
function formatted_sent_messages_ajaxx(format, verb, params, options){ return less_ajaxx('/messages/sent.' + format + '', verb, params, options);}
function messages_path(verb){ return '/messages';}
function messages_ajax(verb, params, options){ return less_ajax('/messages', verb, params, options);}
function messages_ajaxx(verb, params, options){ return less_ajaxx('/messages', verb, params, options);}
function formatted_messages_path(format, verb){ return '/messages.' + format + '';}
function formatted_messages_ajax(format, verb, params, options){ return less_ajax('/messages.' + format + '', verb, params, options);}
function formatted_messages_ajaxx(format, verb, params, options){ return less_ajaxx('/messages.' + format + '', verb, params, options);}
function new_message_path(verb){ return '/messages/new';}
function new_message_ajax(verb, params, options){ return less_ajax('/messages/new', verb, params, options);}
function new_message_ajaxx(verb, params, options){ return less_ajaxx('/messages/new', verb, params, options);}
function formatted_new_message_path(format, verb){ return '/messages/new.' + format + '';}
function formatted_new_message_ajax(format, verb, params, options){ return less_ajax('/messages/new.' + format + '', verb, params, options);}
function formatted_new_message_ajaxx(format, verb, params, options){ return less_ajaxx('/messages/new.' + format + '', verb, params, options);}
function edit_message_path(id, verb){ return '/messages/' + id + '/edit';}
function edit_message_ajax(id, verb, params, options){ return less_ajax('/messages/' + id + '/edit', verb, params, options);}
function edit_message_ajaxx(id, verb, params, options){ return less_ajaxx('/messages/' + id + '/edit', verb, params, options);}
function formatted_edit_message_path(id, format, verb){ return '/messages/' + id + '/edit.' + format + '';}
function formatted_edit_message_ajax(id, format, verb, params, options){ return less_ajax('/messages/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_message_ajaxx(id, format, verb, params, options){ return less_ajaxx('/messages/' + id + '/edit.' + format + '', verb, params, options);}
function message_path(id, verb){ return '/messages/' + id + '';}
function message_ajax(id, verb, params, options){ return less_ajax('/messages/' + id + '', verb, params, options);}
function message_ajaxx(id, verb, params, options){ return less_ajaxx('/messages/' + id + '', verb, params, options);}
function formatted_message_path(id, format, verb){ return '/messages/' + id + '.' + format + '';}
function formatted_message_ajax(id, format, verb, params, options){ return less_ajax('/messages/' + id + '.' + format + '', verb, params, options);}
function formatted_message_ajaxx(id, format, verb, params, options){ return less_ajaxx('/messages/' + id + '.' + format + '', verb, params, options);}
function blogs_path(verb){ return '/blogs';}
function blogs_ajax(verb, params, options){ return less_ajax('/blogs', verb, params, options);}
function blogs_ajaxx(verb, params, options){ return less_ajaxx('/blogs', verb, params, options);}
function formatted_blogs_path(format, verb){ return '/blogs.' + format + '';}
function formatted_blogs_ajax(format, verb, params, options){ return less_ajax('/blogs.' + format + '', verb, params, options);}
function formatted_blogs_ajaxx(format, verb, params, options){ return less_ajaxx('/blogs.' + format + '', verb, params, options);}
function new_blog_path(verb){ return '/blogs/new';}
function new_blog_ajax(verb, params, options){ return less_ajax('/blogs/new', verb, params, options);}
function new_blog_ajaxx(verb, params, options){ return less_ajaxx('/blogs/new', verb, params, options);}
function formatted_new_blog_path(format, verb){ return '/blogs/new.' + format + '';}
function formatted_new_blog_ajax(format, verb, params, options){ return less_ajax('/blogs/new.' + format + '', verb, params, options);}
function formatted_new_blog_ajaxx(format, verb, params, options){ return less_ajaxx('/blogs/new.' + format + '', verb, params, options);}
function edit_blog_path(id, verb){ return '/blogs/' + id + '/edit';}
function edit_blog_ajax(id, verb, params, options){ return less_ajax('/blogs/' + id + '/edit', verb, params, options);}
function edit_blog_ajaxx(id, verb, params, options){ return less_ajaxx('/blogs/' + id + '/edit', verb, params, options);}
function formatted_edit_blog_path(id, format, verb){ return '/blogs/' + id + '/edit.' + format + '';}
function formatted_edit_blog_ajax(id, format, verb, params, options){ return less_ajax('/blogs/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_blog_ajaxx(id, format, verb, params, options){ return less_ajaxx('/blogs/' + id + '/edit.' + format + '', verb, params, options);}
function blog_path(id, verb){ return '/blogs/' + id + '';}
function blog_ajax(id, verb, params, options){ return less_ajax('/blogs/' + id + '', verb, params, options);}
function blog_ajaxx(id, verb, params, options){ return less_ajaxx('/blogs/' + id + '', verb, params, options);}
function formatted_blog_path(id, format, verb){ return '/blogs/' + id + '.' + format + '';}
function formatted_blog_ajax(id, format, verb, params, options){ return less_ajax('/blogs/' + id + '.' + format + '', verb, params, options);}
function formatted_blog_ajaxx(id, format, verb, params, options){ return less_ajaxx('/blogs/' + id + '.' + format + '', verb, params, options);}
function blog_comments_path(blog_id, verb){ return '/blogs/' + blog_id + '/comments';}
function blog_comments_ajax(blog_id, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments', verb, params, options);}
function blog_comments_ajaxx(blog_id, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments', verb, params, options);}
function formatted_blog_comments_path(blog_id, format, verb){ return '/blogs/' + blog_id + '/comments.' + format + '';}
function formatted_blog_comments_ajax(blog_id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments.' + format + '', verb, params, options);}
function formatted_blog_comments_ajaxx(blog_id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments.' + format + '', verb, params, options);}
function new_blog_comment_path(blog_id, verb){ return '/blogs/' + blog_id + '/comments/new';}
function new_blog_comment_ajax(blog_id, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/new', verb, params, options);}
function new_blog_comment_ajaxx(blog_id, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/new', verb, params, options);}
function formatted_new_blog_comment_path(blog_id, format, verb){ return '/blogs/' + blog_id + '/comments/new.' + format + '';}
function formatted_new_blog_comment_ajax(blog_id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/new.' + format + '', verb, params, options);}
function formatted_new_blog_comment_ajaxx(blog_id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/new.' + format + '', verb, params, options);}
function edit_blog_comment_path(blog_id, id, verb){ return '/blogs/' + blog_id + '/comments/' + id + '/edit';}
function edit_blog_comment_ajax(blog_id, id, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '/edit', verb, params, options);}
function edit_blog_comment_ajaxx(blog_id, id, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '/edit', verb, params, options);}
function formatted_edit_blog_comment_path(blog_id, id, format, verb){ return '/blogs/' + blog_id + '/comments/' + id + '/edit.' + format + '';}
function formatted_edit_blog_comment_ajax(blog_id, id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '/edit.' + format + '', verb, params, options);}
function formatted_edit_blog_comment_ajaxx(blog_id, id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '/edit.' + format + '', verb, params, options);}
function blog_comment_path(blog_id, id, verb){ return '/blogs/' + blog_id + '/comments/' + id + '';}
function blog_comment_ajax(blog_id, id, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '', verb, params, options);}
function blog_comment_ajaxx(blog_id, id, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '', verb, params, options);}
function formatted_blog_comment_path(blog_id, id, format, verb){ return '/blogs/' + blog_id + '/comments/' + id + '.' + format + '';}
function formatted_blog_comment_ajax(blog_id, id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '.' + format + '', verb, params, options);}
function formatted_blog_comment_ajaxx(blog_id, id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '.' + format + '', verb, params, options);}
