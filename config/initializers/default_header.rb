SpreeAbc::Application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'XXX',
  'X-XSS-Protection' => '1; mode=block',
  'X-Content-Type-Options' => 'nosniff'
}
