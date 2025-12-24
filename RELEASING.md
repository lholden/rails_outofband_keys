# Releasing rails_outofband_keys

1. Update the version in `lib/rails_outofband_keys/version.rb`

2. Build, tag, push, and publish the gem:

   ```shell
   rake release
   rake github_release
   ```
