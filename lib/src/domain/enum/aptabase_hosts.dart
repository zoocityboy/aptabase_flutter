/// An enumeration representing different hosts.
enum AptabaseHosts {
  /// EU - GDPR compliant
  eu('https://eu.aptabase.com'),

  /// US - HIPAA compliant
  us('https://us.aptabase.com'),

  /// Localhost
  dev('https://localhost:3000'),

  /// Self-hosted
  sh('');

  const AptabaseHosts(this.url);

  /// The url of the host.
  final String url;
}
