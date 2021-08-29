const faker = require('faker');

// NOTE: Should always match the schema.
exports.seed = function (knex) {
	const users = [];
	for (let i = 0; i < 100; i += 1) {
		users.push({
			username: faker.internet.userName(),
			email: faker.internet.email(),
			password: '', // TODO: hash password with bcrypt
			bio: faker.lorem.sentences(),
		});
	}
	return knex('users')
		.del()
		.then(() => knex('users').insert(users));
};
