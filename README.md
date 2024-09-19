# heroku-buildpack-jemalloc

[jemalloc](http://jemalloc.net/) is a general purpose malloc implementation
that works to avoid memory fragmentation in multithreaded applications. This
buildpack makes it easy to install and use jemalloc on Heroku and compatible
platforms.

## Install

```bash
# Add the buildpack
heroku buildpacks:add --index 1 https://github.com/thatcleanlife/heroku-buildpack-jemalloc.git

#Deploy
git push heroku master
```

## Usage

### Recommended

Set the JEMALLOC_ENABLED config option to true and jemalloc will be used for
all commands run inside of your dynos.

```bash
heroku config:set JEMALLOC_ENABLED=true
```

### Per dyno

To control when jemalloc is configured on a per dyno basis use
`jemalloc.sh <cmd>` and ensure that JEMALLOC_ENABLED is unset.

Example Procfile:
```yaml
web: jemalloc.sh bundle exec puma -C config/puma.rb
```

## Configuration

### JEMALLOC_ENABLED

Set this to true to automatically enable jemalloc.

```bash
heroku config:set JEMALLOC_ENABLED=true
```

To disable jemalloc set the option to false. This will cause the application to
restart disabling jemalloc.

```bash
heroku config:set JEMALLOC_ENABLED=false
```

### JEMALLOC_VERSION

Set this to select or pin to a specific version of jemalloc. The default is to
use the latest stable version if this is not set. You will receive an error
mentioning tar if the version does not exist.

**Default**: `5.3.0`

**note:** This setting is only used during slug compilation. Changing it will
require a code change to be deployed in order to take affect.

```bash
heroku config:set JEMALLOC_VERSION=5.3.0
```

#### Available Versions

| Version |
| ------- |
| [5.2.1](https://github.com/jemalloc/jemalloc/releases/tag/5.2.1) |
| [5.3.0](https://github.com/jemalloc/jemalloc/releases/tag/5.3.0) |

The complete and most up to date list of supported versions and stacks is
available on the [releases page.](https://github.com/thatcleanlife/heroku-buildpack-jemalloc/releases)

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```bash
make VERSION=5.3.0
```

Artifacts will be dropped in `dist/` based on Heroku stack and jemalloc version.

### Deploying New Versions

- `make VERSION=X.Y.Z`
- `open dist`
- Go to [releases](https://github.com/thatcleanlife/heroku-buildpack-jemalloc/releases)
- Edit the release corresponding to each heroku Stack
- Drag and drop the new build to attach

### Creating a New Stack
- Go to [releases](https://github.com/thatcleanlife/heroku-buildpack-jemalloc/releases)
- Click "Draft a new release"
- Tag is the name of the Stack (e.g. `heroku-18`)
- Target is `master`
- Title is `[stack]`