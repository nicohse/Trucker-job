# Trucker Job Script

This is a FiveM script for managing a truck rental job using ESX. It allows players to rent trucks, complete delivery routes, and return trucks to the rental location. This script includes client-side and server-side logic, as well as the necessary SQL table setup.

## Features

- **Truck Rental:** Players can rent a truck from a designated rental location.
- **Route Selection:** Players can choose from available delivery routes.
- **Truck Return:** Players can return the truck to a designated return location.
- **Route Completion:** Players earn money upon successful completion of delivery routes.

## Installation

1. **Download and Extract Files**
   - Download the script and extract the files.

2. **Add to Your Resource Folder**
   - Place the extracted files into your server's `resources` directory.

3. **Update `server.cfg`**
   - Add the following lines to your `server.cfg` to ensure the resource is started:
     ```plaintext
     start truck_job
     ```

4. **Database Setup**
   - Import the provided SQL file into your database to create the required table:
     ```sql
     CREATE TABLE `routes` (
         `id` INT AUTO_INCREMENT PRIMARY KEY,
         `name` VARCHAR(255) NOT NULL,
         `x` FLOAT NOT NULL,
         `y` FLOAT NOT NULL,
         `z` FLOAT NOT NULL,
         `reward` INT NOT NULL
     );
     ```

## Configuration

- **Client-Side Configuration**
  - Modify `client.lua` to adjust coordinates for rental and return locations.
  - Configure truck model and route logic as needed.

- **Server-Side Configuration**
  - Adjust the truck rental cost and reward logic in `server.lua`.

## Files

### `client.lua`

Handles the client-side logic including:
- Creating and managing blips and markers.
- Renting trucks and selecting routes.
- Returning trucks and completing routes.

### `server.lua`

Manages server-side logic including:
- Handling route retrieval and truck rental.
- Awarding money for completed routes.
- Managing active truck rentals.

### `insert.sql`

SQL script to create the `routes` table for storing route information.

## Usage

1. **Rent a Truck**
   - Go to the rental location marked on the map.
   - Press `E` to open the truck rental menu.
   - Select a route to rent a truck and start the delivery job.

2. **Complete a Route**
   - Drive to the destination marked on your map.
   - Upon reaching the destination, the route will be marked as complete and you will be notified.

3. **Return the Truck**
   - Drive the truck back to the return location.
   - Press `E` to return the truck and end the rental.

## Troubleshooting

- **Blips and Markers Not Showing**
  - Ensure that the coordinates for rental and return locations are correct.

- **Truck Not Spawning**
  - Verify that the truck model is correctly specified in `server.lua`.

- **SQL Errors**
  - Check the SQL file for correct table creation and ensure it has been imported correctly into your database.

## Contribution

Feel free to contribute to this project by submitting pull requests or opening issues if you encounter any problems or have suggestions for improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

If you have any questions or need support, please open an issue on this GitHub repository. Happy trucking! 🚛
