# Contributing to Git Workflow Assistant

Thank you for your interest in contributing! This guide will help you get started.

## 🎯 Ways to Contribute

### 🐛 Bug Reports
- Use clear, descriptive titles
- Include steps to reproduce
- Mention your OS and shell version
- Provide error messages and logs

### 💡 Feature Requests
- Check existing issues first
- Describe the problem you're solving
- Explain the expected behavior
- Consider implementation complexity

### 📝 Documentation
- Fix typos and improve clarity
- Add examples and use cases
- Update installation instructions
- Improve troubleshooting guides

### 🔧 Code Contributions
- Follow existing code style
- Add tests for new features
- Update documentation
- Use conventional commit messages

## 🚀 Development Setup

### Prerequisites
```bash
# Required tools
git --version          # Git 2.20+
bash --version         # Bash 4.0+
gh --version           # GitHub CLI 2.0+
python3 --version      # Python 3.6+
```

### Getting Started
```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork
git clone https://github.com/yourusername/git-workflow-assistant.git
cd git-workflow-assistant

# 3. Create a feature branch
git checkout -b feature/your-feature-name

# 4. Make your changes
# ... edit files ...

# 5. Test your changes
./git-workflow.sh --help
./git-workflow.sh git-mode

# 6. Commit your changes
git add .
git commit -m "feat: add your feature description"

# 7. Push and create PR
git push origin feature/your-feature-name
gh pr create --title "feat: your feature description"
```

## 📋 Code Style Guidelines

### Shell Script Conventions
```bash
# Use descriptive function names
process_git_command() {
    local user_input="$1"
    # ...
}

# Add error handling
if ! command -v gh >/dev/null 2>&1; then
    log_error "GitHub CLI not found"
    return 1
fi

# Use consistent logging
log_action "Performing operation..."
log_success "Operation completed"
log_warning "Something to note"
log_error "Something went wrong"

# Quote variables to prevent word splitting
local branch_name="$1"
git checkout "$branch_name"
```

### Documentation Style
- Use clear, concise language
- Include code examples
- Add emoji for visual appeal (sparingly)
- Structure with headers and lists

## 🧪 Testing

### Manual Testing
```bash
# Test different modes
./git-workflow.sh                    # Menu mode
./git-workflow.sh help               # Help mode
./git-workflow.sh git-mode           # AI mode
./git-workflow.sh test-branch        # Workflow mode

# Test error conditions
./git-workflow.sh nonexistent-cmd   # Invalid command
# Run in non-git directory           # Error handling
```

### Test Scenarios
- [ ] Branch creation and PR generation
- [ ] Conflict resolution (create test conflicts)
- [ ] AI command processing
- [ ] Error handling and recovery
- [ ] Different Git configurations

## 📝 Commit Message Format

We use [Conventional Commits](https://conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples
```bash
feat: add automatic conflict resolution for package.json
fix: resolve placeholder detection in rebase commands
docs: update installation instructions for Windows
style: improve error message formatting
refactor: extract conflict resolution into separate function
```

## 🔍 Pull Request Process

### Before Submitting
- [ ] Test your changes thoroughly
- [ ] Update documentation if needed
- [ ] Add/update examples in README
- [ ] Check for typos and formatting
- [ ] Ensure backwards compatibility

### PR Description Template
```markdown
## 🎯 What does this PR do?
Brief description of changes...

## 🔧 Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## 🧪 Testing
- [ ] Tested manually
- [ ] Added new test cases
- [ ] Existing tests pass

## 📸 Screenshots (if applicable)
...

## 📋 Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
```

### Review Process
1. **Automated checks** run first
2. **Maintainer review** within 48-72 hours
3. **Address feedback** if any
4. **Merge** after approval

## 🐛 Issue Reporting

### Bug Report Template
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Run command '...'
2. Select option '...'
3. See error

**Expected behavior**
What you expected to happen.

**Environment:**
- OS: [e.g. macOS 13.0, Ubuntu 22.04]
- Shell: [e.g. bash 5.1]
- Git version: [e.g. 2.39.0]
- GitHub CLI: [e.g. 2.20.0]

**Additional context**
Any other context about the problem.
```

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Alternative solutions or features you've considered.

**Additional context**
Any other context or screenshots about the feature request.
```

## 🏷️ Release Process

### Versioning
We use [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- Major: Breaking changes
- Minor: New features (backwards compatible)
- Patch: Bug fixes

### Release Checklist
- [ ] Update version in script
- [ ] Update CHANGELOG.md
- [ ] Create git tag
- [ ] Create GitHub release
- [ ] Update documentation

## 🤝 Community Guidelines

### Be Respectful
- Use inclusive language
- Be patient with beginners
- Provide constructive feedback
- Assume good intentions

### Be Helpful
- Answer questions when possible
- Share knowledge and experience
- Help with code reviews
- Improve documentation

### Be Collaborative
- Discuss ideas openly
- Accept different approaches
- Work together on solutions
- Celebrate successes

## 🙋 Getting Help

### For Contributors
- **Discord/Slack**: [Community chat link]
- **Email**: maintainer@example.com
- **Issues**: For bugs and feature requests
- **Discussions**: For questions and ideas

### For Users
- **README**: Start here for usage info
- **Issues**: Report bugs and request features
- **Discussions**: Ask questions and share tips

## 📚 Resources

### Learning Git
- [Pro Git Book](https://git-scm.com/book)
- [Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

### Shell Scripting
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [ShellCheck](https://shellcheck.net/) - Script analysis tool
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

---

Thank you for contributing! 🎉 Your help makes this project better for everyone.
