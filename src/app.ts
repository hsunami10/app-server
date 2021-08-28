import express from 'express';
import cors from 'cors';
import Knex from 'knex';
import dotenv from 'dotenv';
import { Model } from 'objection';

import knexConfig from 'config/knexfile';

dotenv.config();
const env = process.env.NODE_ENV || 'development';

if (env !== 'development') {
	process.exit(1);
}

const knex = Knex(knexConfig.development);
Model.knex(knex);

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 3000;
app.listen(port, () => {
	console.log('App is listening at port %s', port);
});
