# Git

## GitHub Authentication

1. Generate a new SSH key: `ssh-keygen -t ed25519`
2. Register the public key in GitHub: `cat ~/.ssh/id_ed25519.pub`
3. Authenticate in GitHub: `ssh -T git@github.com`
