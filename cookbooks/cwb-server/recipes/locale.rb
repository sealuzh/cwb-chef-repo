# Attempt to fix failure on some Ubuntu 18.04 with
# incompatible locales during DB setup.
# See: https://github.com/sous-chefs/postgresql/issues/555
# Ensure same local in DB config instead:
# https://github.com/sous-chefs/postgresql
target_locale = node['cwb-server']['system']['locale']
locale target_locale do
  lang        target_locale
  lc_all      target_locale
  action      :update
end
