// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import required packages
import java.util.*;

/**
	This class purpose is to hold the information of a syllabus
	@author a-carrasquillo
*/
public class SyllabusInfo {
	// Data fields
	private String code;
	private String title;
	private String type;
	private String modality;
	private String level;
	private ArrayList<String> prerequisites;
	private ArrayList<String> corequisites;
	private String duration;
	private String credits;
	private String description;
	private String justification;
	private ArrayList<ObjectiveClass> objectives;
	private ArrayList<String> thematicContent;
	private ArrayList<String> teachingStrategies;
	private ArrayList<String> assessmentStrategies;
	private ArrayList<String> textbooks;
	private ArrayList<String> bibliography;
	private ArrayList<String> onlineResources;
	private ArrayList<String> rules;
	private ArrayList<RulesInfo> rulesFullInfo;
	private String authorName;
	private String creationDate;
	private String editorName;
	private String editionDate;

	/**
		<h1>Default constructor</h1>
			Creates an empty syllabus object
	*/
	public SyllabusInfo() {
		code = "";
		title = "";
		type = "";
		modality = "";
		level = "";
		prerequisites = new ArrayList<>();
		corequisites = new ArrayList<>();
		duration = "";
		credits = "";
		description = "";
		justification = "";
		objectives = new ArrayList<ObjectiveClass>();
		thematicContent = new ArrayList<>();
		teachingStrategies = new ArrayList<>();
		assessmentStrategies = new ArrayList<>();
		textbooks = new ArrayList<>();
		bibliography = new ArrayList<>();
	 	onlineResources = new ArrayList<>();
	 	rules = new ArrayList<>(); 
	 	rulesFullInfo = new ArrayList<>();
		authorName = "";
		creationDate = "";
		editorName = "";
		editionDate = "";
	}

	/**
		<h1>Special constructor for basic information</h1>
			Creates a syllabus object with the specified parameters
			@param code - course code 
			@param title - course title
			@param type - course type
			@param modality - course modality
			@param level - course level
	*/
	public SyllabusInfo(String code, String title, String type, String modality, String level) {
		this.code = code;
		this.title = title;
		this.type = type;
		this.modality = modality;
		this.level = level;
	}

	// Getters
	/**
		<h1>getCode method</h1>
			Method that returns the code of the course
			@return Code of the course
	*/
	public String getCode() {
		return this.code;
	}

	/**
		<h1>getTitle method</h1>
			Method that returns the title of the course
			@return Title of the course
	*/
	public String getTitle() {
		return this.title;
	}

	/**
		<h1>getType method</h1>
			Method that returns the type of course
			@return Type of course
	*/
	public String getType() {
		return this.type;
	}

	/**
		<h1>getModality method</h1>
			Method that returns the modality of the course
			@return Modality of the course
	*/
	public String getModality() {
		return this.modality;
	}

	/**
		<h1>getLevel method</h1>
			Method that returns the level of the course
			@return Level of the course
	*/
	public String getLevel() {
		return this.level;
	}

	/**
		<h1>getPrerequisites method</h1>
			Method that returns the prerequisites of the course
			@return ArrayList of the prerequisites of the course
	*/
	public ArrayList<String> getPrerequisites() {
		return this.prerequisites;
	}

	/**
		<h1>getCorequisites method</h1>
			Method that returns the co-requisites of the course
			@return ArrayList of the co-requisites of the course
	*/
	public ArrayList<String> getCorequisites() {
		return this.corequisites;
	}

	/**
		<h1>getDuration method</h1>
			Method that returns the duration of the course
			@return Duration of the course
	*/
	public String getDuration() {
		return this.duration;
	}

	/**
		<h1>getCredits method</h1>
			Method that returns the amount of credits of the course
			@return Credits of the course
	*/
	public String getCredits() {
		return this.credits;
	}

	/**
		<h1>getDescription method</h1>
			Method that returns the description of the course
			@return Description of the course
	*/
	public String getDescription() {
		return this.description;
	}

	/**
		<h1>getJustification method</h1>
			Method that returns the justification of the course
			@return Justification of the course
	*/
	public String getJustification() {
		return this.justification;
	}

	/**
		<h1>getObjectives method</h1>
			Method that returns the objectives of the course with their alignment
			@return Objectives of the course with their alignment
	*/
	public ArrayList<ObjectiveClass> getObjectives() {
		return this.objectives;
	}

	/**
		<h1>getThematicContent method</h1>
			Method that returns the thematic content of the course
			@return ArrayList with the thematic content of the course
	*/
	public ArrayList<String> getThematicContent() {
		return this.thematicContent;
	}

	/**
		<h1>getTeachingStrategies method</h1>
			Method that returns the teaching strategies of the course
			@return ArrayList with the teaching strategies of the course
	*/
	public ArrayList<String> getTeachingStrategies() {
		return this.teachingStrategies;
	}

	/**
		<h1>getAssessmentStrategies method</h1>
			Method that returns the assessment strategies of the course
			@return ArrayList with the assessment strategies of the course
	*/
	public ArrayList<String> getAssessmentStrategies() {
		return this.assessmentStrategies;
	}

	/**
		<h1>getTextbooks method</h1>
			Method that returns the textbooks of the course
			@return ArrayList with the textbooks of the course
	*/
	public ArrayList<String> getTextbooks() {
		return this.textbooks;
	}

	/**
		<h1>getBibliography method</h1>
			Method that returns the bibliography of the course
			@return ArrayList with the bibliography of the course
	*/
	public ArrayList<String> getBibliography() {
		return this.bibliography;
	}

	/**
		<h1>getOnlineResources method</h1>
			Method that returns the online resources of the course
			@return ArrayList with the online resources of the course
	*/
	public ArrayList<String> getOnlineResources() {
		return this.onlineResources;
	}

	/**
		<h1>getRules method</h1>
			Method that returns the rules of the course
			@return ArrayList with the rules of the course
	*/
	public ArrayList<String> getRules() {
		return this.rules;
	}

	/**
		<h1>getRuleFullInfo method</h1>
			Method that returns the full information of the course's rules
			@return ArrayList of type RulesInfo containing all the information
					of the course's rules
	*/
	public ArrayList<RulesInfo> getRuleFullInfo() {
		return this.rulesFullInfo;
	}

	/**
		<h1>getAuthorName method</h1>
			Method that returns the syllabus author's name
			@return Syllabus author's name
	*/
	public String getAuthorName() {
		return this.authorName;
	}

	/**
		<h1>getCreationDate method</h1>
			Method that returns the syllabus creation date
			@return Syllabus creation date
	*/
	public String getCreationDate() {
		return this.creationDate;
	}

	/**
		<h1>getEditorName method</h1>
			Method that returns the syllabus editor's name
			@return Syllabus editor's name
	*/
	public String getEditorName() {
		return this.editorName;
	}

	/**
		<h1>getEditionDate method</h1>
			Method that returns the syllabus edition date
			@return Syllabus edition date
	*/
	public String getEditionDate() {
		return this.editionDate;
	}
	
	// Setters
	/**
		<h1>setCode method</h1>
			Method that set a new value to the course code
			@param code - new course code
	*/
	public void setCode(String code) { 
		this.code = code; 
	}

	/**
		<h1>setTitle method</h1>
			Method that set a new value to the course title
			@param title - new course title
	*/
	public void setTitle(String title) { 
		this.title = title; 
	}

	/**
		<h1>setType method</h1>
			Method that set a new value to the course type
			@param type - new course type
	*/
	public void setType(String type) { 
		this.type = type; 
	}

	/**
		<h1>setModality method</h1>
			Method that set a new value to the course modality
			@param modality - new course modality
	*/
	public void setModality(String modality) { 
		this.modality = modality; 
	}

	/**
		<h1>setLevel method</h1>
			Method that set a new value to the course level
			@param level - new course level
	*/
	public void setLevel(String level) { 
		this.level = level; 
	}

	/**
		<h1>setPrerequisites method</h1>
			Method that set a new value to the course prerequisites
			@param prerequisites - new course prerequisites
	*/
	public void setPrerequisites(ArrayList<String> prerequisites) { 
		this.prerequisites = prerequisites; 
	}

	/**
		<h1>setCorequisites method</h1>
			Method that set a new value to the course co-requisites
			@param corequisites - new course co-requisites
	*/
	public void setCorequisites(ArrayList<String> corequisites) { 
		this.corequisites = corequisites; 
	}

	/**
		<h1>setDuration method</h1>
			Method that set a new value to the course duration
			@param duration - new course duration
	*/
	public void setDuration(String duration) { 
		this.duration = duration; 
	}

	/**
		<h1>setCredits method</h1>
			Method that set a new value to the course credits
			@param credits - new course credits
	*/
	public void setCredits(String credits) { 
		this.credits = credits; 
	}

	/**
		<h1>setDescription method</h1>
			Method that set a new value to the course description
			@param description - new course description
	*/
	public void setDescription(String description) { 
		this.description = description; 
	}

	/**
		<h1>setJustification method</h1>
			Method that set a new value to the course justification
			@param justification - new course justification
	*/
	public void setJustification(String justification) { 
		this.justification = justification; 
	}

	/**
		<h1>setObjectives method</h1>
			Method that set a new value to the course objectives
			with their alignment
			@param objectives - new course objectives with their alignment
	*/
	public void setObjectives(ArrayList<ObjectiveClass> objectives) { 
		this.objectives = objectives; 
	}

	/**
		<h1>setThematicContent method</h1>
			Method that set a new value to the course thematic content
			@param thematicContent - new course thematic content
	*/
	public void setThematicContent(ArrayList<String> thematicContent) { 
		this.thematicContent = thematicContent; 
	}

	/**
		<h1>setTeachingStrategies method</h1>
			Method that set a new value to the course teaching strategies
			@param teachingStrategies - new course teaching strategies
	*/
	public void setTeachingStrategies(ArrayList<String> teachingStrategies) { 
		this.teachingStrategies = teachingStrategies; 
	}

	/**
		<h1>setAssessmentStrategies method</h1>
			Method that set a new value to the course assessment strategies
			@param assessmentStrategies - new course assessment strategies
	*/
	public void setAssessmentStrategies(ArrayList<String> assessmentStrategies) { 
		this.assessmentStrategies = assessmentStrategies; 
	}

	/**
		<h1>setTextbooks method</h1>
			Method that set a new value to the course textbooks
			@param textbooks - new course textbooks
	*/
	public void setTextbooks(ArrayList<String> textbooks) { 
		this.textbooks = textbooks; 
	}

	/**
		<h1>setBibliography method</h1>
			Method that set a new value to the course bibliography
			@param bibliography - new course bibliography
	*/
	public void setBibliography(ArrayList<String> bibliography) { 
		this.bibliography = bibliography; 
	}

	/**
		<h1>setOnlineResources method</h1>
			Method that set a new value to the course online resources
			@param onlineResources - new course online resources
	*/
	public void setOnlineResources(ArrayList<String> onlineResources) { 
		this.onlineResources = onlineResources; 
	}

	/**
		<h1>setRules method</h1>
			Method that set a new value to the course rules
			NOTE: Used when only rules' ids are needed
			@param rules - new course rules
	*/
	public void setRules(ArrayList<String> rules) { 
		this.rules = rules; 
	}

	/**
		<h1>setRulesFullInfo method</h1>
			Method that set a new value to the course rules full info
			NOTE: Used when title and description of the rule are needed
			@param rulesFullInfo - new course rules full info
	*/
	public void setRulesFullInfo(ArrayList<RulesInfo> rulesFullInfo) {
		this.rulesFullInfo = rulesFullInfo;
	}

	/**
		<h1>setAuthorName method</h1>
			Method that set a new value to the syllabus author's name
			@param authorName - new syllabus author's name
	*/
	public void setAuthorName(String authorName) { 
		this.authorName = authorName; 
	}

	/**
		<h1>setCreationDate method</h1>
			Method that set a new value to the syllabus creation date
			@param creationDate - new syllabus creation date
	*/
	public void setCreationDate(String creationDate) { 
		this.creationDate = creationDate; 
	}

	/**
		<h1>setEditorName method</h1>
			Method that set a new value to the syllabus editor's name
			@param editorName - new syllabus editor's name
	*/
	public void setEditorName(String editorName) { 
		this.editorName = editorName; 
	}

	/**
		<h1>setEditionDate method</h1>
			Method that set a new value to the syllabus edition date
			@param editionDate - new syllabus edition date
	*/
	public void setEditionDate(String editionDate) { 
		this.editionDate = editionDate; 
	}
}