exports.up = function (knex) {
	return knex.schema.raw(
		`
		create table users (
			id bigserial not null,
			username text not null unique,
			email text not null unique,
			password text not null,
			bio text,
			created_at timestamp not null default current_timestamp,
			updated_at timestamp not null default current_timestamp,
			deleted_at timestamp,
			primary key (id)
		);

		create index users_id on users (id);
		create index users_created_at on users (created_at);
		create index users_updated_at on users (updated_at);
		`,
	);
};

exports.down = function (knex) {
	return knex.schema.raw(
		`
		drop index users_updated_at;
		drop index users_created_at;
		drop index users_id;

		drop table users;
		`,
	);
};
