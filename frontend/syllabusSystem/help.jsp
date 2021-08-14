<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

<%
	// Perform the authentication process
	if((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)) {
		// Deleting session variables
		session.invalidate();
		// Return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username
		// and the previous page from the session variables
		String currentPage = "help.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database using the applicationDBAuthentication class
		try {
			// Create the appDBAuth object
			applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
				
			// Verify if the user has access to this page
			if(appDBAuth.verifyUserPageAccess(userName, currentPage)) {
				// The user have access to the current page
				
				ResultSet res = appDBAuth.verifyUserPageFlow(userName, currentPage, previousPage);
				// Verify that the user is following the page flow
				if(res.next()) {
					// The user was authenticated
					// Get the user role
					String userRole = res.getString(1);	
					// Create the current page attribute
					session.setAttribute("currentPage", "help.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					%>
					<!doctype html>
					<html lang="es">
					    <head>
					        <!--Indicates the encoding of the characters-->
					        <meta charset="utf-8">
					        <!--Authors of the web page-->
					        <meta name="author" content="a-carrasquillo, arivesan">
					        <!--Importing the CSS style-sheet-->
					        <link rel = "stylesheet" type="text/css" href="css/help.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Webpage title-->
					        <title>Ayuda</title>
					        <!--CSS required for the background picture-->
					        <style type="text/css">
					            body {
					              background-image: url(images_icons/esc_educacion2.JPG);
					              -webkit-background-size:cover;
					              background-size:cover;
					              background-position: center center;
					              height: 100vh;
					              background-repeat: no-repeat;
					              background-attachment: fixed;  
					            }
					        </style>
					    </head>
					    <body>
					        <img class ="logo" src="images_icons/uni-logo.png" alt="Logo Ana G. Mendez">
					<%
					// Beginning of menu
					%>
						<div class="custom-padding">
						<nav>
					        <ul class="menu-area">
					            <b>
					                <li><a href="welcomeMenu.jsp">Home</a></li>
					<%
					// Verify the role of the user to load the appropriate menu
					if(appDBAuth.isAdministrator(userRole) || appDBAuth.isSubManager(userRole)) {
						// Load the admin menu
						// Bring the menu from the database based on the username
						res = appDBAuth.menuElements(userName);
						String previousTitle = "";
						// Counter to determine if it is the first iteration
						int counter = 0;
						// Verify that the result set is not empty
						if(!res.isAfterLast()) {
							// Iterate through the result set
							while(res.next()) {
								// Verify that the title (menu category) is different from
								// the previous one
								if(!previousTitle.equals(res.getString(2)) && (counter==0)) {
									%>
									<li>
					                    <div class="dropdown">
					    	                <button class="dropbtn"><%=res.getString(2)%>
											<i class="fa fa-caret-down"></i>
	                           				</button>
	                        			<div class="dropdown-content">
									<%
								} else if(!previousTitle.equals(res.getString(2)) && (counter!=0)) {
									%>
											</div>
					                    </div>
					                </li>
					                <li>
					                    <div class="dropdown">
					                        <button class="dropbtn"><%=res.getString(2)%>
											<i class="fa fa-caret-down"></i>
	                            			</button>
	                            			<div class="dropdown-content">
									<%
								}
								%>
								<a href="<%=res.getString(1)%>"><%=res.getString(3)%></a>						
								<%
								// Update the previous title variable for the next iteration
								previousTitle = res.getString(2);
								counter++;
							}
							%>
									</div>
					            </div>
					        </li>
							<%
						} else {
							System.out.println("The user does not have a menu option...");
							// Deleting session variables
							session.invalidate();
							// Return to the login page
							response.sendRedirect("login.jsp");
						}
					} else if(appDBAuth.isProfessor(userRole)) {
						// Load professor display
						// These options are still to be implemented, the last one
						// need to be adapted from the admins version
						/*%>
						<li><a href="pendingRequestStatus.jsp">Estado de solicitudes</a></li>
	                    <li><a href="holdList.jsp">Lista de prontuarios retenidos</a></li>
	                    <li><a href="searchNewCourse.jsp">Lista de Cursos sin prontuarios</a></li>
						<%*/
					} else if(appDBAuth.isEmployee(userRole)) {
						// Let in blank on purpose to avoid false error detection
					} else {
						// Error in the role value
						System.out.println("The role value is not recognize");
						// Deleting session variables
						session.invalidate();
						// Return to the login page
						response.sendRedirect("login.jsp");
					}
					%>
									<li><a href="#" id="activo">Ayuda</a></li>
			                    <li><a href="signout.jsp">Logout</a></li>
			                </b>
			            </ul>
			          </nav>
			        </div>
			        <%// End of menu loading%>
			        <div class = "blankpage">
			        	<%
			        	// Structure to determine which will be the help displayed
			        	if(previousPage.equals("addCourseToProgram.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la p&aacute;gina para a&ntilde;adir cursos a programas:</h1>
			        		<img id="addCourseToProgram" src="images_icons/addCourseToProgramHelpPic.jpg" alt="Foto de ayuda para describir las operaciones a realizar en la p&aacute;gina.">
				            <p>Lo primero a realizar para a&ntilde;adir cursos a los programas es seleccionar en grado o nivel acad&eacute;mico en el cual se encuentra el programa deseado. Si el programa no se encuentra en la lista mostrada en la imagen como la lista numero dos (2), recuerde que debe ir a la p&aacute;gina enfocada en la adici&oacute;n de programas de cursos bajo la categor&iacute;a de A&ntilde;adir del men&uacute; que se encuentra en la parte superior.</p>
				            <p>Una vez seleccione el programa deseado de la lista numero dos (2), seleccionar&aacute; de la lista n&uacute;mero tres (3) el curso que desea a&ntilde;adir. Se puede a&ntilde;adir un curso a la vez. Para a&ntilde;adir el curso al programa deber&aacute; presionar el bot&oacute;n A&ntilde;adir mostrado sobre el &aacute;rea enumerada como cuatro (4). Por el contrario, si desea remover el curso de la lista debe presionar el bot&oacute;n Remover.</p>
				            <p>Por &uacute;ltimo, todos los cursos a&ntilde;adidos se podr&aacute;n ver en forma de lista en el &aacute;rea enumerada como cinco (5). Cabe recalcar que la lista no muestra los cursos que ya posee el programa, por lo cual se puede generar un error en caso de que se intente a&ntilde;adir un curso que ya posee el programa.</p>
			        		<%
			        	} else if(previousPage.equals("addNewCourse.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la p&aacute;gina para a&ntilde;adir un curso:</h1>
			        		<p>En el nombre del curso se pueden usar letras, n&uacute;meros, caracteres especiales y espacios.</p>
				            <p>El error m&aacute;s com&uacute;n se debe a que el c&oacute;digo del curso ya se encuentra en uso, por lo cual debe seleccionar otro. Si se supone que el c&oacute;digo no este en uso, favor de comunicarse con la persona designada. Un ejemplo de c&oacute;digo de curso es EDUC-106.</p>
				            <p>Por &uacute;ltimo, recuerde seleccionar el tipo de curso y modalidad, ya que sin los mismos el curso no puede ser a&ntilde;adido. Si el tipo de curso y/o modalidad deseada no se encuentra disponible, comun&iacute;quese con la persona designada para que se hagan los arreglos pertinentes en el sistema.</p>
			        		<%
			        	} else if(previousPage.equals("addProgram.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la p&aacute;gina para a&ntilde;adir programa:</h1>
			        		<p>De ocurrir un error, lo m&aacute;s probable es que el c&oacute;digo utilizado para el programa ya le pertenece a otro programa existente. Recuerde que los c&oacute;digos de programas son de cuatro (4) d&iacute;gitos, por ejemplo, 1234. Es importante recalcar que no debe haber espacio entre los d&iacute;gitos ni alg&uacute;n otro car&aacute;cter que no sean n&uacute;meros.</p>
				            <p>Si el grado acad&eacute;mico que desea utilizar no se encuentra disponible, comun&iacute;quese con la persona que se encuentra dirigiendo el sistema para que se comunique con las personas adecuadas para a&ntilde;adir el mismo y hacer los cambios pertinentes en el sistema.</p>
				            <p>Por &uacute;ltimo, no debe haber ning&uacute;n problema con el nombre del programa, el mismo acepta letras, n&uacute;meros y otros caracteres.</p>
			        		<%
			        	} else if(previousPage.equals("createSyllabus.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la creaci&oacute;n de prontuarios:</h1>
			        		<p>En la foto mostrada a continuaci&oacute;n se puede ver cinco (5) datos sobre el prontuario. Dichos datos no pueden ser alterados, de haber la necesidad de cambiarlos debe comunicarse con la persona que tenga acceso a la base de datos del sistema para que dicha persona pueda realizar los cambios correspondientes.</p>
				            <img id="createSyllabus1" src="images_icons/createSyllabusHelp1.JPG" alt="Foto de ejemplo sobre los primeros cinco datos del prontuario.">
				            
				            <p>Segundo, relacionado con los prerrequisitos, y correquisitos, de haber m&aacute;s de uno (1) se deben separar por comas (,) y si no tiene ning&uacute;n prerrequisito o correquisito el encasillado debe dejarse en blanco. A continuaci&oacute;n, se muestra un ejemplo con dos prerrequisitos y un correquisito. Cabe destacar que si uno o m&aacute;s de dichos c&oacute;digos no se encuentran en la base de datos se generar&aacute; un error que ser&aacute; notificado por el sistema y se le dar&aacute; la oportunidad de arreglar el o los c&oacute;digos de curso.</p>
				            <img id="createSyllabus2" src="images_icons/createSyllabusHelp2.JPG" alt="Foto de ejemplo sobre los prerrequisitos y correquisitos.">
				            
				            <p>La duraci&oacute;n del curso puede escribirse de la forma deseada, dicho encasillado acepta n&uacute;meros, letras y caracteres especiales. Para el dato relacionado con los cr&eacute;ditos del curso es el mismo caso expuesto anteriormente. Por otro lado, cabe destacar que la descripci&oacute;n del curso y la justificaci&oacute;n acepta uno o varios p&aacute;rrafos.</p>
				            
				            <p>Con respecto a los objetivos, primero, como se indica en la foto, se debe marcar las agencias que aplican. Por el momento, el sistema solo cuenta con la agencia denominada CAEP. El segundo paso es llenar la informaci&oacute;n relacionada con el primer objetivo. Una vez se llena la informaci&oacute;n del objetivo, se procede a alinear el objetivo con los est&aacute;ndares seleccionados, por el momento, CAEP. En la regi&oacute;n enumerada como tres (3) se selecciona el est&aacute;ndar a a&ntilde;adir, se van seleccionando uno a la vez. Para a&ntilde;adirlo se debe presionar el bot&oacute;n de "A&ntilde;adir", el cual como se muestra en la foto se encuentra en la regi&oacute;n identificada como cuatro (4). En dicha regi&oacute;n tambi&eacute;n se encuentra el bot&oacute;n "Remover" el cual, como su nombre indica, se utiliza para remover el est&aacute;ndar seleccionado en la caja tres (3) del encasillado enumerado como cinco (5). El proceso para a&ntilde;adir los est&aacute;ndares al encasillado cinco (5) se puede repetir hasta culminar de a&ntilde;adir todos los est&aacute;ndares necesarios.</p>
				            <p>Por otro lado, para los objetivos dos (2) en adelante, primero se deben a&ntilde;adir todos los encasillados necesarios utilizando el bot&oacute;n de "A&ntilde;adir Objetivo", mostrado en la regi&oacute;n enumerada como seis (6). Esto se debe a que el contenido de los encasillados se borrar&aacute; al a&ntilde;adir m&aacute;s objetivos. Por ejemplo, si el prontuario va a contener cinco (5) objetivos, una vez se introduzca la informaci&oacute;n del primer objetivo, se debe presionar el bot&oacute;n de "A&ntilde;adir Objetivo" cuatro (4) veces para que as&iacute; aparezcan los encasillados de los objetivos dos (2) al cinco (5). Si se pasa de cantidad de objetivos, puede presionar el bot&oacute;n de "Remover Objetivo" y el mismo le permitir&aacute; remover los &uacute;ltimos encasillados dedicados al ultimo objetivo. Por &uacute;ltimo, para los objetivos del dos (2) en adelante se repiten los pasos indicados para el primer objetivo para llenar su informaci&oacute;n correspondiente.</p>
				            <img id="createSyllabus3" src="images_icons/createSyllabusHelp3.JPG" alt="Foto de ejemplo sobre los objetivos y su alineaci&oacute;n">
				            
				            <p>Antes de llenar la informaci&oacute;n relacionada con el contenido tem&aacute;tico se debe presionar el bot&oacute;n de "A&ntilde;adir Contenido tem&aacute;tico", como se muestra en la foto a continuaci&oacute;n. Esto se debe a que, si se llena la informaci&oacute;n del segundo contenido tem&aacute;tico y luego se presiona el bot&oacute;n de a&ntilde;adir para agregar el tercer contenido tem&aacute;tico, la informaci&oacute;n del segundo contenido tem&aacute;tico se perder&aacute;. Por esta raz&oacute;n se debe a&ntilde;adir todos los encasillados requeridos antes de empezar a llenar la informaci&oacute;n. Si se diera el caso de que a&ntilde;adi&oacute; encasillados de m&oacute;s, puede presionar el bot&oacute;n de "Remover Contenido tem&aacute;tico", el cual va a remover el &uacute;ltimo encasillado.</p>
				            <img id="createSyllabus4" src="images_icons/createSyllabusHelp4.JPG" alt="Foto de ejemplo sobre el Contenido tem&aacute;tico.">
				            
				            <p>Para la informaci&oacute;n de las estrategias de ense&ntilde;anza, con respecto a la adici&oacute;n de encasillados, es el mismo caso presentado previamente. Por su parte, difiere en que se pueden mostrar opciones a escoger al presionar el tri&aacute;ngulo que se muestra en la foto a continuaci&oacute;n. Se mostrar&aacute;n opciones si la base de datos contiene informaci&oacute;n al respecto. Cuando se escribe una opci&oacute;n que no esta siendo mostrada, dicha opci&oacute;n o informaci&oacute;n ser&aacute; a&ntilde;adida a la base de datos para uso futuro.</p>
				            <img id="createSyllabus5" src="images_icons/createSyllabusHelp5.JPG" alt="Foto de ejemplo sobre las estrategias de ense&ntilde;anza.">
				            
				            <p>Las estrategias de assessment se trabajan del mismo modo que las estrategias de ense&ntilde;anza y las opciones a escoger se comportan del mismo modo.</p>
				            <img id="createSyllabus6" src="images_icons/createSyllabusHelp6.JPG" alt="Foto de ejemplo sobre las estrategias de assessment.">
				            
				            <p>Por &uacute;ltimo, la informaci&oacute;n relacionada al libro de texto, la bibliograf&iacute;a, y los recursos en l&iacute;nea se trabaja de la misma manera que el contenido tem&aacute;tico. Con respecto a las reglas, se pueden marcar todas las reglas que apliquen al curso, pero al menos se debe seleccionar una.</p>
				            <img id="createSyllabus7" src="images_icons/createSyllabusHelp7.JPG" alt="Foto de ejemplo sobre el/los libros de texto, la/las bibliograf&iacute;as, el/los recursos en l&iacute;nea, y las reglas del curso.">
			        		<%
			        	} else if(previousPage.equals("editSyllabus.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la edici&oacute;n de prontuarios:</h1>
			        		<p>Al igual que con la creaci&oacute;n de prontuarios, en la edici&oacute;n no se pueden alterar los datos relacionados con el c&oacute;digo, el t&iacute;tulo, el tipo, la modalidad y el nivel del curso. Si se desea cambiar uno de estos aspectos se deben comunicar con la persona encargada de manejar la base de datos.</p>
				            <img id="editSyllabus1" src="images_icons/editSyllabusHelp1.JPG">
				            
				            <p>En el caso de no tener prerrequisitos y/o correquisitos se mostrar&aacute; "N/A" en el/los encasillados correspondientes. A diferencia de la creaci&oacute;n de prontuarios que no permite que el encasillado contenga valores si no aplica, en este caso el "N/A", en la edici&oacute;n se puede dejar el valor y no afecta el procesamiento de informaci&oacute;n. Del mismo modo, los encasillados se pueden dejar en blanco sino aplican. Por &uacute;ltimo, al igual que en la creaci&oacute;n de prontuarios, los c&oacute;digos de curso se separan por comas (,).</p>
				            <img id="editSyllabus2" src="images_icons/editSyllabusHelp2.JPG">
				            
				            <p>Con respecto a la duraci&oacute;n, la cantidad de cr&eacute;ditos, la descripci&oacute;n del curso, y la justificaci&oacute;n, solo basta con seleccionar su contenido y modificarlo seg&uacute;n corresponda. Recuerde que en la descripci&oacute;n y la justificaci&oacute;n del curso el contenido se puede separar en p&aacute;rrafos de ser necesario.</p>
				            <img id="editSyllabus3" src="images_icons/editSyllabusHelp3.JPG">
				            
				            <p>A continuaci&oacute;n, se explicar&aacute; los distintos aspectos que se pueden modificar de los objetivos del curso. Primero, se pueden a&ntilde;adir objetivos presionando el bot&oacute;n de "A&ntilde;adir Objetivo", y al igual que en la creaci&oacute;n de prontuarios, se debe a&ntilde;adir la totalidad de nuevos objetivos antes de comenzar a llenar su descripci&oacute;n y alinearlos con los est&aacute;ndares correspondientes. Similarmente, se pueden eliminar la cantidad de objetivos, recordando que se eliminar&aacute; el objetivo m&aacute;s reciente. Por ejemplo, si se posee diez (10) objetivos y se presiona el bot&oacute;n de "Remover Objetivo", el objetivo removido ser&aacute; el numero diez (10).</p>
				            <p>Segundo, la descripci&oacute;n de los objetivos ya existentes se puede editar. Del mismo modo, en la alineaci&oacute;n de est&aacute;ndares, se puede a&ntilde;adir est&aacute;ndares o eliminar uno o varios de los existentes. Recordando que el est&aacute;ndar a a&ntilde;adir o remover debe de estar seleccionado en la caja que dice "Seleccione un est&aacute;ndar" que corresponda al objetivo que su alineamiento est&aacute; siendo modificado.</p>
				            <img id="editSyllabus4" src="images_icons/editSyllabusHelp4.JPG">
				            
				            <p>En el caso del contenido tem&aacute;tico, la descripci&oacute;n actual puede ser modificada. Adem&aacute;s, se pueden a&ntilde;adir m&aacute;s encasillados para agregar contenido tem&aacute;tico. Cabe destacar, que si se desean a&ntilde;adir m&aacute;s de un encasillado se debe a&ntilde;adir todos los encasillados correspondientes antes de empezar a llenar su descripci&oacute;n porque al agregar encasillados se borra el contenido de los que fueron a&ntilde;adidos a trav&eacute;s del bot&oacute;n para dicho prop&oacute;sito. Por otro lado, para eliminar encasillados, basta con presionar el bot&oacute;n "Remover Contenido tem&aacute;tico", teniendo en cuenta de que se eliminar&aacute; el contenido m&aacute;s reciente. Por ejemplo, si se posee cinco (5) contenidos tem&aacute;ticos y se presiona el bot&oacute;n para remover, el contenido que ser&aacute; removido es el n&uacute;mero cinco (5).</p>
				            <img id="editSyllabus5" src="images_icons/editSyllabusHelp5.JPG">
				            
				            <p>A continuaci&oacute;n, la informaci&oacute;n de las estrategias de ense&ntilde;anza se puede modificar de varias maneras. La primera siendo la cantidad de estrategias de ense&ntilde;anza. Para esto, podemos presionar el bot&oacute;n de "A&ntilde;adir estrategia" para a&ntilde;adir m&aacute;s encasillados. Por el otro lado, podemos presionar el bot&oacute;n de "Remover estrategia" con el cual removemos la estrategia m&aacute;s reciente. Es decir, si tenemos tres (3) estrategias y presionamos remover, la estrategia que ser&aacute; eliminada ser&aacute; el n&uacute;mero tres (3). Segundo, el contenido de las estrategias actuales puede ser modificado. Por ejemplo, en las fotos mostradas a continuaci&oacute;n podemos ver que si eliminamos el contenido de la primera estrategia se pueden ver m&aacute;s opciones que se encuentren en el sistema. Cabe destacar que se pueden escribir opciones que no se encuentren en la lista, el sistema se encargara de a&ntilde;adirlo y tenerlo disponible para uso futuro. Del mismo modo, si no se borra la totalidad del contenido del encasillado no se podr&aacute; mostrar todas las opciones disponibles, ya que seg&uacute;n lo que est&eacute; escrito en el encasillado se busca en la lista las opciones que concuerden con lo escrito. Por ejemplo, si dejan escrito "Pre", el sistema solo mostrar&aacute; las opciones que comiencen con "Pre". Por ende, si se desea m&aacute;s opciones se debe de eliminar todo el contenido del encasillado a modificar y luego seleccionar el tri&aacute;ngulo para que as&iacute; se muestren todas las opciones disponibles.</p>
				            <img id="editSyllabus6" src="images_icons/editSyllabusHelp6.JPG">
				            <img id="editSyllabus7" src="images_icons/editSyllabusHelp7.png">
				            
				            <p>Para las estrategias de assessment se trabaja de forma similar a las estrategias de ense&ntilde;anza que se describi&oacute; anteriormente.</p>
				            <img id="editSyllabus8" src="images_icons/editSyllabusHelp8.JPG">
				            <img id="editSyllabus9" src="images_icons/editSyllabusHelp9.png">
				            
				            <p>En lo que respecta a los libros de texto, las bibliograf&iacute;as, y los recursos en l&iacute;nea, los mismos se pueden modificar de dos (2) manera. La primera siendo en cantidad, para lo cual podemos presionar el bot&oacute;n de a&ntilde;adir que corresponda a la informaci&oacute;n que deseamos a&ntilde;adir encasillados. Del mismo modo, podemos presionar el bot&oacute;n de remover para eliminar el encasillado m&aacute;s reciente. Segundo, podemos modificar el contenido de los encasillados ya existentes. Por ejemplo, la versi&oacute;n de un libro, el enlace del recurso en l&iacute;nea, entre otros casos.</p>
				            <p>Por &uacute;ltimo, las reglas se modifican seleccionando o desmarcando los t&iacute;tulos de las reglas. De este modo, se altera que reglas aplican al curso. Por otro lado, si se desea modificar el contenido de la regla en s&iacute;, se debe ir a la lista de reglas existentes y seleccionar el t&iacute;tulo de la regla a modificar para as&iacute; acceder a la p&aacute;gina que nos permite modificar el t&iacute;tulo y la descripci&oacute;n de una regla.</p>
				            <img id="editSyllabus10" src="images_icons/editSyllabusHelp10.JPG">
			        		<%
			        	} else if(previousPage.equals("modifyRules.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la p&aacute;gina para modificar las reglas:</h1>
			        		<p>El prop&oacute;sito de esta p&aacute;gina es proveer una manera de editar los t&iacute;tulos de las reglas y la descripci&oacute;n de estas. Al editar su contenido, todos los prontuarios ver&aacute;n dichos cambios.</p>
			        		<%
			        	} else if(previousPage.equals("welcomeMenu.jsp")) {
			        		%>
			        		<h1>Ayuda sobre la p&aacute;gina principal:</h1>
			        		<p>En la barra de b&uacute;squeda se puede escribir el c&oacute;digo de un curso parcialmente o en su totalidad. Del mismo modo, se pude escribir el t&iacute;tulo de un curso de forma parcial o en su totalidad. Al escribir de forma parcial se pueden obtener m&aacute;s de un resultado. Por ejemplo, si escribe en la barra de b&uacute;squeda "ed", como resultado puede obtener cursos que como parte de su c&oacute;digo de curso tengan las letras "ed" en alg&uacute;n lugar de su c&oacute;digo, o incluso en su t&iacute;tulo pero de forma consecutiva, es decir, que la “e” y la “d” deben estar juntas y sin espacios entre ellas.</p>
				            <p>Ahora se explicar&aacute; la b&uacute;squeda a trav&eacute;s de los programas. Como se muestra en las fotos a continuaci&oacute;n, existen varios filtros. El primero de estos siendo "Mostrar Todos" con el cual podemos ver todos los programas que se encuentran en el sistema. A continuaci&oacute;n, se encuentran los filtros "Bachillerato", "Maestr&iacute;a", y "Doctorado", los cuales como sus nombres indican, muestran los programas pertenecientes al bachillerato, maestr&iacute;a, y al doctorado respectivamente. Es importante recalcar que le debe dar "click" sobre el nombre del programa para ver los cursos que estos poseen.</p>
				            <img id="programfilterPic1" src="images_icons/programsFilterHelp1.JPG" alt="Foto mostrando los resultados del primer filtro de programas.">
				            <img id="programfilterPic2" src="images_icons/programsFilterHelp2.JPG" alt="Foto mostrando los resultados del segundo filtro de programas.">
				            <img id="programfilterPic3" src="images_icons/programsFilterHelp3.JPG" alt="Foto mostrando los resultados del tercer filtro de programas.">
				            <img id="programfilterPic4" src="images_icons/programsFilterHelp4.JPG" alt="Foto mostrando los resultados del cuarto filtro de programas.">
			        		<%
			        	} else {
			        		// This message is in case that the page flow is allowed,
			        		// but the page accessed does not have help information yet
			        		%>
			        		<h1>Esta p&aacute;gina no posee ayuda, favor de indic&aacute;rselo a la persona encargada.</h1>
			        		<%
			        	}
			        	%>
			            <!--Back Button-->
			            <button id = "backBtn" type="button" onclick="window.location.href='<%=previousPage%>';">Volver a la p&aacute;gina anterior</button>
			        </div><!--Blank page closing div tag--> 
			    </body>
			</html>
					<%
				} else {
					// The user can not be authenticated
					// Deleting session variables
					session.invalidate();
					// Return to the login page
					response.sendRedirect("login.jsp");
				}
				// Close the result set
				res.close();
				// Close the connection to the database
				appDBAuth.close();
			} else {
				// The user does not have access to the current page
				// Deleting session variables
				session.invalidate();
				// Return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
			%>
			Nothing to show!
			<%
			e.printStackTrace();
			// Deleting session variables
			session.invalidate();
			// Return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>