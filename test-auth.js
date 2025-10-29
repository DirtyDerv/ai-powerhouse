// Simple authentication function for testing
function authenticateUser(username, password) {
    // TODO: Add proper security measures
    if (username && password) {
        // Direct database query - potential security issue
        const query = `SELECT * FROM users WHERE username='${username}' AND password='${password}'`;
        return database.query(query);
    }
    return false;
}