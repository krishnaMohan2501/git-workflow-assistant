# 🚀 Git Workflow Assistant

An intelligent Git workflow automation script powered by AI that simplifies branch management, conflict resolution, and team collaboration.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![GitHub Issues](https://img.shields.io/github/issues/yourusername/git-workflow-assistant)](https://github.com/yourusername/git-workflow-assistant/issues)

## ✨ Features

### 🤖 **AI-Powered Git Assistant**
- Natural language git commands via GitHub Copilot
- Automatic placeholder resolution (`<branch-name>`, `<commit>`, etc.)
- Smart error handling with contextual suggestions
- Interactive command mode for learning and productivity

### 🔄 **Automated Workflow Management**
- Intelligent common branch creation and management
- Automatic conflict resolution for version files (pom.xml, package.json)
- Multi-step rebase handling with conflict auto-resolution
- Cherry-pick integration for feature branches

### 🛡️ **Safety & Intelligence**
- Conflict detection and smart resolution strategies
- Safety checks for destructive operations
- Automatic PR creation with comprehensive descriptions
- Fallback pattern matching when AI is unavailable

## 🎯 Quick Start

### Prerequisites

- **Git** (obviously!)
- **GitHub CLI** (`gh`) - for AI features and PR creation
- **Python 3** - for smart conflict resolution
- **Bash 4.0+** - for script execution

### **🚀 Quick Installation**

```bash
# One-line installation (recommended)
curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash
```

### **🧪 Quick Test**

```bash
# Test the installation
git-workflow.sh --version

# Try it in a Git repository
cd your-git-repo
git-workflow.sh
```

### **🗑️ Quick Uninstall**

```bash
# One-line uninstall
curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash -s -- --uninstall
```

## 📖 Usage Guide

### 🔧 **Workflow Mode**

Perfect for team environments where multiple developers work on a common integration branch:

```bash
# Create and manage a common branch
./git-workflow.sh dev-common

# Integrate a feature branch into common branch
./git-workflow.sh dev-common feature-login
```

**What it does:**
1. ✅ Creates common branch from master (if needed)
2. ✅ Adds empty commit and creates draft PR
3. ✅ Integrates feature branch changes via rebase/cherry-pick
4. ✅ Automatically resolves conflicts (especially version conflicts)
5. ✅ Rebases onto master to maintain clean history
6. ✅ Force pushes with lease protection

### 🤖 **AI Command Mode**

Transform natural language into git commands:

```bash
./git-workflow.sh ai
```

**Example commands:**
- `"show me the last 5 commits"`
- `"create a new branch called feature-auth"`
- `"rebase current branch onto master"`
- `"merge develop into current branch"`
- `"undo the last commit but keep changes"`

### 💡 **Interactive Menu**

Just run the script without arguments:

```bash
./git-workflow.sh
```

Choose from:
1. **Workflow Mode** - Automated branch management
2. **AI Command Mode** - Natural language git assistant
3. **Help** - Detailed documentation
4. **Exit** - Quit the script

## 🎨 Examples

### Creating a New Common Branch

```bash
$ ./git-workflow.sh team-integration

🚀 Starting Intelligent Common Branch Workflow
==============================================
Common branch: team-integration
Master branch: master

📋 STEP 1: Checking Common Branch 'team-integration'
⚠️  WARNING: Common branch 'team-integration' does not exist
Create common branch 'team-integration'? (Y/n): Y

🔧 ACTION: Creating common branch 'team-integration'
✅ Empty commit created successfully
✅ Pull Request created successfully!
🔗 PR URL: https://github.com/yourrepo/pull/123
```

### AI Command Examples

```bash
🤖 Git AI> show me what changed in the last commit
🤖 AI Suggestion: git show --stat HEAD
Execute this command? (Y/n/edit): Y
🚀 EXECUTING: git show --stat HEAD
✅ SUCCESS: Command executed successfully

🤖 Git AI> rebase my branch onto master  
🤖 AI Suggestion: git rebase origin/master
Execute this command? (Y/n/edit): Y
🚀 EXECUTING: git rebase origin/master
✅ SUCCESS: Command executed successfully
```

### Automatic Conflict Resolution

```bash
📋 STEP 5: Syncing Common Branch with Master (Rebase)
🤖 CONFLICTS DETECTED - Starting automatic multi-step resolution...

🔄 Step 1: Resolving conflicts in rebase...
Conflicted files in step 1:
  pom.xml
  package.json

🔧 Auto-resolving: pom.xml
Version conflict: 1.2.0 vs 1.3.0 -> chose 1.3.0
✅ Auto-resolved: pom.xml

🎉 ALL CONFLICTS RESOLVED AUTOMATICALLY!
✅ SUCCESS: Rebase completed successfully
```

## 🛠️ Configuration

### Environment Variables

```bash
# Set default master branch (default: "master")
export GIT_WORKFLOW_MASTER_BRANCH="master"

# Enable debug mode
export GIT_WORKFLOW_DEBUG=1
```

### GitHub CLI Setup

```bash
# Authenticate with GitHub
gh auth login

# Verify installation
gh --version
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 **Bug Reports**
- Use the [issue tracker](https://github.com/yourusername/git-workflow-assistant/issues)
- Include your OS, shell version, and exact error message
- Provide steps to reproduce the issue

### 💡 **Feature Requests**
- Check existing issues first
- Describe the use case and expected behavior
- Consider submitting a PR if you can implement it!

### 🔧 **Development Setup**

```bash
# Fork and clone your fork
git clone https://github.com/yourusername/git-workflow-assistant.git
cd git-workflow-assistant

# Create a feature branch
git checkout -b feature/amazing-new-feature

# Make your changes and test thoroughly
./git-workflow.sh --help

# Commit with conventional commits
git commit -m "feat: add amazing new feature"

# Push and create PR
git push origin feature/amazing-new-feature
gh pr create --title "feat: add amazing new feature"
```

### 📋 **Code Style**
- Follow existing bash conventions
- Add comments for complex logic
- Include error handling for new features
- Test on multiple platforms if possible

## 🐛 Troubleshooting

### Common Issues

**Q: "Command not found: gh"**
```bash
# Install GitHub CLI
# macOS
brew install gh

# Ubuntu/Debian  
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh
```

**Q: How do I uninstall the tool?**
```bash
# One-line uninstall
curl -fsSL https://raw.githubusercontent.com/krishnaMohan2501/git-workflow-assistant/main/install.sh | bash -s -- --uninstall

# Or manual removal
rm -f ~/.local/bin/git-workflow* ~/.local/bin/gitflow ~/.local/bin/gwf
```

**Q: Placeholder errors like `<branch-name>`**
- The script should auto-resolve these
- If not, try updating to the latest version
- Report as a bug if it persists

### Debug Mode

```bash
# Enable verbose logging
export GIT_WORKFLOW_DEBUG=1
./git-workflow.sh your-command

# Check git status
git status
git log --oneline -5
```

## 📊 Compatibility

### Tested Environments
- ✅ **macOS** (Big Sur, Monterey, Ventura)
- ✅ **Ubuntu** 20.04, 22.04
- ✅ **Debian** 11, 12
- ✅ **CentOS/RHEL** 8, 9
- ⚠️ **Windows** (via WSL or Git Bash)

### Requirements
- **Bash** 4.0+ (macOS users may need to upgrade)
- **Git** 2.20+
- **GitHub CLI** 2.0+
- **Python** 3.6+ (for conflict resolution)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **GitHub Copilot** - For AI-powered git suggestions
- **GitHub CLI team** - For the excellent `gh` tool
- **Git community** - For the amazing version control system
- **Contributors** - Everyone who helps improve this project

## 📞 Support

- 📖 **Documentation**: Check this README and `--help` output
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/yourusername/git-workflow-assistant/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/git-workflow-assistant/discussions)
- 📧 **Email**: your.email@example.com

---

⭐ **Star this repo** if it helps you! It motivates us to keep improving.

🔧 **Made with ❤️ for developers who love clean Git workflows**
