workflow "Test, Build and Publish to NPM" {
  resolves = ["Publish"]
  on = "push"
}

# Install
action "Install" {
  uses = "actions/npm@master"
  args = "install --save-dev"
  env = {
    NODE_ENV = "development"
  }
}

# Run tests
action "Test" {
  uses = "actions/npm@master"
  needs = ["Install"]
  args = "test"
  env = {
    NODE_ENV = "test"
  }
}

# Run build
action "Build" {
  uses = "actions/npm@master"
  needs = ["Install", "Test"]
  args = "run build"
  env = {
    NODE_ENV = "development"
  }
}

# Filter for master branch
action "Master" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish" {
  uses = "actions/npm@master"
  needs = ["Master"]
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
