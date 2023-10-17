import type { NextApiRequest, NextApiResponse } from 'next';

export const config = {
  runtime: 'edge',
  unstable_allowDynamic: [
    '**/node_modules/**/*.js',
  ],
};

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  res.status(200).json('ok');
}
