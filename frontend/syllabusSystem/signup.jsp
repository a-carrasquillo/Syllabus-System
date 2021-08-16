<!doctype html>
<html lang="es">
    <head>
        <!--Indicates the encoding of the characters-->
        <meta charset="utf-8">
        <!--Authors of the web page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <!--Importing the CSS style-sheet-->
        <link rel = "stylesheet" type="text/css" href="css/signup.css">
        <!--Website title-->
        <title>Registro</title>
        <!--Webpage description-->
        <meta name="description" content="P&aacute;gina de registro para el portal de prontuarios de la divisi&oacute;n de educaci&oacute;n de la UAGM.">
        <!--Script to validate the password with confirm password-->
        <script>
            function checkform() {
                "use strict";
                // Retrieving the password and the confirmation of the password
                var pass = document.signup.psw.value;
                var passConf = document.signup.psw_repeat.value;
                // Verify if the password is not the same as the confirmation password
                if(pass!==passConf) {
                    // Show the error message
                    document.getElementById("errorPassword").value = "";
                    document.getElementById("errorPassword").value = "Contrase\u00f1as no coinciden!";
                } else {
                    // If the passwords are the same, empty the error message
                    document.getElementById("errorPassword").value = "";
                }
            }
        </script>
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
        <div class ="franja"><!--top strip of page-->
            <img id ="logo" src="images_icons/uni-logo.png" alt="Logo Ana G. Mendez">
            <p id="mainname">Registro del Portal de Prontuarios</p>
        </div>
        <div class = "cuadro_centro">
             <form class="createAccountForm" name="signup" action="createAccount.jsp" method="post" autocomplete="off">
                <%
                // Define the error variables
                String errorUsername = "";
                String errorPassword = "";

                // Define the variables that will hold the user information
                String name = "";
                String lastName = "";
                String userName = "";
                String jobPosition = "";

                /* Verify if the error variable is null, if so, this is the
                   first time loading the page. Else, this page is reloaded
                   after an error in the submit */
                if(session.getAttribute("error")!=null) {
                    // Get the error description from the session variable
                    String error = session.getAttribute("error").toString().trim();
                    // Determine the cause of the error
                    if(error.equals("usernameExists")) {
                        errorUsername = "El nombre de usuario ya existe. Use otro.";
                    } else if(error.equals("passwordsNotMatch")) {
                        errorPassword = "Contrase\u00f1as no coinciden!";
                    } else if(error.equals("unexpectedError")) {
                        // Left blank on purpose
                    } else {
                        System.out.println("Error not recognize in signup.jsp error message...");
                        // Deleting session variables
                        session.invalidate();
                        // Redirect to the login page
                        response.sendRedirect("login.jsp");
                    }
                    // Load user information from session variables
                    name = session.getAttribute("name").toString().trim();
                    lastName = session.getAttribute("lastName").toString().trim();
                    userName = session.getAttribute("userName").toString().trim();
                    jobPosition = session.getAttribute("jobPosition").toString().trim();

                    // Delete all session variables related to the error
                    session.setAttribute("error", null);
                    session.setAttribute("name", null);
                    session.setAttribute("lastName", null);
                    session.setAttribute("userName", null);
                    session.setAttribute("jobPosition", null);
                }
                %>
                <h1>Crear una cuenta</h1>
                <h4>Complete este formulario para crear una cuenta.</h4>
                <hr>
                <label for="name"><b>Nombre</b></label>
                <input type="text" placeholder="Escriba su nombre..." name="name" maxlength="50" value="<%=name%>" required>

                <label for="lastName"><b>Apellidos</b></label>
                <input type="text" placeholder="Ingrese sus apellidos..." name="lastName" maxlength="50" value="<%=lastName%>" required>

                <label for="userName"><b>Nombre de usuario</b></label>
                <input type="text" placeholder="Ingrese su nombre de usuario..." name="userName" maxlength="35" value="<%=userName%>" required>
                    <!--Error message-->
                    <input type="text" class="error" id="errorUsername" name="errorUsername" readonly value="<%=errorUsername%>">
                <label for="psw"><b>Contrase&ntilde;a</b></label>
                <input type="password" placeholder="Ingrese una contrase&ntilde;a..." name="psw" required>

                <label for="psw_repeat"><b>Confirmar contrase&ntilde;a</b></label>
                <input type="password" placeholder="Confirme su contrase&ntilde;a..." name="psw_repeat" required oninput ="checkform()">
                    <!--Error message-->
                    <input type="text" class="error" id="errorPassword" name="errorPassword" readonly value="<%=errorPassword%>">
                <label for="selectPos"><b>Seleccione su puesto</b></label>
                <select name="selectPos" id = "employeeType" required>
                    <option value = "">Seleccione...</option>
                <%
                // Determine the job position display
                if(jobPosition.equals("professor")) {
                    %>
                    <option value = "professor" selected>Profesor</option>
                    <option value = "employee">Empleado</option>
                    <%
                } else if(jobPosition.equals("employee")) {
                    %>
                    <option value = "professor">Profesor</option>
                    <option value = "employee" selected>Empleado</option>
                    <%
                } else if((jobPosition.equals(""))) {
                    %>
                    <option value = "professor">Profesor</option>
                    <option value = "employee">Empleado</option>
                    <%
                } else {
                    System.out.println("Value not recognize in signup.jsp job position variable...");
                    // Deleting session variables
                    session.invalidate();
                    // Redirect to the login page
                    response.sendRedirect("login.jsp");
                }
                %>      
                </select>

                <div class="clearfix">
                    <button type="button" onclick="window.location.href='login.jsp';" class="cancelBtn">Cancelar</button>
                    <button type="submit" class="createBtn" onclick="return checkform();">Reg&iacute;strate</button>
                </div>
            </form> 
        </div>
    </body>
</html>