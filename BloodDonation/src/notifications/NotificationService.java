import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationService {
    private Connection conn;

    public NotificationService(Connection conn) {
        this.conn = conn;
    }

    // Insert a new notification
    public void sendNotification(int userId, String message) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, message, read_status) VALUES (?, ?, FALSE)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, message);
            stmt.executeUpdate();
        }
    }

    // Retrieve unread notifications for a user
    public List<String> getNotifications(int userId) throws SQLException {
        List<String> notifications = new ArrayList<>();
        String sql = "SELECT message FROM notifications WHERE user_id = ? AND read_status = FALSE";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(rs.getString("message"));
                }
            }
        }
        return notifications;
    }
}