<h1 align="center">Turco - Gestión de Turnos</h1>

<p align="center">
  Proyecto práctico para la asignatura <b>Programación para Dispositivos Móviles</b> (Ingeniería Informática, 3er año).
</p>

---

<h2>Descripción</h2>
<p><b>Turco</b> es una aplicación Flutter diseñada para la gestión de turnos de una peluquería mixta. Permite al personal del salón registrar clientes, programar turnos con estilistas y controlar la agenda diaria. Toda la información se maneja en memoria (sin servidor, base de datos ni autenticación) a partir de un conjunto de datos de prueba.</p>

<h2>Tecnologías y Arquitectura</h2>
<ul>
  <li><b>Flutter</b>: Framework de desarrollo.</li>
  <li><b>GoRouter</b>: Navegación (con <code>StatefulShellRoute.indexedStack</code>).</li>
  <li><b>MVVM</b>: Arquitectura basada en ViewModels con <code>ChangeNotifier</code>.</li>
  <li><b>Sin paquetes externos de estado</b>: No se utiliza <code>provider</code>, <code>riverpod</code>, <code>bloc</code> ni similares.</li>
  <li><b>Persistencia en memoria</b>: Los datos se cargan desde <code>lib/data/mock_data.dart</code> al iniciar la app.</li>
</ul>

<h2>Requisitos e Instalación</h2>

<h3>Versión de Flutter</h3>
<p>El proyecto fue desarrollado y compilado utilizando <b>Flutter 3.47.7</b>.</p>

<h3>Application ID</h3>
<p>El identificador de la aplicación es: <br>
<code>com.yosbielalejandro.diazcala.turco</code></p>

<h3>Cómo inicializar y ejecutar el proyecto</h3>
<ol>
  <li>Clona el repositorio: <br><code>git clone https://github.com/Yosbiel/Yosbiel-A.-app-turco.git</code></li>
  <li>Accede al directorio: <br><code>cd Yosbiel-A.-app-turco</code></li>
  <li>Obtén las dependencias: <br><code>flutter pub get</code></li>
  <li>Ejecuta la app en un emulador o dispositivo físico: <br><code>flutter run</code></li>
</ol>

<h3>Cómo generar el APK en modo Release</h3>
<p>Para generar el archivo instalable, ejecuta:</p>
<pre><code>flutter build apk --release</code></pre>
<p>El APK se generará en la ruta: <br>
<code>build/app/outputs/flutter-apk/app-release.apk</code></p>

<p>El APK ya compilado también se encuentra en la carpeta <code>entrega/</code> de este repositorio.</p>

<h2>Estructura de Carpetas</h2>
<p>El código está organizado manteniendo la separación de responsabilidades de MVVM:</p>
<ul>
  <li><code>assets/</code>: Recursos estáticos.
    <ul>
      <li><code>avatares/</code>: Imágenes de perfil de los estilistas.</li>
      <li><code>fonts/</code>: Tipografía Poppins (Regular, Medium, SemiBold, Bold).</li>
      <li><code>servicios/</code>: Imágenes ilustrativas de las categorías de servicios.</li>
    </ul>
  </li>
  <li><code>capturas/</code>: Capturas de pantalla reales de la app en funcionamiento.</li>
  <li><code>entrega/</code>: Archivo APK compilado en modo release.</li>
  <li><code>lib/</code>:
    <ul>
      <li><code>core/</code>: Configuración global (tema y router).</li>
      <li><code>data/</code>: Datos de prueba (<code>mock_data.dart</code>).</li>
      <li><code>models/</code>: Clases de datos (<code>Cliente</code>, <code>Estilista</code>, <code>Servicio</code>, <code>Turno</code>).</li>
      <li><code>viewmodels/</code>: Lógica de negocio y estado (<code>ChangeNotifier</code>).</li>
      <li><code>views/</code>: Pantallas de la interfaz de usuario.</li>
    </ul>
  </li>
</ul>

<h2>Capturas de Pantalla</h2>
<p>Las capturas reales de la aplicación corriendo (tanto en modo claro como oscuro, formularios con errores y listados) se encuentran en la carpeta <a href="capturas/">capturas/</a>.</p>

---

<p align="center"><i>Desarrollado por Yosbiel Alejandro Díaz Cala.</i></p>
