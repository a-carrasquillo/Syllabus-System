// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

/**
	This class purpose is to hold the information of a rule
	so it can be shown in the syllabus preview and also be
	used in the word document generation.
	@author a-carrasquillo
*/
public class RulesInfo {
	// Data fields
	private String title;
	private String description;

	/**
		<h1>Default constructor</h1>
			Creates an empty rule object
	*/
	public RulesInfo() {
		title = "";
		description = "";
	}

	/**
		<h1>Special constructor</h1>
			Creates a rule object with the specified parameters
			@param title - title of the rule
			@param description - description of the rule
	*/
	public RulesInfo(String title, String description) {
		this.title = title;
		this.description = description;
	}

	// Getters
	/**
		<h1>getTitle method</h1>
			Return the value of the title
			@return Title of the rule
	*/
	public String getTitle() { 
		return this.title;	
	}

	/**
		<h1>getDescription method</h1>
			Return the value of the description
			@return Description of the rule
	*/
	public String getDescription() { 
		return this.description;	
	}

	// Setters
	/**
		<h1>setTitle method</h1>
			Set a new value to the title
			@param title - new value of the title
	*/
	public void setTitle(String title) { 
		this.title = title;	
	}

	/**
		<h1>setDescription method</h1>
			Set a new value to the description
			@param description - new value of the description
	*/
	public void setDescription(String description) { 
		this.description = description;	
	}
}