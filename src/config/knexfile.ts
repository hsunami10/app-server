import dotenv from 'dotenv';
import pg from 'pg';

dotenv.config();
pg.defaults.ssl = true;

export default {
	client: 'pg',
	migrations: {
		tableName: 'knex_migrations',
		directory: '../db/migrations',
	},
	// TODO: Log using logger here.
	// log: {
	// 	warn(message) {},
	// 	error(message) {},
	// 	deprecate(message) {},
	// 	debug(message) {},
	// },

	development: {
		connection: {
			host: process.env.POSTGRES_DATABASE_HOST,
			port: parseInt(process.env.POSTGRES_DATABASE_PORT || '5432', 10),
			database: process.env.POSTGRES_DATABASE_NAME,
			user: process.env.POSTGRES_DATABASE_USER,
			// password: undefined,
		},
	},

	// staging: {
	// 	connection: {
	// 		database: 'my_db',
	// 		user: 'username',
	// 		password: 'password',
	// 	},
	// 	pool: {
	// 		min: 2,
	// 		max: 10,
	// 	},
	// 	migrations: {
	// 		tableName: 'knex_migrations',
	// 	},
	// },

	// production: {
	// 	connection: {
	// 		database: 'my_db',
	// 		user: 'username',
	// 		password: 'password',
	// 	},
	// 	pool: {
	// 		min: 2,
	// 		max: 10,
	// 	},
	// 	migrations: {
	// 		tableName: 'knex_migrations',
	// 	},
	// },
};
