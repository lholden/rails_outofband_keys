# rails_outofband_keys

`rails_outofband_keys` is a Rails plugin that changes **how Rails finds your credentials key files** (e.g., `production.key` or `master.key`). It allows you to keep these sensitive keys **outside of your project directory and git tree** (e.g., in `~/.config/`).

It does **not** replace Rails credentials, change where `credentials.yml.enc` lives, or alter how encryption works. It only dynamically configures `config.credentials.key_path` during the boot process.

## Resolution Order

1. If `RAILS_MASTER_KEY` is set in the environment, Rails uses it (this gem does nothing).
2. If `RAILS_CREDENTIALS_KEY_DIR` is set, it is used as the base directory for the app.
3. If `RAILS_OUTOFBAND_BASE_DIR` is set, it is used as the global base directory.
4. Otherwise, the gem fallbacks to OS defaults:
  - **Linux/macOS**: XDG config directory (`~/.config` fallback)
  - **Windows**: `%AppData%`

The final path is constructed as:
`base_directory / root_subdir / credentials_subdir / <environment>.key`
`base_directory / root_subdir / credentials_subdir / master.key`

## Configuration

Because Rails initializes credentials very early (especially for CLI tools like `credentials:edit`), this gem is configured via a YAML file located at `config/rails_outofband_keys.yml`.

### Example config/rails_outofband_keys.yml

```yaml
# The sub-folder for your application or organization
root_subdir: "my_org/my_app"

# The subdirectory where keys are stored (defaults to "credentials")
# Set to null if keys live directly in the root_subdir
credentials_subdir: "credentials"
```

## Permissions

On Unix-like systems, key files **must** have secure permissions. They must be owner-readable and **must not** be accessible by group or others (e.g., mode `0600` or `0400`). The app will raise an `InsecureKeyPermissionsError` and refuse to boot if permissions are too open.

## Installation

Add the gem to your Gemfile:

```ruby
gem "rails_outofband_keys", "~> 0.1.1"
```

## License

MIT
