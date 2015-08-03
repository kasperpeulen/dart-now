part of github.common;

/// Error Generated by [GitHub]
class GitHubError implements Exception {
  final String message;
  final String apiUrl;
  final GitHub github;
  final Object source;

  GitHubError(this.github, this.message, {this.apiUrl, this.source});

  @override
  String toString() => "GitHub Error: ${message}";
}

/// GitHub Entity was not found
class NotFound extends GitHubError {
  NotFound(GitHub github, String msg) : super(github, msg);
}

class BadRequest extends GitHubError {
  BadRequest(GitHub github, [String msg = 'Not Found']) : super(github, msg);
}

/// GitHub Repository was not found
class RepositoryNotFound extends NotFound {
  RepositoryNotFound(GitHub github, String repo)
      : super(github, "Repository Not Found: ${repo}");
}

/// GitHub User was not found
class UserNotFound extends NotFound {
  UserNotFound(GitHub github, String user)
      : super(github, "User Not Found: ${user}");
}

/// GitHub Organization was not found
class OrganizationNotFound extends NotFound {
  OrganizationNotFound(GitHub github, String organization)
      : super(github, "Organization Not Found: ${organization}");
}

/// GitHub Team was not found
class TeamNotFound extends NotFound {
  TeamNotFound(GitHub github, int id) : super(github, "Team Not Found: ${id}");
}

/// Access was forbidden to a resource
class AccessForbidden extends GitHubError {
  AccessForbidden(GitHub github) : super(github, "Access Forbbidden");
}

/// Client hit the rate limit.
class RateLimitHit extends GitHubError {
  RateLimitHit(GitHub github) : super(github, "Rate Limit Hit");
}

/// An Unknown Error
class UnknownError extends GitHubError {
  UnknownError(GitHub github) : super(github, "Unknown Error");
}

/// GitHub Client was not authenticated
class NotAuthenticated extends GitHubError {
  NotAuthenticated(GitHub github) : super(github, "Client not Authenticated");
}

class InvalidJSON extends BadRequest {
  InvalidJSON(GitHub github, [String message = "Invalid JSON"])
      : super(github, message);
}

class ValidationFailed extends GitHubError {
  ValidationFailed(GitHub github, [String message = "Validation Failed"])
      : super(github, message);
}
