# SampleTube Server (Express + MongoDB)

Production-ready REST API built with Express (MVC) and MongoDB (Mongoose).

- Auth: register, login (JWT)
- Videos: list, get by id
- Security: helmet, CORS
- Logging: morgan

## Requirements

- Node.js >= 18
- Set MONGO_URI in .env (MongoDB Atlas URI)

## Quick Start

```bash
# 1) Install dependencies
npm install

# 2) Create env file
cp .env.example .env

# 3) Start dev server
npm run dev
```

### Environment Variables

| Name       | Default                   | Description               |
| ---------- | ------------------------- | ------------------------- |
| PORT       | 4000                      | HTTP port                 |
| MONGO_URI  | (required)                | MongoDB connection string |
| JWT_SECRET | change_this_in_production | Secret for signing JWTs   |
| NODE_ENV   | development               | Node environment          |

Note: MONGO_URI is required. Set it in `.env`, for example: `mongodb+srv://<user>:<pass>@sampletube.fzs5jxv.mongodb.net/`.

## Run

```bash
npm run dev    # with nodemon
# or
npm start      # plain node
```

## API Overview

- Base URL: `/api/v1`
- Content-Type: `application/json`
- Authentication: Bearer JWT (for future protected endpoints)

Standard error schema:

```json
{
  "error": "Message"
}
```

Validation error schema:

```json
{
  "error": "ValidationError",
  "details": [{ "field": "email", "message": "Invalid value" }]
}
```

---

## Auth

### POST /auth/register

Create a new user and receive a JWT.

Request body:

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secret123"
}
```

Success response (201):

```json
{
  "user": { "id": "663f...", "name": "John Doe", "email": "john@example.com" },
  "token": "<JWT>"
}
```

Errors:

- 400: ValidationError
- 409: Email already in use

cURL:

```bash
curl -X POST http://localhost:4000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","password":"secret123"}'
```

### POST /auth/login

Login and receive a JWT.

Request body:

```json
{
  "email": "john@example.com",
  "password": "secret123"
}
```

Success response (200):

```json
{
  "user": { "id": "663f...", "name": "John Doe", "email": "john@example.com" },
  "token": "<JWT>"
}
```

Errors:

- 400: ValidationError
- 401: Invalid credentials

cURL:

```bash
curl -X POST http://localhost:4000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"secret123"}'
```

Authorization header for protected endpoints (future):

```
Authorization: Bearer <token>
```

---

## Videos

### GET /videos

Paginated list of videos. Requires JWT. Files are read from the `videos` folder.

Headers:

```
Authorization: Bearer <token>
```

Query params:

- `page` (number, default 1)
- `limit` (number, default 20, max 100)

Success response (200):

```json
{
  "data": [
    {
      "id": "153821-806526710_small.mp4",
      "title": "153821-806526710_small.mp4",
      "url": "/static/videos/153821-806526710_small.mp4"
    }
  ],
  "page": 1,
  "limit": 20,
  "total": 13
}
```

cURL:

```bash
curl "http://localhost:4000/api/v1/videos?page=1&limit=20" \
  -H "Authorization: Bearer <token>"
```

### GET /videos/:id

Get and stream a single video file by filename (id). The file is returned directly.

cURL:

```bash
curl -L http://localhost:4000/api/v1/videos/153821-806526710_small.mp4 -o out.mp4
```

Errors:

- 404: Video not found

---

## Data Models

### User

```json
{
  "id": "ObjectId",
  "name": "string (2..100)",
  "email": "string (unique, lowercase)",
  "passwordHash": "string",
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

### Video (DB model - not used for file listing)

```json
{
  "_id": "ObjectId",
  "title": "string (required)",
  "description": "string",
  "url": "string (required)",
  "thumbnailUrl": "string",
  "durationSec": "number >= 0",
  "publishedAt": "Date",
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

---

## Project Structure

```
src/
  app.js
  server.js
  config/
    db.js
  controllers/
    auth.controller.js
    video.controller.js
  models/
    User.js
    Video.js
  routes/
    index.js
    auth.routes.js
    video.routes.js
  middlewares/
    errorHandler.js
  utils/
    asyncHandler.js
    jwt.js
    password.js
```

## Notes

- Passwords are hashed with bcrypt.
- JWT expires in 7 days. Tune in `src/utils/jwt.js`.
- Helmet and CORS are enabled globally.

## License

MIT
