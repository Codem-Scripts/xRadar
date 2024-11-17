fx_version 'cerulean'
game 'gta5'
version '1.0.0'
author 'lucidb_'

shared_scripts {
	'shared/*.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
	'server/server_config.lua',
	'server/tablet.lua',
	'server/main.lua',

}

ui_page "html/index.html"
files {
	'html/index.html',
	'html/css/*.css',
	'html/assets/*.png',
	'html/assets/*.jpg',

	'html/assets/*.svg',
	'html/assets/*.TTF',
	'html/assets/*.ttf',
	'html/assets/*.otf',
	'html/assets/*.ogg',
	'html/app/*.js',
	'html/app/**/*.js',
	'html/app/**/**/*.js',
	'html/app/**/**/*.html',
	'html/app/**/**/*.css',

	'html/app/**/**/**/*.js',
	'html/app/**/**/**/*.html',
	'html/app/**/**/**/*.css',


}

lua54 'yes'

escrow_ignore {
	'shared/*.lua',
	'server/server_config.lua',
	'client/editable.lua',

}
