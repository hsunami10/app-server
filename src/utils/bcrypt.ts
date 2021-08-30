import bcrypt from 'bcrypt';

export const hash = async (plaintext: string) => {
	try {
		return await bcrypt.hash(plaintext, 10);
	} catch {
		// TODO: Don't throw here, log instead.
		const msg = 'Something went wrong with bcrypt hashing.';
		console.error(msg);
		throw new Error(msg);
	}
};
