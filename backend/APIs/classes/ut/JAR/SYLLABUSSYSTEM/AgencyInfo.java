// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import required package
import java.util.*;

/**
	This class purpose is to hold the information
	of an objective alignment with agencies standards
	@author a-carrasquillo
*/
public class AgencyInfo {
	// data fields
	private String id;
	private String objectiveId;

	/**
		<h1>Default constructor</h1>
			Creates an empty object.
	*/
	public AgencyInfo()	{
		id = "";
		objectiveId = "";
	}

	/**
		<h1>Special constructor</h1>
			Creates an object with the specified values.
			@param id - id of the agency
			@param objectiveId - id of the agency objective
	*/
	public AgencyInfo(String id, String objectiveId) {
		this.id = id;
		this.objectiveId = objectiveId;
	}

	// getters
	/**
		<h1>getId method</h1>
			Return the value of the id
			@return Id of the agency
	*/
	public String getId() { 
		return this.id;	
	}

	/**
		<h1>getObjectiveId method</h1>
			Return the value of the agency objective id
			@return Id of the agency objective
	*/
	public String getObjectiveId() {
		return this.objectiveId;
	}

	// setters
	/**
		<h1>setId method</h1>
			Set a new value to the id
			@param id - new value of the id
	*/
	public void setId(String id) { 
		this.id = id;	
	}

	/**
		<h1>setObjectiveId method</h1>
			Set a new value to the agency objective id
			@param objectiveId - new value of the id of the agency objective
	*/
	public void setObjectiveId(String objectiveId) {
		this.objectiveId = objectiveId;
	}
}