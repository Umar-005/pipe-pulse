import java.sql.*;
import java.util.*;


class Database {
  private Connection conn;
   Database() {
    connectDB();
  }
  
  // crates table if it doesnt exist
  private void connectDB() {
    try {
      conn = DriverManager.getConnection("jdbc:sqlite:pipepulse.db");
      Statement stmt = conn.createStatement();
      stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "username TEXT UNIQUE, " +
        "password TEXT, " +
        "level INTEGER DEFAULT 1, " +
        "highScore INTEGER DEFAULT 0)");
      stmt.execute("CREATE TABLE IF NOT EXISTS leaderboard (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "username TEXT, " +
        "score INTEGER)");
      stmt.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  // Adds user if it doesnt exist
  boolean addUser(String username, String password) {
    try {
      PreparedStatement check = conn.prepareStatement(
        "SELECT * FROM users WHERE username = ?"
      );
      check.setString(1, username);  // inserts username into the 1st ? 
      ResultSet rs = check.executeQuery();
      if (rs.next()) return false;    // checks if that user exists and if it does returns false

      PreparedStatement pstmt = conn.prepareStatement(
        "INSERT INTO users (username, password, level, highScore) VALUES (?, ?, ?, ?)"
      );
      pstmt.setString(1, username);
      pstmt.setString(2, password);
      pstmt.setInt(3, 1);
      pstmt.setInt(4, 0);
      pstmt.executeUpdate();
      pstmt.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
  
   // Checks users login info to see if it exists
  boolean checkLogin(String username, String password) {
    try {
      PreparedStatement pstmt = conn.prepareStatement(
        "SELECT * FROM users WHERE username=? AND password=?"
      );
      pstmt.setString(1, username);
      pstmt.setString(2, password);
      ResultSet rs = pstmt.executeQuery();
      boolean exists = rs.next();
      pstmt.close();
      return exists;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
  
  int getUserHighScore(String username) {
    try {
      PreparedStatement pstmt = conn.prepareStatement(
        "SELECT highScore FROM users WHERE username=?"
      );
      pstmt.setString(1, username);
      ResultSet rs = pstmt.executeQuery();
      int score = rs.next() ? rs.getInt("highScore") : 0;
      pstmt.close();
      return score;
    } catch (Exception e) {
      e.printStackTrace();
      return 0;
    }
  }
  
    void saveHighScore(String username, int newScore) {
    try {
      int current = getUserHighScore(username);
      if (newScore > current) {
        PreparedStatement pstmt = conn.prepareStatement(
          "UPDATE users SET highScore=? WHERE username=?"
        );
        pstmt.setInt(1, newScore);
        pstmt.setString(2, username);
        pstmt.executeUpdate();
        pstmt.close();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
    ArrayList<String[]> getTop10() {
    ArrayList<String[]> leaderboard = new ArrayList<String[]>();
    try {
      Statement stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT username, score FROM leaderboard ORDER BY score DESC");
      while (rs.next()) {
        leaderboard.add(new String[]{ rs.getString("username"), String.valueOf(rs.getInt("score")) });
      }
      stmt.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    while (leaderboard.size() < 10) leaderboard.add(new String[]{ "N/A", "N/A" });
    return leaderboard;
  }  


  void updateTop10(String username, int newScore) {
  try {
    // Insert the new score for this user
    PreparedStatement insert = conn.prepareStatement(
      "INSERT INTO leaderboard (username, score) VALUES (?, ?)"
    );
    insert.setString(1, username);
    insert.setInt(2, newScore);
    insert.executeUpdate();
    insert.close();

    // Fetch all scores sorted by score DESC
    ArrayList<String[]> leaderboard = new ArrayList<String[]>();
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT username, score FROM leaderboard ORDER BY score DESC");
    while (rs.next()) {
      leaderboard.add(new String[]{ rs.getString("username"), String.valueOf(rs.getInt("score")) });
    }
    stmt.close();

    // Trim to top 10
    while (leaderboard.size() > 10) leaderboard.remove(leaderboard.size() - 1);

    // Clear and rewrite the table to keep only top 10
    Statement clear = conn.createStatement();
    clear.execute("DELETE FROM leaderboard");
    clear.close();

    PreparedStatement pstmt = conn.prepareStatement(
      "INSERT INTO leaderboard (username, score) VALUES (?, ?)"
    );
    for (String[] row : leaderboard) {
      pstmt.setString(1, row[0]);
      pstmt.setInt(2, Integer.parseInt(row[1]));
      pstmt.executeUpdate();
    }
    pstmt.close();

  } catch (Exception e) {
    e.printStackTrace();
  }
}

  void saveLevel(String username, int level) {
    try {
      PreparedStatement pstmt = conn.prepareStatement("UPDATE users SET level=? WHERE username=?");
      pstmt.setInt(1, level);
      pstmt.setString(2, username);
      pstmt.executeUpdate();
      pstmt.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  int getLevel(String username) {
    try {
      PreparedStatement pstmt = conn.prepareStatement("SELECT level FROM users WHERE username=?");
      pstmt.setString(1, username);
      ResultSet rs = pstmt.executeQuery();
      int level = rs.next() ? rs.getInt("level") : 1;
      pstmt.close();
      return level;
    } catch (Exception e) {
      e.printStackTrace();
      return 1;
    }
  }

  // DELETE ONCE DONE
  //void resetDatabase() {
  //  try {
  //    Statement stmt = conn.createStatement();
  //    stmt.execute("DROP TABLE IF EXISTS users;");
  //    stmt.execute("DROP TABLE IF EXISTS leaderboard;");
  //    stmt.close();
  //    println(" Database reset.");
  //    connectDB();
  //  } catch (Exception e) {
  //    e.printStackTrace();
  //  }
  //}

  void close() {
    try {
      if (conn != null) conn.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  
}
