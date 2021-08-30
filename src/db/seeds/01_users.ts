import { Knex } from 'knex';
import * as faker from 'faker';

// This works but we don't want to use relative paths...
// Disabled in eslint override.
import { hash } from '../../utils/bcrypt';

export async function seed(knex: Knex): Promise<void> {
	const numEntries = 100;
	const users = [];
	const promises = [];

	for (let i = 0; i < numEntries; i += 1) {
		promises.push(hash(faker.internet.password()));
	}
	const passwords = await Promise.all(promises);
	for (let i = 0; i < numEntries; i += 1) {
		users.push({
			username: faker.internet.userName(),
			email: faker.internet.email(),
			password: passwords[i],
			bio: faker.lorem.sentences(),
		});
	}

	// Inserts seed entries
	return knex('users').del().insert(users);
}
