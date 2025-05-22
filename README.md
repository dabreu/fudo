# Sample Ruby Rack REST API
## API Endpoints

Below is a summary of the API endpoints defined in the [`openapi.yaml`](./public/openapi.yaml) file:

### **Authentication**
- **POST** `/api/login`  
  Authenticate a user and retrieve a JWT token.  
  **Request Body:**  
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```

### **Users**
- **POST** `/api/users`  
  Create a user.  
  **Request Body:**  
  ```json
  {
    "name": "string",
    "email": "string",
    "password": "string"
  }
  ```

- **GET** `/api/users`  
  Retrieve a list of all users.

- **GET** `/api/users/{id}`  
  Retrieve details of a specific user by ID.

### **Products**
- **POST** `/api/products`  
  Create a new product asynchronously.  
  **Request Body:**  
  ```json
  {
    "name": "string"
  }
  ```  
  **Returns:**  
  - `202 Accepted`: The product creation request has been accepted and is being processed asynchronously. The client can poll using the `Location` header, which points to the URL of the initiated task. For details check [`/api/tasks/{id}/status`](#get-apitasksidstatus)

- **GET** `/api/products`  
  Retrieve a list of all products.

- **GET** `/api/products/{id}`  
  Retrieve details of a specific product by ID.

### **Tasks**
- **GET** `/api/tasks`  
  Retrieve a list of all tasks.

- **GET** `/api/tasks/{id}/status`  
  Retrieve the status of a specific task by ID.  
  If the task is completed, the response includes a `303` status with a `Location` header pointing to the created resource.

## Running the Application with Docker

To run the application using the provided `Dockerfile`, follow these steps:

1. **Build the Docker Image**  
  ```bash
  docker build -t sample-rack-api .
  ```

2. **Run the Docker Container**  
  ```bash
  docker run -p 9292:9292 sample-rack-api
  ```

The api will be accessible at `http://localhost:9292`

## Running API Endpoint Examples

You can test the API endpoints using the provided `requests.http` file. This file contains example requests for the API.

### Steps to Run:
1. Open the [`requests.http`](./app/docs/requests.http) file in your preferred HTTP client or IDE (e.g., Visual Studio Code with the REST Client extension).
2. Execute the desired request directly from the file.

