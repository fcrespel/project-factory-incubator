# Interpolate templates
ensurepassword MATTERMOST_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config/config.json"

# Fix permissions
chmod +x "@{package.app}/bin/platform" "@{package.app}/bin/mattermost"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}" "@{package.log}"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{mattermost.db.name}" || ! mysql_createuser "@{mattermost.db.user}" "$MATTERMOST_DB_PASSWORD" "@{mattermost.db.name}"; then
	rm -f "$POSTINSTALL_OUTPUT"
	exit 1
fi

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service mattermost
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Mattermost"
fi
