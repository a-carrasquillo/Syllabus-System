// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import required packages
import java.util.*;

/**
	This class purpose is to hold the information of an objective
	@author a-carrasquillo
*/
public class ObjectiveClass {
	// Data fields
	private String id;
	private String description;
	private ArrayList<AgencyInfo> objectiveAlignment;

	/**
		<h1>Default constructor</h1>
		Creates an empty object
	*/
	public ObjectiveClass()	{
		id = "";
		description = "";
		objectiveAlignment = new ArrayList<>();
	}

	/**
		<h1>Special constructor</h1>
			Creates an object with the specified parameters
			@param id - id of the objective
			@param description - description of the objective
			@param objectiveAlignment - array list with the information
										of the alignment (agency id,
										agency objective id)
	*/
	public ObjectiveClass(String id, String description, ArrayList<AgencyInfo> objectiveAlignment) {
		this.id = id;
		this.description = description;
		this.objectiveAlignment = objectiveAlignment;
	}

	// Getters
	/**
		<h1>getId method</h1>
			Method that returns the id of the objective
			@return id of the objective
	*/
	public String getId() { 
		return this.id; 
	}

	/**
		<h1>getDescription method</h1>
			Method that returns the description of the objective
			@return Description of the objective
	*/
	public String getDescription() { 
		return this.description; 
	}

	/**
		<h1>getObjectiveAlignment method</h1>
			Method that returns the alignment of the objective
			@return List of the objective alignment using AgencyInfo class to 
					identify the agency and their objective id 
	*/
	public ArrayList<AgencyInfo> getObjectiveAlignment() { 
		return this.objectiveAlignment;
	}

	// Setters
	/**
		<h1>setId method</h1>
			Method that set a new value to the id of the objective
			@param id - id of the objective
	*/
	public void setId(String id) { 
		this.id = id; 
	}

	/**
		<h1>setDescription method</h1>
			Method that set a new value to the description
			@param description - id of the agency that 
							  	 the objective belongs to
	*/
	public void setDescription(String description) { 
		this.description = description; 
	}

	/**
		<h1>setObjectiveAlignment method</h1>
			Method that sets the alignment of the objective using an array list
			@param objectiveAlignment - ArrayList containing the objective alignment
	*/
	public void setObjectiveAlignment(ArrayList<AgencyInfo> objectiveAlignment) {
		this.objectiveAlignment = objectiveAlignment;
	}
}