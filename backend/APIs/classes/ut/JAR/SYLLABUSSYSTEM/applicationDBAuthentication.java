// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import the java.sql package for managing the connections,
// queries and results from the database
import java.sql.* ;

// Import hashing functions
import org.apache.commons.codec.*;

/**
	This class authenticate users using userName and passwords.
	Also have methods required in some operations before the 
	user arrive to the welcome page. This class can be accessed
	from the front-end.
	@author a-carrasquillo
*/
public class applicationDBAuthentication {
	// myDBConn is an MySQLConnector object for accessing to the database
	private MySQLConnector myDBConn;
	
	/**
		<h1>Default constructor</h1>
			It creates a new MySQLConnector object
			and open a connection to the database
	*/
	public applicationDBAuthentication() {
		// Create the MySQLConnector object
		myDBConn = new MySQLConnector();
		
		// Open the connection to the database
		myDBConn.doConnection();
	}
		
	/**
		<h1>authenticate method</h1>
			Authentication method
			@param userName - the username of the user
			@param userPass - password entered by the user
			@return
				A ResultSet containing the user username,
				all roles assigned to the user and the user name.
	*/
	public ResultSet authenticate(String userName, String userPass) {
		// Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		// Define the tables where the selection is performed
		tables = "users_access, role_users";

		// Define the fields list to retrieve the user username,
		// all roles assigned to the user and the user name
		fields = "users_access.username, role_users.nivel_acceso, users_access.nombre";

		// determining the hashing value to compare it with
		// the one in the database
		hashingVal = hashingSha256(userName + userPass);

		// Declare the where condition
		whereClause = "users_access.username = role_users.username and users_access.username='" + userName +"' and hashaccess='" + hashingVal + "'";
				
		System.out.println("Authenticating user and listing username, roles and name...");
		
		// Return the ResultSet containing the result of the search
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
		<h1>isAdministrator method</h1>
			Method used to determine if a user is an administrator
			@param nivel_acceso - identification number of the role
								  that is going to be processed
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user is an administrator
	                    <b>false:</b> the user is not an administrator
	*/
	public boolean isAdministrator(String nivel_acceso)	{
		return (nivel_acceso.trim().indexOf("0")!=-1);
	}

	/**
		NOTE: Needs more work, method is not final version.
		<h1>isSubManager method</h1>
			Method used to determine if a user is a Substitute Manager
			@param nivel_acceso - identification number of the role 
								  that is going to be processed
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user is a Substitute Manager
	                    <b>false:</b> the user is not a Substitute Manager
	*/
	public boolean isSubManager(String nivel_acceso) {
		return (nivel_acceso.trim().indexOf("1")!=-1);
	}

	/**
		<h1>isProfessor method</h1>
			Method used to determine if a user is a Professor
			@param nivel_acceso - identification number of the role 
								  that is going to be processed
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user is a Professor
	                    <b>false:</b> the user is not a Professor
	*/
	public boolean isProfessor(String nivel_acceso)	{
		return (nivel_acceso.trim().indexOf("2")!=-1);
	}

	/**
		<h1>isEmployee method</h1>
			Method used to determine if a user is an Employee 
			@param nivel_acceso - identification number of the role 
								  that is going to be processed
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user is an Employee
	                    <b>false:</b> the user is not an Employee
	*/
	public boolean isEmployee(String nivel_acceso) {
		return (nivel_acceso.trim().indexOf("3")!=-1);
	}

	/**
		<h1>menuElements method</h1>
			Bring the menu related with a role
			@param userName - the username of the user that we
							  want to bring his/her menu
			@return
				A ResultSet containing the pageURL, the category
				of the menu and the page title
	*/
	public ResultSet menuElements(String userName) {
		// Declare function variables
		String fields, tables, whereClause, orderBy;
		
		// Define the tables where the selection is performed
		tables = "role_users, role, role_web_page, menuElement, webPage";

		// Define the fields list to retrieve page URL, the category
		// of the menu and the page title
		fields = "role_web_page.pageURL, menuElement.title, webPage.pageTitle";

		// Define where clause
		whereClause = " role_users.nivel_acceso=role.nivel_acceso and role.nivel_acceso=role_web_page.nivel_acceso";
		whereClause += " and menuElement.menuId = webPage.menuId";
		whereClause += " and role_web_page.pageURL=webPage.pageURL";
		whereClause += " and userName='"+ userName+"' and not webPage.menuId=0";

		// Define orderBy clause
		orderBy = "menuElement.title, role_web_page.pageURL desc";
		
		System.out.println("Listing menu options...");
		
		// Return the ResultSet containing the result of the search
		return myDBConn.doSelect(fields, tables, whereClause, orderBy);
	}	
	
	/**
		<h1>verifyUserPageFlow method<h1>
			Method to verify the page flow of the user
			@param userName - the username of the user 
			@param currentPage - the page that the user is trying to access
			@param previousPage - the page from where the user comes
			@return
				A ResultSet containing all roles assigned to the user,
				the username, the name, and the last name of the user
	*/
	public ResultSet verifyUserPageFlow(String userName, String currentPage, String previousPage) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Define the tables where the selection is performed
		tables = "role_users, role, role_web_page, webPage, users_access, webPagePrevious";

		// Define the fields list to retrieve assigned roles to the user,
		// the username and the name of the user
		fields = " distinct role_users.nivel_acceso, users_access.username, users_access.nombre, users_access.apellidos ";

		// Declaring the where clause
		whereClause = " users_access.username = role_users.username and users_access.username='" + userName; 
		whereClause += "' and role.nivel_acceso=role_users.nivel_acceso and ";
		whereClause += " role_web_page.nivel_acceso=role.nivel_acceso and role_web_page.pageURL=webPage.pageURL";
		whereClause += " and webPagePrevious.currentPageURL='" + currentPage; 
		whereClause += "' and webPagePrevious.previousPageURL='"+previousPage+"'";
		
		System.out.println("Verifying user page flow...");
		
		// Return the ResultSet containing the result of the search
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
		<h1>verifyUserPageAccess method</h1>
			Method used to determine if a user have access to a certain page
			@param userName - the username of the user 
			@param pageTryingToGainAccess - the page that the user is trying
											to gain access
			@return
				<h3>boolean value:</h3>
	                <b>true:</b> the user have access to the requested page
	                <b>false:</b> the user does not have access to the
	                			  requested page
	*/
	public boolean verifyUserPageAccess(String userName, String pageTryingToGainAccess) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Declare and define the return variable of the function
		boolean result = false;

		// Define the tables where the selection is performed
		tables = "users_access, role_users, role, role_web_page";

		// Define the fields list
		fields = " users_access.username, users_access.nombre, role_users.nivel_acceso, role_web_page.pageURL ";

		// Define the where clause
		whereClause = " users_access.username=role_users.username and role_users.nivel_acceso=role.nivel_acceso";
		whereClause += " and role.nivel_acceso=role_web_page.nivel_acceso and ";
		whereClause += " role_web_page.pageURL='" + pageTryingToGainAccess + "' and role_users.username='" + userName + "'"; 
		
		System.out.println("Verifying user access to page " + pageTryingToGainAccess + "...");

		// Calling the doSelect method to determine if the user
		// have access to the page that is requesting
		ResultSet res = myDBConn.doSelect(fields, tables, whereClause);

		/* If the result set have a result this means that the user
		   have access to the page, else, the user does not have
		   access to the page that is requesting */
		try {
			if(res.next())
				result = true;
			else
				result = false;
			
			// Close the result set
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// return the result
			return result;
		}		
	}


	/**
		<h1>addUser method</h1>
			Method used to add a user to the system
			@param name - name of the new user
			@param lastname - last name of the new user
			@param userName - username of the new user
			@param userPass - password of the new user
			@param rol - type of user, professor or employee
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user was added successfully
	                    <b>false:</b> the user cannot be added
	*/
	public boolean addUser(String name, String lastname, String userName, String userPass, String rol) {
		// Declare function variables
		String table, values, hashingValue;

		// Calling the function that will produce the hashing value
		// based on the username and the password
		hashingValue = hashingSha256(userName + userPass);

		// Define the table where the user information is inserted
		table = "users_access";

		// Define the values to be inserted
		values = "'" + name + "', '" + lastname + "', '" + userName + "', '" + hashingValue +"'";

		System.out.println("Adding new user...");

		// Disable the auto-commit since a transaction is going
		// to be performed
		myDBConn.disableAutoCommit();

		// Adding new user to the database
		if(myDBConn.doInsert(table, values)) {
			// The user was added successfully
			// Define the table where the user role is inserted
			table = "role_users";

			// Validate the role parameter
			if(rol.trim().toLowerCase().indexOf("professor")!=-1) {
				rol = "2";
			}
			else if(rol.trim().toLowerCase().indexOf("employee")!=-1) {
				rol = "3";
			}
			else {
				// the role value was not recognize
				// rollback to delete previous insert due to the error
				myDBConn.doRollback();
				// enable auto-commit for future transactions
				myDBConn.enableAutoCommit();
				return false;
			}	

			// Define the values to be inserted
			values = "'" + userName + "',"+ rol +" , CURRENT_TIMESTAMP, NULL";

			System.out.println("Adding user " + userName + " with role " + rol +" ...");
			
			// Adding new user role to the database
			if(myDBConn.doInsert(table, values)) {
				// both inserts were a success
				// Perform a commit to save both inserts
				myDBConn.doCommit();
				// enable auto-commit for future queries
				myDBConn.enableAutoCommit();
				// Return true indicating that all inserts
				// were successful, hence de user was added
				return true;
			}
		}
		// one of the inserts fail
		// Since one of the queries fail, we need to perform a rollback
		myDBConn.doRollback();
		// enable auto-commit for future queries
		myDBConn.enableAutoCommit();
		// Return false, indicating that the user was not added
		// due to an error
		return false;
	}
	
	/**
		<h1>hashingSha256 method</h1>
			Generates a hash value using the sha256 algorithm.
			@param plainText - plaintext to be converted to hashing value
			@return the hash string based on the plainText
	*/
	private String hashingSha256(String plainText) {
		// Generate the hashing value
		String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText);
		// return the hashing value 
		return sha256hex;
	}

	/**
		<h1>usernameExists method</h1>
			Method used to determine if a username already
			exists in the system
			@param userName - the username to be check
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the username already exists
	                    <b>false:</b> the username does not exists
	*/
	public boolean usernameExists(String userName) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Declare and define the return variable of the function
		boolean result = false;

		// Define the table where the selection is performed
		tables = "users_access";

		// Define the field list
		fields = "username";

		// Define the where clause
		whereClause = "username='" + userName + "'"; 
		
		System.out.println("Verifying if username " + userName + " exists in the system...");

		// Calling the doSelect method to determine if the username
		// exists in the system
		ResultSet res = myDBConn.doSelect(fields, tables, whereClause);

		/* If the result set have a result this means
		   that the username exists in the system, else,
		   the username does not exists in the system */
		try {
			if(res.next())
				result = true;
			else
				result = false;

			// Close the result set
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// return the result
			return result;
		}	
	}

	/**
		<h1>searchCompleteName method<h1>
			Method that search the name and last name of
			a user based on the username
			@param userName - the username of the user 
			@return
				A ResultSet containing the name and 
				last name of the user
	*/
	public ResultSet searchCompleteName(String userName) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Define the table where the selection is performed
		tables = "users_access";

		// Define the fields list to retrieve
		fields = "nombre, apellidos";

		// Declaring the where clause
		whereClause = "username='" + userName + "'"; 
		
		System.out.println("Searching the complete name for user identified by " + userName + "...");
		// return a ResultSet with the result
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	
	/**
		</h1>close method</h1>
			Close the connection to the database.
			This method must be called at the end of each page/object
			that instantiates a applicationDBManager object
	*/
	public void close() {
		// Close the connection
		myDBConn.closeConnection();
	}

	/**
		<h1>Debugging method</h1>
			This method is used to test the methods
			of the applicationDBAuthentication class.
			@param args[]: String array 
			@return
	*/
	public static void main(String[] args) {
		// Create an appDBAuth object to connect to the database
		applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
		// Declare the variable that will hold the username
		String userName;
		// Define the username
		userName = "acarrasquillo";

		try {
			// Bring the menu elements 
			ResultSet res = appDBAuth.menuElements(userName);
			
			String previousTitle = "";
			if(!res.isAfterLast()) {
				while(res.next()) {
					// verify if the title is the same as the previous
					if(!previousTitle.equals(res.getString(2)))
						System.out.println("title = " + res.getString(2));
					
					 
					System.out.print("pagetitle = " + res.getString(3));
					System.out.println("\t\tpageURL = " + res.getString(1));
									
					previousTitle = res.getString(2);
				}
			} else {
				System.out.println("The user does not have a menu option...");
			}
			// close the result set
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// close the connection to the database
			appDBAuth.close();
		}	
	}
}