<!--This is the login page. This is where the program begins-->
<!doctype html>
<html lang="es">
    <head>
        <!--Indicates the encoding of the characters-->
        <meta charset="UTF-8">
        <!--Description of the website-->
        <meta name="description" content="Página de inicio de sesión para el portal de prontuarios de la división de educación de la UAGM.">
        <!--Authors of the web page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <!--Website title-->
        <title>Login</title>
        <!--Importing the CSS style-sheet-->
        <link rel = "stylesheet" type="text/css" href="css/login.css">
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
        <div class = "background"><!--image function call--></div>
        <div class ="franja"><!--top strip of page-->
            <img id ="logo" src="images_icons/uni-logo.png" alt="Logo Ana G. Mendez">
            <p id="mainname">Portal de Prontuarios</p>
        </div>
        <div class="mediobox"><!--Login box-->
            <form action='validation.jsp' method="post" autocomplete="off">
                <span id = "user"><b>Nombre de Usuario:</b></span>
                <input type="text" id="uname" name="uname" placeholder="Ingrese su nombre de usuario" maxlength="35" required><br>
                <span id = "pass"><b>Contrase&ntilde;a:</b></span>
                <input type="password" id="userpass" name="userpass" placeholder="Ingrese su contrase&ntilde;a" required><br>
                <% 
                   String error = "";
                   // Verify if it was redirected due to an error 
                   if(session.getAttribute("loginError")!=null) {
                        // Define the error message
                        error = "Usuario o contrase&ntilde;a erroneo/a!!!";
                   }
                %>
                <!--Error message area-->
                <input type="text" id="errorUserNamePass" name="errorUserNamePass" readonly value="<%=error%>">
                <button id ="logbutton" type="submit">LOGIN</button>
            </form>
            <b><a id="signupLink" href="signup.jsp">&iquest;No tiene una cuenta? Oprima aqu&iacute; para crear una.</a></b>
        </div>
    </body> 
</html>