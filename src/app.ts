import path from 'path';

import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { Model } from 'objection';

import knex from 'db/knex';

dotenv.config(); // TODO: { path: path.join(process.pwd(), '.env.development.local') }
const env = process.env.NODE_ENV || 'development';

if (env !== 'development') {
	process.exit(1);
}
Model.knex(knex);

const app = express();
app.use(cors());
app.use(express.json());
app.use('/static', express.static(path.join(__dirname, 'public')));

app.get('/', async (_, res) => res.send('Hello world!'));

const port = process.env.PORT || 3000;
app.listen(port, () => {
	console.log('App is listening at port %s', port);
});
