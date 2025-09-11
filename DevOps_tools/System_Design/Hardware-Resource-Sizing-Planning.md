### Definitions:

- **Operating System**: The software that manages hardware resources and provides services for application software.

- **Application**: The software application being deployed or planned, which performs specific tasks or functions.

- **Total Active User**: The total number of users actively interacting with the application at any given time.

- **TPS (Transactions Per Second)**: The number of transactions processed by the application per second.

- **Concurrent Login**: The number of users logged into the application simultaneously.

- **Concurrent User**: A user who is active in a collaborative editing session. Idle users connected to the document do not significantly impact the server load.

- **Concurrent Session**: The number of active sessions at the same time. For collaborative applications, it indicates how many users are actively engaged in the application simultaneously.

### Example Scenario:

- **Concurrent Sessions Requirement**: 500

- **Current Capacity Handling**: In a NodeJS setup, 514 concurrent sessions are handled by a server with 4 Core CPUs and 8 GB of RAM.

- **Resource Requirement**: Based on the above scenario, the application needs 2 NL/MW (Network Layer/Middleware) servers, each with at least 4 Core CPUs and 8 GB of RAM.

- **High Availability**: To ensure high availability and avoid a single point of failure, deploy two of each critical component:
  - Load Balancer (LB)
  - Web Server
  - NL/MW (Network Layer/Middleware)
  - BL/MW (Business Logic/Middleware)

### Recommendations for Hardware Sizing:

- **Scalability**: Ensure that the hardware configuration allows for scaling up (increasing resources on existing machines) and scaling out (adding more machines) to accommodate growth.

- **Monitoring**: Implement monitoring tools to track server performance and application load. This helps in making informed decisions about resource adjustments.

- **Testing**: Conduct load testing and performance benchmarking to validate the hardware sizing and identify potential bottlenecks before going into production.

- **Redundancy**: Include redundancy in the design for critical components to improve reliability and uptime.

- **Optimization**: Regularly review and optimize server configurations based on usage patterns and performance data.
