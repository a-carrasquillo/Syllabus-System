// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import the java.sql package for managing the connections, queries
// and results from the database
import java.sql.* ;

/**
	This class manage a connection to the database and it should
	not be accessed from the front end. 
	@author a-carrasquillo
*/
public class MySQLConnector {
	// Database credential <jdbc:<protocol>://<hostName>/<databaseName>>
	private final String DB_URL="jdbc:mysql://localhost/syllabus_system";
	
	// Database authorized user information
	private final String USER = "education_client";
	private final String PASS = "YourPassword";
   
	// Connection object
	private Connection conn;
   
	// Statement object to perform queries and transactions on the database
	private Statement stmt;
   
	/**
		<h1>Default constructor</h1>
	*/
	public MySQLConnector() {
		// Define connections objects to null
		conn = null;
		stmt = null;
	}
		
	/**
		<h1>doConnection method</h1>
			It creates a new connection object and open a
			connection to the database.
	*/		
	public void doConnection() {
		try {
			// Register the JDBC driver
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			System.out.println("Connecting to database...");
			// Open a connection using the database credentials
			conn = DriverManager.getConnection(DB_URL, USER, PASS);
		  
			System.out.println("Creating statement...");
			// Create an Statement object for performing queries and transactions
			stmt = conn.createStatement();
			System.out.println("Statement OK...");
		} catch(SQLException sqlex) {
			sqlex.printStackTrace();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
		<h1>closeConnection method </h1>
			Close the connection to the database
	*/		
	public void closeConnection() {
		try {
			// Close the statement object
			stmt.close();
			// Close the connection to the database
			conn.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
		<h1>doSelect method</h1>
			This method performs a selection query to the database
			@param fields: list of fields to be projected from the tables
			@param tables: list of tables to be selected
			@param where: where clause
			@return:
				ResulSet result containing the projected tuples resulting
				from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where) {
		// Create a ResulSet
		ResultSet result = null;
		
		// Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + " where " + where + " ;";
		System.out.println(selectionStatement);
		
		try {
			// Perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			// Return results
			return result;
		}
	}

	/**
		<h1>doSelect method</h1>
			This method performs a selection query to the database
			@param fields: list of fields to be projected from the tables
			@param tables: list of tables to be selected
			@return:
				ResulSet result containing the projected tuples resulting
				from the query
	*/
	public ResultSet doSelect(String fields, String tables) {
		// Create a ResulSet
		ResultSet result = null;
		
		// Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + ";";
		System.out.println(selectionStatement);
		
		try {
			// Perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return results
			return result;
		}
	}
	
	/**
		<h1>doSelect method</h1>
			This method performs a selection query to the database
			@param fields: list of fields to be projected from the tables
			@param tables: list of tables to be selected
			@param where: where clause
			@param orderBy: order by condition
			@return:
				ResulSet result containing the projected tuples resulting
				from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where, String orderBy) {
		// Create a ResulSet
		ResultSet result = null;
		
		// Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + " where " + where + " order by " + orderBy + ";";
		System.out.println(selectionStatement);

		try {
			// Perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return results
			return result;
		}
	}
	
	/**
		<h1>doInsertion method</h1>
			This method performs an insertion to the database
			@param table: table to be updated
			@param values: values to be inserted 
			@return:
				<h3>boolean value:</h3>
					<b>true:</b> the insertion was OK
					<b>false:</b> an error was generated
	*/
	public boolean doInsert(String table, String values) {
		// Declaring and initializing function variable
		boolean res = false;

		// Create the insertion statement and print it in the command line
		String insertStatement ="INSERT INTO "+ table + " values (" + values +");";
		System.out.println(insertStatement);

		// Try to insert a record to the selected table
		try {
			// Perform the insert and catch the result in the res variable
			res = (stmt.executeUpdate(insertStatement) >= 0);
			System.out.println("MySQLConnector insertion: " + res);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return the result
			return res;
		}	
	}

	/**
		<h1>doUpdate method</h1>
			This method performs an update to the database
			@param table: table to be updated
			@param assignmentList: data fields to be updated with their
								   respective values 
			@return:
				<h3>boolean value:</h3> 
					<b>true:</b> the update was OK
					<b>false:</b> an error was generated
	*/
    public boolean doUpdate(String table, String assignmentList) {
		// Declaring and initializing function variable
		boolean res = false;

		// Create the update statement and print it in the command line
		String updateStatement = "UPDATE "+ table + " SET " + assignmentList + " ;";
		System.out.println(updateStatement);

		// Try to update a record to the selected table
		try {
			// Preform the update and catch the result in the res variable
			res = (stmt.executeUpdate(updateStatement) >= 0);
			System.out.println("MySQLConnector update: " + res); 
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return the result
			return res;
		}	
	}

    /**
		<h1>doUpdate method</h1>
			This method performs an update to the database
			@param table: table to be updated
			@param assignmentList: data fields to be updated with their
								   respective values 
			@param where: where clause
			@return:
				<h3>boolean value:</h3>
					<b>true:</b> the update was OK
					<b>false:</b> an error was generated
	*/
    public boolean doUpdate(String table, String assignmentList, String where) {
		// Declaring and initializing function variable
		boolean res = false;

		// Create the update statement and print it in the command line
		String updateStatement ="UPDATE "+ table + " SET " + assignmentList + " WHERE " + where + " ;";
		System.out.println(updateStatement);

		// Try to insert a record to the selected table
		try {
			// Perform the update and catch the result in the res variable
			res = (stmt.executeUpdate(updateStatement) >= 0);
			System.out.println("MySQLConnector update: " + res);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return the result
			return res;
		}	
	}

	/**
		<h1>enableAutoCommit method</h1>
			Method that allows to enable the auto-commit in the database
	*/
	public void enableAutoCommit() {
		try {
			// Verify if there is an active connection
			if(conn != null) {
			  // There is an active connection to the database
				// Turn on the auto-commit
				conn.setAutoCommit(true);
			} else {
				// Error in the connection
				System.out.println("The connection to the database is dropped or not performed, hence the AutoCommit was not enable.");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
		<h1>disableAutoCommit method</h1>
			Method that allows to disable the auto-commit in the database
	*/
	public void disableAutoCommit() {
		try {
			// Verify if there is an active connection
			if(conn != null) {
			  // There is an active connection to the database
				// Turn off the auto-commit
				conn.setAutoCommit(false);
			} else {
				// Error in the connection
				System.out.println("The connection to the database is dropped or not performed, hence the AutoCommit was not disable.");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
		<h1>doCommit method</h1>
			Method that allows to perform a commit in the database
	*/
	public void doCommit() {
		try {
			// Verify if there is an active connection
			if(conn != null) {
			  // There is an active connection to the database
				// Perform the commit
				conn.commit();
			} else {
				// Error in the connection
				System.out.println("The connection to the database is dropped or not performed, hence the commit was not performed");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

    /**
		<h1>doRollback method</h1>
			Method that allows to perform a rollback in the database
	*/
	public void doRollback() {
		try {
			// Verify if there is an active connection
			if(conn != null) {
			  // There is an active connection to the database
				// Perform the rollback
				conn.rollback();
			} else {
				// Error in the connection
				System.out.println("The connection to the database is dropped or not performed, hence the rollback was not performed");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
		<h1>Debugging method</h1>
			This method creates a MySQLConnector object, performs 
			some operations in the database, 
			and close the connection to the database
			@param args[]: String array
	*/
	public static void main(String[] args) {	
		System.out.println("Testing...");
		// Create a MySQLConnector object
		MySQLConnector conn = new MySQLConnector();
		// Declare the fields, tables, where clause, order by,
		// and assignment list string variables
		String fields, tables;
		// Define the projected fields
		fields = "*";
		// Define the selected tables
		tables = "role";
		try {
			// Establish the database connection
			conn.doConnection();
			// Perform some operation 
			ResultSet result = conn.doSelect(fields, tables);
			System.out.println("Listing Roles information...");
			while(result.next()) {
				System.out.println("Role id = " + result.getString(1));
				System.out.println("Role name = " + result.getString(2));
				System.out.println("Role desc = " + result.getString(3));
			}
			// Close the database connection
			conn.closeConnection();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}