import path from 'path';

import express from 'express';
import cors from 'cors';
import Knex from 'knex';
import dotenv from 'dotenv';
import { Model } from 'objection';

import knexConfig from 'config/knexfile';

dotenv.config();
const env = process.env.NODE_ENV || 'development';

console.log(process.env.NODE_ENV);

// TODO: .env.development.local file isn't being seen?
// But .env is?

if (env !== 'development') {
	process.exit(1);
}

const knex = Knex(knexConfig);
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
