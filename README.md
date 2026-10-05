# Setup

Sets up a Linux system from a minimal installation.

## Requirements

- A minimal Arch installation
- A regular user with `sudo` access
- `git`

## Usage

```
git clone https://github.com/albertobeloni/setup.git
cd setup
./setup
```

Run specific modules only:

```
./setup git bash
```

Do not run as root. Logs of failed steps are kept as `*.log` inside the module directory.

## Structure

- `distributions`: package manager wrappers
- `modules/<module>`: one module per component
- `hosts/<host>`: per-machine overrides (matched by hostname)

A module can contain:

| File           | Purpose                                     |
| -------------- | ------------------------------------------- |
| `install.sh`   | Installs packages                           |
| `configure.sh` | Optional `pre` and `post` hooks             |
| `home/`        | Symlinked into `~`                          |
| `root/`        | Copied into `/`                             |
| `requires`     | Modules to run first                        |
| `optional`     | Skipped unless listed in a host's `modules` |

A host's `modules` file lists optional modules to enable, or `!<module>` to skip one. Its `home/` and `root/` files override the modules' files. Use `SETUP_HOST=<name>` to pick a host other than the current hostname.

Replaced files are backed up to `~/.local/state/setup/backup`.

## License

Free to use at your own risk.
