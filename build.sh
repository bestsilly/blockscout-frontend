#!/bin/bash
eval $(node exportEnvs.js)

echo "🔷 Installing dependencies for the main application..."
yarn install --frozen-lockfile --ignore-optional

echo "🔷 Installing dependencies for feature-reporter..."
cd ./deploy/tools/feature-reporter
yarn install --frozen-lockfile

echo "🔷 Installing dependencies for envs-validator..."
cd ../envs-validator
yarn install --frozen-lockfile

echo "🔷 Returning to main app directory (root project directory)..."
cd ../../..

echo "🔷 Generating .env.registry with ENVs list..."
./deploy/scripts/collect_envs.sh ./docs/ENVS.md

echo "🔷 Building the main application..."
npx @cloudflare/next-on-pages@1

echo "🔷 Building the feature-reporter tool..."
cd ./deploy/tools/feature-reporter
yarn compile_config
yarn build

echo "🔷 Building the envs-validator tool..."
cd ../envs-validator
yarn build

echo "🔷 Returning to main app directory (root project directory)..."
cd ../../..

echo "🔷 Downloading external assets..."
./deploy/scripts/download_assets.sh ./public/assets

echo "🔷 Validating environment variables..."
./deploy/scripts/validate_envs.sh
if [ $? -ne 0 ]; then
  echo "❌ Environment validation failed."
  exit 1
fi

# echo "🔷 Generating favicons..."
# ./deploy/scripts/favicon_generator.sh
# if [ $? -ne 0 ]; then
#   echo "❌ Favicon generation failed."
#   exit 1
# fi

echo "🔷 Creating envs.js for the client..."
./deploy/scripts/make_envs_script.sh

echo "🔷 Build process completed!"
