[![Gem Version](https://badge.fury.io/rb/retest.svg)](https://badge.fury.io/rb/retest)

# Retest: Your Go-To Testing Assistant for Ruby Projects

Retest is the ultimate CLI tool for Ruby developers, designed to make your testing workflow seamless and efficient. It monitors file changes and automatically runs relevant tests, ensuring that your code remains solid as you refactor and develop.  

With **zero setup required**, Retest works right out of the box on any Ruby project—no changes to your Gemfile, no unnecessary repo clutter, and no configuration headaches. It's lightweight, dev-centric, and ready to integrate into your workflow instantly.  

## 🚀 **What Makes Retest Awesome?**

- **Plug-and-Play:** Start testing immediately—no installation hassles or setup scripts.
- **Project Independence:** Works with any Ruby project, no Gemfile modifications required.
- **Time-Saving Automation:** Automatically identifies and runs relevant tests as you code.
- **Customizable Workflows:** Tailor commands to your needs with placeholders, options, and interactive features.
- **Sound Notifications:** Get audible feedback for test results.

## 🎥 Demo

Discover Retest main functionalities in this small presentation

https://github.com/user-attachments/assets/5491bcad-134f-4843-9a6f-a474a1394e87

## 💡 **Why Use Retest?**

Testing frequently is the cornerstone of safe refactoring. Retest eliminates the friction of manual test execution by running tests after every file change, helping you stay just one `cmd + z` away from green tests.

## 🔧 **Quick Installation**

Install Retest globally in seconds:  

```bash
gem install retest
```

No need to add it to your Gemfile—just install and go!

## 🛠️ **Key Features**

### **Flexible Commands**  
Run tests with your preferred commands, placeholders, or patterns:  
```bash
retest 'bin/rails test <test> && rubocop <changed>' # Flexible placeholders
retest --all                                        # Run all tests on every file change
retest --diff origin/main                           # Test changes from a branch
```

### **Interactive Companion**  
Stay in control with an interactive shell for test management. Start Retest and enter `h` to explore available commands.  

```
Setup: [RAKE]
Command: 'bundle exec rake test TEST=<test>'
Watcher: [WATCHEXEC]

Launching Retest...
Ready to refactor! You can make file changes now

Type interactive command and press enter. Enter 'h' for help.
> h

* 'h', 'help'              # Prints help.
* 'p', 'pause'             # Pauses Retest. Tests aren't run on file change events until unpaused.
* 'u', 'unpause'           # Unpauses Retest.
* <ENTER>                  # Runs last changed triggered command.
* 'ra, 'run all'           # Runs all tests.
* 'f', 'force'             # Forces a selection of test to run on every file change.
* 'r', 'reset'             # Disables forced selection.
* 'd', 'diff' [GIT BRANCH] # Runs matching specs that changed from a target branch.
* 'c'                      # Clears window.
* 'e', 'exit'              # Exits Retest.

```
### **Supports Multiple Watchers**  
Retest ships with [Listen](https://github.com/guard/listen) for file monitoring but can use the more performant [Watchexec](https://github.com/watchexec/watchexec) if installed.  

To force a specific watcher:  
```bash
retest -w watchexec
```

## 🐳 **Works with Docker**

Retest can run inside Docker containers, ensuring your testing workflow stays consistent across environments.  

```bash
# Inside your container shell
gem install retest
retest 'bundle exec rails test <test>'
```

## ❤️ **Contributing**

Got feedback or ideas? [Start a new discussion](https://github.com/AlexB52/retest/discussions).

Bug reports and pull requests are welcome.

## 🛠️ **Development**

Want to contribute to Retest? Follow these steps to set up your environment

1. Clone the repo and install dependencies: `bin/setup`
2. Experiment with an interactive console: `bin/console`
3. Run retest with local changes applied: `bin/debug`
4. Run tests to ensure everything is working: `rake test`
5. To run integration tests:
	* bundler-app: `bin/test/bundler-app`
	* git-ruby: `bin/test/git-ruby`
	* hanami-app: `bin/test/hanami-app`
	* rails-app: `bin/test/rails-app`
	* rspec-rails: `bin/test/rspec-rails`
	* rspec-ruby: `bin/test/rspec-ruby`
	* ruby-app: `bin/test/ruby-app`
	* ruby-bare: `bin/test/ruby-bare`

Note, we squash all PRs and may edit commit messages for clarity or consistency.

## 🏁 Release

Ruby 3.4 requires being bundled with Gemfile-3.4. 
When creating a new version, make sure to also bundle with 3.4

	BUNDLE_GEMFILE=Gemfile-3.4 bundle install

## 📜 **License**  

Retest is open-source and available under the [MIT License](https://opensource.org/licenses/MIT).
