# Change globals to match the proper value for your site

DELETE_CONFIRM = "Are you sure you want to delete?\nThis can not be undone."
SEARCH_LIMIT = 50
SITE_NAME = 'ArcadeFly.com'
SITE = RAILS_ENV == 'production' ? 'arcadefly.com' : 'localhost:3000'


MAILER_TO_ADDRESS = 'info@#{SITE}'
MAILER_FROM_ADDRESS = 'The ArcadeFly.com Team <support@arcadefly.com>'
REGISTRATION_RECIPIENTS = %W() #send an email to this list everytime someone signs up


YOUTUBE_BASE_URL = "http://gdata.youtube.com/feeds/api/videos/"


# Your Access Key ID:096RRJ93PTDQPZZ44802
# Your Secret Access Key: GXZ0vgPaG57k/vBEJFXyngpImh3yvziyWUfdXueJ
AMS_KEY = "096RRJ93PTDQPZZ44802"
AMAZON_ASSOCIATES_ID = "adamfortuna-20"
ALLOWED_HTML_TAGS = %w(a strong em br table tr td div span)