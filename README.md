# rails_outofband_keys

`rails_outofband_keys` is a small Rails plugin that changes **how Rails finds the credentials key file**
(e.g. `production.key` / `master.key`) so you can keep key files **out of the project directory / git tree**.

It does **not** replace Rails credentials, does **not** change where `credentials.yml.enc` lives, and does
**not** change how encryption works. It only sets `config.credentials.key_path`.

## Resolution order

1. If `RAILS_MASTER_KEY` is set, Rails uses it (this gem does nothing).
2. If `RAILS_CREDENTIALS_KEY_DIR` is set, it is used as the base directory for that specific app.
3. If `RAILS_OUTOFBAND_BASE_DIR` is set, it is used as the global base directory.
4. Otherwise:
   - Linux/macOS: XDG config directory (`~/.config` fallback)
   - Windows: `%AppData%`

Then:

- `<root_subdir>/<credentials_subdir>/<Rails.env>.key`
- `<root_subdir>/<credentials_subdir>/master.key`

By default, `<root_subdir>` is your application's name (e.g., `my_app`) and `<credentials_subdir>` is `credentials`.

## Permissions

On Unix systems, key files **must** be owner-readable and **must not** be accessible by group or others (e.g., mode `0600` or `0400`). The app will raise an `InsecureKeyPermissionsError` and refuse to boot if permissions are too open.

## Configuration

```ruby
# config/application.rb

# Change the root directory (defaults to app name)
config.rails_outofband_keys.root_subdir = "my_custom_folder"

# You can also use nested paths to group apps by organization
config.rails_outofband_keys.root_subdir = "my_org/my_app"

# Or use a Proc for dynamic resolution based on the app name
config.rails_outofband_keys.root_subdir = ->(app_name) { "internal/#{app_name}" }

# Change or remove the credentials sub-folder (defaults to "credentials")
config.rails_outofband_keys.credentials_subdir = nil # Keys live directly in the root_subdir
```

## License

MIT
