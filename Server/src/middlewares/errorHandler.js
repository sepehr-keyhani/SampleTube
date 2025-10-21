// Centralized error handler
export function errorHandler(err, req, res, next) {
  // eslint-disable-line no-unused-vars
  const status = err.status || err.statusCode || 500;
  const message = err.message || "Internal Server Error";

  // express-validator errors
  if (err.errors && Array.isArray(err.errors)) {
    return res.status(400).json({
      error: "ValidationError",
      details: err.errors.map((e) => ({ field: e.path, message: e.msg })),
    });
  }

  return res.status(status).json({
    error: message,
  });
}
