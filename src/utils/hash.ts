import bcrypt from 'bcrypt';

export default async (plaintext: string) => {
	try {
		return await bcrypt.hash(plaintext, 10);
	} catch (error) {
		// TODO: Don't throw here, log instead.
		console.error(error);
		throw new Error(error);
	}
};
