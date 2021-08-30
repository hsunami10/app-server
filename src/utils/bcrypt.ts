import bcrypt from 'bcrypt';

/**
 * Hashes the argument with bcrypt and returns the hashed value.
 * Throws an error if something goes wrong with hashing.
 * @param plaintext The string to hash.
 * @returns A hashed string.
 */
export const hash = async (plaintext: string) => {
	try {
		return await bcrypt.hash(plaintext, 10);
	} catch (error) {
		// TODO: Don't throw here, log instead.
		const msg = 'Something went wrong with bcrypt hashing.';
		console.error(error || msg);
		throw new Error(msg);
	}
};
