# API-First Rails Setup Guide for Frontend Devs

## 1. Convert Controllers to API Format

### Current (HTML):
```ruby
class TasksController < ApplicationController
  def index
    @tasks = Task.all
    # Renders index.html.erb
  end
end
```

### API Version (JSON):
```ruby
class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.all
    render json: @tasks
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end
end
```

## 2. Authentication Options

### Option A: JWT (Stateless - Best for Multi-Repo)
```ruby
# Frontend sends:
POST /api/v1/login
{ "email": "user@example.com", "password": "secret" }

# Rails responds:
{ "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", "user": {...} }

# Frontend stores token and sends in headers:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Option B: Session with CORS (Stateful)
```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'  # Next.js dev server
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete],
      credentials: true  # Important for cookies!
  end
end

# Frontend must send cookies:
fetch('http://localhost:3000/api/tasks', {
  credentials: 'include'  // Send cookies cross-domain
})
```

## 3. API Routes Structure

```ruby
# config/routes.rb
namespace :api do
  namespace :v1 do
    resources :tasks
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    post 'register', to: 'registrations#create'
    get 'me', to: 'users#show'  # Current user
  end
end
```

## 4. Frontend Integration (Next.js Example)

```typescript
// lib/api.ts
const API_URL = 'http://localhost:3000/api/v1'

export async function getTasks() {
  const res = await fetch(`${API_URL}/tasks`, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  })
  return res.json()
}

export async function createTask(data) {
  const res = await fetch(`${API_URL}/tasks`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify(data)
  })
  return res.json()
}

export async function login(email, password) {
  const res = await fetch(`${API_URL}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  })
  const data = await res.json()
  if (data.token) {
    localStorage.setItem('token', data.token)
  }
  return data
}
```

## 5. What Frontend Dev Needs

### API Documentation:
- **Base URL**: `http://localhost:3000/api/v1`
- **Auth Method**: JWT (Bearer token) or Sessions (cookies)
- **Endpoints**:
  - `GET /tasks` - List all tasks
  - `POST /tasks` - Create task
  - `GET /tasks/:id` - Get task
  - `PUT /tasks/:id` - Update task
  - `DELETE /tasks/:id` - Delete task
  - `POST /login` - Authenticate
  - `POST /register` - Create account
  - `DELETE /logout` - End session
  - `GET /me` - Current user info

### Response Format:
```json
// Success
{
  "id": 1,
  "title": "Task title",
  "status": "created",
  "priority": "high"
}

// Error
{
  "errors": {
    "title": ["can't be blank"]
  }
}
```

## 6. Development Setup

### Backend (Rails):
```bash
rails s -p 3001  # Run on different port
```

### Frontend (Next.js):
```bash
npm run dev  # Runs on port 3000
```

### Environment Variables (.env.local):
```
NEXT_PUBLIC_API_URL=http://localhost:3001/api/v1
```

## 7. Deployment

### Backend:
- Deploy to Heroku/Render/Railway
- Set CORS origins to production domain

### Frontend:
- Deploy to Vercel/Netlify
- Set API_URL to production backend

### Example:
```
Frontend: https://myapp.vercel.app
Backend:  https://myapp-api.herokuapp.com
```
