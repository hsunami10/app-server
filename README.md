[toc]

## Setup

### Install VSCode

#### Extensions
- vscode-icons
- YAML
- React Native Tools
- Prettier - Code formatter
- Path Intellisense
- Terminal
- GraphQL
- Gitlens - Git supercharged
- gitignore
- Better Comments
- DotENV
- ESLint
- ES7+ React/Redux/React-Native snippets
- Bash IDE
- shell-format
- AutoComplate Shell
- Shell Syntax

### Install brew packages

```bash
brew install postgresql git watchman ruby node nvm yarn emacs
```

### Install [iTermocil](https://github.com/TomAnthony/itermocil)

```bash
brew install TomAnthony/brews/itermocil
mkdir ~/.itermocil
touch ~/.itermocil/app-server.yml
itermocil --edit app-server
```

In `~/.itermocil/app-server.yml`:

```yaml
windows:
  - name: Dev
    root: ~/app-server
    panes:
      - sh ./scripts/watchman/setup.sh
  - name: Watchers
    root: ~/app-server
    layout: even-horizontal
    panes:
      - yarn dev
      - yarn tsc --watch
```

Then run:

```bash
itermocil app-server
```

#### Troubleshooting

If you encounter the below error:

```bash
Error: Invalid formula: /usr/local/Homebrew/Library/Taps/tomanthony/homebrew-brews/Formula/squid.rb
squid: Calling `sha256 "digest" => :tag` in a bottle block is disabled! Use `brew style --fix` on the formula to update the style or use `sha256 tag: "digest"` instead.
Please report this issue to the tomanthony/brews tap (not Homebrew/brew or Homebrew/core), or even better, submit a PR to fix it:
  /usr/local/Homebrew/Library/Taps/tomanthony/homebrew-brews/Formula/squid.rb:9

Error: Cannot tap tomanthony/brews: invalid syntax in tap!
```

[Build the formula from sources:](https://github.com/TomAnthony/itermocil/issues/117#issuecomment-874879053)

```bash
git clone git@github.com:TomAnthony/homebrew-brews.git
cd homebrew-brews/
brew style --fix Formula
brew install --build-from-source Formula/itermocil.rb
mkdir ~/.itermocil # Continue with steps from above
```

## General Troubleshooting

### Postgresql

```bash
waiting for server to start....2022-06-25 19:19:10.190 CDT [20122] FATAL:  database files are incompatible with server
2022-06-25 19:19:10.190 CDT [20122] DETAIL:  The data directory was initialized by PostgreSQL version 13, which is not compatible with this version 14.4.
```
Run: `brew postgresql-upgrade-database` per [this link](https://stackoverflow.com/a/53745770).

## Database schema

https://dbdiagram.io/d/5c66f857f7c5bb70c72f0802

## Package Management

### `knex` and `objection`

The latest stable versions as of 08/27/2021 typescript type definitions are broken:

- objection `v2.2.15`
- knex `v0.95.10`

Objection was upgraded with `yarn add objection@next` ([see github link here](https://github.com/Vincit/objection.js/issues/2012#issuecomment-881352171)) to `v3.0.0-alpha.4` which fixes the typing issue.

## Learning Resources

### [Bcrypt](https://www.npmjs.com/package/bcrypt)

- https://gist.github.com/laurenfazah/f9343ae8577999d301334fc68179b485

### Typescript

- https://khalilstemmler.com/blogs/typescript/eslint-for-typescript/
- https://iamturns.com/typescript-babel/
- https://robertcooper.me/post/using-eslint-and-prettier-in-a-typescript-project
- https://blog.logrocket.com/babel-vs-typescript/
- https://medium.com/@lucksp_22012/3-options-to-compile-typescript-to-js-rollup-tsc-babel-3319977a6946

In the future, babel is definitely needed for transpiling in different envs.

Therefore, tsc is currently used just for static type-checking (no compiling / transpiling) and babel is used for transpiling (removing types). Babel does not check for types when transpiling so that is done manually with the `yarn run tsc`.

### Postgres support

We decided to use objection.js (for querying) and knex (for migrations).

- [Why objection is better than ORM](https://www.jakso.me/blog/objection-to-orm-hatred)
- [Knex db migrations](https://medium.com/patrik-bego/database-schema-migrations-with-nodejs-de9d9090b177)
- https://stackoverflow.com/a/56040765
- [ORMs are anti-patterns](https://seldo.com/posts/orm_is_an_antipattern)

### Webpack

- [When to use and why](https://blog.andrewray.me/webpack-when-to-use-and-why/)

If you're building a complex Front End application with many **non-code static assets** such as CSS, images, fonts, etc, then **yes, Webpack will give you great benefits.**

If your application is fairly small, and you don't have many static assets and you only need to build one Javascript file to serve to the client, then **Webpack might be more overhead than you need.**

- https://stackoverflow.com/questions/37788142/webpack-for-back-end
- [Webpack with NodeJS](https://www.section.io/engineering-education/webpack/)

### Babel

- [Presets, plugins, config basics](https://medium.com/welldone-software/babel-js-guide-part-1-the-absolute-must-know-basics-plugins-presets-and-config-28150c199e45)
- [Babel beginner's guide](https://www.sitepoint.com/babel-beginners-guide/)
- [Example node server (with babel)](https://github.com/babel/example-node-server)
- Babel / webpack output directory should match the package.json `main` property

- [Correct way to compile with babel](https://gist.github.com/ncochard/6cce17272a069fdb4ac92569d85508f4#file-babel-webpack-md)

### Project directory / file structure:

- https://gist.github.com/tracker1/59f2c13044315f88bee9
- https://stackoverflow.com/a/22844164
- https://stackoverflow.com/a/39554555
- https://rencore.com/blog/deploy-vs-dist-vs-lib-sharepoint-framework-build-folders/
- https://stackoverflow.com/a/23731040

**Explanations**

- `src/` (source): The raw code before minification or concatenation or some other compilation - used to read/edit the code. This is where the original source files are located, before being compiled into fewer files to `dist/`, `public/` or `build/`.

- `lib/` is intended for code that can run as-is.

  - Refers to libraries that are included in a package.

  - Usually what `package.json { main }` points to
  - Users that install your package using `npm` / `yarn` will consume that directly

- `dist/` (distribution): The minified/concatenated version - actually used on production sites. Like cdn.js jquery.min.js script imports in html
  - **Used for shipping a UMD that a user can use if they aren't using package management**
  - For compiled / minified modules that can be used with other systems.
  - Code here is directly used by others without the need to compile or minify the source code that is being reused.
  - Usually JavaScript code is minified and obfuscated for use in production. Therefore, if you want to distribute a JavaScript library, it's advisable to put the plain (not minified) source code into a `src` (source) directory and the minified and obfuscated version into the `dist` (distributable) directory, so others can grab the minified version right away without having to minify it themselves.
  - If your project/module is to be built for use with other platforms (either directly in the browser), or in an `AMD` system (such as `require.js`), then these outputted files should reside under the `dist` directory. It is recommended to use a `(module)-(version).(platform).[min].js` format for the files that output into this directory. For example `foo-0.1.0.browser.min.js` or `foo-0.1.0.amd.js`.

- `build/` is for any scripts or tooling needed to build your project
  - Examples include scripts to fetch externally sourced data as part of your build process.
  - Another example would be using `build/tasks/` as a directory for separating tasks in a project.
- `bin/` is for any executable scripts, or compiled binaries used with, or built from your module.
  - Any system modules your package will use and/or generate.
    - The compiled `node_gyp` output for your module's binary code.
    - Pre-compiled platform binaries
    - `package.json/bin` scripts for your module
  - Files that get added to your PATH when installed
- `env/` is for any environment that's needed for testing

- `assets/` : static content like images, video, audio, fonts etc.
  - can also be in `public/assets`

**lib vs. src**

The difference in using `lib` vs `src` should be:

- `lib` if you can use node's `require()` directly
- `src` if you can not, or the file must otherwise be manipulated before use

If you are committing copies of module/files that are from other systems, the use of `(lib|src)/vendor/(vendor-name)/(project-name)/` is suggested.

**lib vs. dist**

- [Lib for libraries, dist for apps](https://github.com/babel/babel/issues/7237#issuecomment-359515101)

`lib/` - for Babel / transpiling / development

`dist/` - for Webpack / bundling / [production](https://stackoverflow.com/a/59819042)

[Example package.json script with dev / prod builds](https://www.linkedin.com/pulse/building-es6-crud-api-nodejs-expressjs-babel-kanti-vekariya/?articleId=6654378570548379648)

[Example node server (with babel)](https://github.com/babel/example-node-server) - uses `lib` for dev and `dist` for prod

