// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import the java.sql package for managing the connections,
// queries and results from the database
import java.sql.* ;

// Import java.util.* package to use arrayLists
import java.util.*;

/**
	This class manage a connection to the database and it
    should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating
    data without showing how to access the database.
    @author a-carrasquillo
*/
public class applicationDBManager {
	// myDBConn is an MySQLConnector object for accessing the database
	private MySQLConnector myDBConn;
	
	/**
		<h1>Default constructor</h1>
		  It creates a new MySQLConnector object
          and open a connection to the database
	*/
	public applicationDBManager() {
		// Create the MySQLConnector object
		myDBConn = new MySQLConnector();
		
		// Open the connection to the database
		myDBConn.doConnection();
	}

    /**
        <h1>addTypeOfStrategy method</h1>
            This method add a single Strategy type to the database
            @param description - description of the strategy
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the strategy was added successfully
                    <b>false:</b> the strategy cannot be added
    */
    public boolean addTypeOfStrategy(String description) {
        // declaring function variables
        String table, values;

        // Determining the new strategy id
        int strategyId = getAmountTypesStrategies() + 1;

        // Define the table where the insertion will be performed
        table = "tipos_estrategias";

        // Define the values to be inserted in the tipos_estrategias table
        values = "'" + strategyId + "', '" + description + "'";

        // perform the insert into the tipos_estrategias table
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>getAmountTypesStrategies support method</h1>
            Allow us to determine the amount of strategies
            types in the database
            @return Integer value indicating the amount of
            strategies types in the database
    */
    private int getAmountTypesStrategies() {
        // Declare function variables
        String field, table;
        int amount = 0;

        // Define the field that is going to be retrieve from the database
        field = "id_estrategias";

        // Define the table where the selection is performed
        table = "tipos_estrategias";

        // Execute the selection on the database
        ResultSet res = myDBConn.doSelect(field, table);

        /* Iterate over the ResultSet containing all
           strategies types in the database, and count
           how many tuples were retrieved */
        try {
            while(res.next())
                amount++;
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close the result set
             try {
                if(res!=null)
                    res.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            // return the amount of strategies types in the database
            return amount;
        }
    }

    /**
        <h1>listAllTypesOfStrategies method</h1>
            List all the types of teaching strategies in the database
            @return
                A ResultSet containing all the types of teaching
                strategies in the database (id, strategy)
    */
    public ResultSet listAllTypesOfStrategies() {
        // Declare function variables
        String fields, table;
        
        // Define the table where the selection is performed
        table = "tipos_estrategias";
        
        // Define the fields list to retrieve from the table 
        fields = "id_estrategias, descripcion";
                
        System.out.println("Listing all the types of strategies...");
        
        // Return the ResultSet containing all 
        return myDBConn.doSelect(fields, table);
    }

    /**
       <h1>addTeachingStrategy method</h1>
            This support method add a single teaching strategy
            related to a entry id (indirectly a course) to the database
            @param entryId - id of the entry that relates to a course
                             on a certain moment
            @param strategyId - id of the teaching strategy
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the teaching strategy was added successfully
                    <b>false:</b> the teaching strategy cannot be added 
    */
    private boolean addTeachingStrategy(String entryId, String strategyId) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "estrategias_ensenanza";

        // Define the values to be inserted in the table
        values = entryId + ", '" + strategyId + "'";

        // Return true if the insert was successful, else false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>listTeachingStrategy method</h1>
            List all the teaching strategies related to an entry id
            @param entryId - id of the entry that the teaching
                             strategies will be sought 
            @return
                A ResultSet containing all the teaching strategies
                of a course based on the entry id specified
                in the argument
    */
    private ResultSet listTeachingStrategy(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "estrategias_ensenanza, tipos_estrategias";

        // Define the fields list to retrieve from the table 
        fields = "descripcion";

        // Define the where condition 
        where = "estrategias_ensenanza.id_estrategias=tipos_estrategias.id_estrategias and id_entrada=" + entryId;

        System.out.println("Listing teaching strategies of the entry id "+ entryId + "...");
                
        // Return the ResultSet containing all the teaching
        // strategies related to the entry id
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addOnlineResource method</h1>
            This support method add online resources related to an
            entry id to the DB
            @param entryId - id of the entry
            @param onlineResources - list of online resources to be added
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the online resources were added successfully
                    <b>false:</b> the online resources cannot be added

            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again.
    */
    private boolean addOnlineResource(String entryId, ArrayList<String> onlineResources) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "recursos_en_linea";

        // Verify if there are online resources to be inserted
        if(!onlineResources.isEmpty()) {
            // While we have online resources in the array list
            // we performed the insertions in the table 
            while(!onlineResources.isEmpty()) {
                // Define the values to be inserted in the
                // recursos_en_linea table
                values = entryId + ", '" + onlineResources.get(0) + "'";

                // if an error occurs return false
                if(!myDBConn.doInsert(table, values))
                    return false;
                
                // remove the first online resource from the
                // onlineResources since it has been already inserted 
                onlineResources.remove(0);
            }
            // all inserts were successful
            return true;
        }
        // the online resources array list was empty
        return false;
    }

    /**
        <h1>listOnlineResource method</h1>
            List all the online resources related to the entry id
            specified in the argument
            @param entryId - id of the entry that the online resources
                             will be sought 
            @return
                A ResultSet containing all the online resources of an
                entry id specified in the argument
    */
    private ResultSet listOnlineResource(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "recursos_en_linea";

        // Define the fields list to retrieve from the table 
        fields = "recursos";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the online resources related to the entry id "+ entryId + "...");
                
        // Return the ResultSet containing all the online resources
        // related to the entry id specified in the argument
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addPrerequisite method</h1>
            This support method add prerequisites related to an
            entry id to the database
            @param entryId - id of the entry that the prerequisite
                             is related to
            @param prerequisites - code of the course/s that is/are
                                   prerequisite to the current course
                                   (entry id)
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the prerequisite/s was/were added successfully
                    <b>false:</b> the prerequisite/s cannot be added

            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addPrerequisite(String entryId, ArrayList<String> prerequisites) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "prerequisito";

        // Verify if the array list at least have one element
        if(!prerequisites.isEmpty()) {
            // While we have course codes in the array list we
            // performed the insertions in the table 
            while(!prerequisites.isEmpty()) {
                // Define the values to be inserted in the prerequisito table
                values = entryId + ", '" + prerequisites.get(0) + "'";

                // if an error occurs return false
                if(!myDBConn.doInsert(table, values))
                    return false;
                
                // remove the first course code from the prerequisites
                // since it has been already inserted 
                prerequisites.remove(0);
            }
            // all inserts were successful
            return true;
        }
        // the prerequisites array list was empty
        return false;
    }

    /**
        <h1>listPrerequisites method</h1>
            List all the prerequisites related to the entry id
            specified in the argument
            @param entryId - id of the entry that the prerequisites
                             will be sought 
            @return
                A ResultSet containing all the prerequisites related
                to the entry id specified in the argument
    */
    private ResultSet listPrerequisites(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "prerequisito";

        // Define the fields list to retrieve from the table 
        fields = "curso_previo";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the prerequisites related to the entry id "+ entryId + "...");
                
        // Return the ResultSet containing all the prerequisites
        // related to the entry id specified in the argument
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addCorequisite method</h1>
            This support method add co-requisites related to an
            entry id to the database
            @param entryId - id of the entry that the co-requisite
                             is related to
            @param corequisites - code of the course/s that is/are
                                  co-requisite to the current course
                                  specified by the entry id
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the co-requisite was added successfully
                    <b>false:</b> the co-requisite cannot be added 
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again.
    */
    private boolean addCorequisite(String entryId, ArrayList<String> corequisites) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "correquisitos";

        // Verify that there is at least one co-requisite to be added
        if(!corequisites.isEmpty()) {
            // While we have course codes in the array list we perform
            // the insertions in the table 
            while(!corequisites.isEmpty()) {
                // Define the values to be inserted in the correquisitos table
                values = entryId + ", '" + corequisites.get(0) + "'";

                // If an error occurs return false
                if(!myDBConn.doInsert(table, values))
                    return false;
                
                // Remove the first course code from the co-requisites
                // since it has been already inserted 
                corequisites.remove(0);
            }
            // All inserts were successful
            return true;
        }
        // The co-requisites array list was empty
        return false;
    }

    /**
        <h1>listCorequisites method</h1>
            List all the co-requisites related to the entry id
            specified in the argument
            @param entryId - id of the entry that the co-requisites
                             will be sought 
            @return
                A ResultSet containing all the co-requisites related
                to the entry id specified in the argument
    */
    private ResultSet listCorequisites(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "correquisitos";

        // Define the fields list to retrieve from the table 
        fields = "curso";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the co-requisites related to the entry id "+ entryId + "...");
                
        // Return the ResultSet containing all the co-requisites
        // related to the entry id specified in the argument
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addTextbook method</h1>
            This support method add textbook/s related to a 
            course (entry id) to the database
            @param entryId - id of the entry
            @param textbooks - list with the textbooks' names
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the textbook/s was/were added successfully
                    <b>false:</b> the textbook/s cannot be added 
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again.
    */
    private boolean addTextbook(String entryId, ArrayList<String> textbooks) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "libro_texto";

        // Verify that there is at least one textbook to be added
        if(!textbooks.isEmpty()) {
            // While we have textbooks names in the array list
            // we performed the insertions in the table 
            while(!textbooks.isEmpty()) {
                // Define the values to be inserted in the libro_texto table
                values = entryId + ", '" + textbooks.get(0) + "'";

                // If an error occurs return false
                if(!myDBConn.doInsert(table, values))
                    return false;
                
                // Remove the first textbook name from the textbooks
                // since it has been already inserted 
                textbooks.remove(0);
            }
            // All inserts were successful
            return true;
        }
        // The textbooks array list was empty
        return false;
    }

    /**
        <h1>listTextbooks method</h1>
            List all the textbooks related to an entry id specified
            in the argument
            @param entryId - id of the entry that the textbooks will be sought 
            @return
                A ResultSet containing all the textbooks related
                to the entry id specified in the argument
    */
    private ResultSet listTextbooks(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "libro_texto";

        // Define the field list to retrieve from the table 
        fields = "nombre";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the textbooks related to the entry id "+ entryId + "...");
                
        // Return the ResultSet containing all the textbooks
        // related to an entry id specified in the argument
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>listEducationLevels method</h1>
            List all the education levels
            @return
                A ResultSet containing all the education levels
                (grade id, level of education)
    */
    public ResultSet listEducationLevels() {
        // Declare function variables
        String fields, table;

        // Define the table where the selection is performed
        table = "grado_educacion";

        // Define the fields list to retrieve from the table 
        fields = "id_grado, nivel_educ";

        System.out.println("Listing all the education levels...");
                
        // Return the ResultSet containing all the education levels
        return myDBConn.doSelect(fields, table);
    }

    /**
       <h1>addProgram method</h1>
            This method add a program of study to the database
            @param idProgram - code of the program, it has four digits
            @param idLevel - id of the level that the program belongs to
            @param name - name of the program
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the program was added successfully
                    <b>false:</b> the program cannot be added 
    */
    public boolean addProgram(String idProgram, String idLevel, String name) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "programas";

        // Define the values to be inserted in the programas table
        values = "'" + idProgram + "', '" + idLevel + "', '" + name + "', CURRENT_TIMESTAMP";

        // Return true if the insert was successful, else false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>listAllPrograms method</h1>
            List all the programs of study
            @return
                A ResultSet containing all the 
                programs of study (level, program id, name)
    */
    public ResultSet listAllPrograms() {
        // Declare function variables
        String fields, tables, where;

        // Define the table where the selection is performed
        tables = "programas, grado_educacion";

        // Define the fields list to retrieve from the table 
        fields = "nivel_educ, id_programa, nombre_programa";

        // Define the where condition 
        where = "grado_educacion.id_grado=programas.id_grado";

        System.out.println("Listing all the programs of study...");
                
        // Return the ResultSet containing all the programs of study
        return myDBConn.doSelect(fields, tables, where);
    }
    
    /**
       <h1>addCoursesToProgram method</h1>
            This method add courses to a program of study in the database
            @param idProgram - code of the program, it has four digits
            @param courseCodes - arrayList with the course codes
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the courses was added to the program successfully
                    <b>false:</b> the courses cannot be added to the
                                  program successfully
    */
    public boolean addCoursesToProgram(String idProgram, ArrayList<String> courseCodes) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "programa_curso";

        // Verify that there is at least one course code
        if(!courseCodes.isEmpty()) {
            // Disable the auto commit because we are going
            // to do a transaction
            myDBConn.disableAutoCommit();

            // while we have course codes in the array list
            // we performed the insertions in the programa_curso table 
            while(!courseCodes.isEmpty()) {
                // Define the values to be inserted in the programa_curso table
                values = "'" + idProgram + "', '" + courseCodes.get(0) + "', CURRENT_TIMESTAMP";

                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // discard the changes due to an error
                    myDBConn.doRollback();
                    myDBConn.enableAutoCommit();
                    return false;
                }
                // remove the first course code since it has been
                // already inserted 
                courseCodes.remove(0);
            }
            // Since all inserts were made successfully, perform
            // a commit to save the changes
            myDBConn.doCommit();
            // Enable the auto-commit since the transaction has finished
            myDBConn.enableAutoCommit();
            // All the inserts were successful
            return true;
        }
        // The course code array list was empty
        return false;
    }

    /**
        <h1>listCoursesOfProgram method</h1>
            List all the courses that belongs to a program of
            studies specified in the argument
            @param idProgram - id of the program that the user wants to
                               see the courses in it
            @return
                A ResultSet containing all the courses codes that belongs
                to a program of studies specified in the argument
    */
    public ResultSet listCoursesOfProgram(String idProgram) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "programa_curso";

        // Define the fields list to retrieve from the table 
        fields = "codigo_curso";

        // Define the where condition 
        where = "id_programa='" + idProgram + "'";

        System.out.println("Listing all the courses codes that belongs to the program of studies identified by "+ idProgram + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>addTypeOfAssessment method</h1>
            This method add a single assessment type to the database
            @param description - description of the assessment
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the assessment type was added successfully
                    <b>false:</b> the assessment type cannot be added
    */
    public boolean addTypeOfAssessment(String description) {
        // Declaring function variables
        String table, values;

        // Determining the new assessment id
        int assessmentId = getAmountTypesAssessment()+1;

        // Define the table where the insertion will be performed
        table = "tipos_assessment";

        // Define the values to be inserted in the tipos_assessment table
        values = "'" + assessmentId + "', '" + description + "'";

        // perform the insert into the tipos_assessment table
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>getAmountTypesAssessment support method</h1>
            Allow us to determine the amount of assessment types
            in the database
            @return Integer value indicating the amount of 
                    assessment types in the database
    */
    private int getAmountTypesAssessment() {
        // Declare function variables
        String field, table;
        int amount = 0;

        // Define the field that is going to be retrieve from the database
        field = "id_assessment";

        // Define the table where the selection is performed
        table = "tipos_assessment";

        // Execute the selection on the database
        ResultSet res = myDBConn.doSelect(field, table);

        // Iterate over the ResultSet containing all assessment types
        // in the database, and count how many tuples were retrieved
        try {
            while(res.next())
                amount++;
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close the result set
            try {
                if(res!=null)
                    res.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Return the amount of assessment types in the database
            return amount;
        }
    }

    /**
        <h1>listAllTypesOfAssessment method</h1>
            List all the types of assessment strategies in the database
            @return
                A ResultSet containing all the types of assessment
                strategies (id, description) in the database
    */
    public ResultSet listAllTypesOfAssessment() {
        // Declare function variables
        String fields, table;
        
        // Define the table where the selection is performed
        table = "tipos_assessment";
        
        // Define the fields list to retrieve from the table 
        fields = "id_assessment, description";
                
        System.out.println("Listing all the types of assessment...");
        
        // Return the result of the search
        return myDBConn.doSelect(fields, table);
    }

    /**
       <h1>addAssessmentStrategy method</h1>
            This support method add a single assessment related
            to an entry id to the database
            @param entryId - id of the entry
            @param idAssessment - id of the assessment
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the assessment was added successfully
                    <b>false:</b> the assessment cannot be added 
    */
    private boolean addAssessmentStrategy(String entryId, String idAssessment) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "estrategias_assessment";

        // Define the values to be inserted in the estrategias_assessment table
        values = entryId + ", '" + idAssessment + "'";

        // Return true if the insert was successful, else false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>listAssessmentStrategies method</h1>
            List all the assessments related to an entry id
            specified in the argument
            @param entryId - entry id that the assessments will be sought 
            @return
                A ResultSet containing all the assessments related to an 
                entry id specified in the argument
    */
    private ResultSet listAssessmentStrategies(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the tables where the selection is performed
        table = "estrategias_assessment, tipos_assessment";

        // Define the field list to retrieve from the table 
        fields = "description";

        // Define the where condition 
        where = "estrategias_assessment.id_assessment=tipos_assessment.id_assessment and id_entrada=" + entryId;

        System.out.println("Listing the assessments related to entry id "+ entryId + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addBibliography method</h1>
            This support method add bibliographies related to
            an entry id to the database
            @param entryId - id of the entry
            @param bibliographies - list of bibliographies to be added
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the bibliographies were added successfully
                    <b>false:</b> the bibliographies cannot be added 
            
            NOTE: This method does not disable the auto-commit like
            other transactions because this support method is part
            of a bigger transaction that will disable the auto-commit,
            will perform the rollback or commit as needed, and lastly
            will enable the auto-commit again.
    */
    private boolean addBibliography(String entryId, ArrayList<String> bibliographies) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "bibliografias";

        // Verify that there is at least one bibliography 
        if(!bibliographies.isEmpty()) {
            // Disable the auto commit because we are going
            // to do a transaction
            myDBConn.disableAutoCommit();

            // While we have bibliographies in the array list
            // we performed the insertions in the table 
            while(!bibliographies.isEmpty()) {
                // Define the values to be inserted in the bibliografias table
                values = entryId + ", '" + bibliographies.get(0) + "'";

                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // discard the changes due to an error
                    myDBConn.doRollback();
                    myDBConn.enableAutoCommit();
                    return false;
                }
                // Remove the first bibliography from the bibliographies
                // since it has been already inserted 
                bibliographies.remove(0);
            }
            // Since all inserts were made successfully, perform
            // a commit to save the changes
            myDBConn.doCommit();
            // Enable the auto-commit since the transaction has finished
            myDBConn.enableAutoCommit();
            // All the inserts were successful
            return true;
        }
        // The bibliographies array list was empty
        return false;
    }

    /**
        <h1>listBibliographies method</h1>
            List all the bibliographies related to an entry id
            specified in the argument
            @param entryId - entry id that the bibliographies will be sought 
            @return
                A ResultSet containing all the bibliographies related to an 
                entry id specified in the argument
    */
    private ResultSet listBibliographies(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "bibliografias";

        // Define the fields list to retrieve from the table 
        fields = "bibliografia";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the bibliographies related to the entry id "+ entryId + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>addThematicContent method</h1>
            This support method add thematic contents related to
            an entry id to the database
            @param entryId - id of the entry
            @param thematicContents - list of thematic contents to be added
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the thematic content/s was/were added successfully
                    <b>false:</b> the thematic content/s cannot be added 
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addThematicContent(String entryId, ArrayList<String> thematicContents) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "contenido_tematico";

        // Verify that there is at least one thematic content
        if(!thematicContents.isEmpty()) {
            // While we have thematic content in the array list we
            // perform the insertions in the table 
            while(!thematicContents.isEmpty()) {
                // Define the values to be inserted in the prerequisito table
                values = entryId + ", '" + thematicContents.get(0) + "'";

                // if an error occurs return false
                if(!myDBConn.doInsert(table, values))
                {
                    return false;
                }
                // remove the first thematic content from the
                // thematicContents since it has been already inserted 
                thematicContents.remove(0);
            }
            // All the inserts were successful
            return true;
        }
        // The thematic content array list was empty
        return false;
    }

    /**
        <h1>listThematicContent method</h1>
            List all the thematic contents of an entry id
            specified in the argument
            @param entryId - id of the entry that the thematic
                             contents will be sought 
            @return
                A ResultSet containing all thematic contents of
                an entry id specified in the argument
    */
    private ResultSet listThematicContent(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "contenido_tematico";

        // Define the fields list to retrieve from the table 
        fields = "contenido_tem";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the thematic contents of entry id "+ entryId + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>addRule method</h1>
            This method add a rule to the database
            @param title - title of the rule
            @param description - description of the rule
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the rule was added successfully
                    <b>false:</b> the rule cannot be added
    */
    public boolean addRule(String title, String description) {
        // Declaring function variables
        String table, values;

        // Determining the new rule id
        int ruleId = getAmountRules()+1;

        // Define the table where the insertion will be performed
        table = "politica_reglas_cursos";

        // Define the values to be inserted in the politica_reglas_cursos table
        values = "'" + ruleId + "', '" + title + "', '" + description + "'";

        // Return true if the insert was successful, else false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>getAmountRules support method</h1>
            Allow us to determine the amount of rules in the database
            @return Integer value indicating the amount of rules in the database
    */
    private int getAmountRules() {
        // Declare function variables
        String field, table;
        int amount = 0;

        // Define the field that is going to be retrieve from the database
        field = "id_regla";

        // Define the table where the selection is performed
        table = "politica_reglas_cursos";

        // Execute the selection on the database
        ResultSet res = myDBConn.doSelect(field, table);

        // Iterate over the ResultSet containing all rules in the database,
        // and count how many tuples were retrieved
        try {
            while(res.next())
                amount++;
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close the result set
            try {
                if(res != null)
                    res.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Return the amount of rules in the database
            return amount;
        }
    }

    /**
        <h1>listAllRules method</h1>
            List all the rules in the database
            @return
                A ResultSet containing all the rules titles
                with their id (id, title)
    */
    public ResultSet listAllRules() {
        // Declare function variables
        String fields, table;
        
        // Define the table where the selection is performed
        table = "politica_reglas_cursos";
        
        // Define the fields list to retrieve from the table 
        fields = "id_regla, titulo";
                
        System.out.println("Listing all the rules...");
        
        // Return the result of the search
        return myDBConn.doSelect(fields, table);
    }

    /**
        <h1>searchRule method</h1>
        Search the information of a rule based on the ruleId
        specified in the parameter.
        @param ruleId - id of the rule that will be searched
        @return
            A ResultSet containing the title, and the description of the
            rule identified by the rule id specified in the parameter 
    */
    public ResultSet searchRule(String ruleId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "politica_reglas_cursos";

        // Define the fields list to retrieve from the table 
        fields ="titulo, descripcion";

        // Define the where condition 
        where = "id_regla='" + ruleId + "'";

        System.out.println("Listing the information of the rule identified by "+ ruleId + "...");
        
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>updateRuleInfo method</h1>
            Update the information of a rule.
            @param ruleId - id of the rule to be updated
            @param title - modified title of the rule
            @param description - modified description of the rule
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> information updated successfully
                    <b>false:</b> information cannot be updated
    */
    public boolean updateRuleInfo(String ruleId, String title, String description) {
        // Declare function variables
        String table, assignmentList, where;
        
        // Define the table where the selection is performed
        table = "politica_reglas_cursos";
        
        // Define the assignment list
        assignmentList = "titulo='" + title + "', descripcion='" + description + "'";
        
        // Define the where condition to update the correct rule
        where = "id_regla='" + ruleId + "'";
        
        System.out.println("Updating information of rule identified by " + ruleId + "...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }

    /**
       <h1>addRuleToCourse method</h1>
            This support method add rules related to an entry id
            to the database
            @param entryId - id of the entry
            @param ruleIds - ids of the rules to be added
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the rules were added successfully to the course
                    <b>false:</b> the rules cannot be added to the course
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addRuleToCourse(String entryId, ArrayList<String> ruleIds) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "reglas_aplicadas";

        // Verify that there is at least one rule id
        if(!ruleIds.isEmpty()) {
            // While we have rules ids in the array list we perform
            // the insertions in the table 
            while(!ruleIds.isEmpty()) {
                // Define the values to be inserted in the reglas_aplicadas table
                values = entryId + ", '" + ruleIds.get(0) + "'";

                // If an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    return false;
                }
                // Remove the first rule id from the ruleIds since
                // it has been already inserted 
                ruleIds.remove(0);
            }
            // All the inserts were successful
            return true;
        }
        // The rule ids array list was empty
        return false;
    }

    /**
        <h1>listCourseRules method</h1>
            List all the rules related to an entry id specified
            in the argument
            @param entryId - id of the entry that the rules will be sought 
            @return
                A ResultSet containing all course rules (title, description)
                of an entry id specified in the argument
    */
    private ResultSet listCourseRules(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "reglas_aplicadas, politica_reglas_cursos";

        // Define the fields list to retrieve from the table 
        fields = "titulo, descripcion";

        // Define the where condition 
        where = "reglas_aplicadas.id_regla=politica_reglas_cursos.id_regla and id_entrada=" + entryId;

        System.out.println("Listing the rules related to the entry id "+ entryId + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>addCourse method</h1>
            Add a course to the system
            @param courseCode - code of the course
            @param courseTitle - title of the course
            @param courseType - the type of course (A-Conferencia, P-Práctica)
            @param courseModality - the modality of the course (Presencial,
                                    En Línea, Híbrido)
            @param username - username of the user that creates the course
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> the course was added
                    <b>false:</b> the course cannot be added
    */
    public boolean addCourse(String courseCode, String courseTitle, String courseType, String courseModality, String username) {
        // Declaring function variables
        String table, values;

        // Define the table where the insertion will be performed
        table = "cursos";

        // Define the values to be inserted in the cursos table
        values = "'" + courseCode + "', '" + courseTitle + "', '" 
                + courseType + "', '" + courseModality + "', '"
                + username + "', CURRENT_TIMESTAMP";

        // Return true if the insert was successful, else false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>listAllCourseCodes method</h1>
            List all the course codes in the database
            @return
                A ResultSet containing all the course codes
    */
    public ResultSet listAllCourseCodes() {
        // Declare function variables
        String fields, table;
        
        // Define the table where the selection is performed
        table = "cursos";
        
        // Define the fields list to retrieve from the table 
        fields = "codigo_curso";
                
        System.out.println("Listing all the course codes...");
        
        // Return the result of the search
        return myDBConn.doSelect(fields, table);
    }

    /**
        <h1>listNewCourses method</h1>
            List all the new courses, with this we mean all courses that
            do not have a syllabus. 
            @return
                A ResultSet containing all the new courses

            NOTE: This method list only the new courses that have been
            assign to a program to avoid errors in the syllabus creation page
    */
    public ResultSet listNewCourses() {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "cursos";

        // Define the fields list to retrieve from the table 
        fields = "codigo_curso, titulo_curso";

        // Define the where condition 
        where = "codigo_curso NOT IN (SELECT DISTINCT codigo_curso FROM syllabuses) AND ";
        where += "codigo_curso IN (SELECT DISTINCT codigo_curso FROM programa_curso)";

        System.out.println("Listing all new courses...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>searchCourseInfo method</h1>
            Method that search the basic information of a course by
            its course code
            @param courseCode - code of the course that the information
                                will be searched
            @return
                A ResultSet containing the basic information of the
                course(course code, title, type, modality, level)
    */
    public ResultSet searchCourseInfo(String courseCode) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "cursos, programa_curso, programas, grado_educacion";

        // Define the fields list to retrieve from the table 
        fields = "distinct cursos.codigo_curso, titulo_curso, tipo_curso, modalidad, nivel_educ";

        // Define the where condition 
        where = "cursos.codigo_curso=programa_curso.codigo_curso and programa_curso.id_programa=programas.id_programa";
        where += " and programas.id_grado=grado_educacion.id_grado and cursos.codigo_curso='" + courseCode + "'";

        System.out.println("Listing the basic information of the course identified by " + courseCode + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>addObjectives method</h1>
            This support method add the objectives with their alignment
            to the DB
            @param entryId - id of the entry that the objectives are
                             related to
            @param objectives - list of objectives with their alignment
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the objectives were added successfully
                    <b>false:</b> the objectives cannot be added

            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addObjectives(String entryId, ArrayList<ObjectiveClass> objectives) {
        // Declaring function variables
        String table, values;

        // Verify that the objectives array list at least have one objective
        if(!objectives.isEmpty()) {
            // While we have objectives in the array list we perform
            // the insertions in the corresponding table 
            while(!objectives.isEmpty()) {
                // Define the table where the new insertions will be performed
                table = "objetivos";

                // Define the values to be inserted in the objetivos table
                values = entryId + ", " + objectives.get(0).getId() + ", '" + objectives.get(0).getDescription() + "'";

                // If an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    System.out.println("Insert fail into objetivos table...");
                    return false;
                } else {
                    // No error in the insertion, proceed to insert
                    // the objective alignment
                    // Define the table where the new insertions will
                    // be performed
                    table = "objetivos_alineados";
                    // Retrieve the alignment of the objective
                    ArrayList<AgencyInfo> objectiveAlignment = objectives.get(0).getObjectiveAlignment();
                    // Verify that there is at least an element in the objective alignment
                    if(!objectiveAlignment.isEmpty()) {
                        // While we have objectives alignment information in the
                        // array list we perform the insertions in the
                        // corresponding table
                        while(!objectiveAlignment.isEmpty()) {
                            // Define the values to be inserted in the objetivos_alineados table
                            values = entryId + ", " + objectives.get(0).getId() + ", " + objectiveAlignment.get(0).getId();
                            values += ", '" + objectiveAlignment.get(0).getObjectiveId() + "'";

                            // If an error occurs return false
                            if(!myDBConn.doInsert(table, values)) {
                                System.out.println("Insert fail into objetivos_alineados table...");
                                return false;
                            }
                            // Remove the first objective alignment since
                            // it has been already inserted 
                            objectiveAlignment.remove(0);
                        }
                    } else {
                        System.out.println("The objective alignment was empty for a objective, verify which one...")
                        return false;
                    } 
                }
                // Remove the first objective since it has been already inserted 
                objectives.remove(0);
            }
            // All inserts were successful
            return true;
        }
        // The objectives array list was empty
        return false;
    }

    /**
        <h1>addTeachingStrategies method</h1>
            This support method add teaching strategies to the DB.
            It determines if the strategy is not in the system and 
            add it to the tipos_estrategias table, then add the id 
            of the strategy to estrategias_ensenanza table
            @param entryId - id of the entry that the teaching strategies
                             are related to
            @param teachingStrategies - list of teaching strategies
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the teaching strategies were added successfully
                    <b>false:</b> the teaching strategies cannot be added 
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addTeachingStrategies(String entryId, ArrayList<String> teachingStrategies) {
        // Verify that there is at least one teaching strategy
        if(!teachingStrategies.isEmpty()) {
            try {
                // Bring the current teaching strategies from the DB
                ResultSet allTeachingStrategies = listAllTypesOfStrategies();

                // Define ArrayList that will hold the system teaching strategies that are in the DB
                ArrayList<String> systemTeachingStrategies = new ArrayList<>();

                // Insert the information in the ArrayList
                while(allTeachingStrategies.next())
                    systemTeachingStrategies.add(allTeachingStrategies.getString(2));

                int strategyLocation, teachingStrategyId;
                // Compare the teaching strategies in the DB with the ones to be added
                while(!teachingStrategies.isEmpty()) {
                    // Search the teaching strategy in the array list
                    // containing the db info
                    strategyLocation = systemTeachingStrategies.indexOf(teachingStrategies.get(0));
                    // If exists insert the teaching strategy using addTeachingStrategy
                    if(strategyLocation!=-1) {
                        // Strategy exists in the system
                        // Define the teaching strategy id number
                        teachingStrategyId = strategyLocation + 1;
                        if(!addTeachingStrategy(entryId, String.valueOf(teachingStrategyId))) {
                            System.out.println("Addition of the teaching strategy fail...");
                            return false;
                        }
                    } else {
                        // Add the missing teaching strategy to the
                        // db using addTypeOfStrategy
                        if(!addTypeOfStrategy(teachingStrategies.get(0))) {
                            System.out.println("Addition of the teaching strategy category fail...");
                            return false;
                        }

                        // Add the new strategy to the array list to avoid
                        // searching the db again
                        systemTeachingStrategies.add(teachingStrategies.get(0));
                        
                        // Now add the teaching strategy to the course
                        // using addTeachingStrategy
                        if(!addTeachingStrategy(entryId, String.valueOf(systemTeachingStrategies.size()))) {
                            System.out.println("Addition of the teaching strategy fail...");
                            return false;
                        }
                    }
                    // Remove the top teaching strategy after is inserted
                    // into the system
                    teachingStrategies.remove(0);
                }
                // All inserts were successful
                return true;
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
        // Something has fail
        return false;
    }

    /**
        <h1>addAssessmentStrategies method</h1>
            This support method add assessment strategies to the DB.
            It determines if the strategy is not in the system and 
            add it to the tipos_assessment table, then add the id 
            of the strategy to estrategias_assessment table
            @param entryId - id of the entry that the assessment strategies
                             are related to
            @param assessmentStrategies - list of assessment strategies
            @return
                  <h3>boolean value:</h3>
                    <b>true:</b> the assessment strategies were added successfully
                    <b>false:</b> the assessment strategies cannot be added 
            
            NOTE: This method does not disable the auto-commit like other
            transactions because this support method is part of a bigger
            transaction that will disable the auto-commit, will perform
            the rollback or commit as needed, and lastly will enable 
            the auto-commit again. 
    */
    private boolean addAssessmentStrategies(String entryId, ArrayList<String> assessmentStrategies) {
        // Verify that there is at least one assessment strategy
        if(!assessmentStrategies.isEmpty()) {
            try {
                // Bring the current assessment strategies from the DB
                ResultSet allAssessmentStrategies = listAllTypesOfAssessment();

                // Define ArrayList that will hold the system assessment
                // strategies that are in the DB
                ArrayList<String> systemAssessmentStrategies = new ArrayList<>();
                
                // Insert the information in the ArrayList
                while(allAssessmentStrategies.next())
                    systemAssessmentStrategies.add(allAssessmentStrategies.getString(2));

                int strategyLocation, assessmentStrategyId;
                // Compare the assessment strategies in the DB with
                // the ones to be added
                while(!assessmentStrategies.isEmpty()) {
                    // Search the assessment strategy in the array list
                    // containing the db info
                    strategyLocation = systemAssessmentStrategies.indexOf(assessmentStrategies.get(0));
                    
                    //If exists insert the assessment strategy
                    // using addAssessmentStrategy
                    if(strategyLocation!=-1) {
                        // Strategy exists in the system
                        // Define the assessment strategy id number
                        assessmentStrategyId = strategyLocation + 1;
                        if(!addAssessmentStrategy(entryId, String.valueOf(assessmentStrategyId))) {
                            System.out.println("Addition of the assessment strategy fail...");
                            return false;
                        }
                    } else {
                        // Add the missing assessment strategy to the
                        // db using addTypeOfAssessment
                        if(!addTypeOfAssessment(assessmentStrategies.get(0))) {
                            System.out.println("Addition of the assessment strategy category fail...");
                            return false;
                        }

                        // Add the new strategy to the array list to avoid
                        // searching the db again
                        systemAssessmentStrategies.add(assessmentStrategies.get(0));
                        // Now add the assessment strategy to the course
                        // using addAssessmentStrategy
                        if(!addAssessmentStrategy(entryId, String.valueOf(systemAssessmentStrategies.size()))) {
                            System.out.println("Addition of the assessment strategy fail...");
                            return false;
                        }
                    }
                    // Remove the top assessment strategy after is inserted
                    // into the system
                    assessmentStrategies.remove(0);
                }
                // All inserts were successful
                return true;
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
        // Something has fail
        return false;
    }

    /**
        <h1>getAmountSyllabuses support method</h1>
            Allow us to determine the amount of syllabuses in the database
            @return Integer value indicating the amount of syllabuses
                    in the database
    */
    private int getAmountSyllabuses() {
        // Declare function variables
        String field, table;
        int amount = 0;

        // Define the field that is going to be retrieve from the database
        field = "id_entrada";

        // Define the table where the selection is performed
        table = "syllabuses";

        // Execute the selection on the database
        ResultSet res = myDBConn.doSelect(field, table);

        // Iterate over the ResultSet containing all syllabuses
        //in the database, and count how many tuples were retrieved
        try {
            while(res.next())
                amount++;
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close the result set
            try {
                if(res!=null)
                    res.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Return the amount of syllabuses in the database
            return amount;
        }
    }

    /**
        <h1>addAdminSyllabus method</h1>
            This method add the syllabus information created by an admin
            to the system
            @param username - username of the syllabus' author
            @param syllabus - object containing the information of the syllabus
            @return integer value indicating the following
                0: Insert of the information succeed
                1: Insert fail into syllabuses table
                2: The prerequisites insert fail
                3: The co-requisites insert fail
                4: Objectives with their alignment insert fail
                5: Thematic content insert fail
                6: Textbooks insert fail
                7: Bibliographies insert fail
                8: Online resources insert fail
                9: Rules insert fail
                10: Teaching strategies insert fail
                11: Assessment strategies insert fail
    */
    public int addAdminSyllabus(String username, SyllabusInfo syllabus) {
        // Declaring function variables
        String table, values;

        // Determining the new syllabus entry id
        int entryId = getAmountSyllabuses() + 1;

        // Define the table where the first insertion will be performed
        table = "syllabuses";

        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();

        values = entryId + ", '" + syllabus.getCode() + "', '" + username + "', CURRENT_TIMESTAMP, ";
        values += "'" + syllabus.getDuration() + "', '" + syllabus.getCredits() + "', '";
        values += syllabus.getDescription() + "', '" +  syllabus.getJustification() + "', '2', '1'";

        // Try to perform the insertion in the syllabuses table
        if(myDBConn.doInsert(table, values)) {
            // Extract the prerequisites of the syllabus
            ArrayList<String> prerequisites = syllabus.getPrerequisites();
            // Check if the course have prerequisites, if so, insert them in the DB
            if(!prerequisites.isEmpty()) {
                // Call the support method that will insert the prerequisites
                if(!addPrerequisite(String.valueOf(entryId), prerequisites)) {
                    System.out.println("The prerequisites insert fail...");
                    myDBConn.doRollback();
                    myDBConn.enableAutoCommit();
                    return 2;
                }
            }

            // Extract the co-requisites of the syllabus
            ArrayList<String> corequisites = syllabus.getCorequisites();
            // Check if the course have co-requisites, if so, insert them in the DB
            if(!corequisites.isEmpty()) {
                // Call the support method that will insert the co-requisites
                if(!addCorequisite(String.valueOf(entryId), corequisites)) {
                    System.out.println("The co-requisites insert fail...");
                    myDBConn.doRollback();
                    myDBConn.enableAutoCommit();
                    return 3;
                } 
            }

            // Insert the objectives with their alignment
            if(!addObjectives(String.valueOf(entryId), syllabus.getObjectives())) {
                System.out.println("Objectives with their alignment insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 4;
            }

            // Insert the thematic content
            if(!addThematicContent(String.valueOf(entryId), syllabus.getThematicContent())) {
                System.out.println("Thematic content insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 5;
            }
            
            // Insert the textbook(s)
            if(!addTextbook(String.valueOf(entryId), syllabus.getTextbooks())) {
                System.out.println("Textbooks insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 6;
            }

            // Insert the bibliographies
            if(!addBibliography(String.valueOf(entryId), syllabus.getBibliography())) {
                System.out.println("Bibliographies insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 7;
            }

            // Insert the online resources
            if(!addOnlineResource(String.valueOf(entryId), syllabus.getOnlineResources())) {
                System.out.println("Online resources insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 8;
            }

            // Insert the rules
            if(!addRuleToCourse(String.valueOf(entryId), syllabus.getRules())) {
                System.out.println("Rules insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 9;
            }

            // Insert teaching strategies
            if(!addTeachingStrategies(String.valueOf(entryId), syllabus.getTeachingStrategies())) {
                System.out.println("Teaching strategies insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 10;
            }
            
            // Insert assessment strategies
            if(!addAssessmentStrategies(String.valueOf(entryId), syllabus.getAssessmentStrategies())) {
                System.out.println("Assessment strategies insert fail...");
                myDBConn.doRollback();
                myDBConn.enableAutoCommit();
                return 11;
            }
            // Since all inserts were made successfully, perform a commit
            // to save the changes
            myDBConn.doCommit();
            // Enable the auto-commit since the transaction has finished
            myDBConn.enableAutoCommit();
            // All the inserts were successful
            return 0;
        }
        // Fail
        System.out.println("Insert fail into syllabuses table...");
        myDBConn.doRollback();
        myDBConn.enableAutoCommit();
        return 1;
    }

    /**
        <h1>searchProgramCourses method</h1>
            List all the courses that belong to a specific program
            and that have an active syllabus.
            @param programId - id of the program that the courses will
                               be searched.
            @return
                A ResultSet containing all the courses (id, title)
                that satisfy the requirements.
    */
    public ResultSet searchProgramCourses(String programId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "programa_curso, cursos";

        // Define the fields list to retrieve from the table 
        fields = "DISTINCT cursos.codigo_curso, titulo_curso";

        // Define the where condition 
        where = "id_programa='" + programId + "' AND programa_curso.codigo_curso=cursos.codigo_curso ";
        where += "AND cursos.codigo_curso IN (SELECT codigo_curso FROM syllabuses WHERE status='2')";

        System.out.println("Listing all the courses (id, title) that belongs to program identified by " + programId + " \nand have an active syllabus...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>searchCourse method</h1>
            List all the courses that meet the search parameter and
            have an active syllabus.
            
            NOTE: Method to be used in the search bar in the welcome menu
            @param search - Search that is done by the user
            @return
                A ResultSet containing all courses (id, title)
                that meet requirements
    */
    public ResultSet searchCourse(String search) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "programa_curso, cursos";

        // Define the fields list to retrieve from the table 
        fields = "DISTINCT cursos.codigo_curso, titulo_curso";

        // Define the where condition 
        where = "programa_curso.codigo_curso=cursos.codigo_curso AND cursos.codigo_curso IN ";
        where += "(SELECT codigo_curso FROM syllabuses WHERE status='2') AND ";
        where += "(cursos.codigo_curso LIKE '%" + search + "%' OR cursos.titulo_curso LIKE '%" + search + "%')";

        System.out.println("Searching course...");
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>listCourseObjectives method</h1>
            Support method that list all the objectives and their alignment
            related to an entry id specified in the argument
            @param entryId - id of the entry that the objectives
                             with their alignment will be sought 
            @return
                An ArrayList of type ObjectiveClass containing all
                objectives and their alignment related to an entry
                id specified in the argument
    */
    private ArrayList<ObjectiveClass> listCourseObjectives(String entryId) {
        // Declare function variables
        String fields1, table1, where1, fields2, table2, where2;
        // Declare return ArrayList
        ArrayList<ObjectiveClass> objectives = new ArrayList<>();
        // Declare an ArrayList to hold the temporary Alignments
        ArrayList<AgencyInfo> objectiveAlignment;
        // Define the table where the selection is performed
        table1 = "objetivos";
        // Define the fields list to retrieve from the table 
        fields1 = "id_objetivo, objetivos.desc";
        // Define the where condition 
        where1 = "id_entrada=" + entryId;

        ResultSet obj = null;
        // Define a second result set for the objective alignment
        ResultSet alignment = null;
        // Define a second connection, so we not lose the information
        // of the other search
        MySQLConnector myDBConn2 = null;

        try {
            // Establish the second connection
            myDBConn2 = new MySQLConnector();
            myDBConn2.doConnection();

            System.out.println("Process Started: Listing the objectives with their alignment related to the entry id "+ entryId + "...");
            // Search the objectives ids and descriptions
            obj = myDBConn.doSelect(fields1, table1, where1);
            // Define the table where the selection is performed
            table2 = "objetivos_alineados";
            // Define the fields list to retrieve from the table 
            fields2 = "id_agencia, id_objetivo_agencia";
            // iterate over the result set
            while(obj.next()) {
                // Define the where condition 
                where2 = "id_entrada=" + entryId + " AND id_objetivo=" + obj.getString(1);

                // Initialize the ArrayList that will hold the objective alignment
                objectiveAlignment = new ArrayList<>();
                // Search the objective alignment
                alignment = myDBConn2.doSelect(fields2, table2, where2);

                // Iterate over the alignment result set
                while(alignment.next()) {
                    // Insert the alignment information into the ArrayList
                    objectiveAlignment.add(new AgencyInfo(alignment.getString(1), alignment.getString(2)));
                }

                // Insert the objective information with the alignment
                // into the objectives ArrayList
                objectives.add(new ObjectiveClass(obj.getString(1), obj.getString(2), objectiveAlignment));
            }
        } catch(Exception e) {
            e.printStackTrace();
            // Since there has been an exception we should remove all
            // objectives from the list
            objectives.clear();
        } finally {
            // Close result sets
            try {
                if(obj!=null)
                    obj.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if(alignment!=null)
                    alignment.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if(myDBConn2!=null)
                    myDBConn2.closeConnection();
            } catch (Exception e) {
                e.printStackTrace();
            }
            System.out.println("Listing process finish...");
            return objectives;
        }
    }

    /**
        <h1>searchSyllabusInfo method</h1>
            Method that list all the syllabus information based on a
            course code specify in the argument.
            This information is the most recent and approved.
            @param courseCode - code of the course that the syllabus
                                information will be sought 
            @return
                An object of type SyllabusInfo containing all syllabus information
    */
    public SyllabusInfo searchSyllabusInfo(String courseCode) {
        // Define and initialize and empty object to return
        SyllabusInfo syllabus = new SyllabusInfo();

        ResultSet basicCourseInfo = null;
        // Define general result set to hold temporary results, before
        // they are inserted into the SyllabusInfo object
        ResultSet result = null;
        applicationDBAuthentication appDBAuth = null;

        try {
            // Search course basic information, using appropriate method
            basicCourseInfo = searchCourseInfo(courseCode);
            // Verify that there is a result for the search
            if(basicCourseInfo.next()) {
                // Insert the basic information into the object, use setters or special constructor for basic info
                syllabus = new SyllabusInfo(basicCourseInfo.getString(1), basicCourseInfo.getString(2),
                    basicCourseInfo.getString(3), basicCourseInfo.getString(4), basicCourseInfo.getString(5));

                // Search the entryId, using support method
                Integer entryId = searchSyllabusEntryId(courseCode);

                // Verify that we receive a valid entry id
                if(entryId!=0) {
                    // Define general array list to hold list of information
                    ArrayList<String> resultList = new ArrayList<>();

                    // Search prerequisites
                    result = listPrerequisites(String.valueOf(entryId));

                    // Verify if there are prerequisites for the course
                    if(result.next()) {
                        // Reset the pointer
                        result.previous();
                        // While there are prerequisites, add them to the array list
                        while(result.next())
                            resultList.add(result.getString(1));

                        // Insert the information in the syllabus object
                        syllabus.setPrerequisites(resultList);
                        // Clear the array list
                        resultList = new ArrayList<>();
                    }

                    // Search co-requisites
                    result = listCorequisites(String.valueOf(entryId));

                    // Verify if there are co-requisites for the course
                    if(result.next()) {
                        // Reset the pointer
                        result.previous();
                        // While there are co-requisites, add them to the array list
                        while(result.next())
                            resultList.add(result.getString(1));
                        
                        // Insert the information in the syllabus object
                        syllabus.setCorequisites(resultList);
                        // Clear the array list
                        resultList = new ArrayList<>();
                    }

                    // Search syllabus basic information
                    result = syllabusBasicInfo(String.valueOf(entryId));

                    /* For now on, the information will be search in a nested
                       form. Meaning that we only continue if the previous
                       search was a success, else, we delete the information
                       stored */

                    // Verify if there is a result for the basic info search
                    if(result.next()) {
                        // Insert the information into the syllabus object

                        // Possible editor username, later verified
                        // and change to the actual name
                        syllabus.setEditorName(result.getString(1));
                        // Possible edition date
                        syllabus.setEditionDate(result.getString(2));
                        // Duration
                        syllabus.setDuration(result.getString(3));
                        // Credits
                        syllabus.setCredits(result.getString(4));
                        // Description
                        syllabus.setDescription(result.getString(5));
                        // Justification
                        syllabus.setJustification(result.getString(6));

                        // Search the objectives
                        ArrayList<ObjectiveClass> objectives = listCourseObjectives(String.valueOf(entryId));
                        // Verify that there is at least one result
                        // in the ArrayList
                        if(objectives.size()>0) {
                            // Insert the information into the syllabus object
                            syllabus.setObjectives(objectives);

                            // Search the thematic content for the entry id
                            result = listThematicContent(String.valueOf(entryId));

                            // Verify if there are thematic contents
                            // for the course
                            if(result.next()) {
                                // Reset the pointer
                                result.previous();
                                // While there are thematic contents,
                                // add them to the array list
                                while(result.next())
                                    resultList.add(result.getString(1));
                                
                                // Insert the information in the syllabus object
                                syllabus.setThematicContent(resultList);
                                // Clear the array list
                                resultList = new ArrayList<>();

                                // Search the teaching strategies for the entry id
                                result = listTeachingStrategy(String.valueOf(entryId));

                                // Verify if there are teaching strategies for the course
                                if(result.next()) {
                                    // Reset the pointer
                                    result.previous();
                                    // While there are teaching strategies,
                                    // add them to the array list
                                    while(result.next())
                                        resultList.add(result.getString(1));
                                    
                                    // Insert the information in the syllabus object 
                                    syllabus.setTeachingStrategies(resultList);
                                    // Clear the array list
                                    resultList = new ArrayList<>();

                                    // Search the assessment strategies for the entry id
                                    result = listAssessmentStrategies(String.valueOf(entryId));

                                    // Verify if there are assessment strategies for the course
                                    if(result.next()) {
                                        // Reset the pointer
                                        result.previous();
                                        // While there are assessment strategies, add them to the array list
                                        while(result.next())
                                            resultList.add(result.getString(1));
                                        
                                        // Insert the information in the syllabus object
                                        syllabus.setAssessmentStrategies(resultList);
                                        // Clear the array list
                                        resultList = new ArrayList<>();

                                        // Search the textbooks for the entry id
                                        result = listTextbooks(String.valueOf(entryId));

                                        // Verify if there are textbooks for the course
                                        if(result.next()) {
                                            // Reset the pointer
                                            result.previous();
                                            // While there are textbooks, add them to the array list
                                            while(result.next())
                                                resultList.add(result.getString(1));

                                            // Insert the information in the syllabus object
                                            syllabus.setTextbooks(resultList);
                                            // Clear the array list
                                            resultList = new ArrayList<>();

                                            // Search the bibliographies for the entry id
                                            result = listBibliographies(String.valueOf(entryId));

                                            // Verify if there are bibliographies for the course
                                            if(result.next()) {
                                                // Reset the pointer
                                                result.previous();
                                                // While there are bibliographies, add them to the array list
                                                while(result.next())
                                                    resultList.add(result.getString(1));
                                                
                                                // Insert the information in the syllabus object
                                                syllabus.setBibliography(resultList);
                                                // Clear the array list
                                                resultList = new ArrayList<>();

                                                // Search the online resources for the entry id
                                                result = listOnlineResource(String.valueOf(entryId));

                                                // Verify if there are online resources for the course
                                                if(result.next()) {
                                                    // Reset the pointer
                                                    result.previous();
                                                    // While there are online resources, add them to the array list
                                                    while(result.next())
                                                        resultList.add(result.getString(1));
                                                    
                                                    // Insert the information in the syllabus object
                                                    syllabus.setOnlineResources(resultList);
                                                    // Clear the array list
                                                    resultList = new ArrayList<>();

                                                    // Search the rules information for the entry id
                                                    result = listCourseRules(String.valueOf(entryId));

                                                    // Verify if there are rules information for the course
                                                    if(result.next()) {
                                                        //Reset the pointer
                                                        result.previous();
                                                        // Define an array list of type RulesInfo to hold the rules information
                                                        ArrayList<RulesInfo> rules = new ArrayList<>();
                                                        // While there are rules, add them to the array list
                                                        while(result.next())
                                                            rules.add(new RulesInfo(result.getString(1), result.getString(2)));
                                                        
                                                        // Insert the information in the syllabus object
                                                        syllabus.setRulesFullInfo(rules);
                                                        // Clear the array list
                                                        rules = new ArrayList<>();

                                                        // Search the syllabus author
                                                        result = syllabusCreationInfo(courseCode);

                                                        // Verify if there is a result for the creation info
                                                        if(result.next()) {
                                                            // Insert the creation info into the syllabus object
                                                            // Author username
                                                            syllabus.setAuthorName(result.getString(1));
                                                            // Creation date-time
                                                            syllabus.setCreationDate(result.getString(2));

                                                            /* Verify creation and edition dates to determine
                                                               if they are the same this means that an edition
                                                               was not perform */
                                                            if(syllabus.getCreationDate().equals(syllabus.getEditionDate())) {
                                                                // Same date-time
                                                                // Delete the edition information
                                                                syllabus.setEditorName("");
                                                                syllabus.setEditionDate("");
                                                            }

                                                            // Instantiate an appDBAuth object to access the required method
                                                            appDBAuth = new applicationDBAuthentication();

                                                            // Find the complete name of the author
                                                            result = appDBAuth.searchCompleteName(syllabus.getAuthorName());

                                                            // Verify that the author complete name was found
                                                            if(result.next()) {
                                                                // Insert the complete name in the syllabus object
                                                                syllabus.setAuthorName(result.getString(1) + " " + result.getString(2));
                                                                
                                                                // If the syllabus has an editor, search his/her complete name
                                                                if(!syllabus.getEditorName().trim().isEmpty()) {
                                                                    // Find the complete name of the editor
                                                                    result = appDBAuth.searchCompleteName(syllabus.getEditorName());

                                                                    // Verify that the editor complete name was found
                                                                    if(result.next()) {
                                                                        // Insert the complete name in the syllabus object
                                                                        syllabus.setEditorName(result.getString(1) + " " + result.getString(2));
                                                                    } else {
                                                                        System.out.println("Error: Editor's name not found...");
                                                                        // Delete all the information in the syllabus object
                                                                        syllabus = new SyllabusInfo();
                                                                    }
                                                                }
                                                            } else {
                                                                System.out.println("Error: Author's name not found...");
                                                                // Delete all the information in the syllabus object
                                                                syllabus = new SyllabusInfo();
                                                            }
                                                        } else {
                                                            System.out.println("Error: No creation info found for course identified by " + courseCode + "...");
                                                            // Delete all the information in the syllabus object
                                                            syllabus = new SyllabusInfo();
                                                        }
                                                    } else {
                                                        System.out.println("Error: No rules found for entry id " + entryId + "...");
                                                        // Delete all the information in the syllabus object
                                                        syllabus = new SyllabusInfo();
                                                    }
                                                } else {
                                                    System.out.println("Error: No online resources found for entry id " + entryId + "...");
                                                    // Delete all the information in the syllabus object
                                                    syllabus = new SyllabusInfo();
                                                }
                                            } else {
                                                System.out.println("Error: No bibliographies found for entry id " + entryId + "...");
                                                // Delete all the information in the syllabus object
                                                syllabus = new SyllabusInfo();
                                            }
                                        } else {
                                            System.out.println("Error: No textbooks found for entry id " + entryId + "...");
                                            // Delete all the information in the syllabus object
                                            syllabus = new SyllabusInfo();
                                        }
                                    } else {
                                        System.out.println("Error: No assessment strategies found for entry id " + entryId + "...");
                                        // Delete all the information in the syllabus object
                                        syllabus = new SyllabusInfo();
                                    }
                                } else {
                                    System.out.println("Error: No teaching strategies found for entry id " + entryId + "...");
                                    // Delete all the information in the syllabus object
                                    syllabus = new SyllabusInfo();
                                }
                            } else {
                                System.out.println("Error: No thematic content found for entry id " + entryId + "...");
                                // Delete all the information in the syllabus object
                                syllabus = new SyllabusInfo();
                            }
                        } else {
                            System.out.println("Error: Objectives not found for entry id " + entryId + "...");
                            // Delete all the information in the syllabus object
                            syllabus = new SyllabusInfo();
                        }
                    } else {
                        System.out.println("Error: syllabus basic information not found for entry id " + entryId + "...");
                        // Delete all the information in the object
                        syllabus = new SyllabusInfo();
                    }
                } else {
                    System.out.println("Invalid entryId for course identified by " + courseCode + ", there is no syllabus for this course");
                    // Delete all the information in the object
                    syllabus = new SyllabusInfo();
                }
            } else {
                System.out.println("The basic information for the course identified by " + courseCode + " cannot be found...");
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close result sets, and connection
            try {
                if(basicCourseInfo!=null)
                    basicCourseInfo.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if(result!=null)
                    result.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if(appDBAuth!=null)
                    appDBAuth.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Return the syllabus information
            return syllabus;
        }
    }

    /**
        <h1>searchSyllabusEntryId method</h1>
            Support method that search the entry id of a syllabus based
            on a course code specify in the argument
            and that is the most recent and approved syllabus.
            @param courseCode - code of the course that the syllabus entry
                                id will be sought 
            @return
                Integer value indicating the entry id of the syllabus.
    */
    private Integer searchSyllabusEntryId(String courseCode) {
        // Declare function variables
        String fields, table, where, orderBy;
        // Default value, it does not exists in the DB
        Integer entryId = 0;

        // Define the table where the selection is performed
        table = "syllabuses";

        // Define the field list to retrieve from the table 
        fields = "id_entrada";

        // Define the where condition 
        where = "codigo_curso='" + courseCode + "' AND status='2'";

        // Define orderBy clause
        orderBy = "fecha DESC LIMIT 1";

        System.out.println("Searching entryId for course identified by " + courseCode + "...");
        
        ResultSet result = null;

        try {
            // Perform the search in the DB
            result = myDBConn.doSelect(fields, table, where, orderBy);
            // Determine if we have a result, then extract the entryId value
            if(result.next())
                entryId = Integer.parseInt(result.getString(1));
        } catch(Exception e) {
             e.printStackTrace();
        } finally {
            // Close result set
            try {
                if(result!=null)
                    result.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            return entryId;
        }
    }

    /**
        <h1>syllabusBasicInfo method</h1>
            Support method that list the basic information of a syllabus,
            based on the entry id specified in the argument.
            @param entryId - entry id of the course that the basic
                             information will be sought
            @return 
                ResultSet with the basic information (username, date,
                duration, credits, description, justification)    
    */
    private ResultSet syllabusBasicInfo(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "syllabuses";

        // Define the fields list to retrieve from the table 
        fields = "username, fecha, duracion, creditos, descripcion, justificacion";

        // Define the where condition 
        where = "status='2' AND id_entrada=" + entryId;

        System.out.println("Listing the basic information of the syllabus identified by the entryId " + entryId + "...");
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>syllabusCreationInfo method</h1>
            Support method that search the creation information
            (author username, creation date-time) Keep in mind that
            will search the oldest active syllabus of the specified course
            @param courseCode - code of the course that the syllabus
                                creation info will be sought
            @return
                A ResultSet containing the author and creation date-time
    */
    private ResultSet syllabusCreationInfo(String courseCode) {
        // Declare function variables
        String fields, table, where, orderBy;

        // Define the table where the selection is performed
        table = "syllabuses";

        // Define the fields list to retrieve from the table 
        fields = "username, fecha";

        // Define the where condition 
        where = "codigo_curso='" + courseCode + "' AND status='2'";

        // Define orderBy clause
        orderBy = "fecha LIMIT 1";

        System.out.println("Searching creation information for course identified by " + courseCode + "...");
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where, orderBy);
    }

    /**
        <h1>searchSyllabusInfoEdition method</h1>
            Method that list all the syllabus information based on a
            course code specify in the argument.
            This information is the most recent and approved.
            @param courseCode - code of the course that the syllabus
                                information will be sought 
            @return
                An object of type SyllabusInfo containing all syllabus information
        
        NOTE: This method compare to searchSyllabusInfo, does not search
        creation and edition information. 
        Also, the rules' search focus on their ids instead of title
        and description.
    */
    public SyllabusInfo searchSyllabusInfoEdition(String courseCode) {
        // Define and initialize and empty object to return
        SyllabusInfo syllabus = new SyllabusInfo();

        ResultSet basicCourseInfo = null;
        // Define general result set to hold temporary results,
        // before they are inserted into the SyllabusInfo object
        ResultSet result = null;

        try {
            // Search course basic information, using appropriate method
            basicCourseInfo = searchCourseInfo(courseCode);
            // Verify that there is a result for the search
            if(basicCourseInfo.next()) {
                // Insert the basic information into the object,
                // use setters or special constructor for basic info
                syllabus = new SyllabusInfo(basicCourseInfo.getString(1), basicCourseInfo.getString(2),
                    basicCourseInfo.getString(3), basicCourseInfo.getString(4), basicCourseInfo.getString(5));

                // Search the entryId, using support method
                Integer entryId = searchSyllabusEntryId(courseCode);

                // Verify that we receive a valid entry id
                if(entryId!=0) {
                    // Define general array list to hold list of information
                    ArrayList<String> resultList = new ArrayList<>();

                    // Search prerequisites
                    result = listPrerequisites(String.valueOf(entryId));

                    // Verify if there are prerequisites for the course
                    if(result.next()) {
                        // Reset the pointer
                        result.previous();
                        // While there are prerequisites, add them to the array list
                        while(result.next())
                            resultList.add(result.getString(1));
                        
                        // Insert the information in the syllabus object
                        syllabus.setPrerequisites(resultList);
                        // Clear the array list
                        resultList = new ArrayList<>();
                    }

                    // Search co-requisites
                    result = listCorequisites(String.valueOf(entryId));

                    // Verify if there are co-requisites for the course
                    if(result.next()) {
                        // Reset the pointer
                        result.previous();
                        // While there are co-requisites, add them to the array list
                        while(result.next())
                            resultList.add(result.getString(1));
                        
                        // Insert the information in the syllabus object
                        syllabus.setCorequisites(resultList);
                        // Clear the array list
                        resultList = new ArrayList<>();
                    }

                    // Search syllabus basic information
                    result = syllabusBasicInfo(String.valueOf(entryId));

                    /* For now on, the information will be search in a
                       nested form. Meaning that we only continue if the
                       previous search was a success, else, we delete the
                       information stored */

                    // Verify if there is a result for the basic info search
                    if(result.next()) {
                        // Insert the information into the syllabus object
                        // Duration
                        syllabus.setDuration(result.getString(3));
                        // Credits
                        syllabus.setCredits(result.getString(4));
                        // Description
                        syllabus.setDescription(result.getString(5));
                        // Justification
                        syllabus.setJustification(result.getString(6));

                        // Search the objectives
                        ArrayList<ObjectiveClass> objectives = listCourseObjectives(String.valueOf(entryId));
                        // Verify that there is at least one result in the ArrayList
                        if(objectives.size()>0) {
                            // Insert the information into the syllabus object
                            syllabus.setObjectives(objectives);

                            // Search the thematic content for the entry id
                            result = listThematicContent(String.valueOf(entryId));

                            // Verify if there are thematic contents for the course
                            if(result.next()) {
                                // Reset the pointer
                                result.previous();
                                // While there are thematic content, add them to the array list
                                while(result.next())
                                    resultList.add(result.getString(1));
                                
                                // Insert the information in the syllabus object
                                syllabus.setThematicContent(resultList);
                                // Clear the array list
                                resultList = new ArrayList<>();

                                // Search the teaching strategies for the entry id
                                result = listTeachingStrategy(String.valueOf(entryId));

                                // Verify if there are teaching strategies for the course
                                if(result.next()) {
                                    // Reset the pointer
                                    result.previous();
                                    // While there are teaching strategies, add them to the array list
                                    while(result.next())
                                        resultList.add(result.getString(1));
                                    
                                    // Insert the information in the syllabus object 
                                    syllabus.setTeachingStrategies(resultList);
                                    // Clear the array list
                                    resultList = new ArrayList<>();

                                    // Search the assessment strategies for the entry id
                                    result = listAssessmentStrategies(String.valueOf(entryId));

                                    // Verify if there are assessment strategies for the course
                                    if(result.next()) {
                                        // Reset the pointer
                                        result.previous();
                                        // While there are assessment strategies, add them to the array list
                                        while(result.next())
                                            resultList.add(result.getString(1));
                                        
                                        // Insert the information in the syllabus object
                                        syllabus.setAssessmentStrategies(resultList);
                                        // Clear the array list
                                        resultList = new ArrayList<>();

                                        // Search the textbooks for the entry id
                                        result = listTextbooks(String.valueOf(entryId));

                                        // Verify if there are textbooks for the course
                                        if(result.next()) {
                                            // Reset the pointer
                                            result.previous();
                                            // While there are textbooks, add them to the array list
                                            while(result.next())
                                                resultList.add(result.getString(1));
                                            
                                            // Insert the information in the syllabus object
                                            syllabus.setTextbooks(resultList);
                                            // Clear the array list
                                            resultList = new ArrayList<>();

                                            // Search the bibliographies for the entry id
                                            result = listBibliographies(String.valueOf(entryId));

                                            // Verify if there are bibliographies for the course
                                            if(result.next()) {
                                                // Reset the pointer
                                                result.previous();
                                                // While there are bibliographies, add them to the array list
                                                while(result.next())
                                                    resultList.add(result.getString(1));
                                                
                                                // Insert the information in the syllabus object
                                                syllabus.setBibliography(resultList);
                                                // Clear the array list
                                                resultList = new ArrayList<>();

                                                // Search the online resources for the entry id
                                                result = listOnlineResource(String.valueOf(entryId));

                                                // Verify if there are online resources for the course
                                                if(result.next()) {
                                                    // Reset the pointer
                                                    result.previous();
                                                    // While there are online resources, add them to the array list
                                                    while(result.next())
                                                        resultList.add(result.getString(1));
                                                    
                                                    // Insert the information in the syllabus object
                                                    syllabus.setOnlineResources(resultList);
                                                    // Clear the array list
                                                    resultList = new ArrayList<>();

                                                    // Search the rules' ids for the entry id
                                                    result = listCourseRulesIds(String.valueOf(entryId));

                                                    // Verify if there are rules' ids for the course
                                                    if(result.next()) {
                                                        // Reset the pointer
                                                        result.previous();
                                                        // Define an array list of type String to hold the
                                                        // rules' ids information
                                                        ArrayList<String> rules = new ArrayList<>();
                                                        // While there are rules' ids, add them to the array list
                                                        while(result.next())
                                                            rules.add(result.getString(1));
                                                        
                                                        // Insert the information in the syllabus object
                                                        syllabus.setRules(rules);
                                                        // Clear the array list
                                                        rules = new ArrayList<>(); 
                                                    } else {
                                                        System.out.println("Error: No rules found for entry id " + entryId + "...");
                                                        // Delete all the information in the syllabus object
                                                        syllabus = new SyllabusInfo();
                                                    }
                                                } else {
                                                    System.out.println("Error: No online resources found for entry id " + entryId + "...");
                                                    // Delete all the information in the syllabus object
                                                    syllabus = new SyllabusInfo();
                                                }
                                            } else {
                                                System.out.println("Error: No bibliographies found for entry id " + entryId + "...");
                                                // Delete all the information in the syllabus object
                                                syllabus = new SyllabusInfo();
                                            }
                                        } else {
                                            System.out.println("Error: No textbooks found for entry id " + entryId + "...");
                                            // Delete all the information in the syllabus object
                                            syllabus = new SyllabusInfo();
                                        }
                                    } else {
                                        System.out.println("Error: No assessment strategies found for entry id " + entryId + "...");
                                        // Delete all the information in the syllabus object
                                        syllabus = new SyllabusInfo();
                                    }
                                } else {
                                    System.out.println("Error: No teaching strategies found for entry id " + entryId + "...");
                                    // Delete all the information in the syllabus object
                                    syllabus = new SyllabusInfo();
                                }
                            } else {
                                System.out.println("Error: No thematic content found for entry id " + entryId + "...");
                                // Delete all the information in the syllabus object
                                syllabus = new SyllabusInfo();
                            }
                        } else {
                            System.out.println("Error: Objectives not found for entry id " + entryId + "...");
                            // Delete all the information in the syllabus object
                            syllabus = new SyllabusInfo();
                        }
                    } else {
                        System.out.println("Error: syllabus basic information not found for entry id " + entryId + "...");
                        // Delete all the information in the object
                        syllabus = new SyllabusInfo();
                    }
                } else {
                    System.out.println("Invalid entryId for course identified by " + courseCode + ", there is no syllabus for this course");
                    // Delete all the information in the object
                    syllabus = new SyllabusInfo();
                }
            } else {
                // Error
                System.out.println("The basic information for the course identified by " + courseCode + " cannot be found...");
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Close result sets
            try {
                if(basicCourseInfo!=null)
                    basicCourseInfo.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if(result!=null)
                    result.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Return the syllabus information
            return syllabus;
        }
    }

    /**
        <h1>listCourseRulesIds method</h1>
            List all the rules' ids related to an entry id specified
            in the argument
            @param entryId - id of the entry that the rules' ids
                             will be sought 
            @return
                A ResultSet containing all course rules ids of an
                entry id specified in the argument
    */
    private ResultSet listCourseRulesIds(String entryId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "reglas_aplicadas";

        // Define the field list to retrieve from the table 
        fields = "id_regla";

        // Define the where condition 
        where = "id_entrada=" + entryId;

        System.out.println("Listing the rules' ids related to the entry id "+ entryId + "...");
                
        // Return the result of the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
		<h1>close method</h1>
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
			@param args[]: String array 
	*/
	public static void main(String[] args) {
		ResultSet res = null;
        applicationDBManager appDBMnger = null;
		try {
			// Create a applicationDBManager object
			appDBMnger = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMnger.toString());
            String search = "Test";   

            // Search the course in the DB
            res = appDBMnger.searchCourse(search);

            // Extract the information
            while(res.next()) {
                System.out.println("Course Code: " + res.getString(1));
                System.out.println("Course Title: " + res.getString(2));
            }
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
            // Close the database connection
            try {
                if(res!=null)
                    res.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            try {
                if(appDBMnger!=null)
                    appDBMnger.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
	}
}